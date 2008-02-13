package Test::Hyper::Singleton::Context;

use strict;
use warnings;

use base qw(Test::Class::Hyper);
use Test::More;

sub content :Test(3) {
    use_ok 'Hyper::Singleton::Context';
    ok( Hyper::Singleton::Context->singleton()->isa('Hyper::Context'),
        'singleton type'
    );
    ok( Hyper::Singleton::Context->singleton()->isa('Hyper::Singleton'),
        'singleton type'
    );
}

1;
