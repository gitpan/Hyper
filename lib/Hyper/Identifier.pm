package Hyper::Identifier;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Singleton);
use Class::Std::Storable;

use Readonly;
Readonly my $IDENTIFIER_PREFIX => 'hyperid_';

my %identifier_of :ATTR(:default<0>);

sub create_identifier {
    my $self    = shift;
    my $ident   = ident $self;

    $identifier_of{$ident}++;

    return "$IDENTIFIER_PREFIX$identifier_of{$ident}";
}

1;

__END__

=pod

=head1 NAME

Hyper::Identifier - get a unique identifer (eg. for html ids)

=head1 VERSION

This document describes Hyper::Identifier 0.01

=head1 SYNOPSIS

    use Hyper::Identifier 0.01;

    my $identifier = Hyper::Identifier->new()->create_identifier();

=head1 DESCRIPTION

Hyper::Identifier creates unique identifiers. It depends on
the singleton design pattern.

=head1 SUBROUTINES/METHODS

=head2 create_identifier

    my $identifier = $object->create_identifier();

Create and get a new unique identifier.

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

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: $

=item Id

$Id: $

=item Revision

$Revision: $

=item Date

$Date: $

=item HeadURL

$HeadURL: $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
