package Test::Hyper::SOAP::Typelib::TPerson;
use strict;
use warnings;
use diagnostics;
use Test::More;
use base 'Test::Class';

sub startup : Test( startup => 1) {
    use_ok 'Hyper::SOAP::Typelib::TPerson';
}

sub serialize : Test(2) {
    my $obj;
    ok $obj = Hyper::SOAP::Typelib::TPerson->new({ mPersonID => 1234567 }),
        "Object creation";
    is $obj->serialize(), '<mPersonID >1234567</mPersonID >', 'serialization';
}

1;