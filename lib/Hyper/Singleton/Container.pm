package Hyper::Singleton::Container;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use base qw(Hyper::Singleton Hyper::Container);

1;

__END__

=pod

=head1 NAME

Hyper::Singleton::Container - Singleton version of Hyper::Container.

=head1 VERSION

This document describes Hyper::Singleton::Container 0.01

=head1 SYNOPSIS

    use Hyper::Singleton::Container;

    my $singleton    = Hyper::Singleton::Container->singleton();
    my $new_instance = Hyper::Singleton::Container->new();

=head1 DESCRIPTION

Hyper::Singleton::Container inherits from Hyper::Container and uses the
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

Hyper::Container

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

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Singleton/Container.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
