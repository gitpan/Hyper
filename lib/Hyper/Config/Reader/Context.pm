package Hyper::Config::Reader::Context;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Config::Reader);
use Class::Std::Storable;

use File::Spec ();
use Cwd ();

use Hyper::Config::Object::Context;
use Hyper::Config::Object::Default;
use Hyper::Functions;

my %context_of :ATTR(:get<context>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;

    exists $arg_ref->{base_path} and return;

    # this config readers read the framework config
    # and get's it's config via some roedel doedel
    my ($volume, $path) = File::Spec->splitpath(
        File::Spec->rel2abs(__FILE__)
    );
    $self->_set_base_path(
        Cwd::realpath(
            File::Spec->catpath(
                $volume,
                $path . ('../' x 4),
                q{}
            )
        )
    );

    return;
}

sub _read_config :PROTECTED {
    my $self    = shift;
    my $ini     = shift;
    my $ident   = ident $self;
    my $context = Hyper::Config::Object::Context->new();

    for my $group ( $ini->Sections() ) {
        my $resolve_ref = $group eq 'Class'
            ? \&Hyper::Functions::fix_class_name
            : sub { return $#_ ? \@_ : $_[0]; };
        my %value_of    = map {
            $_ => $resolve_ref->($ini->val($group => $_));
        } $ini->Parameters($group);
        $context->set_config_of(
            $group => Hyper::Config::Object::Default->new({data => \%value_of})
        );
    }

    $context_of{$ident} = $context;
    return $self;
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Reader::Context - Object oriented INI Style Config Reader

=head1 VERSION

This document describes Hyper::Config::Reader::Context 0.01

=head1 SYNOPSIS

    use Hyper::Config::Reader::Context;
    my $context_reader = Hyper::Config::Reader::Context->new({
        base_path => '/srv/web/www.example.com/',
        file      => '/srv/web/www.example.com/etc/MyPortal/Context.ini',
    });

=head1 DESCRIPTION

Context Reader Object, used for reading ini style config files.
an initial config file for this object can be generated using
Hyper::Generator::Environment.

=head1 ATTRIBUTES

=over

=item context :get

see Hyper::Config::Object::Context

=back

=head1 SUBROUTINES/METHODS

=head2 BUILD

    use Hyper::Config::Reader::Context;
    my $object = Hyper::Config::Reader::Context->new();

or

    use Hyper::Config::Reader::Context;
    my $object = Hyper::Config::Reader::Context->new({
        base_path => '/srv/web/www.example.com/',
    });

Adjust some defaults and reads the config file. The hash ref param
with the key base_path is used to adjust base path for the config
file.

=head2 _read_config :PROTECTED

Internally used to read the config file into an object hierarchy.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Sample for an Context.ini
(eg. located at /srv/web/www.example.com/etc/MyPortal/Context.ini)

    [Global]
    base_path=srv/web/www.example.com/
    namespace=MyPortal

    [Class]
    translator=Hyper.Translator.Noop
    template=Hyper.Template.HTC
    application=Hyper.Application.Default

    [Hyper::Application::Default]
    ;template=index.htc

    [Hyper::Persistence]
    cache_path=/tmp

    [Hyper::Error]
    ;plain_template=Hyper/Error/plain_error.htc
    ;html_template=Hyper/Error/html_error.htc

You can access the config via some object methods.

    'Hyper.Translator.Noop'
        eq $object->get_context()
               ->get_config('Class')->get_translator();

or

    '/tmp'
        eq $object->get_context()
               ->get_config('Hyper::Error')->get_cache_path();

or using caller package instead of fixed param for get_config

    package Hyper::Error;

    '/tmp'
        eq $object->get_context()
               ->get_config()->get_cache_path();


=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Config::Reader

=item *

Class::Std::Storable

=item *

File::Spec

=item *

Cwd

=item *

Hyper::Config::Object::Context

=item *

Hyper::Config::Object::Default

=item *

Hyper::Functions

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

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Config/Reader/Context.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
