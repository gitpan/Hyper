package Hyper::Config::Object::Step;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Error;

my %name_of        :ATTR(:get<name>);
my %controls_of    :ATTR(:get<controls>);
my %action_of      :ATTR(:get<action>);
my %transitions_of :ATTR(:get<transitions> :default<[]>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;

    $name_of{$ident}        = delete $arg_ref->{name} || throw('missing attribute >name< in step');
    $transitions_of{$ident} = delete $arg_ref->{transitions};
    $controls_of{$ident}    = delete $arg_ref->{controls};
    $action_of{$ident}      = delete $arg_ref->{action};

    if (%{$arg_ref}) {
        throw('invalid argument(s) >' . (join ',', keys %$arg_ref) . '< for step');
    }
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Object::Step - Configuration Object for a Workflow Step

=head1 VERSION

This document describes Hyper::Config::Object::Step 0.01

=head1 SYNOPSIS

use Hyper::Config::Object::Step;

    my $object = Hyper::Config::Object::Step->new({
        name  => 'this.value=MyDataSource',
    });

=head1 DESCRIPTION

Hyper::Config::Object::Step is used managing configuration
items for Hyper Workflow Steps.

=head1 ATTRIBUTES

=over

=item name        :get :init_arg

=item controls    :get :init_arg :default<()>

=item action      :get :init_arg :default<()>

=item transitions :get :init_arg :default<[]>

=back

=head1 SUBROUTINES/METHODS

=head2 new

    my $object = Hyper::Config::Object::Step->new({
        name  => 'this.value=MyDataSource',
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

 $Id: Step.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Config/Object/Step.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
