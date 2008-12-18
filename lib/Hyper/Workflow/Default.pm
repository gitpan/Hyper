package Hyper::Workflow::Default;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std;

use Storable;

use Hyper;
use Hyper::Functions;
use Hyper::Singleton::CGI;
use Hyper::Singleton::Context;
use Hyper::Singleton::Container::Validator::Group;
use Hyper::Singleton::Container::Validator::Single;

my %service_of                 :ATTR(:get<service>);
my %usecase_of                 :ATTR(:get<usecase>);
my %viewstate_of               :ATTR(:get<viewstate>);
my %application_of             :ATTR(:get<application>);
my %application_class_of       :ATTR(:name<application_class> :default<()>);
my %_current_shown_controls_of :ATTR(:default<{}>);
my %_shown_controls_of         :ATTR();

sub START {
    my $self  = shift;
    my $ident = shift;
    my $cgi   = Hyper::Singleton::CGI->singleton();
    my $cache = Hyper->singleton()->get_cache();

    $application_class_of{$ident}
        ||= Hyper::Singleton::Context
                ->singleton()
                ->get_config('Class')
                ->get_application()
        || 'Hyper::Application::Default';

    $service_of{$ident}
        =    $cgi->param('service')
          || $cgi->param('s')
          || do {
                 my $thawn = $cache->thaw('service');
                 $thawn ? ${$thawn} : ()
             };
    $usecase_of{$ident}
        =    $cgi->param('usecase')
          || $cgi->param('u')
          || do {
              my $thawn = $cache->thaw('usecase');
              $thawn ? ${$thawn} : ()
          };
    $_shown_controls_of{$ident} = $cache->thaw('shown_controls') || {};

    $viewstate_of{$ident}
        = Hyper::Singleton::CGI->singleton()->param('viewstate');

    return $self;
}

sub work {
    my $self  = shift;
    my $ident = ident $self;
    my $cache = Hyper->singleton()->get_cache();

    if ( $service_of{$ident} && $usecase_of{$ident} ) {
        my $flow_class = Hyper::Functions::use_via_string(
            Hyper::Singleton::Context
                ->singleton()
                ->get_config('Global')
                ->get_namespace()
            . "::Control::Flow::$service_of{$ident}::F$usecase_of{$ident}"
        );

        # thaw / create all neccessary things
        my $flow_control      = $cache->thaw('flow_control') || $flow_class->new();
        my $single_validators = $cache->thaw('single_validators')
                             || Hyper::Singleton::Container::Validator::Single->singleton();
        my $group_validators  = $cache->thaw('group_validators')
                             || Hyper::Singleton::Container::Validator::Group->singleton();

        my $application
            = $application_of{$ident}
            = Hyper::Functions::use_via_string(
                  Hyper::Functions::fix_class_name($self->get_application_class())
              )->new({
                  flow_control => $flow_control,
                  viewstate    => $viewstate_of{$ident},
              });
        $application->work();

        $_shown_controls_of{$ident}->{$application->get_viewstate() || q{}}
            = $_current_shown_controls_of{$ident};

        # freeze
        local $Storable::forgive_me = 1;
        $cache->freeze({
            flow_control      => $flow_control,
            single_validators => $single_validators,
            group_validators  => $group_validators,
            service           => \$service_of{$ident},
            usecase           => \$usecase_of{$ident},
            shown_controls    => $_shown_controls_of{$ident},
        });
    }
    else {
        # work the flow -> workflow :)
        Hyper::Functions::use_via_string(
            Hyper::Functions::fix_class_name($self->get_application_class())
        )->new()->work();
    }

    return $self;
}

sub set_show_state {
    my $self    = shift;
    my $control = shift;

    $_current_shown_controls_of{ident $self}->{$control->get_name()} = ();

    return $self;
}

sub get_show_state {
    my $self    = shift;
    my $control = shift;

    return exists $_shown_controls_of{ident $self}
        ->{$self->get_viewstate()}
        ->{$control->get_name()};
}

1;

__END__

=pod

=head1 NAME

Hyper::Workflow::Default - Default Workflow for Hyper

=head1 VERSION

This document describes Hyper::Workflow::Default 0.01

=head1 SYNOPSIS

    use Hyper::Workflow::Default;
    my $workflow = Hyper::Workflow::Default->new();
    $workflow->work();

=head1 DESCRIPTION

=head1 ATTRIBUTES

=over

=item service           :get

=item usecase           :get

=item viewstate         :get

=item application       :get

=item application_class :name :default<()>

Default is configurable via L<Hyper::Singleton::Context> or points to
L<Hyper::Application::Default>.

    [Class]
    application=Hyper::Application::Minimal

=item _shown_controls

Private attribute needed for _set_from_cgi in L<Hyper::Control::Base>

=item _current_shown_controls

Private attribute needed for _set_from_cgi in L<Hyper::Control::Base>

=back

=head1 SUBROUTINES/METHODS

=head2 START

Set application class with data from config attribute if it's false.

=head2 work

Start a the workflow.

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

=head2 set_show_state

    my $base_control = Hyper::Control::Base::BPushButton->new();
    $workflow->set_show_state($base_control);

Sets show state of $base_control in the current workflow viewstate.
This is used to do L<Hyper::Control::Base>::_set_from_cgi on thaw
only if this element was shown in an viestate (see get_show_state).

=head2 get_show_state

    my $base_control = Hyper::Control::Base::BPushButton->new();
    my $was_shown    = $workflow->get_show_state($base_control);

Indicates if a Base Control was shown in current viewstate.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

    [Global]
    namespace=YourNamespace

    [Class]
    application=Hyper.Application.Any


=head1 DEPENDENCIES

=over

=item *

L<version>

=item *

L<Class::Std>

=item *

L<Storable>

=item *

L<Hyper>

=item *

L<Hyper::Functions>

=item *

L<Hyper::Singleton::CGI>

=item *

L<Hyper::Singleton::Context>

=item *

L<Hyper::Singleton::Container::Validator::Group>

=item *

L<Hyper::Singleton::Container::Validator::Single>

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

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Workflow/Default.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
