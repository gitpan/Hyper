package Test::Hyper::Template;

use strict;
use warnings;

use base qw(Test::Class::Hyper);
use Test::More;

sub template :Test(2) {
    use_ok('Hyper::Template');
    ok( ! Hyper::Template->_init() => 'initializing');
}

1;
