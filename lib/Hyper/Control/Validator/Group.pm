package Hyper::Control::Validator::Group;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control::Validator);
use Class::Std::Storable;

use Hyper::Functions;
use Hyper::Singleton::Container::Validator::Group;

my %roles_of :ATTR(:default<{}>);

sub START {
    # add group validators to our base element
    $_[0]->add_group_validator(
        map {
            Hyper::Functions::use_via_string($_->get_class())->new({
                config => $_,
            });
        } @{$_[0]->get_config()->get_group_validators() or return $_[0]}
    );

    return $_[0];
}

sub add_group_validator {
    my ($self, @validators) = @_;

    Hyper::Singleton::Container::Validator::Group
        ->singleton()
        ->add_validators_of({
            $self->get_name() => \@validators,
        });

    return $self;
}

sub get_group_validators {
    return Hyper::Singleton::Container::Validator::Group
        ->singleton()
        ->get_validators_of(shift->get_name());
}

sub add_base_element {
    my $self      = shift;
    my $arg_ref   = shift;
    my $roles_ref = $roles_of{ident $self};

    for my $validator ( @{$self->get_group_validators() || []} ) {
        for my $role_name ( keys %{$arg_ref} ) {
            $roles_ref->{$role_name} = $arg_ref->{$role_name};
        }
    }

    return $self;
}

sub get_first_invalid_validator {
    my @validators = @{
        Hyper::Singleton::Container::Validator::Group
            ->singleton()->get_validators_of(shift->get_name())
        || []
    };

    for my $validator ( @validators ) {
        return $validator if ! $validator->get_is_valid();
    }

    return;
}

sub all_roles_valid {
    my $self = shift;

    FIND_INVALID_CONTROL:
    for my $control ( values %{$roles_of{ident $self}} ) {
        my $validator_control = $control->get_validator_control()
            or next FIND_INVALID_CONTROL;
        return if $validator_control->get_first_invalid_validator();
    }

    return 1;
}

sub is_valid {
    my $self      = shift;
    my $roles_ref = $roles_of{ident $self};
    my $value_ref = {
        map {
            $_ => scalar $roles_ref->{$_}->get_value();
        } keys %{$roles_ref}
    };

    # groups are only valid if all members are valid
    return $self->all_roles_valid() && ! grep {
        ! $_->is_valid($value_ref);
    } @{$self->get_group_validators()};
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Validator::Group - Control for handling group validators.

=head1 VERSION

This document describes Hyper::Control::Validator::Group 0.01

=head1 SYNOPSIS

    use Hyper::Control::Validator::Group;

    my $object = Hyper::Control::Validator::Group->new();

=head1 DESCRIPTION

Control which offers a template based container for group validators.

=head1 ATTRIBUTES

=over

=item roles :default<{}>

=back

=head1 SUBROUTINES/METHODS

=head2 add_group_validator

    $object->add_group_validator(
        Hyper::Validator::Group::Compare->new(),
    );

Add Single Validators to the control.

=head2 get_group_validators

    my $validators_ref = $object->get_group_validators();

Get Group Validators which are trailed to the control.

=head2 get_first_invalid_validator

    my $first_invalid_validator = $object->get_first_invalid_validator();

Get the first invalid validator of this control.

=head2 all_roles_valid

    my $all_roles_are_valid = $object->all_roles_valid();

Checks if all controls which own a role in our group validator are valid.

=head2 is_valid

    my $is_valid = $object->is_valid();

Returns a boolean value which show if all appended validators are valid.

=head2 add_base_element

    $object->add_base_element({
        first => $base_control_new_password,
    });

or

    $object->add_base_element({
        first  => $base_control_new_password,
        second => $base_control_repeat_new_password,
    });

Add Base elements to the all appended Validator Groups.
Each base element takes a named role in the validator group(s).
eg. $base_control_new_password takes teh named role >first<

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

Hyper::Singleton::Container::Validator::Group

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Group.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Control/Validator/Group.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
