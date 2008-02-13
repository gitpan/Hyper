package Test::Hyper::Config::Object::Context;

use strict;
use warnings;

use Test::More;
use base qw(Test::Class::Hyper);

sub startup : Test(startup => 1) {
    use_ok('Hyper::Config::Object::Context');
}

sub methods :Test(6) {
    my $obj;
    ok($obj = Hyper::Config::Object::Context->new(), 'Object creation');

    my $name_of_explicit_package    = 'ExplicitPackage';
    my $config_for_explicit_package = 'Another Test';
    my $config_for_current_package  = 'Test 2';

    # Set Config
    ok(
        $obj->set_config_of(
            $name_of_explicit_package
                => $config_for_explicit_package
        ) => 'set config data for explicit package'
    );
    ok(
        $obj->set_config_of(
            __PACKAGE__
                => $config_for_current_package
        ) => 'set config data for current package'
    );

    # get and recheck config
    ok(
        $obj->get_config(
            $name_of_explicit_package
        ) eq $config_for_explicit_package
        => 'get config for explicit package'
    );
    ok(
        $obj->get_config(
            __PACKAGE__
        ) eq $config_for_current_package
        => 'get config data for current package'
    );
    ok(
        $obj->get_config() 
        => 'get config data without arguments'
    );
}

1;
