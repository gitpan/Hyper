package Hyper::Template::HTC;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(HTML::Template::Compiled);
use Hyper;
use Hyper::Template; # don't inherit; contains only class methods
use Hyper::Functions;
use Hyper::Template::HTC::Compiler;

use File::Basename;
use File::Spec;

sub new {
    my ($class, %arg_of) = @_;

    Hyper::Template::_init(\%arg_of);

    # ATTENTION:
    #   our own params must be deleted, cause
    #   they're not valid for HTML::Template::Compiled
    if ( exists $arg_of{for_class} ) {
         $arg_of{filename}
             = Hyper::Functions::class_to_path(delete $arg_of{for_class})
             . '.'
             . Hyper::Template::get_suffix_for_class($class);
    }

    my $template = HTML::Template::Compiled::new($class,
        tagstyle               => [qw(+asp -comment -php -tt -classic)],
        out_fh                 => 1,
        search_path_on_include => 1,
        loop_context_vars      => 1,
        path                   => Hyper::Template::get_template_paths(),
        plugin                 => [qw(
            Hyper::Template::HTC::Plugin::Text
        )],
        %arg_of,
    );
    $template->param(Hyper => Hyper->singleton());

    return $template;
}

sub compiler_class {
    return 'Hyper::Template::HTC::Compiler';
}

sub output {
    my $self = shift;
    $self->get_out_fh()
        or return $self->SUPER::output(@_);

    # WORKAROUND
    # supress the following warnings
    # cause of problem with: uninitialized IO::Scalar line 421
    local $^W = 0;
    $self->SUPER::output(@_ ? @_ : Hyper->singleton()->get_output_handle());
    return q{};
}

1;

__END__

=pod

=head1 NAME

Hyper::Template::HTC - class for using HTC based Hyper templates

=head1 VERSION

This document describes Hyper::Template::HTC 0.01

=head1 SYNOPSIS

    use Hyper::Template::HTC;
    my $template = Hyper::Template::HTC->new();

=head1 DESCRIPTION

Hyper::Template::HTC inherits from HTML::Template::Compiled,
sets some default params for HTC and gets the filename of
the template via translating the caller package name to a
filename.

=head1 SUBROUTINES/METHODS

=head2 new

    use Hyper::Template::HTC;
    Hyper::Template::HTC->new(
        filename => '/srv/web/www.example.com/var/sample.htc'
    );

or

    Hyper::Template::HTC->new(
        out_fh    => 0,
        for_class => 'Hyper::Control::Base::BInput',
    );

If the for_class parameter was set and there was no filename
parameter we try to get the filename of the template via the
_class_to_file method of Hyper::Functions.

You have to set at least one of the following two parameters:

=over

=item filename

default: undef

Full template filename.

=item for_class

default: undef

Find Template via Class name.

=back

Replacable parameters for internal HTML::Template::Compiled->new()

=over

=item out_fh

default: 1

Whether to directly output content or not. See L<HTML::Template::Compiled>.

=back

=head2 compiler_class

Used for setting Hypers special HTC Compiler L<Class Hyper::Template::HTC::Compiler>
which is used to workaround some HTC bugs (see CPANs RT for details).

=head2 output

    use Hyper::Template::HTC;
    my $template = Hyper::Template::HTC->new(
        for_class => 'Any::Thing',
        out_fh    => 0,
    );
    my $output_string = $template->output();

Output is dispatched directly to L<HTML::Template::Compiled>'s output method.

    use Hyper::Template::HTC;
    my $template = Hyper::Template::HTC->new(
        for_class => 'Any::Thing',
        out_fh    => 1,
    );
    $template->output();
    # eq $template->output(Hyper->singleton()->get_output_handle());

    # with own filehandle
    $template->output(IO::Scalar->new());

All warnings will be disabled cause of a problem with IO::Scalar.
L<HTML::Template::Compiled>'s output method is called with filehandle from args
or with Hyper's global output handle as default if out_fh is set.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

HTML::Template::Compiled

=item *

Hyper

=item *

Hyper::Template

=item *

Hyper::Functions

=item *

File::Basename

=item *

File::Spec

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

$Id: HTC.pm 433 2008-04-30 01:56:24Z ac0v $

=item Revision

$Revision: 433 $

=item Date

$Date: 2008-04-30 03:56:24 +0200 (Mi, 30 Apr 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Template/HTC.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
