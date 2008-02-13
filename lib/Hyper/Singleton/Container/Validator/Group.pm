package Hyper::Singleton::Container::Validator::Group;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use base qw(Hyper::Singleton::Container::Validator);

1;

__END__

=pod

=head1 NAME

Hyper::Singleton::Container::Validator::Group
 - a Hyper::Singleton::Container::Validator used for group validators.

=head1 VERSION

This document describes Hyper::Singleton::Container::Validator::Group 0.01

=head1 SYNOPSIS

    use Hyper::Singleton::Container::Validator::Group;

    my $singleton    = Hyper::Singleton::Container::Validator::Group->singleton();
    my $new_instance = Hyper::Singleton::Container::Validator::Group->new();

=head1 DESCRIPTION

Hyper::Singleton::Container::Validator::Group inherits from
Hyper::Singleton::Container::Validator.

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

Hyper::Singleton::Container::Validator

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
