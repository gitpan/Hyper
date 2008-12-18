package Hyper::Debug;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;

my %debug_messages_of :ATTR(:default<[]>);

sub get_html {
    my $self  = shift;
    my $ident = ident $self;

    return '<div style="border: 1px solid #0000FF; margin: 8px;">'
        . '<div style="background: #0000FF; font-weight: bold; color: #FFFFFF;">Messages of Hyper::Debug</div>'
        . '<div style="padding: 10px;">'
        . (
            join q {}, map {
                my $package = $_->{caller};
                my $message = join '<br />', map {
                        s{&}{&amp;}xmsg;
                        s{>}{&gt;}xmsg;
                        s{<}{&lt;}xmsg;
                        $_;
                    } @{$_->{messages}};

                qq{<div style="font-weight: bold;">$package</div>
                   <div style="margin-left: 10px;">$message</div>}
            } @{$debug_messages_of{$ident}}
        )
        . '</div></div>';
}

sub add_debug {
    my ($self, @messages) = @_;
    my $caller            = caller;
    my $ident             = ident $self;

    # if caller differs from last caller of this function ...
    if (@{$debug_messages_of{$ident}} && $debug_messages_of{$ident}->[-1]->{caller} eq $caller) {
        push @{$debug_messages_of{$ident}->[-1]->{messages}}, @messages;
    }
    else {
        push @{$debug_messages_of{$ident}}, {
            caller   => $caller,
            messages => \@messages,
        };
    }

    return $self;
}

1;

__END__

=pod

=head1 NAME

Hyper::Debug - class for storing debug messages

=head1 VERSION

This document describes Hyper::Debug 0.01

=head1 SYNOPSIS

    use Hyper::Debug;

    my $debug = Hyper::Debug->new();
    $debug->add_debug('... checking fuel');

=head1 DESCRIPTION

Hyper::Debug can store messages with information of the package were they wre dropped.

=head1 ATTRIBUTES

=over

=item debug_messages :default<[]>

=back

=head1 SUBROUTINES/METHODS

=head2 add_debug

    $object->add_debug('.. checking fuel');

Add new debug message to object.

=head2 get_html

    my $debug_html = $object->get_html();

Get debug messages as readable html.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

 $Author: ac0v $

=item Id

 $Id: Debug.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

 $HeadURL: file:///srv/cluster/svn/repos/Hyper/Hyper/trunk/lib/Hyper/Debug.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
