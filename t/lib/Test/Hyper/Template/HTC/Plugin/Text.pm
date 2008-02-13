package Test::Hyper::Template::HTC::Plugin::Text;

use strict;
use warnings;
use Test::More;

use base 'Test::Class::Hyper';

sub startup : Test(startup => 3) {
    use_ok 'HTML::Template::Compiled';
    use_ok 'Hyper::Template::HTC::Plugin::Text';
}

sub text_translator_noop :Test(3) {
    my $default_text = 'Test String';
    my %result_of = (
        '<%TEXT variable %>'       => $default_text,
        '<%TEXT VALUE="static" %>' => 'static',
        '<%TEXT VALUE="[_1] has [_2] points!" _1="Larry" _2_VAR="var.with.points" %>'
            => '[_1] has [_2] points!',
    );

    for my $template ( keys %result_of ) {
        my $htc = HTML::Template::Compiled->new(
            plugin    => [ 'Hyper::Template::HTC::Plugin::Text' ],
            scalarref => \$template,
        );
        $htc->param(variable => $default_text);
        is( $htc->output() => $result_of{$template} );
    }
}

1;


