package Hyper::Application::Default;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Application);
use Class::Std;

use Hyper;
use Hyper::Singleton::CGI;
use Hyper::Singleton::Context;
use Hyper::Singleton::Debug;
use Hyper::Template::HTC;

my %template_of :ATTR(:get<template>);

sub START {
    my $self    = shift;
    my $ident   = shift;
    my $arg_ref = shift;

    # init our template
    $template_of{$ident} = Hyper::Template::HTC->new(
        filename => $arg_ref->{template}
            || Hyper::Singleton::Context->singleton()
                   ->get_config(ref $self)
                   ->get_template()
            || 'index.htc',
        loop_context_vars => 1,
    );

    return $self;
}

sub _output_header :PROTECTED {
    my $self = shift;
    Hyper->singleton()->get_output_handle()->print(
        Hyper::Singleton::CGI->singleton()->header(
            -type            => 'text/html',
            -charset         => 'utf-8',
            '-cache-control' => 'must-revalidate, post-check=0, pre-check=0',
            @_
        ),
    );
    return $self;
}

sub work {
    my $self         = shift;
    my $hyper        = Hyper->singleton();
    my $template     = $self->get_template();
    my $flow_control = $self->get_flow_control();
    my $workflow     = $hyper->get_workflow();

    $self->_output_header();
    $template->param(
        service => $workflow->get_service(),
        usecase => $workflow->get_usecase(),
        header  => 1,
    );
    $template->output();

    if ( $flow_control ) {
        $flow_control->work();
        $self->_populate_viewstate();
    }

    $template->param(
        debug  => Hyper::Singleton::Debug->singleton()->get_html(),
        hidden => $self->_get_hidden_fields(),
        header => 0,
        footer => 1,
    );
    $template->output();

    return $self;
}

sub _get_hidden_fields :PROTECTED {
    my $self = shift;

    return {
        uuid      => Hyper->singleton()->get_uuid(),
        viewstate => $self->get_viewstate(),
    };
}

1;

__END__

=pod

=head1 NAME

Hyper::Application::Default - Default Application Class for Hyper

=head1 VERSION

This document describes Hyper::Application::Default 0.01

=head1 SYNOPSIS

    use Hyper::Application::Default;
    Hyper::Application::Default->new();

=head1 DESCRIPTION

Default Application for Hyper Workflows with HTML header.

=head1 ATTRIBUTES

=over

=item template :get

=back

=head1 SUBROUTINES/METHODS

=head2 START

    use Hyper::Application::Default;
    Hyper::Application::Default->new();

Initialize the template attribute with a new Hyper::Template::HTC object.
Use template from config or the template index.htc
HTC Object is created with param loop_context_vars => 1.

=head2 _output_header :PROTECTED

    $self->_output_header();

Output CGI headers (cache-control, type).

=head2 work

=over

=item 1.

Output header.

=item 2.

Output template with

    NAME       VALUE
    ------------------------------------------------
    service    service from Hyper Singleton
    usecase    usecase from Hyper Singleton
    header     1

=item 3.

Restore viewstate and start the workflow if the workflow is existant.

=item 4.

Output template with

    NAME       VALUE
    ------------------------------------------------
    service    service from Hyper Singleton
    usecase    usecase from Hyper Singleton
    header     0
    footer     1
    debug      html from Hyper::Singleton::Debug
    hidden     return from method _get_hidden_fields

=back

=head2 _get_hidden_fields

    my $hidden_ref = $self->_get_hidden_fields();

Returns a hashref with

    NAME       VALUE
    ------------------------------------------------
    uuid       uuid from Hyper Singleton
    viewstate  return from method _get_viewstate

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

Sample for your Context.ini

    [Hyper::Application::Default]
    template=index.htc

=head1 DEPENDENCIES

=over

=item *

L<version>

=item *

L<Hyper::Application>

=item *

L<Class::Std>

=item *

L<Hyper>

=item *

L<Hyper::Singleton::CGI>

=item *

L<Hyper::Singleton::Context>

=item *

L<Hyper::Singleton::Debug>

=item *

L<Hyper::Template::HTC>

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

 $Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Application/Default.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
