package Hyper::Application::Minimal;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std;
use base qw(Hyper::Application);

sub work {
    my $self = shift;

    if ( my $flow_control = $self->get_flow_control() ) {
        $flow_control->work();
        $self->_populate_viewstate();
    }

    return $self;
}

1;

__END__


=pod

=head1 NAME

Hyper::Application::Minimal - Minimalistic Application Class for Hyper

=head1 VERSION

This document describes Hyper::Application::Minimal 0.01

=head1 SYNOPSIS

    use Hyper::Application::Minimal;
    Hyper::Application::Minimal->new();

=head1 DESCRIPTION

Minimalistic Application for Hyper Workflows.

=head1 ATTRIBUTES

=head1 SUBROUTINES/METHODS

=head2 work

    use Hyper::Application::Minimal;
    Hyper::Application::Minimal->new()->work();

Restores viewstate and starts our workflow if existant.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Application

=item *

Class::Std

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

 $Author: ac0v $

=item Id

 $Id: Minimal.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

 $HeadURL: file:///srv/cluster/svn/repos/Hyper/Hyper/trunk/lib/Hyper/Application/Minimal.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
