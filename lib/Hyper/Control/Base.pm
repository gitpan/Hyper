package Hyper::Control::Base;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control::Template Hyper::Control Hyper::Name);
use Class::Std::Storable;

use Hyper;
use Hyper::Functions;
use Hyper::Singleton::CGI;
use Hyper::Singleton::Debug;

my %value_of             :ATTR(:set<value>);
my %validator_control_of :ATTR(:set<validator_control> :get<validator_control>);

sub START {
    my $self   = shift;
    my $ident  = shift;
    my $config = $self->get_config() or return $self;
    my $owner  = $self->get_owner();

    # add single validators to our base element
    my $validator_ref = $config->get_single_validators();
    if ( $validator_ref && @{$validator_ref} ) {
        $self->add_single_validator(
            map {
                Hyper::Functions::use_via_string($_->get_class())->new({
                    config => $_,
                    owner  => $self,
                });
            } @{$validator_ref}
        );
    }

    # join named validators
    for my $validator_config ( @{$config->get_named_validators() || []} ) {
        $self->join_group_validator({
            act_as => $validator_config->get_act_as(),
            group  => $owner->get_object($validator_config->get_name()),
        });
    }

    return $self;
}

sub clear {
    $value_of{ident $_[0]} = ();
    return $_[0];
}

sub _set_from_cgi :PRIVATE {
    my $self = shift;

    my @values = Hyper::Singleton::CGI->singleton()->param($self->get_name());
    $self->set_value(@values ? @values > 1 ? \@values : $values[0] : undef);

    return $self;
}

sub get_value {
    my $value = $value_of{ident $_[0]};
    return ref $value eq 'ARRAY'
        ? wantarray ? @{$value} : $value->[0]
        : $value;
}

sub get_html {
    $_[0]->populate_show_state();
    return $_[0]->get_template()->output();
}

sub populate_show_state {
    Hyper->singleton()->get_workflow()->set_show_state($_[0]);
    return $_[0];
}

sub add_single_validator {
    my ($self, @validators) = @_;
    my $validator_control
        = $self->get_validator_control()
       || do {
              # build the validator control (used as error message container)
              my $config = $self->get_config() ? $self->get_config()->get_validator_control() : ();
              my $validator_control = Hyper::Functions::use_via_string(
                  $config ? $config->get_class() : 'Hyper::Control::Validator::Single'
                  )->new({ config => $config, owner => $self });
              $self->set_validator_control($validator_control);
              $validator_control;
          };

    $validator_control->add_single_validator(@validators);

    return $self;
}

sub join_group_validator {
    my $self    = shift;
    my $arg_ref = shift;

    $arg_ref->{group}->add_base_element({
        $arg_ref->{act_as} => $self,
    });

    return $self;
}

sub is_valid {
    my $self              = shift;
    my $validator_control = $self->get_validator_control()
        or return 1;

    return $validator_control->is_valid();
}

sub use_out_fh {
    return 0;
}

sub STORABLE_thaw_post {
    my $ident = ident $_[0];

    # shown on last page ?
    if ( Hyper->singleton()->get_workflow()->get_show_state($_[0])  ) {
        $_[0]->_set_from_cgi();
    }

    return $_[0]->SUPER::STORABLE_thaw_post();
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Base - base class for all base control classes

=head1 VERSION

This document describes Hyper::Control::Base 0.01

=head1 SYNOPSIS

    package Hyper::Control::Base::BSampleControl;

    use Class::Std::Storable;
    use base qw(Hyper::Control::Base);

    1;

=head1 DESCRIPTION

Hyper::Control::Base provides functions like managing single validators,
validation, getting value without handling CGI things etc.
We provide basicly everything whats needed for base controls.

=head1 ATTRIBUTES

=over

=item value :set :get

=item validator_control :get :set

Control which provides validation with methods
for Single Validators.

=back

=head1 SUBROUTINES/METHODS

=head2 set_value

    $object->set_value('Damian Conway');

or for multiple values

    $object->set_value(['Damian Conway', 'Lary Wall']);

Set value for this object. Also useful for preselection.

=head2 clear

    $object->clear();

Shortcut to object attribute value to undef.

=head2 add_single_validator

    $object->add_single_validator(
        Hyper::Validator::Single::Required->new()
    );

Registers validators in our Validator Control.

=head2 join_group_validator

    $object->join_group({
        group  => $self->get_object('vCompareGroupValidator'),
        act_as => 'first',
    });

Join a validator group with a defined role (act_as).

=head2 is_valid

    $object->is_valid();

This method communicates with the attached Validator Control.
Checks if all registered validators think that the current
value of this object is valid. If all validators are valid
group validators are checked.
Validators whose validation fails will add their error message
to the validator field. Method is_valid returns a boolean value.

=head2 get_value

    my $value = $object->get_value();

or for multiple values

    my @values = $object->get_value();

Returns an an array of current values (post/get params) in list
config and single value in scalar context.
If we have multiple values we also return only one value (the
first one) in scalar context.

=head2 get_html

Calls template from get_template and sets the param this to $self.
Returns $template->output();

Calls populate_show_state to update the control's show_state.

=head2 populate_show_state

Informs the the application that element was show via calling the
applications method set_show_state. This is used to update the
controls value automatically from CGI on an object thaw.

=head2 STORABLE_thaw_post :CUMULATIVE

Don't use this method for your code. It's called automaticaly
after object was thawn. The method calls _set_from_cgi to fill
our object with cgi params.

=head2 _set_from_cgi :PRIVATE

    $self->_set_from_cgi();

Set our value from cgi if current post/get request
has data for our object (parameter name = object name).
Setting single and multiple values is supported.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Control::Template

=item *

Hyper::Control

=item *

Hyper::Name

=item *

List::MoreUtils

=item *

Hyper::Singleton::CGI

=item *

Hyper::Singleton::Debug

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
