package Hyper::Request::ModPerl2;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Apache2::RequestUtil;

use Readonly;
Readonly my $PACKAGE => __PACKAGE__;

sub set_note {
    my $note_ref = shift;
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

# ToDo: Add POD
