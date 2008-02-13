package Hyper::Context;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std;
use Hyper::Config::Reader::Context;

my %context_of :ATTR();
my %file_of    :ATTR(:get<file> :init_arg<file> :default<()>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;

    $context_of{$ident} = Hyper::Config::Reader::Context->new({
        config_for => __PACKAGE__, map {
            exists $arg_ref->{$_} ? ($_ => $arg_ref->{$_}) : ();
        } qw(base_path file)
    })->get_context();
}

sub get_config {
    my $ident = ident shift;
    return $context_of{$ident}->get_config(shift || scalar caller);
}

1;

__END__

=pod

=head1 NAME

Hyper::Context - Context for accessing our configuration

=head1 VERSION

This document describes Hyper::Context 0.01

=head1 SYNOPSIS

    use Hyper::Context;

    my $config = Hyper::Context
        ->new()
        ->get_config('MyApp::Control::Flow::Web::Shop');

or

    package MyApp::Tester;

    my $config = Hyper::Context->new()->get_config();

=head1 DESCRIPTION

Hyper::Context provides access to the context configuration
for different sections. Mostly the config sections have the
same name as the package where you use them.

=head1 ATTRIBUTES

=over

=item file :get :init_arg :default<$base_path/$namespace/Context.ini>

 Config file name.

=back

=head1 SUBROUTINES/METHODS

=head2 BUILD

    my $context = Hyper::Context->new();

Called automatically from Class::Std after object
initialization. This method calls the reader for our
context config.

=head2 get_config

    $context->get_config('MyClass::Name');

or

    $context->get_config();

Get named configuration section or config for a
class/package. If there is no parameter given wie
use the caller package name as section name.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std

=item *

Hyper::Config::Reader::Context

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

 $Author: $

=item Id

 $Id: $

=item Revision

 $Revision: $

=item Date

 $Date: $

=item HeadURL

 $HeadURL: $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
