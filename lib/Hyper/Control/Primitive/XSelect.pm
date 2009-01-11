package Hyper::Control::Primitive::XSelect;

use strict;
use warnings;

use version; our $VERSION = qv('0.02');

use base qw(Hyper::Control::Base::BSelect);

use Class::Std::Storable;
use Scalar::Util;
use Hyper::Functions qw(listify);

my %selected_of         :ATTR(:get<selected>);
my %deselected_of       :ATTR(:get<deselected> :default<[]>);
my %deselected_value_of :ATTR(:get<deselected_value> :default<[]>);

# get elements for default select
sub get_template_elements {
    my %selected_index_of = map { ( $_ => undef ); } defined $_[0]->get_value() ? $_[0]->get_value() : ();
    my $element_index     = -1;
    return [
        map {
            ++$element_index;
            { data        => $_,
              value       => $element_index,
              is_selected => exists $selected_index_of{$element_index},
            };
        } @{$_[0]->get_elements() || []}
    ];
}

# select by callback
sub _set_selected_by_callback :PROTECTED {
    my $self     = shift;
    my $callback = shift;
    my $ident    = ident $self;

    $selected_of{$ident}         = [];
    $deselected_of{$ident}       = [];
    $deselected_value_of{$ident} = [];

    # populate value to base element
    my $element_index = -1;
    $self->SUPER::set_value([
        map {
            ++$element_index;
            $callback->($_)
                ? do {
                    push @{$selected_of{$ident}}, $_;
                    $element_index;
                  }
                : do {
                    push @{$deselected_of{$ident}}, $_;
                    push @{$deselected_value_of{$ident}}, $element_index;
                    ();
                  };
        } @{$self->get_elements() || []}
    ]);

    return $self;
}

sub set_elements {
    my $self    = shift;
    my $arg_ref = shift || [];
    my $ident   = ident $self;

    $selected_of{$ident}         = [];
    $deselected_of{$ident}       = [ @{$arg_ref} ]; # copy content, that's ok
    $deselected_value_of{$ident} = [ 0 .. @{$arg_ref} - 1 ];
    $self->SUPER::set_elements($arg_ref);

    return $self;
}

# select by stringified element or code ref
sub set_selected {
    my $self            = shift;
    my $selected_ref    = shift || [];

    return $self->_set_selected_by_callback($selected_ref)
        if ref $selected_ref eq 'CODE';

    # some copied code to allow ordered element mode :)
    my $i               = 0;
    my %tmp_selected_of = map { ( "$_" => $i++ ); } @{$selected_ref};
    my $ident           = ident $self;

    $selected_of{$ident}         = [];
    $deselected_of{$ident}       = [];
    $deselected_value_of{$ident} = [];

    # populate value to base element
    my $element_index = -1;
    $self->SUPER::set_value([
        map {
            ++$element_index;
            exists $tmp_selected_of{"$_"}
                ? do {
                    $selected_of{$ident}->[$tmp_selected_of{"$_"}] = $_;
                    $element_index;
                  }
                : do {
                    push @{$deselected_of{$ident}}, $_;
                    push @{$deselected_value_of{$ident}}, $element_index;
                    ();
                  };
        } @{$self->get_elements() || []}
    ]);

    # remove crap aka empty entries for elements, which are not in our element list
    @{$selected_of{$ident}} = grep { defined $_ } @{$selected_of{$ident}};

    return $self;
}

# select by element index
sub set_value {
    my $self        = shift;
    my $value_ref   = listify(shift);
    my $ident       = ident $self;
    my $element_ref = $self->get_elements();

    # select elements by index
    my %selected_index_of = map { $_ => undef; } @{$value_ref};

    $deselected_of{$ident}       = [];
    $deselected_value_of{$ident} = [];
    $selected_of{$ident}         = [
        map {
            # filter invalid index
            Scalar::Util::looks_like_number($_) ? $element_ref->[$_] : ();
        } @{$value_ref}
    ];

    FIND_DESELECTED: for my $i ( 0 .. $#{$element_ref} ) {
        next FIND_DESELECTED if exists $selected_index_of{$i};
        push @{$deselected_of{$ident}}, $element_ref->[$i];
        push @{$deselected_value_of{$ident}}, $i;
    }

    $self->SUPER::set_value($value_ref);

    return $self;
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Primitive::XSelect - advanced and secure select control

=head1 VERSION

This document describes Hyper::Control::Primitive::XSelect 0.02

=head1 SYNOPSIS

    use Hyper::Control::Primitive::XSelect;
    my $object = Hyper::Control::Primitive::XSelect->new();

=head1 DESCRIPTION

Primitive Control for Selects which enables you to select objects and
other complex data structures - not only the value from the selected
elements which is used with standard cgi forms.

Another important thing of the XSelect is that users can not
inject unknown elements (e.g. add and choose an element, which is not
listed). So forms which uses the XSelect are more secure than others
cause you don't need to keep care for injected elements.

=head1 ATTRIBUTES

=over

=item selected         :get

=item deselected       :get :default<[]>

=item deselected_value :get :default<[]>

=back

=head1 SUBROUTINES/METHODS

=head2 add_element

    $object->add_element(qw(one two three));

Append elements to the elements attribute.

=head2 get_template_elements

    my $template_elements_ref = $xselect->get_template_elements();
    # [
    #     { data => $element, value => 0, is_selected => 0, },
    #     { data => $element, value => 1, is_selected => 1, },
    #     ...
    # ]

Used in Templates for getting all collected element info as
array ref with some hash ref structures.
The key value is the element's index (security reasons).

=head2 set_elements

    $xselect->set_elements([ $object1, $object2, $object3]);
    # or
    $xselect->set_elements([ $hash_ref1, $hash_ref2 ]);
    # or
    $xselect->set_elements([ qw(a b c) ]);

Set elements which should could be selected.

=head3 set_selected

    $xselect->set_selected([ $object1, $object2 ]);
    # or
    $xselect->set_selected([ qw(a c) ]);

Set selected by passing the original Objects or the original scalar values.
Elements will be selected in ordered data mode.

    $xselect->set_selected(sub { 'a' eq $_[0] });

You can also call set_selected with a code reference. The code reference
is called for each element of the XSelect and has to return a true value
if the element is selected.

=head2 set_value

    $xselect->set_value([ 1, 2, 0 ]);

Select elements by their index.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Control::Base::BSelect

=item *

Hyper::Functions

=item *

Scalar::Util

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: XSelect.pm 528 2009-01-11 05:43:02Z ac0v $

=item Revision

$Revision: 528 $

=item Date

$Date: 2009-01-11 06:43:02 +0100 (So, 11 Jan 2009) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/tags/0.05/lib/Hyper/Control/Primitive/XSelect.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
