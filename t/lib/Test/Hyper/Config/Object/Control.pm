package Test::Hyper::Config::Object::Control;

use strict;
use warnings;

use Test::More;
use base qw(Test::Class::Hyper);

sub startup : Test(startup => 1) {
    use_ok('Hyper::Config::Object::Control');
}

sub methods :Test(4) {
    my $obj;
    ok(
        $obj = Hyper::Config::Object::Control->new({
            name  => 'x',
            class => 'x',
        }) =>  'Object creation'
    );

    local $@ = ();
    eval {
        Hyper::Config::Object::Control->new({ class => 'x' });
    };
    ok(-1 != (index $@, 'missing attribute >name<'), 'without name param');

    $@ = ();
    eval {
        Hyper::Config::Object::Control->new({ name => 'x' });
    };
    ok(-1 != (index $@, 'missing attribute >class<'), 'without class param');

    $@ = ();
    eval {
        Hyper::Config::Object::Control->new({
           name  => 'x',
           class => 'x',
           xxx   => 'x',
        });
    };
    ok(-1 != (index $@, 'invalid argument(s) >xxx< for control'),
        'with invalid param'
    );
}

1;
