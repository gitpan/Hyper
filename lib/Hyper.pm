package Hyper;

use strict;
use warnings;
use version; our $VERSION = qv('0.03');

use Class::Std;
{
    # workaround to suppress uninitialized warning
    # see http://rt.cpan.org/Public/Bug/Display.html?id=30833
    my $class_std_can = \&UNIVERSAL::can;
    no warnings qw(redefine once);
    *UNIVERSAL::can = sub {
        defined $_[0] or return;
        return $class_std_can->(@_);
    };
}

use base qw(Hyper::Singleton);

use IO::Scalar;

use Hyper::Persistent;
use Hyper::Functions;
use Hyper::Singleton::CGI;

my %uuid_of           :ATTR(:get<uuid>);
my %cache_of          :ATTR(:get<cache>);
my %output_handle_of  :ATTR(:name<output_handle> :default<()>);
my %workflow_of       :ATTR(:get<workflow>);
my %workflow_class_of :ATTR(:name<workflow_class> :default<()>);

sub START {
    my $self  = shift;
    my $ident = ident $self;

    $output_handle_of{$ident}  ||= IO::Scalar->new();

    # ToDo: add all other Workflows.... (Validator (Single+Group)
    $workflow_class_of{$ident} ||= 'Hyper::Workflow::Default';

    return $self;
}

sub work {
    my $self  = shift;
    my $ident = ident $self;

    # get/init our cache
    $cache_of{$ident} = Hyper::Persistent->new({
        uuid => scalar Hyper::Singleton::CGI->singleton()->param('uuid'),
    });
    $uuid_of{$ident}  = $cache_of{$ident}->get_uuid();

    $workflow_of{$ident} = Hyper::Functions::use_via_string(
        $workflow_class_of{$ident}
    )->new();
    $workflow_of{$ident}->work();

    print ${$output_handle_of{$ident}->sref()};

    return $self;
}

1;

__END__

=pod

=head1 NAME

Hyper - The global Hyper Workflow Interface

=head1 VERSION

This document describes Hyper 0.03

=head1 SYNOPSIS

    use Hyper;
    Hyper->new()->work();

=head1 DESCRIPTION

=head1 ATTRIBUTES

=over

=item service        :get

=item usecase        :get

=item uuid           :get

=item cache          :get

=item output_handle  :name<output_handle> :default<IO::Scalar->new()>

=item workflow       :get

=item workflow_class :name :default<'Hyper::Workflow::Default'>

=back

=head1 SUBROUTINES/METHODS

=head2 START

Set application class with data from config attribute if it's false.

=head2 work

Start a Hyper workflow.

=over

=item 1.

Create new cache for persistence or get existant cache.
The CGI param uuid is used as cache id.

=item 2.

Get service from cgi param s(ervice) or from the cache if existant.

=item 3.

Get usecase from cgi param u(secase) or from the cache if existant.

=item 4.

Start a hyper workflow (Default, Single Validation, Group Validation)

=back

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

=head1 DEPENDENCIES

=over

=item *

L<version>

=item *

L<Class::Std>

=item *

L<IO::Scalar>

=item *

L<Hyper::Singleton>

=item *

L<Hyper::Persistent>

=item *

L<Hyper::Functions>

=item *

L<Hyper::Singleton::CGI>

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Hyper.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
