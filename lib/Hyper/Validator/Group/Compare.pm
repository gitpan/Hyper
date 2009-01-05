package Hyper::Validator::Group::Compare;

use strict;
use warnings;

use version; our $VERSION = qv('0.01');

use base qw(Hyper::Validator::Group);
use Class::Std::Storable;

sub VALIDATE {
    my $self    = shift;
    my $arg_ref = shift;

    return exists $arg_ref->{first}
    && exists $arg_ref->{second}
    && (
        defined $arg_ref->{first}
         && defined $arg_ref->{second}
         && $arg_ref->{first} eq $arg_ref->{second}
         || ! defined $arg_ref->{first}
         && ! defined $arg_ref->{second}
    );
}

1;

__END__

=pod

=head1 NAME

Hyper::Validator::Group::Compare - Validator comparing values

=head1 VERSION

This document describes Hyper::Validator::Group::Compare 0.01

=head1 SYNOPSIS

    use Hyper::Validator::Group::Compare;

    my $validator = Hyper::Validator::Group::Compare->new();
    my $invalid   = $validator->is_valid({
        first  => 'value one',
        second => 'value two',
    });
    my $valid     = $validator->is_valid({
        first  => 'match',
        second => 'match',
    });
    my $valid_too = $validator->is_valid({
        first  => undef,
        second => undef,
    });


=head1 DESCRIPTION

Hyper::Validator::Group is used for checking
if a two values are equal.

=head1 SUBROUTINES/METHODS

=head2 VALIDATE

    $validator->VALIDATE($arg_ref);

Called from Hyper::Validator::is_valid for the validation

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Validator::Group

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Compare.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Validator/Group/Compare.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
