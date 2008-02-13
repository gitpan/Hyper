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

# ToDo: Add POD
