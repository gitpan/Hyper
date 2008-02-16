package Hyper::Control::Base::BUpload;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control::Base);
use Class::Std::Storable;

use Hyper::Singleton::CGI;
use File::Basename;

sub get_filehandle {
    return Hyper::Singleton::CGI->singleton()->upload(shift->get_name());
}

sub get_filename {
    return (File::Basename->fileparse(shift->get_value()))[0];
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Base::BUpload - Upload Base Control

=head1 VERSION

This document describes Hyper::Control::Base::BUpload 0.01

=head1 SYNOPSIS

    use Hyper::Control::Base::BUpload;
    my $object = Hyper::Control::Base::BUpload->new();

=head1 DESCRIPTION

Base Control for Uploads (eg. input type="file")

=head1 SUBROUTINES/METHODS

=head2 get_filehandle

    my $filehandle = $object->get_filehandle();

Get the filehandle of an upload field.

=head2 get_filename

    my $filename = $object->get_filename();

Get the filename part of an upload field.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Control::Base

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: BUpload.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Control/Base/BUpload.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
