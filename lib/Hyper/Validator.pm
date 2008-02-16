package Hyper::Validator;

use strict;
use warnings;

use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use base qw(Hyper::Control::Template);

my %is_valid_of :ATTR(:get<is_valid> :default<1>);

sub get_html {
    return shift->get_template()->output();
}

sub is_valid {
    my ($self, @values) = @_;

    return $is_valid_of{ident $self} = $self->VALIDATE(@values);
}

1;

__END__

=pod

=head1 NAME

Hyper::Validator - Validator base class for all validator classes

=head1 VERSION

This document describes Hyper::Validator 0.01

=head1 SYNOPSIS

    package Hyper::Validator::Single;

    use Class::Std::Storable;
    use base qw(Hyper::Validator);

    1;

=head1 DESCRIPTION

Hyper::Validator provides basic features like templating for
writing a validator class.

=head1 SUBROUTINES/METHODS

=head2 new

    my $object = Hyper::Validator->new();

or with template filename and owner

    my $object = Hyper::Validator->new({
       owner    => $input_object,
    });

Contructor with additional owner parameter, which sets the owner
of this validator (eg. a specific input or text field object)

=head2 get_html

    $object->get_html();

Add this param to the template and return the return value
of the output method of template.

=head2 is_valid

    $object->is_valid();

Calls the object method VALIDATE, stores the return value
in the object attribute is_valid and returns it.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Control::Template

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Validator.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Validator.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
