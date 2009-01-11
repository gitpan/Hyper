#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use English qw(-no_match_vars);

$ENV{RELEASE_TESTING}
    or plan(
        skip_all => 'Author test.  Set $ENV{RELEASE_TESTING} to a true value to run.'
    );

eval 'use Test::Prereq::Build';

if ( $EVAL_ERROR ) {
    my $msg = 'Test::Prereq::Build not installed; skipping';
    plan( skip_all => $msg );
}
else {
    # workaround, cause this method is missing in Test::Prereq::Build
    no warnings qw(once);
    *Test::Prereq::Build::add_build_element = sub {};
}

# workaround for the bugs of Test::Prereq::Build
my @skip_workaround = qw{
    Test::Class::Hyper
    Test::Hyper::Config::Object::Context
    Test::Hyper::Config::Object::Control
    Test::Hyper::Config::Object::Default
    Test::Hyper::Config::Object::Step
    Test::Hyper::Control
    Test::Hyper::Control::Container
    Test::Hyper::Control::Flow
    Test::Hyper::Error
    Test::Hyper::Singleton::CGI
    Test::Hyper::Validator::Group::Compare
    Test::Hyper::Debug
    Test::Hyper::Generator::Control::Flow
    Test::Hyper::Singleton::Context
    Test::Hyper::Template
    Test::Hyper::Template::HTC::Plugin::Lang
    Test::Hyper::Template::HTC::Plugin::Text
    Test::Hyper::Translator::Noop
    Test::Hyper::Template::HTC::Plugin::Constant
    Test::Hyper::Validator
    Test::Hyper::Validator::BSingleSelect::Required
    Test::Hyper::Validator::BTextField::AlphaNumericWord
    Test::Hyper::Validator::BTextField::Required
    Test::Hyper::Validator::Group
    Test::Hyper::Validator::Group::ComparePasswords
    Test::Hyper::Validator::GroupSingle
    Test::Hyper::Validator::Required
    Test::Hyper::Validator::Single
    Test::Hyper::Validator::Single::BSingleSelect::Required
    Test::Hyper::Validator::Single::BTextField::BDateField
    Test::Hyper::Validator::Single::BTextField::BDateField::ValidFuture
    Test::Hyper::Validator::Single::BTextField::BDateField::ValidPast
    Test::Hyper::Validator::Single::BTextField::PhoneNumber
    Test::Hyper::Validator::Single::BTextField::Required
    Test::Hyper::Validator::Single::Required
};


# These modules should not go into Build.PL
my @skip_devel_only = qw{
    Test::Kwalitee
    Test::Perl::Critic
    Test::Prereq::Build
};

my @skip = (
    'Apache2::RequestUtil', # optional
    @skip_workaround,
    @skip_devel_only,
);

prereq_ok( undef, undef, \@skip );
