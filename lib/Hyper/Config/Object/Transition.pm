package Hyper::Config::Object::Transition;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Error;

my %source_of      :ATTR(:get<source>);
my %destination_of :ATTR(:get<destination>);
my %condition_of   :ATTR(:get<condition>);

sub BUILD {
    my ($self, $ident, $arg_ref)  = @_;

    $source_of{$ident}      = delete $arg_ref->{source}      || throw('missing attribute >source<');
    $destination_of{$ident} = delete $arg_ref->{destination} || throw('missing attribute >destination<');
    $condition_of{$ident}   = delete $arg_ref->{condition};

    if (%{$arg_ref}) {
        throw('invalid argument(s) >' . (join ',', keys %$arg_ref) . '< for transition');
    }
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Object::Transition - Configuration Object for a Workflow Transition

=head1 VERSION

This document describes Hyper::Config::Object::Transition 0.01

=head1 SYNOPSIS

    use Hyper::Config::Object::Transition;

    my $object = Hyper::Config::Object::Transition->new({
        source      => 'Initialize',
        destination => 'Show',
    });

=head1 DESCRIPTION

Hyper::Config::Object::Transition is used for managing
configuration items for Hyper Workflow Transitions.

=head1 ATTRIBUTES

=over

=item source      :get :init_arg

=item destination :get :init_arg

=item condition   :get :init_arg :default<()>

=back

=head1 SUBROUTINES/METHODS

=head2 new

    my $object = Hyper::Config::Object::Transition->new({
        source      => 'Initialize',
        destination => 'Show',
    });

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

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
