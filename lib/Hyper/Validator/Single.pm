package Hyper::Validator::Single;

use strict;
use warnings;

use version; our $VERSION = qv('0.01');

use base qw(Hyper::Validator);
use Class::Std::Storable;

1;

__END__

=pod

=head1 NAME

Hyper::Validator::Single - Base class for single validators

=head1 VERSION

This document describes Hyper::Validator::Single 0.01

=head1 SYNOPSIS

    package Hyper::Validator::Single::Required;

    use Class::Std::Storable;
    use base qw(Hyper::Validator::Single);

    sub VALIDATE {
        return defined $_[0];
    }

    1;

=head1 DESCRIPTION

Hyper::Validator::Single is only for a strict inheritance
queue used in the whole Hyper Framework.

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

 Hyper::Validator

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
