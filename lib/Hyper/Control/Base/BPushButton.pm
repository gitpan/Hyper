package Hyper::Control::Base::BPushButton;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control::Base);
use Class::Std::Storable;

sub pushed {
    my $self   = shift;
    my $pushed = $self->get_value() ? 1 : 0;

    $self->clear();

    return $pushed;
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Base::BPushButton - Push Button Base Control

=head1 VERSION

This document describes Hyper::Control::Base::BPushButton 0.01

=head1 SYNOPSIS

    use Hyper::Control::Base::BPushButton;
    my $object = Hyper::Control::Base::BPushButton->new();

=head1 DESCRIPTION

Base Control for Buttons (eg. submit buttons)

=head1 SUBROUTINES/METHODS

=head2 pushed

    $object->pushed();

Returns a boolean value that indicates if the button was pushed.
ATTENTION: This method clears/deletes the value of the object.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Control::Base

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: BPushButton.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Control/Base/BPushButton.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

