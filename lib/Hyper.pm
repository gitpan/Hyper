package Hyper;

use strict;
use warnings;
use version; our $VERSION = qv('0.05');

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

This document describes Hyper 0.05

=head1 SYNOPSIS

    use Hyper;
    Hyper->new()->work();

=head1 DESCRIPTION

Hyper stands for "Hype reloaded" and is a framework for workflow based web applications.
With Hyper you're able to create Workflows with persistent data. It's like a running your
Perl code on a Tomcat Server ;)

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

$Id: Hyper.pm 528 2009-01-11 05:43:02Z ac0v $

=item Revision

$Revision: 528 $

=item Date

$Date: 2009-01-11 06:43:02 +0100 (So, 11 Jan 2009) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
