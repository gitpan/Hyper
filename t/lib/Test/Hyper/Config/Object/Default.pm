package Test::Hyper::Config::Object::Default;

use strict;
use warnings;

use Test::More;
use Test::Exception;
use base qw(Test::Class::Hyper);

sub startup : Test(startup => 1) {
    use_ok('Hyper::Config::Object::Default');
}

sub methods :Test(2) {
    my $obj;
    ok(
        $obj = Hyper::Config::Object::Default->new(
            { data => 'name' }
        ),
        'object creation'
    );

    # or it will warn ...
    local $SIG{__WARN__} = sub {};
    throws_ok(
        sub { Hyper::Config::Object::Default->gett_foo() },
        qr{\ACan't locate class method }ms,
        'warns on wrong method',
    );
}

1;
