package Hyper::Config::Reader::Container;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Config::Reader::Flow);
use Class::Std::Storable;

use Hyper::Config::Object::Control::Validator;
use Hyper::Config::Object::Validator::Group;
use Hyper::Config::Object::Validator::Named;
use Hyper::Config::Object::Validator::Single;
use Hyper::Functions;
use Hyper::Error;

sub _read_config {
    my $self  = shift;
    my $ini   = shift;
    my $ident = ident $self;

    $self->SUPER::_read_config($ini);
    my $control_ref = $self->get_controls();

    VALIDATOR_SUB_GROUPS:
    for my $full_group ( $ini->GroupMembers('Validator') ) {
        my (undef, $validator_name) = split m{\s}, $full_group;

        defined $validator_name or next VALIDATOR_SUB_GROUPS;

        my %arg_of =  map {
            $_ => scalar $ini->val($full_group, $_);
        } $ini->Parameters($full_group);
        $arg_of{class} = Hyper::Functions::fix_class_name($arg_of{class});

        $control_ref->{$validator_name} = Hyper::Config::Object::Control::Validator->new({
            class    => $control_ref->{$validator_name}->get_class(),
            template => $control_ref->{$validator_name}->get_template(),
            map {
                ("validator_$_" => scalar $arg_of{$_});
            } keys %arg_of
        });
    }

    my %validators_of = ();
    CONTROL_SUB_GROUPS:
    for my $full_group ( $ini->GroupMembers('Control') ) {
        my (undef, $control_name, @group_parts) = split m{\s}, $full_group;

        @group_parts or next CONTROL_SUB_GROUPS;
        my $sub_type = shift @group_parts;
        if ( $sub_type eq 'Validator') {
            my $type = shift @group_parts;

            my %arg_of =  map {
                $_ => scalar $ini->val($full_group, $_);
            } $ini->Parameters($full_group);

            if ( $type eq 'Single' ) {
                if ( my $class = shift @group_parts ) {
                    push @{$validators_of{$control_name}->{single}},
                        Hyper::Config::Object::Validator::Single->new({
                            class => Hyper::Functions::fix_class_name($class),
                            %arg_of,
                        });
                }
                else {
                    $arg_of{class} &&= Hyper::Functions::fix_class_name(
                        $arg_of{class}
                    );
                    $validators_of{$control_name}->{control}
                        = Hyper::Config::Object::Control::Validator->new(\%arg_of);
                }
            }
            elsif ( $type eq 'Named' ) {
                my $validator_name = shift @group_parts;
                $validator_name or next CONTROL_SUB_GROUPS;
                exists $control_ref->{$validator_name}
                    or throw("can't find group validator control named >$validator_name<");

                push @{$validators_of{$control_name}->{named}},
                    Hyper::Config::Object::Validator::Named->new({
                        name => $validator_name,
                        %arg_of,
                    });
            }
            elsif ( $type eq 'Group' ) {
                my $class = shift @group_parts;
                $class or next CONTROL_SUB_GROUPS;
                push @{$validators_of{$control_name}->{group}},
                    Hyper::Config::Object::Validator::Group->new({
                        class => Hyper::Functions::fix_class_name($class),
                        %arg_of,
                    });
            }
            else {
                throw("unknown validator type >$type< near $full_group");
            }
        }
        else {
            throw("unknown sub type >$sub_type< near >$full_group<");
        }
    }
    for my $control_name ( keys %{$control_ref} ) {
        my $validator_ref = $validators_of{$control_name};
        my $control       = $control_ref->{$control_name};
        if ( $validator_ref->{single} ) {
            $control->set_single_validators($validator_ref->{single});
            $control->set_validator_control(
                $validator_ref->{control} || Hyper::Config::Object::Control::Validator->new({
                    class => 'Hyper::Control::Validator::Single',
                })
            );
        }
        $control->set_group_validators($validator_ref->{group});
        $control->set_named_validators($validator_ref->{named});
    }

    return $self;
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Reader::Container - ini style Container Control config reader

=head1 VERSION

This document describes Hyper::Config::Reader::Container 0.01

=head1 SYNOPSIS

    use Hyper::Config::Reader::Container;
    my $object = Hyper::Config::Reader::Container->new({
        base_path => '/srv/web/www.example.com/',
        file      => 'MyPortal/Control/Container/FTest.ini',
    });

=head1 DESCRIPTION

This module is used for reading ini config files into Hyper config objects.

=head1 SUBROUTINES/METHODS

=head2 _read_config :PROTECTED

Internally used to read the config file into an object hierarchy.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

The ini style configuration files are stored within the following structure:

 $BASE_PATH/etc/$NAMESPACE/Control/Container/$SERVICE/$USECASE.ini

=head1 CONFIG FILE SYNTAX

See Hyper::Config::Reader::Flow for more options.
Hyper::Control::Container are Flow Controls but they can also
have some validation stuff.

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

=head3 [Control $NAME Validator Single] - attach single validators

You can attach Single Validators to Controls (eg. Required Validator for
a Hyper::Control::Base::BInput Control).

=over

=item template :OPTIONAL

Template for the Hyper::Validator::Control::Container object which is
used as container where the validator messages should be shown.

=back

=head3 [Control $NAME Validator Single $VALIDATOR_CLASS]

Attach a specific validator to the control.

=over

=item template :OPTIONAL

Template with the Validator message.

=back

Full example:

 [Control]
 [Control cExampleControl]
 class=ControlType.myService.myUsecase
 template=/path/to/template
 [Control cExampleControl Validator Single Hyper.Validator.Single.Required]
 [Control cExampleControl Validator Single Hyper.Validator.Single.EMail]

=head3 [Control $NAME Validator Group $CLASS] - be a group validator

This Control is used to show the group validator.

Full example:

 [Control]
 [Control vComparePasswords]
 class=Hyper.Control.Validator.Group
 [Control vComparePassword Validator Group Hyper.Validator.Group.Compare]

=head3 [Control $NAME Validator Named $GROUP] - attach named group validators

Let the Control act as a object in a group validator. $GROUP is the name
of the Group Validator Control.

=over

=item act_as :MANDATORY

Act as named role in the group validator.

=back

Full example:

 [Control]
 [Control vComparePasswords]
 class=Hyper.Control.Validator.Group
 [Control vComparePassword Validator Group Hyper.Validator.Group.Compare]

 [Control cNewPassword]
 class=Hyper.Control.Base.BInput
 [Control cNewPassword Validator Named vComparePasswords]
 act_as=first
 [Control cRepeatNewPassword]
 class=Hyper.Control.Base.BInput
 [Control cRepeatNewPassword Validator Named vComparePasswords]
 act_as=second

=head2 CODE GENERATION

use generate-flow.pl to generate a perl class for yout flow control with
a shadow class and a basic template.

 hyper.pl -b $BASE_PATH -s $SERVICE -u $USECASE -t container

The following files will be generated:

if not existant:

 $BASE_PATH/lib/Hyper/Control/Container/$SERVICE/C$USECASE.pm
 $BASE_PATH/var/Hyper/Control/Container/$SERVICE/$USECASE.htc

always (previous files will be overwritten):

 $BASE_PATH/lib/Hyper/Control/Container/$SERVICE/_C$USECASE.pm

=head2 YOUR CODE

Each Step will call a method named action_$STEP_NAME if existant.

This methods may gather data from interfaces, perform interface calls etc.

You should place your code and template into

 $BASE_PATH/lib/Hyper/Control/Container/$SERVICE/C$USECASE.pm
 $BASE_PATH/var/Hyper/Control/Container/$SERVICE/$USECASE.htc

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Config::Reader::Flow

=item *

Class::Std::Storable

=item *

Hyper::Config::Object::Control::Validator

=item *

Hyper::Config::Object::Validator::Group

=item *

Hyper::Config::Object::Validator::Named

=item *

Hyper::Config::Object::Validator::Single

=item *

Hyper::Functions

=item *

Hyper::Error

=item *

Hyper::Config::Reader

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

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Config/Reader/Container.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
