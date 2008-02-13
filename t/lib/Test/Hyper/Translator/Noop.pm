package Test::Hyper::Translator::Noop;

use strict;
use warnings;

use Test::More;
use base qw(Test::Class::Hyper);

sub startup : Test(startup => 1) {
    use_ok('Hyper::Translator::Noop');
}

sub methods :Test(2) {
    my $obj;
    ok($obj = Hyper::Translator::Noop->new(), 'Object creation');

    my $text = 'Hello World!';
    ok($obj->translate($text) eq $text => 'translation');
}

1;
