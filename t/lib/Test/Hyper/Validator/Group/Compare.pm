package Test::Hyper::Validator::Group::Compare;

use strict;
use warnings;

use base qw(Test::Class::Hyper);

use Test::More;

sub validator : Test(15) {
    use_ok('Hyper::Validator::Group::Compare');
    my $obj;

    ok( $obj = Hyper::Validator::Group::Compare
        ->new({ owner => 'test' }), 'Object creation');

    ok( $obj->is_valid({ first => 'test', second => 'test'}), 'strings: test test');
    ok( $obj->is_valid({ first => 0, second => 0}), 'numbers: 0 0');
    ok( $obj->is_valid({ first => 9, second => 9}), 'numbers: 9 9');
    ok( $obj->is_valid({ first => 47.11, second => 47.11}), 'numbers: 47.11 47.11');
    ok( $obj->is_valid({ first => q{}, second => q{}}), 'empty: q{} q{}');
    ok( $obj->is_valid({ first => undef, second => undef}), 'undef: undef undef');

    ok( ! $obj->is_valid({ first => 'foo', second => 'bar'}), 'strings: foo bar');
    ok( ! $obj->is_valid({ first => 'foo'}), 'exists: first => foo');
    ok( ! $obj->is_valid({ second => 'bar'}), 'exists: second => bar');
    ok( ! $obj->is_valid({ first => undef, second => 'bar'}), 'undef: undef bar');
    ok( ! $obj->is_valid({ first => 'foo', second => undef}), 'undef: foo undef');
    ok( ! $obj->is_valid({ first => q{}, second => 'bar'}), 'empty: q{} bar');
    ok( ! $obj->is_valid({ first => 'foo', second => q{}}), 'empty: foo q{}');

}

1;
