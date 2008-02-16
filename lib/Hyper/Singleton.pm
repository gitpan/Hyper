package Hyper::Singleton;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Functions;

our $REQUEST_CLASS
    = ( exists $ENV{MOD_PERL} && $ENV{MOD_PERL} > 2 )
    ? 'Hyper::Request::ModPerl2'
    : 'Hyper::Request::Default';

sub BUILD {
    return shift->_init_singleton();
}

sub singleton {
    my $class = shift;
    return $class->_get_singleton() || $class->new(@_);
}

sub STORABLE_thaw_post :CUMULATIVE {
    return $_[0]->_init_singleton();
}

sub _init_singleton :PRIVATE {
    Hyper::Functions::use_via_string($REQUEST_CLASS)->set_note({
        (ref $_[0] || $_[0]) => $_[0]
    });
    return $_[0];
}

sub _get_singleton :PRIVATE {
    return Hyper::Functions::use_via_string($REQUEST_CLASS)->get_note(ref $_[0] || $_[0]);
}

1;

__END__

# ToDo: Cleanup POD;

=pod

=head1 NAME

Hyper::Singleton - base class which implements the
singleton design pattern

=head1 VERSION

This document describes Hyper::Singleton 0.01

=head1 SYNOPSIS

    package Hyper::Singleton::Sample;

    use Class::Std::Storable;
    use base qw(Hyper::Singleton);

    1;

    my $instance_1 = Hyper::Singleton::Sample->singleton();
    my $instance_2 = Hyper::Singleton::Sample->singleton();

    ref $instance_1 eq ref $instance_2;

=head1 DESCRIPTION

Hyper::Singleton gives the inheriting class the singleton method, which
is used to get only one object of this class on every call.

=head1 SUBROUTINES/METHODS


=head2 BUILD

    my $new_instance = Hyper::Singleton::Debug->new();

Create a new Object instance.

=head2 singleton

    my $instance = Hyper::Singleton::Sample->singleton();

Get the object as singleton.

=head2 _init_singleton :PRIVATE

    $self->_init_singleton();

Initializes the singleton and stores it to our global vars.

=head2 _get_singleton :PRIVATE

    my $existant_instance = $self->_get_singleton();

Get existant instance of the singleton object.

=head2 _get_request_object :PRIVATE

    my $r = $self->_get_request_object();

Get the apache request object in mod perl environments.

=head2 _get_identifier :PRIVATE

    my $identifier = $self->_get_identifier();

Get the apache request object in mod perl environments.

=head2 STORABLE_thaw_post :CUMULATIVE

Reinitialize our object on thaw.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Apache2::RequestUtil

=item *

Apache::RequestUtil

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Singleton.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Singleton.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
