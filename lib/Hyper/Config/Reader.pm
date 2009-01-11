package Hyper::Config::Reader;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;

use Hyper::Functions ();
use Hyper::Error;

use English qw($OS_ERROR);
use Config::IniFiles;
use File::Spec ();

my %base_path_of :ATTR(:get<base_path> :init_arg<base_path> :default<()>);
my %file_of      :ATTR(:name<file>     :default<q{}>);

sub START {
    my ($self, $ident, $arg_ref) = @_;
    my $file = $file_of{$ident};
    if ( ref $file ) {
        $self->_read_config(
            Config::IniFiles->new(
                -file => $file,
            ) or Hyper::Error::throw("can't read INI file from GLOB $OS_ERROR", @Config::IniFiles::errors)
        );
    }
    else {
        if ( ! File::Spec->file_name_is_absolute($file) ) {
            my $base_path = $self->get_base_path();
            if ( ! $file ) {
                $file = Hyper::Functions::class_to_path($arg_ref->{config_for}) . '.ini';
            }
            $file = defined $base_path
                ? do {
                    $base_path .= '/etc/';
                    -d $base_path or Hyper::Error::throw("can't find base_path >$base_path<");
                    "$base_path/$file";
                  }
                : Hyper::Functions::find_file(config => $file);
        }
        $self->_read_config(
            Config::IniFiles->new( -file => $file )
                or Hyper::Error::throw("can't read INI file >$file< $OS_ERROR", @Config::IniFiles::errors)
        );
    }

    return $self;
}

sub _set_base_path :RESTRICTED {
    $base_path_of{ident $_[0]} = $_[1];
    return $_[0];
}

1;

__END__

=pod

=head1 NAME

Hyper::Config::Reader - abstract base class for all config objects.

=head1 VERSION

This document describes Hyper::Config::Reader 0.01

=head1 SYNOPSIS

    package Hyper::Config::Reader::Sample;

    use Class::Std::Storable;
    use base qw(Hyper::Config::Reader);

    sub _read_config :RESTRICTED {
        my $self = shift;
        my $ini  = shift; # Config::IniFile

        # fetch data into objects / or attributes

        return $self;
    }

    1;

=head1 DESCRIPTION

Hyper::Config reads config files and calls _read_config of the
inheriting class to parse the config.

=head1 ATTRIBUTES

=over

=item base_path :get :init_arg :default<()>

=item file      :name :default<()>

=back

=head1 SUBROUTINES/METHODS

=head2 START

    Hyper::Config::Sample->new({ for_class => 'Hyper::Control::Base::BBase' });

or

    Hyper::Config::Sample->new({ for_class => Hyper::Control::Base::BBase->new() });

or

    Hyper::Config::Sample->new({ file => '/etc/passwd' });

Reads config from an ini file. You can pass the filename directly via the
param file or via passing the for_class param. The file param has precedence.
If for_class param is used we try to get our config with replacing the '::'
chars of the class name with '/', prepeding the base path and adding the
prefix .ini.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Functions

=item *

Hyper::Error

=item *

English

=item *

Config::IniFiles

=item *

File::Spec

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

 $Author: ac0v $

=item Id

 $Id: Reader.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

 $Revision: 317 $

=item Date

 $Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

 $HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Config/Reader.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

