package Hyper::Config::Object::Default;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;

my %data_of :ATTR(:init_arg<data>);

sub AUTOMETHOD {
    my ($self, $ident, @arguments) = @_;
    my $method_name = $_;

    if ( $method_name =~ m{get_(.+)}xms ) {
        my $get_what = $1;
        return sub {
            $data_of{$ident}->{$get_what};
        }
    }

    warn "can't call >$method_name< on >" . (ref $self) . '< object';

    return;
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Object::Default - Default Configuration Object

=head1 VERSION

This document describes Hyper::Config::Object::Default 0.01

=head1 SYNOPSIS

    use Hyper::Config::Object::Default;

    my $default = Hyper::Config::Object::Default->new({
        data => {
            file => '/tmp/x.tmp',
            path => '/tmp',
        }
    });
    $default->get_path() eq '/tmp';

=head1 DESCRIPTION

Hyper::Config::Object::Default is used for storing simple
configuration items like those used in the hyper context.

=head1 ATTRIBUTES

=over

=item data :init_arg

=back

=head1 SUBROUTINES/METHODS

=head2 new

    my $default = Hyper::Config::Object::Default->new({
        data => {
            file => '/tmp/x.tmp',
            path => '/tmp',
        }
    });

Each key of the data hash ref init_arg is accessable via a
get_$name_of_key method which is added via AUTOMETHOD.

=head2 get_*

    $default->get_path();

Where * is a key of the data init_arg. Returns value
of the value with the key * in the hash ref of init_arg
data.

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

 $Id: Default.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Config/Object/Default.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
