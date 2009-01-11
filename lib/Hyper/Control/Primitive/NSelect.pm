package Hyper::Control::Primitive::NSelect;
use strict;
use warnings;

use version; our $VERSION = qv('0.02');

use Class::Std::Storable;
use base qw(Hyper::Control::Primitive Hyper::Control::Base);

my %named_selects_of  :ATTR(:default<{}> :set<named_selects> :get<named_selects>);
my %elements_of       :ATTR(:get<elements>);

sub add_element {
    my $self = shift;

    push @{$elements_of{ident $self} ||= []}, @_;

    return $self;
}

sub add_named_select {
    my $self    = shift;
    my $arg_ref = shift;
    my $ident   = ident $self;

    for my $name (keys %{$arg_ref}) {
        $named_selects_of{$ident}->{$name} = $arg_ref->{$name};
    }

    return $self;
}

sub set_elements {
    my $self  = shift;
    my $ident = ident $self;

    $elements_of{ $ident } = shift || [];

    for my $select ( @{ $self->get_selects() } ) {
        $select->set_elements($elements_of{$ident});
    }

    return $self;
}

sub get_selects {
    return [ values %{$named_selects_of{ident $_[0]}} ];
}

sub get_named_select {
    return $named_selects_of{ident $_[0]}->{$_[1]};
}

sub _populate_default_elements_to :PROTECTED {
    my $self             = shift;
    my $default          = shift;
    my $named_select_ref = $named_selects_of{ident $self};

    my %is_selected_of = ();
    FIND_DESELECTED: for my $name ( keys %{$named_select_ref} ) {
        next FIND_DESELECTED if $name eq $default;
        for my $value ( @{$named_select_ref->{$name}->get_deselected_value()} ) {
            ++$is_selected_of{$value};
        }
    }

    my $none_default_select_count = ( keys %{$named_select_ref} ) - 1;
    $named_select_ref->{$default}->set_value([
        map {
            $is_selected_of{$_} < $none_default_select_count
                ? ()
                : $_;
        } keys %is_selected_of
    ]);

    return $self;
}

1;

__END__

# Todo: Add POD
