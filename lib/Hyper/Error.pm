package Hyper::Error;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use autouse 'Apache2::Log';
use autouse 'Data::Dumper';

use HTML::Template::Compiled;
use Hyper::Singleton::CGI;
use File::Spec;

use English qw($INPUT_LINE_NUMBER);
use Readonly;
Readonly my %HANDLER_OF => (
   warn  => 'warn',
   fatal => 'die',
);
Readonly my $SHOW_LINES_BEFORE => 5;
Readonly my $SHOW_LINES_AFTER  => 5;

sub import {
    my ($class, %arg_of) = @_;

    no strict qw(refs);
    # export throw by default
    if ( ! exists $arg_of{throw} || $arg_of{throw} ) {
        *{(caller) . '::throw'} = *Hyper::Error::throw;
    }
    no warnings qw(redefine);

    SET_SIGNAL_HANDLER:
    for my $name ( keys %arg_of ) {
        next SET_SIGNAL_HANDLER if ! $arg_of{$name};
        $main::SIG{'__' . ( uc $HANDLER_OF{$name} ) . '__'}
            = *{"CORE::GLOBAL::$HANDLER_OF{$name}"}
            = \&_show_error_message;
    }

    return;
}

sub _is_eval_context {
    my ($package, $file, $line, $sub, $wantarray, $evaltext) = @_;
    return ( exists $ENV{MOD_PERL} ? 0 : $^S ) || ( $sub && $sub eq '(eval)' );
}

sub _show_error_message {
    # prevent from endless loops if we die internaly
    local *CORE::GLOBAL::die;
    { no warnings qw(redefine);
      *CORE::GLOBAL::die = sub { CORE::die(@_) };
    }

    my @messages        = @_;
    my @stack           = ();
    my $is_webserver    = exists $ENV{SERVER_SOFTWARE};
    my $ignore_packages = join q{|},
        qw(Hyper::Error ModPerl::Registry CGI::Carp Carp Hyper::Developer::Server HTTP::Server::Simple),
        exists $ENV{MOD_PERL}
            ? 'main \z'
            : ();

    my $i = 0;
    my $code_lines_ref;
    GET_CALLERSTACK:
    while ( my ($package, $file, $line, $sub, $wantarray, $evaltext) = caller $i++ ) {
        if ( $package ) {
            next GET_CALLERSTACK if $package =~ m{\A (?: $ignore_packages )}xmso;

            if ( Hyper::Error::_is_eval_context($package, $file, $line, $sub, $wantarray, $evaltext) ) {
                CORE::die @messages;
            }

            # fixup: mod_perl creates ugly package names for compiled scripts ;)
            if ( exists $ENV{MOD_PERL} ) {
                $package =~ s{\A ModPerl::ROOT::ModPerl::Registry::[^:]* \z}{main}xms;
            }
            # show code of first package which
            # is not in the Hyper:: namespace
            if ( ! $code_lines_ref && 0 != index $package, 'Hyper' ) {
                $code_lines_ref = _show_source($file, $line);
            }

            push @stack, {
                package => $package, ## no critic qw(package)
                file    => $file,
                line    => $line,
                sub     => $sub,
            };
        }
    }

    if ( $is_webserver ) {
        print Hyper::Singleton::CGI->singleton()->header(
            -type            => 'text/html',
            -pragma          => 'no-cache',
            '-cache-control' => 'no-store, no-cache, must-revalidate',
        );
    }

    my $file     = '__UNKNOWN__';
    my $template = eval {
        require Hyper::Singleton::Context;
        require Hyper::Template;

        my $config = Hyper::Singleton::Context->singleton()->get_config();
        $file = $is_webserver
            ? $config->get_html_template() || 'Error/html_error.htc'
            : $config->get_plain_template() || 'Error/plain_error.htc';

        HTML::Template::Compiled->new(
            out_fh            => 0,
            plugin            => [],
            loop_context_vars => 1,
            filename          => $file,
            path              => Hyper::Template::get_template_paths(),
        );
    };

    # sanity death
    if ($@) {
        _output(
            $is_webserver
                ? "can't access error template &gt;$file&lt;" . Data::Dumper::Dumper(\@stack, $@, \@messages)
                : "can't access error template >$file<" . Data::Dumper::Dumper(\@stack, $@, \@messages)
        );
    }
    else {
        $template->param(
            stack        => \@stack,
            environment  => {
                map {
                    exists $ENV{$_} ? ($_ => $ENV{$_}) : ();
                } qw(
                    SERVER_NAME
                    SERVER_ADMIN
                    SCRIPT_URI
                    SCRIPT_FILENAME
                    MOD_PERL
                    MOD_PERL_API_VERSION
                    HTTP_HOST
                )
            },
            code_lines   => $code_lines_ref,
            messages     => $is_webserver
                ? [ map { split m{\n}xms, $_; }@messages ]
                : \@messages,
            show_details => 1,
        );
        _output($template->output());
    }
    exit;
}

sub _output {
    if ( $ENV{MOD_PERL} ) {
        eval {
            require Apache2::RequestUtil;
            if ( ! Apache2::RequestUtil->request()->bytes_sent() ) {
                Apache2::RequestUtil->request()->custom_response(
                    500,
                    join q{}, (
                        # MSIE won't display a custom 500 response unless it is >512 bytes!
                        $ENV{HTTP_USER_AGENT} =~ m{MSIE}xms
                            ? '<!--' . (' ' x 513) . " -->\n"
                            : q{}
                    ), @_
                );
            }
        };
        CORE::die(@_);
    }
    print @_;
    CORE::die(@_);
}

sub _show_source {
    my $filename    = shift;
    my $line_number = shift;

    open my $file, '<', $filename or return;

    my $start = $line_number - $SHOW_LINES_BEFORE;
    my $end   = $line_number + $SHOW_LINES_AFTER;

    my @code_lines;
    GET_CODE_LINES:
    while ( my $line = <$file> ) {
        next GET_CODE_LINES if $INPUT_LINE_NUMBER <= $start;
        last GET_CODE_LINES if $INPUT_LINE_NUMBER > $end;

        my $contains_error = $line_number == $INPUT_LINE_NUMBER;

        push @code_lines,
            { contains_error => $contains_error, line => $line };

        if ( $contains_error && $line !~ m{;[\s\t]*\z}xms ) {
            ++$line_number;
            ++$end;
        }
    }
    return \@code_lines;
}

sub throw {
    _show_error_message(@_); die @_;
}

1;

__END__

=pod

=head1 NAME

Hyper::Error - catch die and/or warn, offers throw method

=head1 VERSION

This document describes Hyper::Error 0.01

=head1 SYNOPSIS

    use Hyper::Error fatal => 1, warn => 1;

    throw('error occured');

=head1 DESCRIPTION

Hyper::Error can catch fatal (die) and warn (warn) messages. The error output
for shell scripts is plain text. Errors in Webserver context drop html
messages.
The error messages includes the callerstack, some codelines of last called
package in Hyper namespace, some environment variables, and the original
message. There is also a throw exported by default to throw errors.

=head1 SUBROUTINES/METHODS

=head2 import

    use Hyper::Error warn => 1, fatal => 1;

or more complex and without exported throw method

    require Hyper::Error;
    Hyper::Error->import(warn => 1, fatal => 1, throw => 0);

Adjust signal handlers for warn and/or die and exports the throw method.

=head2 _show_error_message

    Hyper::Error::_show_error_message(qw(
        error_message_of_line_1
         error_message_of_line_2
    ));

Print errormessage (html or plaintext).

=head2 _show_source

    Hyper::Error::_show_source($file_name, $line_number);

Get a code snippet for file, line.

=head2 throw

    use Hyper::Error;
    throw('my error');

or
    Hyper::Error throw => 0;
    Hyper::Error::throw('my error');

Used for throwing failures.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

Sample for your Context.ini

    [Hyper::Error]
    html_template=Error/html_error.htc
    plain_template=Error/plain_error.htc

=head1 DEPENDENCIES

=over

=item *

version

=item *

autouse

=item *

Apache2::Log

=item *

Data::Dumper

=item *

HTML::Template::Compiled

=item *

File::Spec

=item *

English

=item *

Readonly

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Error.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Error.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
