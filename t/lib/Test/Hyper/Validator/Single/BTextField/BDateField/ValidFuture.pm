package Test::Hyper::Validator::Single::BTextField::BDateField::ValidFuture;
use strict;
use warnings;
use Test::More;
use base qw(Test::Class::Hyper);

sub startup : Test(startup => 1) {
    # do everything you need to once before tests start here

    use_ok('Hyper::Validator::Single::BTextField::BDateField::ValidFuture');
    # manipulate @ISA to call restricted methods
    #push @Test::Hyper::Validator::BTextField::AlphaNumericWord::ISA,
    #    'Hyper::Validator::BTextField::AlphaNumericWord';
}

sub validator : Test(10) {
    use_ok('Hyper::Validator::Single::BTextField::BDateField::ValidFuture');

    my $obj;
    ok( $obj = Hyper::Validator::Single::BTextField::BDateField::ValidFuture
        ->new({ owner => 'test' }), 'Object creation');

    ok( $obj->is_valid('2010-12-01'),       'string: 2010-12-01');
    ok( ! $obj->is_valid('2006-12-01'),     'string: 2006-12-01');
    ok( ! $obj->is_valid('abcdefg'),        'string: abcdefg');
    ok( ! $obj->is_valid('01234-56-89'),    'string: 01234-56-89');
    ok( ! $obj->is_valid(23),               'value:  23');
    ok( ! $obj->is_valid(0),                'value:  0');
    ok( ! $obj->is_valid(undef),            'undef');
    ok( ! $obj->is_valid(q{}) ,             'empty string');

}

1;