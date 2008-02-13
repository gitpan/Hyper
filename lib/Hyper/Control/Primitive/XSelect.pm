package Hyper::Control::Primitive::XSelect;

use strict;
use warnings;

use base qw(Hyper::Control::Base::BSelect);

use Class::Std::Storable;
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
        } @{$self->get_elements()}
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

    my %tmp_selected_of = map { ( "$_" => $_ ); } @{$selected_ref};

    $self->_set_selected_by_callback(
        sub { exists $tmp_selected_of{"$_[0]"}; }
    );

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

    $selected_of{$ident}         = [];
    $deselected_of{$ident}       = [];
    $deselected_value_of{$ident} = [];
    for my $i ( 0 .. $#{$element_ref} ) {
        if ( exists $selected_index_of{$i} ) {
            push @{$selected_of{$ident}}, $element_ref->[$i];
        }
        else {
            push @{$deselected_of{$ident}}, $element_ref->[$i];
            push @{$deselected_value_of{$ident}}, $i;
        }
    }

    $self->SUPER::set_value($value_ref);

    return $self;
}

1;

# ToDo: add POD
