package Mafia::Script::Init;

use v5.14;

use Moose;
use namespace::autoclean;
use Path::Class;
require SQL::Script;
require Catalyst::ScriptRunner;

with 'Catalyst::ScriptRole';

sub run {
	my $self = shift;

	my $fn = (split ":", $self->config->{"Model::DB"}{connect_info}{dsn})[-1];
	if( -e $fn ) {
		print "Database file already exists. Initialisation will overwrite it. Continue? [y] ";
		if( <STDIN> =~ /n/i ) {
			exit(0);
		}
		else {
			unlink $fn;
		}
	}

	say "Creating database at $fn";
	my $dbh = $self->db;
	my $sql = SQL::Script->new;
	$sql->read( file($self->config->{home}, "data", "schema.sql")->stringify );
	$sql->run( $dbh );
	undef $dbh;

	my $schema = $self->schema;

	print "Admin username: ";
	chomp(my $admin = <STDIN>);

	say "Creating admin account `$admin` with password `admin`";

	$schema->resultset('User')->create({
		name     => $admin,
		password => 'admin',
		is_admin => 1,
		is_mod   => 1,
	});

	$schema->resultset('Team')->create({ name => $_ }) for qw/Town Mafia Nomad Bratva Yakuza/;

	Catalyst::ScriptRunner->run('Mafia', 'UpdateRoles');
}

1;