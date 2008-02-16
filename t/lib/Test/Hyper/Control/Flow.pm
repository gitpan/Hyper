package Test::Hyper::Control::Flow;

use strict;
use warnings;

use base qw(Test::Class::Hyper);
use Test::More;
use Storable qw(freeze thaw);

sub setup :Test(startup => 1) {
    use_ok('Hyper::Control::Flow');
}

sub one :Test(12) {
    use_ok('MyTest::Control::Flow::Minimal::FOne');
    ok(
        my $flow = MyTest::Control::Flow::Minimal::FOne->new()
            => 'initializing'
    );
    ok( $flow->get_state() eq 'START' => 'get_state (initial)');
    ok( $flow->set_state('END')       => 'set_state');
    ok( $flow->get_state() eq 'END'   => 'get_state');
    ok( $flow->set_state('START')     => 'set_state');

    ok( ! $flow->get_object()              => 'get_object');
    ok( ! $flow->get_object('not defined') => 'get_object');

    ok ( ! $flow->work() => 'work' );

    # set end state
    ok( $flow->set_state('END')       => 'set_state');
    # basic freeze thaw
    ok (
        ref thaw(freeze($flow)) eq 'MyTest::Control::Flow::Minimal::FOne'
            => 'freeze / thaw'
    );
    # state reset after thaw?
    ok (
        thaw(freeze($flow))->get_state() eq 'START'
            => 'freeze / thaw state was reset'
    );
}

sub two :Test(7) {
    use_ok('MyTest::Control::Flow::Minimal::FTwo');
    ok(
        my $flow = MyTest::Control::Flow::Minimal::FTwo->new()
            => 'initializing'
    );
    ok( $flow->get_object('cFirst')
            => 'get_object'
    );
    # empty viewstate
    ok( ! $flow->get_state_recursive()
            => 'initial get_state_recursive'
    );

    # existant viewstate
    ok( $flow->set_state('END') => 'set_state');
    is( undef, my $viewstate = $flow->get_state_recursive(), 'get_state_recursive');

    ok( $flow->restore_state_recursive($viewstate)
            => 'restore_state_recursive'
    );
}

1;
