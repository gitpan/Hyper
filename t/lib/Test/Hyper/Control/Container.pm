package Test::Hyper::Control::Container;

use strict;
use warnings;

use base qw(Test::Class::Hyper);
use Test::More;
use Storable qw(freeze thaw);

sub setup :Test(startup => 1) {
    use_ok('Hyper::Control::Container');
}

sub first :Test(5) {
    use_ok('MyTest::Control::Container::Minimal::CFirst');
    ok(
        my $flow = MyTest::Control::Container::Minimal::CFirst->new()
            => 'initializing'
    );
    ok( $flow->get_object('cEnterData')     => 'get_object');
    ok( $flow->get_object('cEnterMoreData') => 'get_object');
    ok ( ! $flow->work() => 'work' );
}

sub second :Test(11) {
    use_ok('MyTest::Control::Container::Minimal::CSecond');
    ok(
        my $flow = MyTest::Control::Container::Minimal::CSecond->new()
            => 'initializing'
    );
    ok( my $first   = $flow->get_object('cEnterFirst'), 'get_object');
    ok( my $second  = $flow->get_object('cEnterSecond'), 'get_object');
    ok( my $compare = $flow->get_object('vCompare'), 'get_object');
    ok( ! $flow->is_valid(), '! is_valid()' );
    ok( ! $flow->is_valid(), '! is_valid()' );

    ok( eval { $first->set_value(1); 1 }, '$first->set_value(1)' );
    ok( eval { $second->set_value(2); 1 }, '$second->set_value(2)' );
    ok( ! $flow->is_valid(), '! is_valid()' );

    ok( ! $flow->is_valid(), '! is_valid()' );

    #    ok ( ! $flow->work() => 'work' );
}

1;
