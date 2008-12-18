package Test::Hyper::Validator;
use strict;
use warnings;

use Test::More;
use Test::Exception;

use base qw(Test::Class::Hyper);

sub validator :Test(4) {
    use_ok('Hyper::Validator');
    ok(my $obj = Hyper::Validator->new(), 'Object creation');
    ok($obj->get_is_valid(), 'is_valid default value is true');

    throws_ok(
        sub { $obj->get_html() },
        qr{Hyper/Validator\.htc}ms,
        'Object creation without existant template',
    );

    return;
}

1;
