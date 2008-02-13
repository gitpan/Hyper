package Test::Hyper::HTC::Plugin::Text::LabelHashTranslator;
use strict;
no warnings;
use diagnostics;

use Test::More;
use base 'Test::Class::Hyper';

sub startup :Test(startup => 6) {
    use_ok 'Hyper_Misc::TieLabelHash';
    use_ok 'HTML::Template::Compiled';
    use_ok 'Hyper::Translator::Noop';
    use_ok 'Hyper::Singleton::Context';
    use_ok 'Hyper::Translator::Labels::Local';
    use_ok 'Hyper::Translator::Labels::Styleguide';

    Hyper::Singleton::Context->singleton()->set_translator(
        Hyper::Translator::Labels::Styleguide->new( {
            styleguide_class => qw(LabelHashTranslatorFakeStyleguide),
        } ),
    );
}


sub labels :Test( 3 ) {

    my $htc;
    $htc = HTML::Template::Compiled->new(
        plugin => [ 'Hyper::HTC::Plugin::Text' ],
        scalarref => \'<%TEXT foo VALUE="key_bla"%>',
        debug => 0,
    );

    $htc->param( foo => [ 'bla', 3 ] );
    is $htc->output(), 'Your bla has 3 wheels on the left'
        , 'maketext plural output';

    $htc->param( foo => [ 'car', 1 ] );
    is $htc->output(), 'Your car has 1 wheel on the left'
        , 'maketext singular output';


    $htc->param( foo => [ 'bla', 0 ]);
    is $htc->output(), 'Your bla has no wheel on the left'
        , 'maketext zero output';

}

sub textile : Test( 1 ) {
    my $htc = HTML::Template::Compiled->new(
        plugin => [ 'Hyper::HTC::Plugin::Text' ],
        scalarref => \'<%TEXT foo VALUE="key_textile" ESCAPE="TEXTILE"%>',
        debug => 0,
    );

    $htc->param( foo => [ 'bla', 3 ] );
    # TODO content comparison
    ok $htc->output(), 'textile output';
}

package LabelHashTranslatorFakeStyleguide;
use Hyper_Misc::TieLabelHash;

sub new { return bless {}, 'LabelHashTranslatorFakeStyleguide' };
sub singleton { return bless {}, 'LabelHashTranslatorFakeStyleguide' };
sub getLabels {
    my $mylabels;
    tie %$mylabels, 'Hyper_Misc::TieLabelHash', (
    'key_bla' => 'Your [_1] has [*,_2,wheel,wheels,no wheel] on the left',
    'key_textile' => <<"EOT",
Your [_1] has [*,_2,wheel,wheels,no wheel] on the left

* One
** Two

EOT
    );
    return $mylabels;
};

1;