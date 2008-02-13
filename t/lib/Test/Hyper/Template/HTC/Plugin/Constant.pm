package Test::Hyper::Template::HTC::Plugin::Constant;

use strict;
use warnings;
use Test::More;

use base 'Test::Class::Hyper';

sub startup : Test(startup => 2) {
    use_ok 'HTML::Template::Compiled';
    use_ok 'Hyper::Template::HTC::Plugin::Constant';
}

sub text_translator :Test(9) {
    my @templates = (
        '<%DEFINE SOME_CONST="foo" OTHER_CONST="bar"%>',
        '<%= SOME_CONST %>',
        '<%= OTHER_CONST %>',
        '<%LOCAL FOO="bar"%>',
        '<%= FOO %>',
        '<%/LOCAL%>',
        '<%CONST foo%>',
        '<%= _ %>',
        '<%/CONST%>',
    );
    for my $template ( @templates ) {
        # with all possible things
        my $htc = HTML::Template::Compiled->new(
            plugin    => [ 'Hyper::Template::HTC::Plugin::Constant' ],
            scalarref => \$template,
            debug     => 0,
        );

        #$htc->param(foo => 'bla');
        ok( $htc->output(), 'bla');
    }
}

1;


