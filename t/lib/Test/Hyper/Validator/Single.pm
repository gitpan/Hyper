package Test::Hyper::Validator::Single;
use strict;
use warnings;
use Test::More;
use base qw(Test::Class::Hyper);

sub validator :Test(2) {
    use_ok('Hyper::Validator::Single');
    ok( my $obj = Hyper::Validator::Single->new(), 'Object creation');

    return;
}

1;
