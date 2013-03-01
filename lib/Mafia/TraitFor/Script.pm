package Mafia::TraitFor::Script;

use Moose::Role;
use namespace::autoclean;
use FindBin '$Bin';
use Path::Class;
require Mafia::Config;

sub config {
	my $self = shift;

	return $self->{config} //= Mafia::Config->load;
}

sub db {
	my $self = shift;
	require DBI;

	return $self->_connect('DBI');
}

sub schema {
	my $self = shift;
	require Mafia::Schema;

	return $self->_connect('Mafia::Schema');
}

sub _connect {
	my( $self, $class ) = @_;

	my %connect_info = %{ $self->config->{'Model::DB'}{connect_info} };

	my($dsn, $username, $password) = delete @connect_info{qw/dsn username password/};

	return $class->connect($dsn, $username, $password, \%connect_info);
}

sub version {
	my $self = shift;

	open R, "<", file($self->config->{home}, 'lib', 'Mafia.pm');
	while(<R>) {
		if(/\$VERSION = (.+?);/) {
			return eval $1;
		}
	}

	return 0;
}

1;