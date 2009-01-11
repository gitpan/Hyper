package Hyper::Request::Default;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

my $_note_ref;

sub set_note {
    my $note_ref = $_[1];

    for my $name ( keys %{$note_ref} ) {
        $_note_ref->{$name} = $note_ref->{$name};
    }

    return;
}

sub get_note {
    return $_note_ref->{$_[1]};
}

sub cleanup {
    return $_note_ref = ();
}

1;

__END__

=pod

=head1 NAME

Hyper::Request::Default - store data for one Request only

=head1 VERSION

This document describes Hyper::Request::Default 0.01

=head1 SYNOPSIS

    use Hyper::Request::Default;
    my $object = Hyper::Request::Default->new();

=head1 DESCRIPTION

Used to keep data persistent for one request. This mechanism is used for
Hyper's Singleton mechanism.

=head1 ATTRIBUTES

=head1 SUBROUTINES/METHODS

=head2 set_note

    $object->set_note({ 'Hyper::Singleton::Test' => $singleton_test });

Add a named note/item to request-sensitive storage.

=head2 get_note

    $object->get_note('Hyper::Singleton::Test');

Get a named note/item from request-sensitive storage.

=head2 cleanup

    $object->cleanup();

Remote all notes/items from  request-sensitive storage.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Default.pm 528 2009-01-11 05:43:02Z ac0v $

=item Revision

$Revision: 528 $

=item Date

$Date: 2009-01-11 06:43:02 +0100 (So, 11 Jan 2009) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Request/Default.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
