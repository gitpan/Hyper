package Hyper::Config::Object::Control::Validator;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Error;

my %class_of              :ATTR(:get<class> :default<'Hyper::Control::Validator'>);
my %template_of           :ATTR(:get<template>);
my %dispatch_of           :ATTR(:get<dispatch>);
my %validator_class_of    :ATTR(:get<validator_class>);
my %validator_template_of :ATTR(:get<validator_template>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;

    if ( exists $arg_ref->{class} ) {
        $class_of{$ident} = delete $arg_ref->{class};
    }
    $template_of{$ident}           = delete $arg_ref->{template};
    $validator_class_of{$ident}    = delete $arg_ref->{validator_class};
    $validator_template_of{$ident} = delete $arg_ref->{validator_template};

    if (%{$arg_ref}) {
        throw('invalid argument(s) >' . (join ',', keys %{$arg_ref}) . '< for validator config object ...');
    }
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Object::Control::Validator
 - Configuration Object for Validator Controls

=head1 VERSION

This document describes Hyper::Config::Object::Control::Validator 0.01

=head1 SYNOPSIS

use Hyper::Config::Object::Control::Validator;

    my $object = Hyper::Config::Object::Control->new({
        class => 'Hyper::Control::Validator',
    });

=head1 DESCRIPTION

Hyper::Config::Object::Control::Validator is used managing
configuration items for Hyper Validator Controls.

=head1 ATTRIBUTES

=over

=item class              :get :init_arg :defaul<'Hyper::Control::Validator'>

=item template           :get :init_arg :default<()>

=item dispatch           :get :init_arg :default<()>

=item validator_class    :get :init_arg :default<()>

=item validator_template :get :init_arg :default<()>

=back

=head1 SUBROUTINES/METHODS

=head2 new

    my $object = Hyper::Config::Object::Control->new({
        class => 'Hyper::Control::Validator',
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

 $Id: Validator.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Config/Object/Control/Validator.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
