package Test::Hyper::SOAP::LocalType::faultdetail;
use strict;
use warnings;
use Test::More;
use base 'Test::Class';

sub startup :Test(startup => 1) {
    use_ok 'Hyper::SOAP::LocalType::faultdetail';
}

sub xmlns : Test(1) {
    ok Hyper::SOAP::LocalType::faultdetail->get_xmlns(
        'http://schemas.xmlsoap.org/soap/envelope/'
    );
}

sub serialize : Test(1) {
    my $obj = Hyper::SOAP::LocalType::faultdetail->new({
        TException => {
        }
    }
    );

    is "$obj",
        '<detail xmlns="http://schemas.xmlsoap.org/soap/envelope/" ><TException ></TException ></detail>',
        'faultdetail serialization';

}

1;