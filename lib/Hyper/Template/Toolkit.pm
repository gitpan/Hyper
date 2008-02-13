package Hyper::Template::Toolkit;

use strict;
use warnings;
use version; our $VERSION = qv('0.01');

use base qw(Template);

use Hyper;
use Hyper::Template; # don't inherit; contains only class methods
use Hyper::Functions;
use Hyper::Singleton::Context;
use Hyper::Template::HTC::Compiler;

use File::Basename;
use File::Spec;

sub new {
    my ($class, %arg_of) = @_;

    Hyper::Template::_init(\%arg_of);

    my $filename = exists $arg_of{for_class}
        ? Hyper::Functions::class_to_path(delete $arg_of{for_class})
          . '.'
          . Hyper::Template::get_suffix_for_class($class)
        : delete $arg_of{filename};

    my $self = SUPER::new($class, {
        INCLUDE_PATH => Hyper::Template::get_template_paths(),
        TAG_STYLE    => 'asp',
        %arg_of,
    });

    $self->{__PACKAGE__} = {
        filename => $filename,
        param_ref => {
            Hyper => Hyper->singleton(),
        },
    };


#            Hyper::Template::HTC::Plugin::Text


    return $self;
}

sub param {
    my ($self, %arg_of) = @_;

    for my $name ( keys %arg_of ) {
        $self->{__PACKAGE__}->{param_ref}->{$name} = $arg_of{$name};
    }

    return $self;
}

sub output {
    my $self = shift;

    if ( $self->get_out_fh() ) {
        # WORKAROUND
        # supress the following warnings
        # cause of problem with: uninitialized IO::Scalar line 421
        local $^W = 0;
        $self->process(
            $self->{__PACKAGE__}->{filename},
            $self->{__PACKAGE__}->{param_ref},
            @_ ? @_ : Hyper->singleton()->get_output_handle()
        );
        return q{};
    }
    else {
        $self->process(
            $self->{__PACKAGE__}->{filename},
            $self->{__PACKAGE__}->{param_ref},
            \my $output,
        );
        return $output;
    }
}

1;

__END__
