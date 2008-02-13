package Test::Hyper::Control::Primitive::XSelect;

use strict;
use warnings;

use lib qw(D:/workspace/Hyper/Hyper/trunk/t/lib D:/workspace/Hyper/Hyper/trunk/lib);

use base qw(Test::Class::Hyper);
use Test::More;

use Readonly;

BEGIN {
    my $filename = substr __PACKAGE__, 6;
    $filename =~ s{::}{/}xmsg;
    caller or eval "use Devel::Cover qw(-select $filename -merge 0 +ignore .)";
}

sub use_module :Test(startup => 2) {
    my $class = substr __PACKAGE__, 6;
    use_ok($class);

    ok($class->new(), 'create object');
}

sub _create_object {
    my $class = substr __PACKAGE__, 6;
    return eval { $class->new() };
}

sub set_elements :Test(5) {
    my $control = _create_object();
    ok($control->set_elements(), 'set empty elements');

    my @elements = map { { i => $_ } } 1..10;
    ok($control->set_elements(\@elements), 'set some elements');
    is_deeply($control->get_elements(), \@elements, 'get some elements');
    is(@{$control->get_selected()}, 0, 'nothing selected');
    is_deeply($control->get_deselected(), \@elements, 'everything deselected');
}

sub set_selected :Test(12) {
    my $control = _create_object();

    my @elements = map { { i => $_ } } 0..5;
    ok($control->set_elements(\@elements), 'set six elements');
    is(scalar @{$control->get_selected()}, 0, 'nothing selected');

    ok($control->set_selected([ @elements[1..4] ]), 'set selected [1..4]');
    is_deeply($control->get_selected(), [ @elements[1..4] ], 'get_selected() is ok' );
    is_deeply($control->get_deselected(), [ @elements[0,5] ], 'get_deselected() is ok' );
    is_deeply($control->get_deselected_value(), [ qw(0 5) ], 'get_deselected_value() is ok');

    ok($control->set_elements(\@elements), 'set six elements');
    is(scalar @{$control->get_selected()}, 0, 'nothing selected');

    ok($control->set_selected( sub { $_[0]->{i} == 5 } ), 'set selected sub { $_[0]->{i} == 5 }');
    is_deeply($control->get_selected(), [ $elements[5] ], 'get_selected() is ok' );
    is_deeply($control->get_deselected(), [ @elements[0..4] ], 'get_deselected() is ok' );
    is_deeply($control->get_deselected_value(), [ 0..4 ], 'get_deselected_value() is ok');
}

sub set_value :Test(5) {
    my $control = _create_object();

    my @elements = map { { i => $_ } } 5..10;
    ok($control->set_elements(\@elements), 'set six elements');

    ok($control->set_value([0,2,4]), 'set_value [0,2,4]');
    is_deeply($control->get_selected(), [ @elements[0,2,4] ], 'get_deselected() is ok' );
    is_deeply($control->get_deselected(), [ @elements[1,3,5] ], 'get_deselected() is ok' );
    is_deeply($control->get_deselected_value(), [ qw(1 3 5) ], 'get_deselected_value() is ok');
}

sub get_template_elements :Test(7) {
    my $control = _create_object();

    my @elements = map { { i => $_ } } 0..5;
    ok($control->set_elements(\@elements), 'set six elements');
    ok( ! ( grep { $_->{is_selected}; } @{$control->get_template_elements()} ), 'nothing selected in return of get_template_elements()');

    ok($control->set_selected([ @elements[0,-1] ]), 'set_selected() [0,-1]');

    ok( my $template_elements_ref = $control->get_template_elements(), 'get_template_elements()');
    ok( ( $template_elements_ref->[0]->{is_selected} && shift @{$template_elements_ref} ), 'element 0 was selected');
    ok( ( $template_elements_ref->[-1]->{is_selected} && pop @{$template_elements_ref} ), 'element -1 was selected');
    ok( ! ( grep { $_->{is_selected}; } @{$template_elements_ref} ), 'nothing else was selected');
}

caller or Test::Class->runtests();

1;
