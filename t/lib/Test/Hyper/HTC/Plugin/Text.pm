package Test::Hyper::HTC::Plugin::Text;
use strict;
no warnings;
use Test::More;
use diagnostics;
use base 'Test::Class::Hyper';

sub startup : Test(startup => 3) {
    use_ok 'HTML::Template::Compiled';
    use_ok 'Hyper::Translator::Noop';
    use_ok 'Hyper::Translator::Labels::Local';
}

sub text_translator : Test(2) {
    Hyper::Singleton::Context->singleton()->set_translator(
        Hyper::Translator::Noop->new(),
    );

    my $htc;
    $htc = HTML::Template::Compiled->new(
        plugin => [ 'Hyper::HTC::Plugin::Text' ],
        scalarref => \'<%TEXT foo VALUE="bla" ESCAPE="foo"%>',
        debug => 0,
    );

    $htc->param(
        foo => 'bla',
    );

    is( $htc->output(), 'bla');

    Hyper::Singleton::Context->singleton()->set_translator(
        Hyper::Translator::Labels::Local->new( {
            labels => {
                bla => 'blubb',
            }
        } ),
    );

    is( $htc->output(), 'blubb');
}

1;


