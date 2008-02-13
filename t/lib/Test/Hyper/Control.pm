package Test::Hyper::Control;

use strict;
use warnings;

use base qw(Test::Class::Hyper);
use Test::More;
use Test::Exception;
use Storable qw(freeze thaw);

sub setup :Test(startup => 1) {
    use_ok('Hyper::Control');
}

sub default :Test(7) {
    ok(
        my $control = Hyper::Control->new()
            => 'initializing'
    );
    ok( $control->get_value_recursive([qw(this)])
            => 'get_value_recursive(this)' );
    ok( ! $control->get_value_recursive([qw(this dispatch)])
            => 'get_value_recursive(this dispatch)' );
    ok( ! $control->get_value_recursive([qw(dispatch)])
            => 'get_value_recursive(dispatch)' );

    $control->set_dispatch(undef);
    ok( thaw(freeze($control)) => 'freeze / thaw' );
    ok( $control->set_value_recursive([qw(this dispatch)], 'TEST')
            => 'set_value_recursive(this dispatch) => TEST' );
    ok( $control->get_value_recursive([qw(this dispatch)]) eq 'TEST'
            => 'set_value_recursive(this dispatch) eq TEST' );
}

sub set_value_recursive :Test(9) {
    ok( my $control = Hyper::Control->new()
            => 'initializing' );

    my $hash_ref = {};
    *Hyper::Control::get_hash_ref = sub { return $hash_ref; };
    ok ( $control->set_value_recursive(
             [qw(this hash_ref add key now)],
             'test',
         ) => 'hash ref based set_value_recursive'
    );
    ok( $control->get_value_recursive(
            [qw(this hash_ref add key now)]
        ) eq 'test'
            => 'hash ref based get_value_recursive'
    );
    my $nothing;
    *Hyper::Control::get_undef  = sub { return $nothing; };
    *Hyper::Control::set_undef  = sub { $nothing = $_[1]; };
    ok ( $control->set_value_recursive(
             [qw(this undef test value)],
             'test',
         ) => 'set method -> autovivification'
    );
    ok( $control->get_value_recursive(
            [qw(this undef test value)]
        ) eq 'test'
            => 'get modified'
    );
    ok( $control->get_value_recursive(
            [qw(this undef test value)]
        ) eq $nothing->{test}->{value}
            => ' compare with original var'
    );

    *Hyper::Control::get_control  = sub { return $control; };
    ok ( $control->set_value_recursive(
             [qw(this control dispatch test value)],
             'test',
         ) => 'set method -> object -> autovivification'
    );
    ok( $control->get_value_recursive(
            [qw(this control dispatch test value)]
        ) eq 'test'
            => 'get modified'
    );
    ok ( $control->get_dispatch()->{test}->{value} eq 'test'
             => 'compare with original var'
    );
}

sub dispatch :Test(5) {
    ok( my $control = Hyper::Control->new({
            dispatch => 'Hyper::Control'
        })
            => 'initializing' );

    throws_ok(
        sub { thaw(freeze($control)) },
        qr{can't find method >DISPATCH< in class >Hyper::Control<}msi,
        'throws ok on invalid DISPATCH',
    );

    my $DISPATCH_called;
    *Hyper::Control::DISPATCH = sub { $DISPATCH_called = 1; };
    ok( ! $DISPATCH_called, 'DISPATCH not called after initialize' );
    ok( my $thawn = thaw(freeze($control))
            => 'freeze / thaw' );
    ok( $DISPATCH_called, 'DISPATCH called after thaw' );
}

1;
