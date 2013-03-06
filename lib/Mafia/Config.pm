package Mafia::Config;

use v5.14;
use strict;
use YAML ();
use FindBin '$Bin';
use Path::Class;
use Carp 'croak';

my $home = $ENV{MAFIA_HOME} || $ENV{CATALYST_HOME} || dir($Bin)->parent->stringify;

sub load {
	my $fn = file($home, "mafia.yml")->stringify;
	my %defaults;

	# Why do it like this? Because if it's hard-coded it doesn't play nice with
	# the server reload switch (-r). Pain in the butt. This way we're re-reading
	# the defaults (catching any changes) every time we load the config.
	open SELF, "<", $INC{ file("Mafia", "Config.pm") };
	while( my $line = <SELF> ) {
		if($line =~ /^__END__/) {
			%defaults = do { local $/; eval <SELF> };
		}
	}
	close SELF;

	if( !-e $fn ) {
		croak "Local config file ($fn) not found.";
	}
	else {
		my($local_config) = YAML::LoadFile( $fn );

		my $config = {
			%defaults, 
			ref $local_config eq 'HASH' ? %$local_config : ()
		};

		return $config;
	}
}

1;

__END__
(
	name => 'Mafia',
	home => $home,
	
	default_view => 'TT',
	encoding => 'UTF-8',
	'View::TT' => { 
		INCLUDE_PATH => [ dir($home, 'root', 'src' ) ],
	},
	'Model::DB' => {
		connect_info => {
			dsn => "dbi:SQLite:" . file($home, "data", "Mafia.db")->stringify,
			username => "",
			password => "",
			sqlite_unicode => 1,
			on_connect_do => q{PRAGMA foreign_keys = ON}
		},
	},
	'Plugin::Authentication' => {
		default => {
			class         => 'SimpleDB',
			user_model    => 'DB::User',
			password_type => 'self_check',
		},
	},
	'Plugin::Session' => {
		flash_to_stash => 1,
		expires => 365 * (60 * 60 * 24),
	},

    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1,
)