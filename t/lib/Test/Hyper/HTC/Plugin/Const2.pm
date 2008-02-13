package HTC::Plugin::Const2;
use strict;
use warnings;
use HTML::Template::Compiled::Expression qw(:expressions);
use HTML::Template::Compiled;

HTML::Template::Compiled->register('HTC::Plugin::Const2');

our $VERSION = '0.01';

sub register {
    my ($class) = @_;
    return {
        tagnames => {
            HTML::Template::Compiled::Token::OPENING_TAG() => {
                CONSTANT => [sub { exists $_[1]->{NAME} }, qw(NAME)],
            },
            HTML::Template::Compiled::Token::CLOSING_TAG() => {
                CONSTANT => [undef, qw(NAME)],
            },
        },
        compile => {
            CONSTANT => {
                open => \&_const_open,
                close => \&_const_close,
            },
        },
    }
}

sub _const_open {
    my $htc   = shift;
    my $token = shift;
    my $attr  = $token->get_attributes();
    my $code = _expr_open()->to_string(2) . " # CONST $attr->{NAME}\n";
    $code .= "    my \$C = \\'$attr->{NAME}';  #;EO_CONST \n";
    return $code;
}

sub _const_close {
    my $htc   = shift;
    return _expr_close()->to_string(2) . "\n";
}

1;