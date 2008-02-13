package Hyper::Control::Base::BSelect;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control::Base);
use Class::Std::Storable;

my %elements_of :ATTR(:set<elements> :get<elements>);

sub add_element {
    my $self = shift;

    push @{$elements_of{ident $self} ||= []}, @_;

    return $self;
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Base::BSelect - Select Base Control

=head1 VERSION

This document describes Hyper::Control::Base::BSelect 0.01

=head1 SYNOPSIS

    use Hyper::Control::Base::BSelect;
    my $object = Hyper::Control::Base::BSelect->new();

=head1 DESCRIPTION

Base Control for Selects (eg. select, select with multiple, mulitselect)

=head1 ATTRIBUTES

=over

=item elements :get :set

=back

=head1 SUBROUTINES/METHODS

=head2 add_element

    $object->add_element(qw(one two three));

Append elements to the elements attribute.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Control::Base

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
