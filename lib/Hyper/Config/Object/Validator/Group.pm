package Hyper::Config::Object::Validator::Group;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Error;

my %class_of    :ATTR(:get<class>);
my %template_of :ATTR(:get<template>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;

    $class_of{$ident}    = delete $arg_ref->{class} || throw('missing attribute >class<');
    $template_of{$ident} = delete $arg_ref->{template};

    if (%{$arg_ref}) {
        throw('invalid argument(s) >' . (join ',', keys %{$arg_ref}) . '< for validator config object');
    }
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Object::Validator::Group
 - Configuration Object for Group Validators

=head1 VERSION

This document describes Hyper::Config::Object::Validator::Group 0.01

=head1 SYNOPSIS

    use Hyper::Config::Object::Validator::Group;

    my $object = Hyper::Config::Object::Validator::Group->new({
        class => 'Hyper::Validator::Group::Compare',
    });

=head1 DESCRIPTION

Hyper::Config::Object::Validator::Group is used managing
configuration items for Hyper Group Validators.

=head1 ATTRIBUTES

=over

=item class    :get :init_arg

=item template :get :init_arg :default<()>

=back

=head1 SUBROUTINES/METHODS

=head2 new

    my $object = Hyper::Config::Object::Validator::Group->new({
        class => 'Hyper::Validator::Group::Compare',
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

 $Id: Group.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Config/Object/Validator/Group.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
