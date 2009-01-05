use Module::Build;
my $build = Module::Build->new(
    dist_abstract      => 'Hyper Framework',
    dist_name          => 'Hyper',
    dist_version       => '0.04_01',
    module_name        => 'Hyper',
    license            => 'artistic',
    create_makefile_pl => 'traditional',
    requires           => {
        #Apache2::RequestUtil                 => 0,
        Cache::FileCache                     => 0,
        Class::Std::Storable                 => 0,
        Class::Std                           => '0.0.8',
        Config::IniFiles                     => 0,
        Cwd                                  => 0,
        Data::Dumper                         => 0,
        Data::UUID                           => 0,
        English                              => 0,
        File::Basename                       => 0,
        File::Find                           => 0,
        File::Path                           => 0,
        File::Spec                           => 0,
        HTML::Template::Compiled::Expression => 0,
        HTML::Template::Compiled::Utils      => 0,
        HTML::Template::Compiled             => '0.88',
        IO::File                             => 0,
        IO::Scalar                           => 0,
        JSON::XS                             => '2.01',
        List::MoreUtils                      => 0,
        #Parse::RecDescent                    => 0,
        Perl6::Export::Attrs                 => 0,
        Readonly                             => 0,
        Scalar::Util                         => 0,
        Storable                             => 0,
        #Template                             => 0,
        UNIVERSAL::require                   => 0,
        CGI                                  => 0,
        base                                 => 0,
        version                              => 0,
        #Date::Format                         => 0,
        #Date::Parse                          => 0,
        #Fcntl                                => 0,
        #Symbol                               => 0,
        #Time::HiRes                          => 0,
    },

    build_requires => {
        Test::Exception     => 0,
        Test::More          => 0,
        Test::Pod           => 0,
        Test::Pod::Coverage => 0,
        Test::Class         => 0,
        File::Basename      => 0,
        File::Find          => 0,
    },
    recursive_test_files => 1,
    meta_add => {
        no_index => {
            namespace => 'Hyper::var',
        },
    }
);
$build->add_build_element('htc');

$build->create_build_script;

# Find most uses:
# grep "use [^;]*;" -roh  --include=*.pm * | grep -v "use Hyper" | grep -v "use base qw(Hyper::" | sort | uniq
