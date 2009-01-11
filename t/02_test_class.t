#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use File::Spec;

BEGIN {
    require lib;
    lib ->import(
        map {
            my $path = dirname(__FILE__) . "/$_";
            -d $path ? $path : ();
        } qw(../lib/ lib)
    );
}
our %PATH_OF = (
    t    => dirname(__FILE__),
    libs => [
        map {
            my $path = dirname(__FILE__) . "/$_";
            -d $path ? $path : ();
        } qw(../lib/ lib)
    ],
);

use Test::Class::Hyper;

use Test::Hyper;

#use Test::Hyper::Application;
#use Test::Hyper::Application::Default;
#use Test::Hyper::Application::Minimal;

use Test::Hyper::Config::Object::Context;
use Test::Hyper::Config::Object::Control;
#use Test::Hyper::Config::Object::Control::Validator;
use Test::Hyper::Config::Object::Default;
use Test::Hyper::Config::Object::Step;
#use Test::Hyper::Config::Object::Transition;

#use Test::Hyper::Config::Object::Validator::Group;
#use Test::Hyper::Config::Object::Validator::Named;
#use Test::Hyper::Config::Object::Validator::Single;

#use Test::Hyper::Config::Reader;
#use Test::Hyper::Config::Reader::Container;
#use Test::Hyper::Config::Reader::Context;
#use Test::Hyper::Config::Reader::Flow;


#use Test::Hyper::Container;
#use Test::Hyper::Context;
use Test::Hyper::Control;
use Test::Hyper::Control::Primitive::XSelect;

use Test::Hyper::Control::Base;
use Test::Hyper::Control::Base::BTree;
#use Test::Hyper::Control::Base::BInput;
#use Test::Hyper::Control::Base::BPushButton;
#use Test::Hyper::Control::Base::BSelect;
#use Test::Hyper::Control::Base::BTree;
#use Test::Hyper::Control::Base::BUpload;

use Test::Hyper::Control::Flow;
use Test::Hyper::Control::Container;
#use Test::Hyper::Control::Primitive;
#use Test::Hyper::Control::Template;
#use Test::Hyper::Control::Validator;
#use Test::Hyper::Control::Validator::Group;
#use Test::Hyper::Control::Validator::Single.pm

#use Test::Hyper::Debug;
use Test::Hyper::Error;
#use Test::Hyper::Functions;

#use Test::Hyper::Identifier;
#use Test::Hyper::Name;
#use Test::Hyper::Persistent;
#use Test::Hyper::Singleton;
use Test::Hyper::Singleton::CGI;
#use Test::Hyper::Singleton::Container;
#use Test::Hyper::Singleton::Container::Validator;
#use Test::Hyper::Singleton::Container::Validator::Group;
#use Test::Hyper::Singleton::Container::Validator::Single;
use Test::Hyper::Singleton::Context;
#use Test::Hyper::Singleton::Debug;

use Test::Hyper::Template;
#use Test::Hyper::Template::HTC;


#TODO use Test::Hyper::Template::HTC::Plugin::Constant;
use Test::Hyper::Template::HTC::Plugin::Text;
##use Test::Hyper::Template::HTC::Plugin::Lang;

#use Test::Hyper::Translator;
use Test::Hyper::Translator::Noop;

use Test::Hyper::Validator;
use Test::Hyper::Validator::Group;
use Test::Hyper::Validator::Group::Compare;
use Test::Hyper::Validator::Single;
use Test::Hyper::Validator::Single::Required;

##use Test::Hyper::HTC::Plugin::Text::LabelHashTranslator;
##use Test::Hyper::HTC::Plugin::Lang;
##use Test::Hyper::HTC::Plugin::Text;

#--------------------------------
Test::Class::Hyper->runtests();


##use Test::CP::HTC::Plugin::Text;
##use Test::Hyper::HTC::Plugin::Lang;
##use Test::CP::Singleton::Context;

##use Test::CP::Translator::Labels::Local;
##use Test::CP::Translator::Labels::Styleguide;
##use Test::CP::Validator::Single::Required;
##use Test::CP::Validator::Single::BSingleSelect::Required;
##use Test::CP::Validator::Single::BTextField::Required;
##use Test::CP::Validator;
##use Test::CP::HTC::Plugin::Text::LabelHashTranslator;
