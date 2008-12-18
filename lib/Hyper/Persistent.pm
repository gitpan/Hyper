package Hyper::Persistent;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std;
use Data::UUID;
use Storable;
use Cache::FileCache;

use Hyper::Error;
use Hyper::Singleton::Context;
use Hyper::Functions qw(listify);

use Readonly;
Readonly my @CACHE_KEYS => qw(
    flow_control
    single_validators
    group_validators
    service
    usecase
    controls
    shown_controls
);

my %uuid_of  :ATTR(:name<uuid> :default<()>);
my %cache_of :ATTR();

sub START {
    my ($self, $ident, $arg_ref) = @_;

    # set uuid to arg ref, if present,
    # and create on if there is none.
    # Allows sub-classes to set their uuid in BUILD
    $uuid_of{$ident} ||= Data::UUID->new->create_str();
    $cache_of{$ident} = Cache::FileCache->new({
        namespace  => $uuid_of{$ident},
        cache_root => Hyper::Singleton::Context
            ->singleton()
            ->get_config()
            ->get_cache_path()
    });

    return $self;
}

sub freeze {
    my $self    = shift;
    my $arg_ref = shift; # { workflow validators service usecase controls }
    my $cache   = $cache_of{ident $self};

    CACHE:
    for my $key ( @CACHE_KEYS ) {
        $arg_ref->{$key} or next CACHE;
        $cache->set($key => Storable::freeze($arg_ref->{$key}));
    }

    # controls is used for a control specific caches :D
    $arg_ref->{element} or return $self;

    $cache->set(
        controls => {
            map {
                $_->get_name() => $_;
            } listify($arg_ref->{controls})
        },
    );

    return $self;
}

sub thaw {
    my $self  = shift;
    my $what  = shift;

    return Storable::thaw(
        $cache_of{ident $self}->get(
            $what or throw(q{can't thaw without a valid identifier})
        ) or return
    );
}

1;

__END__

=pod

=head1 NAME

Hyper::Persistent - Object cache for the Hyper Framework

=head1 VERSION

This document describes Hyper::Persistent 0.01

=head1 SYNOPSIS

    use Hyper::Persistence;
    my $cache = Hyper::Persistence->new();

=head1 DESCRIPTION

Hyper::Persistence is used for the workflow cache which is used to
store hyper objects which are used on different pages.

=head1 ATTRIBUTES

=over

=item uuid :name :default<()>

=item cache

=back

=head1 SUBROUTINES/METHODS

=head2 START

Initialize uuid with return from Data::UUID->new->create_str()
if uuid is false. Create a Cache::FileCache object in the uuid
namespace with cache path from config and store it to the cache
attribute.

=head2 thaw

    my $old_object_data = $object->thaw();

Thaw your persistence objects form the cache.

=head2 freeze

    $object->freeze({
        flow_control      => $flow_control,
        single_validators => $single_validators,
        group_validators  => $group_validators
        service           => $service,
        usecase           => $usecase,
        shown_controls    => $shown_controls,
        controls          => [
            $base_control,
            $any_other_control,
        ],
    });

Freeze your objects for persistence. The controls
key is used as an for an control specific cache.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

Sample for your Context.ini

    [Hyper::Persistent]
    cache_path=/tmp/hyper_cache

=head1 DEPENDENCIES

=over

=item *

version

=item *

L<Class::Std>

=item *

L<Readonly>

=item *

L<Data::UUID>

=item *

L<Storable>

=item *

L<Cache::FileCache>

=item *

L<Hyper::Error>

=item *

L<Hyper::Singleton::Context>

=item *

L<Hyper::Functions>

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Persistent.pm 357 2008-04-09 08:54:54Z ac0v $

=item Revision

$Revision: 357 $

=item Date

$Date: 2008-04-09 10:54:54 +0200 (Wed, 09 Apr 2008) $

=item HeadURL

$HeadURL: file:///srv/cluster/svn/repos/Hyper/Hyper/trunk/lib/Hyper/Persistent.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
