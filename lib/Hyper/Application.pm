package Hyper::Application;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std;
use JSON::XS 2.01;

my %flow_control_of :ATTR(:name<flow_control> :default<()>);
my %viewstate_of    :ATTR(:get<viewstate>);

sub START {
    my $self         = shift;
    my $viewstate    = $_[1]->{viewstate};
    my $flow_control = $self->get_flow_control();

    if ( $flow_control && $viewstate ) {
        $flow_control->restore_state_recursive(
            decode_json(
                $viewstate_of{ident $self} = $viewstate
            )
        );
    }

    return $self;
}

sub _populate_viewstate :RESTRICTED {
    my $self         = shift;
    my $ident        = ident $self;
    my $flow_control = $self->get_flow_control() or return q{};
    my $viewstate    = $flow_control->get_state_recursive();

    if ( ref $viewstate ) {
        $viewstate = encode_json($viewstate);
    }

    return $viewstate_of{$ident} = $viewstate;
}

1;

__END__

=pod

=head1 NAME

Hyper::Application - abstract base class for Hyper Applications

=head1 VERSION

This document describes Hyper::Application 0.01

=head1 SYNOPSIS

    use Hyper::Application;
    Hyper::Application->new({ flow_control => $flow_control })->work();

=head1 DESCRIPTION

Provides basic features needed for traversing flow controls.

=head1 ATTRIBUTES

=over

=item flow_control :name<flow_control :default<()>

=item viewstate    :get<viewstate>

This should be a valid JSON string.

=back

=head1 SUBROUTINES/METHODS

=head2 START

    Hyper::Application->new();

Restores viewstate of the flow_control the viewstate attribute of
both are existant in the object attributes.

=head2 _populate_viewstate :RESTRICTED

    $self->_populate_viewstate();

Collects the viewstate from the flow_control and stores the
collected value as JSON string to the viewstate attribute.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

L<version>

=item *

L<Class::Std>

=item *

L<JSON::XS>

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

 $Author: ac0v $

=item Id

 $Id: Application.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Application.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
