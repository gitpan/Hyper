package Test::Hyper::Control::Base::BTree;

use strict;
use warnings;

use base qw(Test::Class::Hyper);
use Test::More;
use Storable qw(freeze thaw);

sub setup :Test(startup => 6) {
    use_ok('Hyper::Control::Base::BTree');
    ok( my $obj = _create_object(), 'object creation' );
    is( $obj->use_out_fh(), 0, 'use_out_fh()' );

    use_ok('Hyper::Config::Object::Control');
    use_ok('Hyper::Config::Object::Validator::Single');
    ok( $obj = _create_configured_object(), 'configured object creation' );
}

sub hierarchy :Test(13) {
    my $root = _create_object();
    ok( $root->is_root(), 'is root tree node');
    ok( ! $root->has_childs(), 'root has no childs' );

    my $child_1 = _create_object('cChild1');
    ok( $root->add_child( $child_1 ), 'add child' );
    ok( ! $child_1->is_root(), 'child ! is_root' );
    ok( $root->is_root(), 'is root tree node');

    ok( $root->has_childs(), 'root has childs' );

    ok( ! $child_1->has_next_sibling(), 'child has no next sibling' );
    ok( ! $child_1->has_previous_sibling(), 'child has no previous sibling' );

    my $child_2 = _create_object('cChild2');
    ok( $root->add_child( $child_2 ), 'add child' );
    ok( $child_1->has_next_sibling(), 'child 1 has next sibling' );
    ok( $child_2->has_previous_sibling(), 'child 2 has previous sibling' );
    ok( ! $child_1->has_previous_sibling(), 'child 1 has no previous sibling' );
    ok( ! $child_2->has_next_sibling(), 'child 2 has no next sibling' );

    # ToDo: add path check
}

sub _create_configured_object {
    return Hyper::Control::Base::BTree->new({
        config => Hyper::Config::Object::Control->new({
            name              => $_[-1] || 'cSample',
            class             => 'Hyper::Control::Base::BTree',
            single_validators => [
                Hyper::Config::Object::Validator::Single->new({
                    class => 'Hyper::Validator::Single::Required',
                }),
            ],
        }),
    });
}

sub _create_object {
    return Hyper::Control::Base::BTree->new();
}

sub storable :Test(1) {
    no warnings qw(redefine);
    my $original_STORABLE_thaw_post_ref = \&Hyper::Control::Base::STORABLE_thaw_post;
    my $called;
    *Hyper::Control::Base::STORABLE_thaw_post = sub {
      $called = 1;
      &$original_STORABLE_thaw_post_ref;
    };
    my $obj = thaw(freeze(_create_object()));

    ok( $called, 'STORABLE_thaw_post called' );
    *Hyper::Control::Base::STORABLE_thaw_post
      = $original_STORABLE_thaw_post_ref;
}

1;
