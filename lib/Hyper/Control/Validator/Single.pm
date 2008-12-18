package Hyper::Control::Validator::Single;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control::Validator);
use Class::Std::Storable;
use List::MoreUtils qw(first_value);

use Hyper::Singleton::Container::Validator::Single;

my %owner_of :ATTR(:name<owner> :default<()>);

sub add_single_validator {
    my ($self, @validators) = @_;

    Hyper::Singleton::Container::Validator::Single
        ->singleton()
        ->add_validators_of({
            $self->get_name() => [
                @{$self->get_single_validators() || []},
                @validators,
            ],
        });

    return $self;
}

sub get_single_validators {use Data::Dumper;
    return Hyper::Singleton::Container::Validator::Single
        ->singleton()
        ->get_validators_of(shift->get_name());
}

sub get_first_invalid_validator {
    my @validators = @{
        Hyper::Singleton::Container::Validator::Single
            ->singleton()->get_validators_of(shift->get_name())
        || []
    };

    for my $validator ( @validators ) {
        return $validator if ! $validator->get_is_valid();
    }

    return;
}

sub is_valid {
    my $self   = shift;
    my $owner  = $owner_of{ident $self};
    my @values = $owner->get_value();

    return ! grep {
        ! $_->is_valid(@values);
    } @{$self->get_single_validators() || []};
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Validator::Single - Control for handling single validators.

=head1 VERSION

This document describes Hyper::Control::Validator::Single 0.01

=head1 SYNOPSIS

    use Hyper::Control::Validator::Single;

    my $object = Hyper::Control::Validator::Single->new();

=head1 DESCRIPTION

Control which offers a template based container for single validators.

=head1 ATTRIBUTES

=over

=item owner :name :default<()>

=back

=head1 SUBROUTINES/METHODS

=head2 add_single_validator

    $object->add_single_validator(
        Hyper::Validator::Single::Required->new(),
    );

Add Single Validators to the control.

=head2 get_single_validators

    my $validators_ref = $object->get_single_validators();

Get Single Validators which are trailed to the control.

=head2 get_first_invalid_validator

    my $first_invalid_validator = $object->get_first_invalid_validator();

Get the first invalid validator of this control.

=head2 is_valid

    my $is_valid = $object->is_valid();

Returns a boolean value which show if all appended validators are valid.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Control::Validator

=item *

Class::Std::Storable

=item *

List::MoreUtils

=item *

Hyper::Singleton::Container::Validator::Single

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Single.pm 474 2008-05-29 13:25:22Z ac0v $

=item Revision

$Revision: 474 $

=item Date

$Date: 2008-05-29 15:25:22 +0200 (Thu, 29 May 2008) $

=item HeadURL

$HeadURL: file:///srv/cluster/svn/repos/Hyper/Hyper/trunk/lib/Hyper/Control/Validator/Single.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
