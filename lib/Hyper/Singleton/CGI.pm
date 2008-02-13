package Hyper::Singleton::CGI;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(CGI);
my $instance;

sub new {
    if ($instance) {
        $instance->DESTROY();
    }

    return $instance = CGI::new(@_);
}

sub singleton {
    return $instance || shift->new(@_);
}

sub DESTROY {
    shift->SUPER::DESTROY();
    $instance = ();
}

1;

__END__

=pod

=head1 NAME

Hyper::Singleton::CGI - Singleton CGI Class.

=head1 VERSION

This document describes Hyper::Singleton::CGI 0.01

=head1 SYNOPSIS

    use Hyper::Singleton::CGI;

    my $singleton    = Hyper::Singleton::CGI->singleton();
    my $new_instance = Hyper::Singleton::CGI->new();

=head1 DESCRIPTION

Hyper::Singleton::CGI inherits from CGI and uses the
singleton design pattern.

=head1 SUBROUTINES/METHODS

=head2 new

    my $new_instance = Hyper::Singleton::CGI->new();

Create a new Object instance.

=head2 singleton

    my $singleton = Hyper::Singleton::CGI->singleton();

Get the object as singleton.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

CGI

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
