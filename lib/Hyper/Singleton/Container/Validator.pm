package Hyper::Singleton::Container::Validator;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use base qw(Hyper::Singleton::Container);

sub add_validators_of {
    my $self    = shift;
    my $arg_ref = shift;

    $self->set_objects({
        %{$self->get_objects() || {}},
        %{$arg_ref},
    });

    return $self;
}

sub get_validators_of {
    return shift->get_object(shift);
}

1;

__END__

=pod

=head1 NAME

Hyper::Singleton::Container::Validator
 - a Hyper::Singleton::Container with additional features for validators.

=head1 VERSION

This document describes Hyper::Singleton::Container::Validator 0.01

=head1 SYNOPSIS

    use Hyper::Singleton::Container::Validator;

    my $singleton    = Hyper::Singleton::Container::Validator->singleton();
    my $new_instance = Hyper::Singleton::Container::Validator->new();

=head1 DESCRIPTION

Hyper::Singleton::Container::Validator inherits from
Hyper::Singleton::Container.

=head1 SUBROUTINES/METHODS

=head2 add_validators_of

    $object->add_validators_of({
        $name_of_another_object => \@validators
    });

Add Validators for a named object.

=head2 get_validators_of

    $object->get_validators_of($name_of_another_object);

Get Validators of a named object.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Singleton::Container

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Validator.pm 474 2008-05-29 13:25:22Z ac0v $

=item Revision

$Revision: 474 $

=item Date

$Date: 2008-05-29 15:25:22 +0200 (Do, 29 Mai 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Singleton/Container/Validator.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
