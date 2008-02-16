package Hyper::Control::Template;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;

use Hyper::Singleton::Context;
use Hyper::Functions;

use Readonly;
Readonly my $DEFAULT_TEMPLATE_CLASS => 'Hyper::Template::HTC';

my %template_of          :ATTR(:set<template>);
my %template_filename_of :ATTR(:name<template_filename> :default<q{}>);

sub START {
    if ( $_[0]->isa('Hyper::Control') && ( my $config = $_[0]->get_config() ) ) {
        $template_filename_of{$_[1]} ||= $config->get_template();
    }
    return $_[0];
}

sub _init_template :RESTRICTED {
    my $self           = shift;
    my $owner          = $self->can('get_owner') ? $self->get_owner() : ();
    my $template_class = Hyper::Functions::use_via_string(
        Hyper::Singleton::Context->singleton
              ->get_config('Class')->get_template()
        || $DEFAULT_TEMPLATE_CLASS
    );

    my $template_filename = $self->get_template_filename();
    my $template          = $template_class->new(
        out_fh => 1 || $owner && $owner->use_out_fh(), # ToDo: Remove me, I'm a workaround
        @_,
        $template_filename
            ? ( filename  => $template_filename )
            : ( for_class => ref $self),
    );
    $template->param(this => $self);
    $self->set_template($template);

    return $self;
}

sub STORABLE_freeze_pre :CUMULATIVE {
    delete $template_of{ident $_[0]};
    return $_[0];
}

sub get_template {
    my $self  = shift;
    my $ident = ident $self;

    if ( ! $template_of{$ident} ) {
        $self->_init_template();
    }

    return $template_of{$ident};
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Template - base class for control classes which
needs templating features

=head1 VERSION

This document describes Hyper::Control::Template 0.1

=head1 SYNOPSIS

    package Hyper::Control::Base;

    use Class::Std::Storable;
    use base qw(Hyper::Control Hyper::Control::Template);

    1;

=head1 DESCRIPTION

Hyper::Control::Template provides the template for the inheriting class
and handles Class::Std::Storable compatibility for different
template engines.

=head1 ATTRIBUTES

=over

=item template          :set

=item template_filename :name :default<q{}>

=back

=head1 SUBROUTINES/METHODS

=head2 _init_template :RESTRICTED

    $self->_init_template();

Loads the template class of current Context if it's not loaded.
Creates a new template with base_path and filename/for_class attribute
and save it as class attribute template.

=head2 STORABLE_freeze_pre :CUMULATIVE

Templates can't be freezed because we use non Class::Std::Storable
Template engines. I don't think, that creating a persistent template
Engine is useful.

=head2 get_template

    my $template = $object->get_template();

Initialize the template if it's not existant in our class attributes,
or create it via calling $self->_init_template().
Returns template corresponding to your class.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

Sample for your Context.ini

    [Class]
    template=Hyper.Template.HTC

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Singleton::Context

=item *

Hyper::Functions

=item *

Readonly

=item *

Hyper::Template::HTC

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Template.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Control/Template.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
