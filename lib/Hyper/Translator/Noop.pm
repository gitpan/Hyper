package Hyper::Translator::Noop;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Translator);
use Class::Std::Storable;

sub translate {
    return $_[1];
}

1;

=head1 NAME

Hyper::Translator::Noop - A translator which does not translate at all

=head1 VERSION

This document describes Hyper::Translator::Noop 0.01

=head1 SYNOPSIS

    use Hyper::Translator::Noop;

    my $translator = Hyper::Translator::Noop->new();

    $translator->translate('my text') eq 'my text';

=head1 DESCRIPTION

Hyper::Translator::Noop is a translator which is
used for non i18n environments or while developing.

=head1 SUBROUTINES/METHODS

=head2 translate

Returns it's parameter $_[1].

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Translator

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
