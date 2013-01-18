#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Mafia';
all_from 'lib/Mafia.pm';
perl_version '5.014';


requires (
	'Catalyst::Runtime' => '5.90013',
	'Catalyst::Plugin::ConfigLoader' => 0,
	'Catalyst::Plugin::Static::Simple' => 0,
	'Catalyst::Action::RenderView' => 0,
	'Moose' => 0,
	'namespace::autoclean' => 0,
	'Config::General' => 0,
)
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
