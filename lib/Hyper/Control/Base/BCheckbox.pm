package Hyper::Control::Base::BCheckbox;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control::Base);
use Class::Std::Storable;

sub checked {
    my $self = shift;
    return 1 if defined $self->get_value();
    return;
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Base::BCheckbox - Single Checkbox Base Control

=head1 VERSION

This document describes Hyper::Control::Base::BCheckbox 0.01

=head1 SYNOPSIS

    use Hyper::Control::Base::BCheckbox;
    my $object = Hyper::Control::Base::BCheckbox->new();

=head1 DESCRIPTION

Base Control for a single Checkbox

=head1 SUBROUTINES/METHODS

=head2 checked

    my $is_checked = $object->checked();

Indicates if checkbox was checked or not.

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

$Id: BCheckbox.pm 237 2007-12-05 12:53:43Z ac0v $

=item Revision

$Revision: 237 $

=item Date

$Date: 2007-12-05 13:53:43 +0100 (Wed, 05 Dec 2007) $

=item HeadURL

$HeadURL: file:///srv/cluster/svn/repos/Hyper/Hyper/branches/0.02/lib/Hyper/Control/Base/BCheckbox.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
