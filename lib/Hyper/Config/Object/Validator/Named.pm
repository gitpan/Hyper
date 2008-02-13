package Hyper::Config::Object::Validator::Named;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use Class::Std::Storable;
use Hyper::Error;

my %name_of   :ATTR(:get<name>);
my %act_as_of :ATTR(:get<act_as>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;

    $name_of{$ident}   = delete $arg_ref->{name}   || throw('missing attribute >class<');
    $act_as_of{$ident} = delete $arg_ref->{act_as} || throw('missing attribute >act_as<');

    if (%{$arg_ref}) {
        throw('invalid argument(s) >' . (join ',', keys %{$arg_ref}) . '< for validator config object');
    }
}

1;

__END__


=pod

=head1 NAME

Hyper::Config::Object::Validator::Named
 - Configuration Object for Named Validators

=head1 VERSION

This document describes Hyper::Config::Object::Validator::Named 0.01

=head1 SYNOPSIS

    use Hyper::Config::Object::Validator::Named;

    my $object = Hyper::Config::Object::Validator::Named->new({
        name   => 'vComparePasswords',
        act_as => 'first_password',
    });

=head1 DESCRIPTION

Hyper::Config::Object::Validator::Named is used managing
configuration items for named Hyper Validators.

=head1 ATTRIBUTES

=over

=item name   :init_arg

=item act_as :init_arg

=back

=head1 SUBROUTINES/METHODS

=head2 new

    my $object = Hyper::Config::Object::Validator::Named->new({
        name   => 'vComparePasswords',
        act_as => 'first_password',
    });

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

version

=item *

Class::Std::Storable

=item *

Hyper::Error

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

 $Author: $

=item Id

 $Id: $

=item Revision

 $Revision: $

=item Date

 $Date: $

=item HeadURL

 $HeadURL: $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
