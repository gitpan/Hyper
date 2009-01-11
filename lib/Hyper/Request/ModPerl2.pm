package Hyper::Request::ModPerl2;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Apache2::RequestUtil;

use Readonly;
Readonly my $PACKAGE => __PACKAGE__;

sub set_note {
    my $note_ref = $_[-1];
    my $pnotes   = Apache2::RequestUtil->request()->pnotes();
    my @names    = keys %{$note_ref};

    for my $name ( @names ) {
        $pnotes->{$name} = $note_ref->{$name};
    }

    # store info which pnotes are used
    $pnotes->{$PACKAGE} = {
        %{$pnotes->{$PACKAGE} || {}},
        map { ( $_ => undef ); } @names,
    };

    return;
}

sub get_note {
    return Apache2::RequestUtil->request()->pnotes($_[1]);
}

sub cleanup {
    my $pnotes = Apache2::RequestUtil->request()->pnotes();

    for my $name ( keys %{$pnotes->{$PACKAGE} || {}} ) {
        delete $pnotes->{$name};
    }

    return;
}

1;


__END__

=pod

=head1 NAME

Hyper::Request::ModPerl2 - store data for one Request only

=head1 VERSION

This document describes Hyper::Request::ModPerl2 0.01

=head1 SYNOPSIS

    use Hyper::Request::ModPerl2;
    my $object = Hyper::Request::ModPerl2->new();

=head1 DESCRIPTION

Used to keep data persistent for one request. This mechanism is used for
Hyper's Singleton mechanism.

Instead of Hyper::Request::Default this class works with ModPerl2.

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

$Id: ModPerl2.pm 528 2009-01-11 05:43:02Z ac0v $

=item Revision

$Revision: 528 $

=item Date

$Date: 2009-01-11 06:43:02 +0100 (So, 11 Jan 2009) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Request/ModPerl2.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
