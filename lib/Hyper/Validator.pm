package Hyper::Validator;

use strict;
use warnings;

use version; our $VERSION = qv('0.02');

use Class::Std::Storable;
use base qw(Hyper::Control::Template);

my %is_valid_of     :ATTR(:get<is_valid> :default<1>);
my %config_of       :ATTR(:name<config>  :default<()>);
my %_valid_state_of :ATTR();

sub get_next_html { # ToDo: add pod
    my $template = $_[0]->get_template();
    $template->param( is_valid => shift @{$_valid_state_of{ident $_[0]}} );
    return $template->output();
}

sub get_html {
    my $template = $_[0]->get_template();
    $template->param( is_valid => $_[0]->get_is_valid() );
    return $template->output();
}

sub is_valid { # ToDo: add more pod
    my ($self, @values) = @_;

    my $valid_ref
        = $_valid_state_of{ident $self}
        = [ map { scalar $self->VALIDATE($_) } @values ];

    return $is_valid_of{ident $self} = @values == grep { $_; } @{$valid_ref};
}

sub _set_valid_state :RESTRICTED {
    $_valid_state_of{ident $_[0]} = $_[1];
}

sub _set_is_valid :RESTRICTED {
    $is_valid_of{ident $_[0]} = $_[1];
}


1;

__END__

#ToDo: FIX POD for _set_valid_state and _set_is_valid

=pod

=head1 NAME

Hyper::Validator - Validator base class for all validator classes

=head1 VERSION

This document describes Hyper::Validator 0.02

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

Add the the 'is_valid' param to the template and return the
return value of the output method of template.

The 'is_valid' param indicates if any value was invalid.

=head2 get_next_html

    # validate an object with one valid and one invalid value

    # show valid message
    $object->get_next_html();

    # show invalid message
    $object->get_next_html();

Works like get_html expect that the 'is_valid' param indicates
if the current value (we iterate over the values validation state)
is valid. The values are handled iterative.

=head2 is_valid

    $object->is_valid();

Calls the object method VALIDATE, stores the return value
in the object attribute is_valid and a list of valid/invalid states
in the private attribute _valid_state_of. The return value indicates
if all values are valid.

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

$Id: Validator.pm 474 2008-05-29 13:25:22Z ac0v $

=item Revision

$Revision: 474 $

=item Date

$Date: 2008-05-29 15:25:22 +0200 (Do, 29 Mai 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Validator.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
