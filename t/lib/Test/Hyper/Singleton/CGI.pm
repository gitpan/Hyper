package Test::Hyper::Singleton::CGI;

use strict;
use warnings;

use base qw(Test::Class::Hyper);
use Test::More;

sub object :Test(4) {
    use_ok 'Hyper::Singleton::CGI';
    ok( Hyper::Singleton::CGI->singleton(),
        'singleton creation'
    );
    ok( Hyper::Singleton::CGI->singleton()->isa('CGI'),
        'CGI type'
    );
    ok( Hyper::Singleton::CGI->new(),
        'object creation'
    );
}

1;
