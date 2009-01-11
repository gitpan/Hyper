package Hyper::Control::Primitive;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control Hyper::Control::Template);
use Class::Std::Storable;

sub use_out_fh {
    return 0;
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Primitive - base class for all primitive control classes

=head1 VERSION

This document describes Hyper::Control::Primitive 0.01

=head1 SYNOPSIS

    package Hyper::Control::Primitive::PSampleControl;

    use Class::Std::Storable;
    use base qw(Hyper::Control::Primitive);

    1;

=head1 DESCRIPTION

Hyper::Control::Primitive inherits from Hyper::Control and is just
a empty class for the religous inheriting concept of the framework.

Primitive Controls are Controls which are not specified. So you can
do anything you'd like to do in your primitives.

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Control

=item *

Hyper::Control::Template

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

$Id: Primitive.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Control/Primitive.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
