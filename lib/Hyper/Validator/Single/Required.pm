package Hyper::Validator::Single::Required;

use strict;
use warnings;

use version; our $VERSION = qv('0.01');

use base qw(Hyper::Validator::Single);
use Class::Std::Storable;

sub VALIDATE {
    my $self  = shift;
    my $value = shift;

    return defined $value && $value ne q{};
}

1;

__END__

=pod

=head1 NAME

Hyper::Validator::Single::Required - Validator for required values

=head1 VERSION

This document describes Hyper::Validator::Single::Required 0.01

=head1 SYNOPSIS

    use Hyper::Validator::Single::Required;

    my $validator = Hyper::Validator::Single::Required->new();
    my $invalid   = $validator->is_valid(undef);
    my $valid     = $validator->is_valid(1);


=head1 DESCRIPTION

Hyper::Validator::Single::Required is used for checking
if a value is defined and not an empty string.

=head1 SUBROUTINES/METHODS

=head2 VALIDATE

    $validator->VALIDATE($value);

Called from Hyper::Validator::is_valid for the validation.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Validator::Single

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Required.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Validator/Single/Required.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
