package Hyper::Template;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Hyper::Functions;
use Hyper::Error;
use Hyper::Singleton::Context;

use Readonly;
Readonly my %SUFFIX_OF => qw(
    Hyper::Template::Toolkit tt
    Hyper::Template::HTC     htc
);
Readonly my %CLASS_OF => reverse %SUFFIX_OF;

sub _init {
    Hyper::Functions::use_via_string(
        Hyper::Singleton::Context
            ->singleton()
            ->get_config('Class')
            ->get_translator()
    )->init();

    return;
}

sub get_template_paths {
    return [
        map {
            "$_/" . Hyper::Functions::get_path_for('template');
        } @{
              Hyper::Functions::listify(
                  Hyper::Singleton::Context
                      ->singleton()
                      ->get_config('Global')
                      ->get_base_path()
              )
          }, Hyper::Functions::get_path_from_file(__FILE__)
    ];
}

sub get_class_for_suffix {
    return $CLASS_OF{$_[-1]};
}

sub get_suffix_for_class {
    return $SUFFIX_OF{$_[-1]};
}

1;

__END__

ToDo: fix POD

=pod

=head1 NAME

Hyper::Template - abstract base class to adopt template engines

=head1 VERSION

This document describes Hyper::Template 0.01

=head1 SYNOPSIS

    package Hyper::Template::Simple;

    use base qw(Hyper::Template);

    my %param_of :ATTR(:default<{}>);

    sub param {
        my $ident = ident shift;
            $param_of{$ident} = {
            %{$param_of{$ident}},
            @_,
        };
    }

    sub output {
        sprintf $template_file_content, $param_of{ident shift};
    }

    1;

=head1 DESCRIPTION

Hyper::Template offers some basic methods for adopting Template engines
to the Hyper Framework.

=head1 SUBROUTINES/METHODS

=head2 _init

    Hyper::Template::_init();

Does some initializing tasks such as setting the correct template engine.

=head2 get_template_paths

    my $template_paths_ref = $self->get_template_path();

Get an array reference with paths where templates are located.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

Sample for your Context.ini

    [Global]
    base_path=/srv/web/www.example.com/

    [Class]
    translator=Hyper.Translator.Noop

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Functions

=item *

Hyper::Error

=item *

Hyper::Singleton::Context

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: $

=item Id

$Id: $

=item Revision

$Revision: $

=item Date

$Date: $

=item HeadURL

$HeadURL: $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
