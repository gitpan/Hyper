package MyTest::Control::Container::Minimal::_CFirst;

use strict;
use warnings;

use Class::Std::Storable;
use base qw(Hyper::Control::Container);


my %mAttributeOne :ATTR(:default<()> :get<mAttributeOne> :set<mAttributeOne>);

my %mAttributeTwo :ATTR(:default<()> :get<mAttributeTwo> :set<mAttributeTwo>);

sub _get_destination_of_END :RESTRICTED {
    my $self = shift;
    return;
}

sub _get_destination_of_START :RESTRICTED {
    my $self = shift;
    return;
}

1;

__END__

=pod

=head1 NAME

MyTest::Control::Container::Minimal::_CFirst - auto-generated by Hyper Framework

=head1 CAVEATS

Don't touch this module - your changes will be lost on the next generator run.

Edit MyTest::Control::Container::Minimal::CFirst instead.

=head1 METHODS

=head1 COPYING


=head1 AUTHOR

 Generated by Hyper::Generator::Flow

=cut

