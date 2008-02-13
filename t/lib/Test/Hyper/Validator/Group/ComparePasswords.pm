package Test::Hyper::Validator::Group::ComparePasswords;
use strict;
use warnings;
use Test::More;
use base qw(Test::Class::Hyper);

sub validator : Test(4) {
    use_ok('Hyper::Validator::Group::ComparePasswords');
    my $obj;

    ok( $obj = Hyper::Validator::Group::ComparePasswords
        ->new({ owner => 'test' }), 'Object creation');

    ok( $obj->is_valid({ first_password => 'test', second_password => 'test'}), 'passwords: test test');
    ok( ! $obj->is_valid({ first_password => 'foo', second_password => 'bar'}), 'passwords: test test');

}

1;