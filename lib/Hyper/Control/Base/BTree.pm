package Hyper::Control::Base::BTree;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Hyper::Control::Base);
use Class::Std::Storable;
use Scalar::Util;

my %childs_of   :ATTR(:set<childs>   :get<childs> :default<[]>);
my %parent_of   :ATTR(:get<parent>);
my %data_of     :ATTR(:name<data>    :default<()>);
my %position_of :ATTR(:get<position> :set<position>);

sub set_parent {
    $parent_of{ ident $_[0] } = $_[1];
    Scalar::Util::weaken($parent_of{ ident $_[0] });
    return $_[0];
}

sub STORABLE_thaw_post {
    # Storable restores weak references as normal references
    # weaken up-reference in tree after thawing
    Scalar::Util::weaken($parent_of{ ident $_[0] })
        if defined $parent_of{ ident $_[0] };
}

sub add_child {
    my $self  = shift;
    my $i     = scalar @{$childs_of{ident $self}};

    push @{$childs_of{ident $self}}, map {
        $_->set_parent($self);
        $_->set_position($i++);
        $_;
    } @_;

    return $self;
}

sub has_childs {
    return @{shift->get_childs()};
}

sub has_next_sibling {
    my $self   = shift;
    my $parent = $self->get_parent() or return;
    return $self->get_position() != $#{@{$parent->get_childs()}};
}

sub has_previous_sibling {
    my $self = shift;
    return ! shift->get_position();
}

sub is_root {
    return ! $parent_of{ident shift};
}

sub get_html {
    no warnings qw(once);
    local $HTML::Template::Compiled::MAX_RECURSE = ~ 0;
    return shift->SUPER::get_html();
}

sub get_template_childs {
    return $_[0]->has_childs()
        ? [ map { {this => $_ }; } @{$_[0]->get_childs()} ]
        : ();
}

sub get_path {
    my $current = shift;
    my @path;

    do {
        my $position = $current->get_position();
        unshift @path, $position if defined($position) or return \@path;
    } while ( $current = $current->get_parent() );
}

1;

__END__

=pod

=head1 NAME

Hyper::Control::Base::BTree - Tree Base Control

=head1 VERSION

This document describes Hyper::Control::Base::BTree 0.01

=head1 SYNOPSIS

    use Hyper::Control::Base::BTree;
    my $object = Hyper::Control::Base::BTree->new();

=head1 DESCRIPTION

Base Control for HTML Trees.

=head2 ATTRIBUTES

=over

=item childs   :set :get :default<[]>

=item parent   :set :get

=item data     :set :get

=item position :set :get

=back

=head1 SUBROUTINES/METHODS

=head2 add_child

    my $child = Hyper::Control::Base::BTree->new();
    $child->set_data('this is a nice child');
    $object->add_child($child);

Add a child to a tree object. Childs are Tree Objects too.

=head2 has_childs

    my $has_childs = $object->has_childs();

Indicates if a tree has childs.

=head2 has_next_sibling

    my $has_next_sibling = $object->has_next_sibling();

Indicates if a tree object has a next siblings.

=head2 has_previous_sibling

    my $has_previous_sibling = $object->has_previous_sibling();

Indicates if a tree object has a previous siblings.

=head2 is_root

    my $is_root = $object->is_root();

Indicates if a tree object has no parent node / if it's the root tree object.

=head2 get_html

    my $html = $object->get_html();

Adjust $HTML::Template::Compiled::MAX_RECURSE and returns
the rendered template.

=head2 get_template_childs

    my $template_childs = $object->get_template_childs();

Some Template engines are very stupid. This method is a helper method
which returns all childs of a tree object as an array of hash refs which
look like [ { this => $child[0] }, { this => $child[1] }, ... ]

If you don't understand what I mean, take a closer look on the default
HTC template of for this Control.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Hyper::Control::Base

=item *

Class::Std::Storable

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: kutterma $

=item Id

$Id: BTree.pm 497 2008-06-09 13:43:40Z kutterma $

=item Revision

$Revision: 497 $

=item Date

$Date: 2008-06-09 15:43:40 +0200 (Mo, 09 Jun 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/branches/0.04/lib/Hyper/Control/Base/BTree.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
