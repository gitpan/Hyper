package Hyper::Translator;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Error;

sub translate {
    throw(__PACKAGE__ . ' is an abstract class. Did you try to use it directly ?');
}

sub init {
    return shift;
}

1;

__END__

=pod

=head1 NAME

Hyper::Translator - abstract base class for all translator classes

=head1 VERSION

This document describes Hyper::Translator 0.01

=head1 SYNOPSIS

    package Hyper::Translator::Sample;

    use Class::Std::Storable;
    use base qw(Hyper::Translator);

    sub translate {
        my $self  = shift;
        my $value = shift;

        my $translated_value = ...;

        return $translated_$value;
    }

    1;

=head1 DESCRIPTION

Provides basic features for translators in the Hyper Framework.

=head1 SUBROUTINES/METHODS

=head2 translate

If you create a new translator you have to implement this method.
If translation is required (eg. in templates) this method is
called with the params $value and $arg_ref. $arg_ref is used for
passing Locale::Maketext params.

=head2 init

This method is called to initialize your translator. (optional)

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

 version

=item *

 Class::Std::Storable

=item *

 Hyper::Error

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Translator.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sa, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Translator.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
