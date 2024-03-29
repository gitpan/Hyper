package MyTest::Control::Flow::Minimal::_FTwo;

use strict;
use warnings;

use Class::Std::Storable;
use base qw(Hyper::Control::Flow);

sub _get_destination_of_END :RESTRICTED {
    my $self = shift;
    return;
}

sub _work_control_of_Initialize :RESTRICTED {
    my $self = shift;

    for my $control ( qw(cFirst) ) {
        $self->get_object($control)->work();
    }

    return;
}

sub _get_destination_of_Initialize :RESTRICTED {
    my $self = shift;
    return 'END';
}

sub _get_destination_of_START :RESTRICTED {
    my $self = shift;
    return 'Initialize';
}

1;

__END__

=pod

=head1 NAME

MyTest::Control::Flow::Minimal::_FTwo - auto-generated by Hyper Framework

=head1 CAVEATS

Don't touch this module - your changes will be lost on the next generator run.

Edit MyTest::Control::Flow::Minimal::FTwo instead.

=head1 COPYING


=head1 AUTHOR

 Generated by Hyper::Generator::Flow

=cut
