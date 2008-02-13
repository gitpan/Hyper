package Hyper::Control::Validator;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control Hyper::Control::Template Hyper::Name);
use Class::Std::Storable;
use Hyper::Error;

sub get_html {
    return shift->get_template()->output();
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Validator - Control for getting Validator messages.

=head1 VERSION

This document describes Hyper::Control::Validator 0.01

=head1 SYNOPSIS

    use Hyper::Control::Validator;

    my $object = Hyper::Control::Validator->new();

=head1 DESCRIPTION

Control which offers a template based container for validator messages.

=head1 SUBROUTINES/METHODS

=head2 get_html

    my $validator_output = $object->get_html();

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

Hyper::Name

=item *

Class::Std::Storable

=item *

Hyper::Error

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
