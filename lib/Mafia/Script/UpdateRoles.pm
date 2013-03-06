package Mafia::Script::UpdateRoles;

use v5.14;

use Moose;
use namespace::autoclean;
use Path::Class;

with 'Catalyst::ScriptRole';

sub run {
	my $self = shift;

	my $rs = $self->schema->resultset('Role');

	my @roles = map { substr(file($_)->basename, 0, -3) }
		glob file($self->config->{home}, qw/lib Mafia Schema Result Player *.pm/); 

	$rs->create({ name => $_ }) for grep { !$rs->find({ name => $_ }) } @roles;

	for my $role ( $rs->all ) {
		unless( $role->name ~~ \@roles ) {
			say "Warning: The role `$role` exists in data, but there is no player class for it.";
		}
	}
}

1;