package Mafia::Script::CompileLess;

use v5.14;

use Moose;
use namespace::autoclean;
use Path::Class;

with 'Catalyst::ScriptRole';

sub run {
	my $self = shift;

	chdir dir($self->config->{home}, 'root', 'static', 'style');

	my $css = `lessc mafia.less` or die "Failed to compile LESS: $?";

	unlink $_ for glob "mafia-*.css";

	open CSS, ">", sprintf("mafia-%s.css", $self->version);
	print CSS $css;
	close CSS;
}

1;