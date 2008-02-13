package Hyper::Config::Object::Validator::Single;

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

Hyper::Config::Object::Validator::Single
 - Configuration Object for Single Validators

=head1 VERSION

This document describes Hyper::Config::Object::Validator::Single 0.01

=head1 SYNOPSIS

    use Hyper::Config::Object::Validator::single;

    my $object = Hyper::Config::Object::Validator::single->new({
        class => 'Hyper::Validator::Single::Required',
    });

=head1 DESCRIPTION

Hyper::Config::Object::Validator::Single is used managing
configuration items for Hyper Single Validators.

=head1 ATTRIBUTES

=over

=item class    :get :init_arg

=item template :get :init_arg :default<()>

=back

=head1 SUBROUTINES/METHODS

=head2 new

    my $object = Hyper::Config::Object::Validator::Single->new({
        class => 'Hyper::Validator::Single::Required',
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
