package Hyper::Request::ModPerl2;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Apache2::RequestUtil;

sub set_note {
    my $note_ref = shift;
    my $pnotes   = Apache2::RequestUtil->request()->pnotes();
    my @names    = keys %{$note_ref};

    for my $name ( @names ) {
        $pnotes->{$name} = $note_ref->{$name};
    }

    # store info which pnotes are used
    $pnotes->{__PACKAGE__} = {
        %{$pnotes->{__PACKAGE__} || {}},
        map { ( $_ => undef ); } @names,
    };

    return;
}

sub get_note {
    return Apache2::RequestUtil->request()->pnotes($_[1]);
}

sub cleanup {
    my $pnotes = Apache2::RequestUtil->request()->pnotes();

    for my $name ( keys %{$pnotes->{__PACKAGE__} || {}} ) {
        delete $pnotes->{$name};
    }

    return;
}

1;

# ToDo: Add POD
