package Test::Hyper::Validator::Single::Required;
use strict;
use warnings;
use Test::More;
use base qw(Test::Class::Hyper);

sub validator : Test(6) {
    use_ok('Hyper::Validator::Single::Required');
    my $obj;

    ok( $obj = Hyper::Validator::Single::Required
        ->new({ owner => 'test' }), 'Object creation');
    ok( $obj->is_valid(23), 'value: 23');
    ok( $obj->is_valid(0), 'value: 0');
    ok( ! $obj->is_valid(undef), 'undef');
    ok( ! $obj->is_valid(q{}) , 'empty string');

}

1;