package Hyper::Control::Container;

use strict;
use warnings;
use version; our $VERSION = qv('1.0');

use base qw(Hyper::Control::Flow Hyper::Control::Template Hyper::Name);

use Class::Std::Storable;

use Hyper::Config::Reader::Container;
use Hyper::Singleton::Context;

my %config_of :ATTR();

sub _get_config :RESTRICTED {
    my $self = shift;

    # get our config object
    return Hyper::Config::Reader::Container->new({
        config_for => ref $self,
        base_path  => Hyper::Singleton::Context->singleton()
            ->get_config()->get_base_path(),
    });
}
sub use_out_fh {
    return 0;
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Container - base class for all base container classes

=head1 VERSION

This document describes Hyper::Control::Container 1.0

=head1 SYNOPSIS

    package Hyper::Control::Container::CSampleContainer;

    use Class::Std::Storable;
    use base qw(Hyper::Control::Container);

    1;

=head1 DESCRIPTION

Hyper::Control::Container provides group validator and config acces
for container controls.

=head1 SUBROUTINES/METHODS

=head2 _get_config :RESTRICTED

    my $config = $self->_get_config();

Returns a Hyper::Config::Object::Container object with the
the config for the object.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Control::Flow

=item *

Hyper::Control::Template

=item *

Hyper::Name

=item *

Class::Std::Storable

=item *

Hyper::Config::Reader::Container

=item *

Hyper::Singleton::Context

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Container.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Control/Container.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
