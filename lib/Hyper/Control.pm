package Hyper::Control;

use strict;
use warnings;
use version; our $VERSION = qv('0.02');

use base qw(Hyper::Container);
use Class::Std::Storable;
use Scalar::Util;

use Hyper::Error;
use Hyper::Functions;

my %dispatch_of :ATTR(:name<dispatch>   :default<()>);
my %config_of   :ATTR(:name<config>     :default<()>);
my %owner_of    :ATTR(:get<owner>       :default<()>);

sub BUILD {
    # use @_ for speed
    # $self->set_owner( delete $arg_ref->{ owner })
    $_[0]->set_owner(delete $_[2]->{owner});
    return $_[0];
}

sub START {
    if ( my $config = $_[0]->get_config() ) {
        if ($config->can('get_dispatch')) {
            $dispatch_of{$_[1]} ||= $config->get_dispatch();
        }
    }

    return $_[0];
}

sub set_owner {
    $owner_of{ident $_[0]} = $_[1];
    Scalar::Util::weaken($owner_of{ident $_[0]});
    return $_[0];
}

sub set_value_recursive {
    my $self           = shift;
    my @parts          = @{(shift)};
    my $value          = shift;
    my $last_part      = pop @parts;
    my $last_value_ref = $self->get_value_recursive(\@parts, 1);

    if ( Scalar::Util::blessed($last_value_ref) ) {
        my $set_ref = $last_value_ref->can("set_$last_part")
            or throw(
                   sprintf
                       q{can't find setter >%s< in object of class >%s<},
                       "set_$last_part", ref $last_value_ref
               );
        $set_ref->($last_value_ref, $value);
    }
    else {
        $last_value_ref->{$last_part} = $value;
    }

    return $self;
}

sub get_value_recursive {
    my $self             = shift;
    my $parts_ref        = shift or return;
    my $autovivification = shift;
    my $last_value       = $self;

    # this == $self :)
    if ( $parts_ref->[0] eq 'this' ) {
        shift @{$parts_ref};
    }

    GET_VALUE: for my $name ( @{$parts_ref} ) {
        # is blessed object ?
        if ( Scalar::Util::blessed($last_value) ) {
            my $get_via_name_ref  = $last_value->can("get_$name");
            # via get_$name method
            $last_value = $get_via_name_ref
                ? do {
                      # via get_$name
                      my $value_of_get = $get_via_name_ref->($last_value);

                      defined $value_of_get || ! $autovivification
                          ? $value_of_get
                          : do {
                                my $new_value = {};
                                $last_value->can("set_$name")->($last_value, $new_value);
                                $new_value;
                            };
                  }
                : $last_value->isa('Hyper::Container') # via get_object method
                      ? do {
                            my $object = $last_value->get_object($name);

                            Scalar::Util::blessed($object)
                                ? $object
                                : throw(
                                      "can't get object with name >$name< in >"
                                      . ( ref $self )
                                      . '<'
                                  );
                        }
                      : throw(
                            "getting >$name< is not possible  in >"
                            . (ref $self)
                            . '<'
                        );
        }
        else {
            # is hash entry or croak
            $last_value = $last_value->{$name} ||= $autovivification ? {} : ();
        }
    }

    return $last_value;
}

sub STORABLE_thaw_post {
    my $self  = shift;
    my $class = $dispatch_of{ident $self}
      or return $self;

    Hyper::Functions::use_via_string($class);
    my $dispatch_ref = $class->can('DISPATCH')
        or throw("can't find method >DISPATCH< in class >$class<");
    $dispatch_ref->($self);

    # Storable restores weak references as normal references
    # weaken up-reference in tree after thawing
    Scalar::Util::weaken( $owner_of{ ident $self } )
        if defined $owner_of{ ident $self };

    return $self;
}

1;

__END__

=pod

=head1 NAME

Hyper::Control - base class for all control classes

=head1 VERSION

This document describes Hyper::Control 0.02

=head1 SYNOPSIS

    package Hyper::Control::Sample;

    use Class::Std::Storable;
    use base qw(Hyper::Control);

    1;

=head1 DESCRIPTION

Hyper::Control inherits from Hyper::Container, adds the capability for getting
the state of controls, including embedded controls and adds some methods
needed for running our generated code.

=head1 ATTRIBUTES

=over

=item dispatch :default<()> :name

=back

=head1 SUBROUTINES/METHODS

=head2 set_value_recursive

    $self->set_value_recursive(
        [qw(this initiator id)],                             # parts
        => $self->get_value_recursive([qw(permission type)]) # value
    );


Set a value by try and error. Don't call this method
in YOUR programms. It's only used in generated code.

=head2 get_value_recursive

    $self->get_value_recursive([qw(this initiator id)]);

Get a value by try and error. Don't call this method
in YOUR programms. It's only used in generated code.

=head2 STORABLE_thaw_post

Calls the DISPATCH method on the class stored in the dispatch attribute
if the dispatch attribute is true.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Container

=item *

Hyper::Error

=item *

Hyper::Functions

=item *

Scalar::Util

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: kutterma $

=item Id

$Id: Control.pm 497 2008-06-09 13:43:40Z kutterma $

=item Revision

$Revision: 497 $

=item Date

$Date: 2008-06-09 15:43:40 +0200 (Mo, 09 Jun 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Control.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
