package Test::Hyper::Control::Base;

use strict;
use warnings;

use base qw(Test::Class::Hyper);
use Test::More;
use Storable qw(freeze thaw);

sub setup :Test(startup => 6) {
    use_ok('Hyper::Control::Base');
    ok( my $obj = _create_object(), 'object creation' );
    is( $obj->use_out_fh(), 0, 'use_out_fh()' );

    use_ok('Hyper::Config::Object::Control');
    use_ok('Hyper::Config::Object::Validator::Single');
    ok( $obj = _create_configured_object(), 'configured object creation' );
}

sub _create_configured_object {
    return Hyper::Control::Base->new({
        config => Hyper::Config::Object::Control->new({
            name              => $_[-1] || 'cSample',
            class             => 'Hyper::Control::Base',
            single_validators => [
                Hyper::Config::Object::Validator::Single->new({
                    class => 'Hyper::Validator::Single::Required',
                }),
            ],
        }),
    });
}

sub _create_object {
    return Hyper::Control::Base->new();
}

sub set_value :Test(4) {
    my $obj = _create_object();

    ok( eval { $obj->set_value(1); 1; }, 'set_value()');
    is( $obj->get_value(), 1, 'get_value()');
    my $value_ref = [1,2,3];
    ok( eval { $obj->set_value($value_ref); 1; }, 'set_value()');
    is_deeply( [$obj->get_value()], $value_ref, 'get_value()');
}

sub clear :Test(4) {
    my $obj = _create_object();

    ok( eval { $obj->set_value(1); 1; }, 'set_value()');
    is( $obj->get_value(), 1, 'set_value()');
    ok( $obj->clear(), 'clear()');
    ok( ! $obj->get_value(), 'get_value()');
}

sub single_validator :Test(7) {
    my $obj = _create_object();

    use_ok('Hyper::Validator::Single::Required');
    ok(
        $obj->add_single_validator(
            Hyper::Validator::Single::Required->new()
        ),
        'add_single_validator()',
    );

    ok( ! $obj->is_valid(), 'is_valid() with invalid value' );
    ok( eval { $obj->set_value(1); 1 }, 'set_value(1)');
    ok( $obj->is_valid(), 'is_valid() with valid value' );
    ok( eval { $obj->set_value(undef); 1 }, 'set_value(undef)');
    ok( ! $obj->is_valid(), 'is_valid() with invalid value' );
}

1;
