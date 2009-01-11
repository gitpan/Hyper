package Hyper::Config::Object::Context;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;

my %data_of :ATTR;

sub set_config_of {
    my ($self, $for_package, $config) = @_;

    $data_of{ident $self}->{$for_package} = $config;
}

sub get_config {
    my $self    = shift;
    my $package = shift || caller;
    my $ident   = ident $self;

    return exists $data_of{$ident}->{$package}
        ? $data_of{$ident}->{$package}
        : do {
              # remove singleton crap for some auto thinges :)
              $package =~ s{\A ([^:]+::)Singleton::}{$1}xms;
              $data_of{$ident}->{$package} || $data_of{$ident}->{Global};
          };
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Object::Context - Context Configuration Object

=head1 VERSION

This document describes Hyper::Config::Object::Context 0.01

=head1 SYNOPSIS

    use Hyper::Config::Object::Context;
    use Hyper::Config::Object::Default;

    my $context = Hyper::Config::Object::Context->new();
    $context->set_config_of(
        'MyClass::Name' => Hyper::Config::Object::Default->new({
            data => {
                file => '/tmp/x.tmp',
                path => '/tmp',
            },
        }),
    );

       $context->get_config('MyClass::Name')->get_path()
    eq $context->get_config('MyClass::Singleton::Name')->get_path()
    eq '/tmp';

=head1 DESCRIPTION

Hyper::Config::Object::Context is used to access contextual
configuration items, eg. cache_path for Hyper::Persistence.

=head1 SUBROUTINES/METHODS

=head2 set_config_of

    $context->set_config_of(
        'MyPackage::Name' => $config,
    );

You can set the config for a package where every kind
of storable object and data structre is allowed as $config.

=head2 get_config

    my $config = $context->get_config('MyPackage::Name');

or use automatically the caller package as key

    my $config = $context->get_config();

Returns the Configuration item of an object.

=head3 Lookup Sequence (first found config is used)

=over

=item *

via given key (if there was no param we use caller package as key)

=item *

remove any >::Singleton< things from the key and do the lookup again

=item *

last chance to get a config using >Global< as key

=back

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

 $Id: Context.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Config/Object/Context.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
