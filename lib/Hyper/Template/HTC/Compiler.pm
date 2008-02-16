package Hyper::Template::HTC::Compiler;

use strict;
use warnings;
use version; our $VERSION = qv(0.01);

use base qw(HTML::Template::Compiled::Compiler);

sub parse_var {
    my $self   = shift;
    my $varstr = $self->SUPER::parse_var(@_);

    # fix var parser :)
    $varstr =~ s{\$var\s=\sUNIVERSAL::can\(\$var,'can'\)\s\?\s\$var->([^(]+)\(\)\s:\s\$var->\{'([^']+)'\};}
                {\$var = 'HASH' eq ref \$var ? \$var->\{'$2'\} : UNIVERSAL::can(\$var,'$1') ? \$var->$1() : undef;}xmsg;

    return $varstr;
}

1;

__END__

=head1 NAME

Hyper::Template::HTC::Compiler - Provide improved HTC features in a dirty way.

=head1 VERSION

This document describes Hyper::Template::HTC 0.01

=head1 SYNOPSIS

    package My::HTC;

    use base qw(HTML::Template::Compiled);
    use Hyper::Template::HTC::Compiler;

    sub compiler_class {
        return 'Hyper::Template::HTC::Compiler';
    }

=head1 DESCRIPTION

This is the compiler class for L<Hyper::Template::HTC::Compiler>.
It applies some small workarounds to fix most bugs reported on CPAN's RT.

=head1 SUBROUTINES/METHODS

=head2 parse_var

Allow mixed use of methods and hash key lookups for vars.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item *

L<version>

=item *

L<HTML::Template::Compiled::Compiler>

=back


=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 RCS INFORMATIONS

=over

=item Last changed by

$Author: ac0v $

=item Id

$Id: Compiler.pm 317 2008-02-16 01:52:33Z ac0v $

=item Revision

$Revision: 317 $

=item Date

$Date: 2008-02-16 02:52:33 +0100 (Sat, 16 Feb 2008) $

=item HeadURL

$HeadURL: http://svn.hyper-framework.org/Hyper/Hyper/trunk/lib/Hyper/Template/HTC/Compiler.pm $

=back

=head1 AUTHOR

Andreas Specht  C<< <ACID@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Andreas Specht C<< <ACID@cpan.org> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

