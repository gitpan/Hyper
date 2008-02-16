package Hyper::Config::Reader::Flow;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Config::Reader);
use Class::Std::Storable;

use Hyper::Error;
use Hyper::Functions;
use Hyper::Config::Object::Step;
use Hyper::Config::Object::Control;
use Hyper::Config::Object::Transition;

my %steps_of      :ATTR(:default<{}> :get<steps>);
my %validators_of :ATTR(:default<{}> :get<validators>);
my %controls_of   :ATTR(:default<{}> :get<controls>);
my %attributes_of :ATTR(:default<[]> :get<attributes>);

sub _read_config :PROTECTED {
    my $self              = shift;
    my $ini               = shift;
    my $ident             = ident $self;
    my %step_config_of    = ();
    my %control_config_of = ();

    for my $full_group ( $ini->GroupMembers('Control') ) {
        my (undef, $control_name, $sub_group)
            = split m{\s}, $full_group;

        next if $sub_group;

        my $control = $control_config_of{$control_name} = {
            name => $control_name, map {
                $_ => $ini->val($full_group, $_);
            } $ini->Parameters($full_group)
        };

        # fix class name: replace . with ::
        for my $attr_name ( qw(class dispatch) ) {
            $control->{$attr_name} &&= Hyper::Functions::fix_class_name(
                $control->{$attr_name}
            );
        }
    }
    # create Hyper::Config::Object::Control objects
    $controls_of{$ident} = {
        map {
            $_->{name} => Hyper::Config::Object::Control->new($_);
        } values %control_config_of
    };

    for my $full_group ( $ini->GroupMembers('Step') ) {
        my (undef, $step_name, $transition_destination)
            = split m{\s}, $full_group;

        # remove = signs
        $step_name =~ s{=}{_}xmsg;
        $step_config_of{$step_name}->{name} = $step_name;

        if ( $transition_destination ) {
            push @{$step_config_of{$step_name}->{transitions} ||= []},
                Hyper::Config::Object::Transition->new({
                    source      => $step_name,
                    destination => $transition_destination,
                    map {
                        $_ => $ini->val($full_group, $_);
                    } $ini->Parameters($full_group)
                });
        }
        else {
            # Why here ? we need it for all steps...
            # -> moved up
            # $step_config_of{$step_name}->{name} = $step_name;

            # val returns a list in list context - no need to split it up
            # later...

            # valid are currently transition, controls, action
            for my $param_name ( $ini->Parameters($full_group) ) {
                $step_config_of{$step_name}->{$param_name}
                    = $param_name eq 'action'
                          ? $ini->val($full_group, $param_name)
                          : $param_name eq 'controls'
                                ? [ $ini->val($full_group, $param_name) ]
                                : throw("invalid data >$param_name< for step named >$step_name<");
            }

        }
    }

    # create Hyper::Config::Object::Step objects
    $steps_of{$ident} = {
        map {
            $_->{name} => Hyper::Config::Object::Step->new($_);
        } values %step_config_of
    };

    $attributes_of{$ident} = [
        grep {
            defined $_;
        } $ini->val('Global', 'attributes')
    ];

    return $self;
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Reader::Flow - ini style Flow Control config reader

=head1 VERSION

This document describes Hyper::Config::Reader::Flow 0.01

=head1 SYNOPSIS

    use Hyper::Config::Reader::Flow;
    my $object = Hyper::Config::Reader::Flow->new({
        base_path => '/srv/web/www.example.com/',
        file      => 'etc/MyPortal/Control/Flow/FTest.ini',
    });

=head1 DESCRIPTION

This module is used for reading ini config files into Hyper config objects.

=head1 ATTRIBUTES

=over

=item steps      :get :default<{}>

=item validators :get :default<{}>

=item controls   :get :default<{}>

=item attributes :get :default<[]>

=back

=head1 SUBROUTINES/METHODS

=head2 _read_config :PROTECTED

Internally used to read the config file into an object hierarchy.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

The ini style configuration files are stored within the following structure:

 $BASE_PATH/etc/$NAMESPACE/Control/Flow/$SERVICE/$USECASE.ini

=head1 CONFIG FILE SYNTAX

The config file syntax is UNIX-Style .ini-Files. They are a bit different
from Windows-style .ini files - the most notable difference is
heredoc-support:

 attribute=<<EOT
 first_value
 second_value
 third_value
 EOT

The config file is split into several sections.

=head2 Config file sections

=head3 [Global]

Global configuration data goes here.

The attributes allowed in [Global] are described below.

=over

=item attributes

Attributes for this Control. Multiple attributes can be specified using the
heredoc syntax.

=back

Example:

 [Global]
 attributes=<<EOT
 mMyAttribute
 mAnotherOne
 EOT

=head3 [Control] - embedded controls

You can embed Flow, Container and Primitive controls. Each embedded control
needs a unique name and a class.

Controls are all subsections of the section [Control]:

 [Control]
 [Control $NAME]

Controls have the following attributes:

=over

=item class :MANDATORY

Class of the embedded control. Perl class name with all '::' replaced by '.'
and without the leading Hyper namespace

Example:

 [Control cSampleControl]
 ; use Hyper::Control::Container::CSample as Perl class
 class=Control.Container.CSample

=item template :OPTIONAL

Available for Container, Base and Primitive Controls. Template used for
rendering a control. You may either specify a path relative to base_path
or an absolute path.

=item dispatch :OPTIONAL

You can specify a class where a method named DISPATCH exists.
This method is called very early in our Hyper workflow, before
anything was printed to the client. You can change the Hyper
application for example if you won't send any HTML Headers.
This is needed for example if you'd like to implement a download.

=back

Full example:

 [Control]
 [Control cExampleControl]
 class=ControlType.myService.myUsecase
 template=/path/to/template

=head3 [Step] - workflow steps

A workflow consist of a number of steps. Steps may have actions (code) to be
executed and controls to be displayed.

Steps are connected via transitions which may have conditions to be met.

All steps are subsections of the section [Step]:

 [Step]
 [Step myStep]

Steps may have the following attributes:

=over

=item action :OPTIONAL

Actions are executed before your own code is executed.
In actions, you may assign data to embedded controls by reading out other
controls' data or calling their methods.

Multiple actions can be specified using the heredoc syntax.
Each action must be terminated by ';'.

Elements of the action syntax are described below.

=over

=item * this

The special control "this" refers to an instance of the current object itself:

 this.mAccount=cAccount.value();

This corresponds to $self used as a convention in perl classes.

=item * Constants

Numbers without any quotes or text with embraced by ' or ".

 this.mNumericConstant=23;
 this.mStringConstant="Hello World"

=item * Variables / Attributes

Variables can be nested with a '.' as seperator. Each variable must begin
with a char A-Z, a-z as first sign. All other chars of the variable
name can be A-Z, a-z, _ and 0-9.

 this.mNumericConstant=this.someVariable;
 this.mStringConstant=cControl.anotherVariable2;

=item * Methods

Each method name must begin with a char A-Z, a-z as first sign. All other
chars of the variable name can be A-Z, a-z, _ and 0-9.

Methods can also be called on nested variables if the variable has this
method.

=back

Examples:

 ; assignment
 action=<<EOT
 this.mTextAttribute="This is a Constant";
 this.mAnotherText='Another Constant';
 this.mNumber=1234;
 cEmbeddedContainer.mValue=cAnotherContainer.mTest;
 EOT

 ; method call
 action=<<EOT
 this.callMe();
 cEmbeddedContainer.mValue=cAnotherContainer.test();
 EOT

=back

=head3 [Step $SOURCE $DESTINATION] - transitions from one step to another

Each Step may have multiple transitions to other steps.

Transitions are written as sub-sections of the source step with the name of
the destination step:

 [Step SourceStep DestinationStep]

Transitions may only be performed when a condition is met. If no condition
is specified, the transition will be performed automatically.

Transitions may have the following attributes:

=over

=item condition :OPTIONAL

You may use constants, variables, and method calls in conditions
(see actions for more information). You can't make assignments but you
may use the following logical operators.

 Operator       Description
 ------------------------------------
 !              Logical not
 not            Not operator
 ==             Numeric equal
 !=             Numeric uneuqal
 eq             String equal
 ne             String unequal
 &&             Logical and
 ||             Logical or
 and            And operator
 or             or operator

Operator precendence is equal to perl - see L<perlop> for details.

Examples:

 [Step One altTwo]
 condition=this.is_valid();

 [Step One altTwo]
 condition=this.is_valid() && cControl.something.is_valid();

=back

=head2 CODE GENERATION

use generate-flow.pl to generate a perl class for yout flow control with
a shadow class and a basic template.

 hyper.pl -b $BASE_PATH -s $SERVICE -u $USECASE -t flow

The following files will be generated:

if not existant:

 $BASE_PATH/lib/Hyper/Control/Flow/$SERVICE/F$USECASE.pm
 $BASE_PATH/var/Hyper/Control/Flow/$SERVICE/$USECASE.htc

always (previous files will be overwritten):

 $BASE_PATH/lib/Hyper/Control/Flow/$SERVICE/_F$USECASE.pm

=head2 YOUR CODE

Each Step will call a method named action_$STEP_NAME if existant.

This methods may gather data from interfaces, perform interface calls etc.

You should place your code and template into

 $BASE_PATH/lib/Hyper/Control/Flow/$SERVICE/F$USECASE.pm
 $BASE_PATH/var/Hyper/Control/Flow/$SERVICE/$USECASE.htc

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Config::Reader

=item *

Class::Std::Storable

=item *

Hyper::Error

=item *

Hyper::Functions

=item *

Hyper::Config::Object::Step

=item *

Hyper::Config::Object::Control

=item *

Hyper::Config::Object::Transition

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Flow.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Config/Reader/Flow.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
