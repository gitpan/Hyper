package Test::Class::Hyper;

use strict;
use warnings;

use base qw(Test::Class);
use Test::More;
use File::Basename;

sub setup :Test(setup => 4) {
    my $base_path = dirname(__FILE__) . '/../../../';

    # TODO: reproduce context-setup Error
    #XXX print '__FILE__: ', __FILE__, ' $base_path: ', $base_path, "\n";

    open my $config, '<', \(my $config_scalar = <<"EOT");
[Global]
base_path=<<EOX
$base_path
EOX
template_class=Hyper::Template::HTC
namespace=MyTest

[Class]
translator=Hyper.Translator.Noop
application=Hyper.Application.Default

[Hyper::Application]
template=../../../var/Hyper/index.htc

[Hyper::Persistence]
cache_path=./tmp/

;[Hyper::Error]
;plain_template=../../../var/Hyper/Error/plain_error.htc
;html_template=../../../var/Hyper/Error/html_error.htc
EOT

    local $SIG{__WARN__} = sub {
        # Config::IniFiles line 522.
        $_[0] =~ m{\A \Qstat() on unopened filehandle\E}xms ? () : warn @_;
    };
    use_ok('Hyper::Singleton::Context');
    ok( Hyper::Singleton::Context->new({
            file => $config,
        }) => 'Context setup'
    );
    use_ok('Hyper');
    ok( Hyper->new({
            service => 'none',
            usecase => 'none',
        }) => 'starting application'
    );
}

1;
