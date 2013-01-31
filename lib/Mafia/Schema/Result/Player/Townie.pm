package Mafia::Schema::Result::Player::Townie;

use base "Mafia::Schema::Result::Player";

sub type {
	"Town";
}

1;