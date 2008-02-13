package Test::Hyper::Error;

use strict;
use warnings;

use Test::More;
use Test::Exception;
use base qw(Test::Class::Hyper);

sub error : Test(2) {
    use_ok('Hyper::Error');
    throws_ok(
        sub {
            use Hyper::Error;
            throw('my special error');
        },
        qr{my special error}ms,
        'throws ok',
    );
}

1;
