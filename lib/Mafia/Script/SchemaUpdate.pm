package Mafia::Script::SchemaUpdate;

use v5.14;

use Moose;
use namespace::autoclean;
use File::Temp 'tempfile';
use Path::Class 'file';
require SQL::Script;
require DBI;

with 'Catalyst::ScriptRole';

sub run {
	my $self = shift;
	my(undef, $tmp) = tempfile;

	my $home = $self->config->{home};

	my $dbh = DBI->connect("dbi:SQLite:$tmp");
	my $sql = SQL::Script->new;
	$sql->read( file($self->config->{home}, "data", "schema.sql")->stringify );
	$sql->run( $dbh );

	my @args = (
		file($home, "script", "mafia_create.pl")->stringify,
		'model',
		'DB',
		'DBIC::Schema',
		'Mafia::Schema',
		'create=static',
		'components=TimeStamp,PassphraseColumn',
		"dbi:SQLite:$tmp",
		'sqlite_unicode=1',
	);

	system(@args) == 0
		or die "system @args failed: $?";

	unlink $tmp;
	unlink file($home, "lib", "Mafia", "Model", "DB.pm.new")->stringify;
}

1;