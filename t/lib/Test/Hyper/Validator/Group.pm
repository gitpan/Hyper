package Test::Hyper::Validator::Group;

use strict;
use warnings;

use Test::More;

use base qw(Test::Class::Hyper);

sub validator : Test(2) {
    use_ok('Hyper::Validator::Group');
    ok( my $obj = Hyper::Validator::Group->new(), 'Object creation' );
}

1;
