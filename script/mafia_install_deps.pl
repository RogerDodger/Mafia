#!/usr/bin/env perl

use v5.14;
use CPAN;

while(<DATA>) {
	chomp;
	local $@;
	my($mod, $ver) = split /\s+/, $_;
	$ver //= 0;

	eval "use $mod $ver";
	if($@) {
		CPAN::Shell->install($mod)
	}
	else {
		say "$mod is " . ($ver == 0 ? "installed." : "up to date ($ver).");
	}
}

__DATA__
Catalyst::Devel 1.37
Catalyst::Runtime 5.90013
Catalyst::Plugin::ConfigLoader
Catalyst::Plugin::Static::Simple
Catalyst::Action::RenderView
Moose
namespace::autoclean
Config::General
Catalyst::View::TT 0.40
DateTime 0.78
DateTime::Format::Human::Duration 0.61
SQL::Script
DBIx::Class
DBIx::Class::TimeStamp
DBIx::Class::PassphraseColumn
Text::Markdown
Alien::Tidyp 1.4.7
HTML::Tidy 1.54