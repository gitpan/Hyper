package Hyper::Control::Flow;

use strict;
use warnings;
use version; our $VERSION = qv('1.1');

use base qw(Hyper::Control);

use Class::Std::Storable;
use Hyper::Error;

use Hyper::Config::Reader::Flow;
use Hyper::Identifier;
use Hyper::Functions;
use Hyper::Singleton::Debug;
use Hyper::Singleton::Context;
use Scalar::Util;
use List::MoreUtils qw(any);

my %identifier_of :ATTR();
my %state_of      :ATTR();
my %config_of     :ATTR();

sub START {
    my ($self, $ident, $arg_ref) = @_;

    # for persistance of identifier id's
    $identifier_of{$ident}  = Hyper::Identifier->singleton();
    $config_of{ident $self} = $self->_get_config();

    return $self;
}

sub get_state {
    return $state_of{ident shift} ||= 'START';
}

sub use_out_fh {
    return 1;
}

sub set_state {
    $state_of{ident $_[0]} = $_[1];
    return $_[0];
}

sub _get_config :RESTRICTED {
    my $self = shift;

    # get our config object
    return Hyper::Config::Reader::Flow->new({
        config_for => ref $self,
        base_path  => Hyper::Singleton::Context->singleton()
            ->get_config()->get_base_path(),
    });
}

sub get_object {
    my $self = shift;
    my $name = shift || return;

    # get existant object
    my $object = $self->SUPER::get_object($name);

    return $object if $object;

    # object isn't existant => try to create it
    my $config   = $config_of{ident $self};
    my $control  = $config->get_controls()->{$name} || return;
    my $class    = $control->get_class();
    my $step     = $config->get_steps()->{$name};

    $object = Hyper::Functions::use_via_string($class)->new({
        config => $control,
        owner  => $self,
    });

    # decrement ref xounter to prevent a memory hole
    Scalar::Util::weaken($self);

    $self->SUPER::set_object({$name => $object});

    return $object;
}

sub work {
    my $self          = shift;
    my $ident         = ident $self;
    my $current_state = $self->get_state();

    Hyper::Singleton::Debug->singleton->add_debug(
        sprintf 'work control of class >%s< with state >%s<', ref $self, $current_state
    );

    {   # execute generated action method if existant
        my $action_ref = $self->can("_action_of_$current_state");
        if ( $action_ref ) {
            Hyper::Singleton::Debug->singleton->add_debug(
                "... execute generated actions of >$current_state<"
            );
            $action_ref->($self);
        }
    }

    {   # execute user action method if implemented
        my $action_ref = $self->can("ACTION_$current_state");
        if ( $action_ref ) {
            Hyper::Singleton::Debug->singleton->add_debug(
                "... execute method >ACTION_$current_state<"
            );
            $action_ref->($self);
        }
    }

    my @embedded_controls = do {
        my $step = $config_of{ident $self}->get_steps()->{$current_state}
            or throw("step named >$current_state< not found");
        @{$step->get_controls() || []};
    };
    for my $name_of_embedded_control ( @embedded_controls ) {
        Hyper::Singleton::Debug->singleton->add_debug(
            "... work embedded control >$name_of_embedded_control<"
        );
        my $embedded_control = $self->get_object($name_of_embedded_control)
            or throw("embedded control named >$name_of_embedded_control< is not configured");

        # traverse / work embedded controls if existant and workable ;)
        my $work_ref = $embedded_control->can('work');
        if ( $work_ref ) {
            $work_ref->($embedded_control);
        }
    }

    my $next_state = $self->_check_transitions();
    if ( $next_state ) {
        Hyper::Singleton::Debug->singleton->add_debug(
            "... walk transition from >$current_state< to >$next_state<"
        );
        $self->set_state($next_state);
        return $self->work();
    }

    return;
}

# returns new state if transition matched
sub _check_transitions :PROTECTED {
    my $self          = shift;
    my $current_state = shift || $self->get_state();

    # check transitions
    if ( my $destination_ref = $self->can("_get_destination_of_$current_state") ) {
        # try to get destination of transition or return
        my $destination_state = $destination_ref->($self)
            or return;

        # check for changed state
        return $self if $destination_state eq $current_state;

        # return next state
        return $destination_state;
    }

    return;
}

sub get_state_recursive {
    my $self      = shift;
    my $ident     = ident $self;
    my %object_of = %{$self->get_objects() || {}};
    my $state     = $self->get_state();

    return ( $state eq 'START' || $state eq 'END' )
        ? ()
        : [ $state,
            map {
                my $object = $object_of{$_};
                my $get_state_recursive = $object->can('get_state_recursive');
                $get_state_recursive
                    ? do {
                          my $state_of_embedded = $get_state_recursive->($object);
                          $state_of_embedded
                              ? { $_ => $get_state_recursive->($object) }
                              : ()
                      }
                    : ();
            } keys %object_of
          ];
}

sub restore_state_recursive {
    my $self      = shift;
    my $state_ref = shift or return $self;
    my $ident     = ident $self;
    my %object_of = %{$self->get_objects() || {}};

    my $current_state = shift @{$state_ref};
    $self->set_state(
            $self->_check_transitions($current_state) || $current_state
    );

    SET_EMBEDDED_STATES:
    for my $state_for_ref ( @{$state_ref} ) {
        if (ref $state_for_ref && ref $state_for_ref eq 'HASH') {
            my ($name, $embedded_state_ref) = @{[ %{$state_for_ref} ]};
            my $object = $object_of{$name} or next SET_EMBEDDED_STATES;
            my $restore_state_recursive = $object->can('restore_state_recursive')
                    or next SET_EMBEDDEDSTATE;
            $restore_state_recursive->($object, $embedded_state_ref);
        }
    }

    return $self;
}

sub is_valid {
    my $self = shift;

    # validate groups after single validators
    my ($invalid, @groups);
    for my $control ( values %{$self->get_objects()} ) {
        if ( $control->isa('Hyper::Control::Validator::Group') ) {
            push @groups, $control;
        }
        else {
            my $is_valid = $control->can('is_valid')
                ? $control->is_valid()
                : 1;
            $invalid ||= ! $is_valid;
        }
    }

    my $groups_are_invalid = grep {
        ! $_->is_valid();
    } @groups;

    return ! ( $invalid || $groups_are_invalid );
}

sub STORABLE_thaw_post :CUMULATIVE {
    $state_of{ident shift} = ();
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Flow - base class for all flow and container controls

=head1 VERSION

This document describes Hyper::Control::Flow 1.1

=head1 SYNOPSIS

    package Hyper::Control::Flow::FSampleControl;

    use Class::Std::Storable;
    use base qw(Hyper::Control::Flow);

    1;

=head1 DESCRIPTION

This class allows you to create flow controls which are
defined in your configuration. It checks conditions to walk
different transitions and calls generated functions and functions
which where implemented in the code you've written.
There are also methods to get the current state recursivelay
(including all embedded controls) and another method to restore
an old state (this is needed for browser back and forward button).

=head1 ATTRIBUTES

=over

=item identifier

=item state

=item config

=back

=head1 SUBROUTINES/METHODS

=head2 START

    my $object = Hyper::Control::Flow::FSampleControl->new();

Initialize Hyper::Identifier for persistance of ids.
Calls _get_config and stores the config into the config
attribute. If we have no state we set current state
to START.

=head2 _get_config :RESTRICTED

Get config for instance of this control.

=head2 get_object

    my $embedded_control = $self->get_object('cSelectPerson');

Get an embedded control. Control Object is created if it
wasn't existant since yet. Control class is read from
config object.
This method will also initialize and append validators
which are configured for a control.

=head2 work

    $object->work();

Start workflow of flow control.

Generated Code comes from your step config.
Call generated actions, call your action
methods if it they where implemented and check
for transitions. If the condition of a transition
is true the internal state of Hyper::Control::Flow is
updated the state is updated and method work is
called again.

Workflow description of the work method:

=over

=item $self->_action_of_step()

=item $self->ACTION_of_step()

=item $embedded_control->work()

=item check transitions

=item if current transition condition is valid

update internal state and call work again

=item if no transitions left

return

=back

=head2 get_state

    my $state = $object->get_state();

Get the current state of an object.

=head2 set_state

    $object->set_state('step name');

Set state of the control. Valid states are the names of
your steps defined in your config.

=head2 get_state_recursive

    my $viewstate = $object->get_state_recursive();

Get the state of this and all embedded controls.

Return structure:
  [ 'state_of_this_control',
    { name_of_embedded_1 => [...] },
    { name_of_embedded_2 => [...] },
  ]

=head2 restore_state_recursive

    $object->restore_state_recursive($viewstate);

Restore state of this and all embedded controls
eg. after GET or POST. Use the return value from
get_state_recursive to restore a state.

=head2 _check_transitions :PROTECTED

    my $destination_state = $self->_check_transitions();

This method is used to check if a valid transition can be found.

=head2 is_valid

    my $all_embedded_controls_are_valid = $object->is_valid();

Check if all embedded controls are valid and return a boolean value.
This method performs the group validation only if all single
validators are valid.

=head2 STORABLE_thaw_post :CUMULATIVE

This method is called automatically. It deletes the state object attribute.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Control

=item *

Class::Std::Storable

=item *

Hyper::Error

=item *

Hyper::Config::Reader::Flow

=item *

Hyper::Identifier

=item *

Hyper::Functions

=item *

Hyper::Singleton::Debug

=item *

Hyper::Singleton::Context

=item *

List::MoreUtils

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Flow.pm 318 2008-02-16 01:57:57Z ac0v $

=item Revision

$Revision: 318 $

=item Date

$Date: 2008-02-16 02:57:57 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Control/Flow.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
