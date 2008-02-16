package Hyper::Config::Object::Control;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Error;

my %name_of              :ATTR(:get<name>);
my %template_of          :ATTR(:get<template>);
my %class_of             :ATTR(:get<class>);
my %dispatch_of          :ATTR(:get<dispatch>);
my %single_validators_of :ATTR(:get<single_validators> :set<single_validators>);
my %named_validators_of  :ATTR(:get<named_validators> :set<named_validators>);
my %group_validators_of  :ATTR(:get<group_validators> :set<group_validators>);
my %validator_control_of :ATTR(:get<validator_control> :set<validator_control>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;

    $name_of{$ident}              = delete $arg_ref->{name}  or throw('missing attribute >name<');
    $class_of{$ident}             = delete $arg_ref->{class} or throw('missing attribute >class<');
    $dispatch_of{$ident}          = delete $arg_ref->{dispatch};
    $template_of{$ident}          = delete $arg_ref->{template};
    $single_validators_of{$ident} = delete $arg_ref->{single_validators};
    $group_validators_of{$ident}  = delete $arg_ref->{group_validators};
    $validator_control_of{$ident} = delete $arg_ref->{validator_control};

    if (%{$arg_ref}) {
        throw('invalid argument(s) >' . (join ',', keys %$arg_ref) . '< for control ...');
    }
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Object::Control - Configuration Object for Controls

=head1 VERSION

This document describes Hyper::Config::Object::Control 0.01

=head1 SYNOPSIS

    use Hyper::Config::Object::Control;

    my $object = Hyper::Config::Object::Control->new({
        name  => 'cTestControl',
        class => 'Hyper::Control::Base::Test::Me',
    });

=head1 DESCRIPTION

    Hyper::Config::Object::Control is used managing configuration
    items for Hyper Controls.

=head1 ATTRIBUTES

=over

=item name              :get :init_arg

=item class             :get :init_arg

=item template          :get :init_arg :default<()>

=item dispatch          :get :init_arg :default<()>

=item single_validators :get :init_arg :default<()> :set

=item named_validators  :get :init_arg :default<()> :set

=item group_validators  :get :init_arg :default<()> :set

=item validator_control :get :init_arg :default<()> :set

=back

=head1 SUBROUTINES/METHODS

=head2 new

    my $object = Hyper::Config::Object::Control->new({
        name  => 'cTestControl',
        class => 'Hyper::Control::Base::Test::Me',
    });

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Error

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

 $Author: ac0v $

=item Id

 $Id: Control.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Config/Object/Control.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
