package Test::Hyper::Config::Object::Step;

use strict;
use warnings;

use Test::More;
use Test::Exception;
use base qw(Test::Class::Hyper);

sub startup : Test(startup => 1) {
    use_ok('Hyper::Config::Object::Step');
}

sub methods :Test(4) {
    my $obj;
    ok(
        $obj = Hyper::Config::Object::Step->new(
            { name => 'foo' }
        ),
        'object creation name only'
    );
    ok(
        $obj = Hyper::Config::Object::Step->new({
            name        => 'foo',
            transitions => 'bar',
            controls    => 'baz',
            action      => 'foobar',

        }),
        'object creation'
    );

    dies_ok
        { $obj = Hyper::Config::Object::Step->new() }
        'dies without attributes';

    dies_ok
        { $obj = Hyper::Config::Object::Step->new(
             { foo => 'bar' }
        )}
        'dies with wrong attributes';

}

1;
