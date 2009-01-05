package Hyper::Template::HTC::Plugin::Text;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Hyper::Error;
use Hyper::Functions;
use Hyper::Singleton::Context;

use HTML::Template::Compiled;
use HTML::Template::Compiled::Token;

HTML::Template::Compiled->register('Hyper::Template::HTC::Plugin::Text');

sub register {
    my ($class) = @_;
    return {
        # opening and closing tags to bind to
        tagnames => {
            #    <%TEXT VALUE="key_label" ESCAPE=TEXTILE %>
            # or <%TEXT some_variable_from_assign %>
            # or <%TEXT VALUE="1st [_1], 2nd [_2]" _1="maketext value 1" _2_VAR="2nd.maketext.value.as.var" %>
            HTML::Template::Compiled::Token::OPENING_TAG() => {
                TEXT => [ undef, qw(VALUE ESCAPE _\d+ _\d+_VAR) ],
            },
        },
        compile => {
            # methods to compile to
            TEXT => {
                # on opening tab
                open => \&TEXT,
                # if you need closing, uncomment and implement method
                # close => \&close_text
            },
        },
    };
}

sub _lookup_variable {
    my $htc      = shift;
    my $var_name = shift;

    return $htc->get_compiler->parse_var(
        $htc,
        var            => $var_name,
        method_call    => $htc->method_call(),
        deref          => $htc->deref(),
        formatter_path => $htc->formatter_path(),
    );
}

sub TEXT {
    my $htc      = shift;
    my $token    = shift;
    my $arg_ref  = shift;
    my $attr_ref = $token->get_attributes();
    my $filename = $htc->get_filename();

    # ATTENTION: $attr->{NAME} and $attr->{VAR} isn't mandatory
    # but we we have to pass q{} instead of undef
    # resolve var if existant (eg. <%TEXT a_var_dingens ...

    my @maketext_list;
    FILL_MAKETEXT_LIST:
    for my $name ( keys %{$attr_ref} ) {
        my ($position, $is_variable) = $name =~ m{\A_(\d+)(_VAR)?\z}xms;

        $position or next FILL_MAKETEXT_LIST;

        throw("error in template $filename can't use maktext position $position twice")
            if defined $maketext_list[$position - 1];

        $maketext_list[$position - 1] = $is_variable
            ? _lookup_variable($htc, $attr_ref->{$name})
            : q{'} . ( quotemeta $attr_ref->{$name} ) . q{'};
    }
    my $translator_class = Hyper::Functions::use_via_string(
        Hyper::Singleton::Context
            ->singleton()
            ->get_config('Class')
            ->get_translator()
    );

    # necessary for HTC's caching mechanism
    my $maketext_string = '[' . ( join ', ',  @maketext_list ) . ']';
    my $escape_string   = '['
        . ( defined $attr_ref->{ESCAPE}
                ? ( join ',', map { q{'} . ( quotemeta $_ ) . q{'}; } split m{\|}xms,  $attr_ref->{ESCAPE} )
                : q{}
          )
        . ']';
    my $file_string = defined $filename
        ? q{'} . ( quotemeta $filename ) . qw{'}
        : 'undef'; # that's ok ...
    my $text = exists $attr_ref->{NAME}
        ? exists $attr_ref->{VALUE}
              ? throw(
                    "error in template $filename: "
                    . q{you can't use NAME and VALUE at the same time for HTC Plugin }
                    . __PACKAGE__
                )
              : _lookup_variable($htc, $attr_ref->{NAME})
        : q{'} . ( defined $attr_ref->{VALUE} ? $attr_ref->{VALUE} : q{} ) . q{'};

    # be careful in returns - they are double quoted strings.
    # escape variable names, if you mean variables, do not qoute (but put
    # quotes around) variables if you mean their content...
    return <<"EO_CODE";
$arg_ref->{out} $translator_class->translate(
          $text, {
              maketext => $maketext_string,
              escape   => $escape_string,
              filename => $file_string,
          },
       );
EO_CODE
}

1;

__END__

=pod

=head1 NAME

Hyper::Template::HTC::Plugin::Text - Plugin to connect Hyper Translators to HTC

=head1 VERSION

This document describes Hyper::Template::HTC::Plugin::Text 0.01

=head1 SYNOPSIS

ATTENTION: You always need a valid L<Hyper::Singleton::Context> for this plugin.

    use HTML::Template::Compiled;
    my $htc = HTML::Template::Compiled->new(
        plugin    => [qw(Hyper::Template::HTC::Plugin::Text)],
        scalarref => \'<%TEXT VALUE="Hello World!" %>',
    );
    $htc->output();

=head1 DESCRIPTION

Hyper::Template::HTC::Plugin::Text connects L<Hyper::Translator>s
to L<HTML::Template::Compiled>. The Plugin allows you to create multilingual
templates including maketext features (assumed that your Translator
supports this).

=head1 SYNTAX

=over

=item static text values

    <%TEXT VALUE="some static text" %>

=item text from a variable

    <%TEXT a.var %>

=item maketext with an static value

    <%TEXT VALUE="Hello [_1]!" _1="Damian" %>

=item maketext with an variable

    <%TEXT VALUE="Hello [_1]!" _1_VAR="var.with.the.value" %>

=item mixed samples

    <%TEXT a.text _1="Damian" _2="Conway" %>

    <%TEXT VALUE="[_1] has [_2] points!" _1="Larry" _2_VAR="var.with.points" %>

    <%TEXT a.complex.text _1="Larry" _2="Wall" _3_VAR="var.with.points" %>

=back

=head1 SUBROUTINES/METHODS

=head2 register

Callback which is used by L<HTML::Template::Compiled> to register the plugin.

=head2 TEXT

Don't call this method, it's used to create the HTC Template Code.
This method is used as callback which is registerd to L<HTML::Template::Compiled>
by our register method.

It calls the translate method of the Translator found via

    Hyper::Singleton::Context->singleton()->get_config('Class')->get_translator()

The translate method is called like

    $translator_class->translate(
        'result of variable lookup or VALUE', {
            maketext => [],       # maketext params from eg. _1 _2_VAR
            escape   => ['WIKI'], # escape eg. ESCAPE="WIKI" or ESCAPE="HTML|TEXTILE" etc.
            filename => '',       # template's filename or undef if no filename existant
        }
    );

=head2 _lookup_variable

Internally used to lookup variables in L<HTML::Template::Compiled>

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

=head1 DEPENDENCIES

=over

=item *

L<version>

=item *

L<Hyper::Error>

=item *

L<Hyper::Functions>

=item *

L<Hyper::Singleton::Context>

=item *

L<HTML::Template::Compiled>

=item *

L<HTML::Template::Compiled::Token>

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Text.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Template/HTC/Plugin/Text.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
