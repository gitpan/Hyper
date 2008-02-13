package Hyper::Name;

use strict;
use warnings;

use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Identifier;

my %name_of :ATTR(:set<name> :get<name>);

sub START {
    my $self  = shift;
    my $ident = shift;
    my $name  = $name_of{$ident};

    return defined $name
        ? $name
        : ( $name_of{$ident} = Hyper::Identifier->singleton()->create_identifier() );
        # don't delete the () otherwise we create on each call a new identifier
}

1;

=pod

=head1 NAME

Hyper::Name - class for getting unique names for each instance.

=head1 VERSION

This document describes Hyper::Name 0.01

=head1 SYNOPSIS

    use Hyper::Name;

    my $object_name = Hyper::Name->new()->get_name();

=head1 DESCRIPTION

Hyper::Name is a class for creating unique names
used for example for cgi-param names.

=head1 ATTRIBUTES

=over

=item name :set :get

=back

=head1 SUBROUTINES/METHODS

=head2 get_name

    my $name = $object->get_name();

Returns a unique name for the object. If we've currently
no name we genarate one using Hyper::Identifier method
create_identifier.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

 version

=item *

 Class::Std::Storable

=item *

 Hyper::Identifier

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
