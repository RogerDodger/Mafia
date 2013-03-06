package Mafia::Script::SeedData;

use v5.14;

use Moose;
use namespace::autoclean;

with 'Catalyst::ScriptRole';

require Text::Lorem::More;

sub run {
	my $self = shift;
	my $schema = $self->schema;

	my $lorem = Text::Lorem::More->new;
	
	my @usernames = map { $lorem->username } 1..9;
	my $user_rs   = $schema->resultset('User');
	my @users     = map { $user_rs->create({ name => $_ }) } @usernames;

	
}

1;