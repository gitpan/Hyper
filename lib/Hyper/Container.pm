package Hyper::Container;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;

my %objects_of :ATTR(:default<{}> :get<objects> :set<objects>);

sub set_object {
    my $self    = shift;
    my $arg_ref = shift;
    my $ident   = ident $self;

    for my $name ( keys %{$arg_ref} ) {
        $objects_of{$ident}->{$name} = $arg_ref->{$name};
    }

    return $self;
}

sub get_object {
    my $self  = shift;
    my $ident = ident $self;
    my $name  = shift;

    return $objects_of{$ident}->{$name};
}

1;

__END__

=pod

=head1 NAME

Hyper::Container - base class for all container classes.

=head1 VERSION

This document describes Hyper::Container 0.01

=head1 SYNOPSIS

    package Hyper::Control::Container;

    use Class::Std::Storable;
    use base qw(Hyper::Control::Container);

    1;

=head1 DESCRIPTION

Provides methods to set and get named objects which are needed in your class
(eg. some named embedded controls). This class is NOT only used
in Hyper::Control::Conainer.

=head1 ATTRIBUTES

=over

=item objects :get :set :default<{}>

=back

=head1 SUBROUTINES/METHODS

=head2 set_object

    $object->set_object({
        cNext => Hyper::Control::Base::BPushButton->new(),
        cReset => Hyper::Control::Base::BPushButton->new(),
    });

Store as many named objects as you like.
ATTENTION: Only Class::Std::Storable objects are supported
- other objects will crash on freeze (persistance).

=head2 get_object

    $object->get_object('bNext');

Get named object.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

 version

=item *

 Class::Std::Storable

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

 $Author: ac0v $

=item Id

 $Id: Container.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Container.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
