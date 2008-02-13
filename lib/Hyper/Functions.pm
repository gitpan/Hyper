package Hyper::Functions;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use UNIVERSAL::require;
use Perl6::Export::Attrs;
use File::Spec ();
use File::Basename ();

use Readonly;
Readonly my %PATH_FOR => qw(
    template var
    config   etc
    package  lib
);

sub listify :Export {
    return @_
        ? @_ > 1
            ? [ @_ ]
            : defined $_[0]
                ? do {
                    my $ref_type = ref $_[0];
                    $ref_type && ($ref_type eq 'ARRAY')
                        ? $_[0]
                        : [ $_[0] ];
                }
                : []
        : [];
}

sub use_via_string :Export {
    my $class = shift;
    $class->use()
        or do {
            require Hyper::Error;
            Hyper::Error::throw("can't find package >$class< original error was >$@<");
        };
    return $class;
}

sub get_path_for :Export {
    return exists $PATH_FOR{$_[0]} ? $PATH_FOR{$_[0]} : ();
}

sub find_file :Export {
    my $type = shift;
    my $file = shift;

    return $file if File::Spec->file_name_is_absolute($file);

    my $path = $PATH_FOR{$type}
        or do {
            require Hyper::Error;
            Hyper::Error::throw("can't find path for >$type<")
        };

    require Hyper::Singleton::Context;
    my @tried  = map {
        my $try = "$_/$path/$file";
        return $try if -e $try;
        $try;
    } get_path_from_file(__FILE__), @{
          listify(Hyper::Singleton::Context->singleton()->get_config('Global')->get_base_path())
      };

    require Hyper::Error;
    Hyper::Error::throw(
        "can't find file >$file< via full paths >",
        ( join ', ', @tried ),
        '<',
    );
}

sub class_to_path :Export {
    my $class = shift;
       $class =~ s{::}{/}xmsg;
    return $class;
}

sub fix_class_name :Export {
    my $class = shift;
       $class =~ s{\.}{::}xmsg;
    return $class;
}

sub get_path_from_file :Export {
    return File::Spec->rel2abs(File::Basename::dirname($_[0]));
}

1;

__END__

=pod

=head1 NAME

Hyper::Functions - common functions for the Hyper Framework

=head1 VERSION

This document describes Hyper::Functions 0.01

=head1 SYNOPSIS

use Hyper::Functions;

=head1 DESCRIPTION

Hyper::Functions provides some basic subroutines which need no oop things.

=head1 SUBROUTINES/METHODS

=head2 listify :Export

    use Hyper::Functions qw(listify);
    my $array_ref = listify('text');

or

    use Hyper::Functions;
    $array_ref = Hyper::Functions::listify(['text']);

Returns the original list reference or put the given parameters
into a list reference, which is returned.

A single undef is converted into an empty list ref

=head2 use_via_string :Export

    use Hyper::Functions qw(use_via_string);
    my $class = use_via_string('My::Package');

Allows you to use a package with a string.

=head2 get_path_for :Export

    use Hyper::Functions qw(get_path_for);
    my $path = get_path_for('template'); # template, config, package

Get path for a specific type (eg. template will result in var).

=head2 find_file :Export

    use Hyper::Functions qw(find_file);
    my $full_path = find_file(template => 'my/file.htc');

Returns the original filename if its absolute. For relative filenames
If the filename is relative we search for the file in the the base_path
from Context.ini and the Hyper Template storage.
The first param (eg. template) is used as file type to get the type part
for the paths. I think nobody knows what I mean, so look at this examples:

    find_file(template => 'my/file.htc');
    # searches in $base_path/var/my/file.htc
    #         and $hyper_template_path/var/my/file.htc

    find_file(config => 'my/file.ini');
    # searches in $base_path/etc/my/file.ini
    #         and $hyper_template_path/etc/my/file.ini

    find_file(package => 'my/file.pm');
    # searches in $base_path/lib/my/file.pm
    #         and $hyper_template_path/lib/my/file.pm

If no file was found an failure will be thrown.

=head2 class_to_path :Export

    use Hyper::Functions qw(class_to_path);
    my $path = class_to_path('My::Class');

    $path eq 'My/Class';

Replace all double : chars with a /. This function is used for guessing
template and config paths for Controls.

=head2 fix_class_name :Export

    use Hyper::Functions qw(fix_class_name);
    my $class = fix_class_name('My.Class');

    $class eq 'My::Class';

Replace all . chars with two : chars. This function is used to fix the
class names used in the config syntax.

=head2 get_path_from_file :Export

    use Hyper::Functions qw(get_path_from_file);
    my $path = get_path_from_file('/etc/passwd');

    $path eq '/etc';

Returns the absolute path of the directory where the file is located.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Use L<Hyper::Singleton::Context> for your configuration.

Sample for your Context.ini

    [Global]
    base_path=/srv/web/www.example.com/

=head1 DEPENDENCIES

=over

=item *

version

=item *

UNIVERSAL::require

=item *

Perl6::Export::Attrs

=item *

File::Spec

=item *

File::Basename

=item *

Readonly

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
