package Hyper::Singleton::Debug;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use base qw(Hyper::Singleton Hyper::Debug);

1;

__END__

=pod

=head1 NAME

Hyper::Singleton::Debug - Singleton version of Hyper::Debug.

=head1 VERSION

This document describes Hyper::Singleton::Debug 0.01

=head1 SYNOPSIS

    use Hyper::Singleton::Debug;

    my $singleton    = Hyper::Singleton::Debug->singleton();
    my $new_instance = Hyper::Singleton::Debug->new();

=head1 DESCRIPTION

Hyper::Singleton::Debug inherits from Hyper::Debug and uses the
singleton design pattern.

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Singleton

=item *

Hyper::Debug

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Debug.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Singleton/Debug.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
