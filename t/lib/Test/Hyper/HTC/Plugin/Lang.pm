package Test::Hyper::HTC::Plugin::Lang;
use strict;
no warnings;
use Test::More;
use diagnostics;
use base 'Test::Class::Hyper';

sub startup : Test(startup => 2) {
    use_ok 'HTML::Template::Compiled';
    use_ok 'Hyper::HTC::Plugin::Lang'
}

sub lang : Test(1) {
    my $htc;
    $htc = HTML::Template::Compiled->new(
        plugin => [ 'Hyper::HTC::Plugin::Lang' ],
        scalarref => \'<%LANG%><%= lang %><%/LANG%>',
        debug => 0,
    );

    is( $htc->output(), 'de');

}

1;


