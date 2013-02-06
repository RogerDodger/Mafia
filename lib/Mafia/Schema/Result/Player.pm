use utf8;
package Mafia::Schema::Result::Player;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mafia::Schema::Result::Player

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<players>

=cut

__PACKAGE__->table("players");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1
  size: 16

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 game_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 vote_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 team_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 life

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1, size => 16 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "game_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "vote_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "team_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "life",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<user_id_game_id_unique>

=over 4

=item * L</user_id>

=item * L</game_id>

=back

=cut

__PACKAGE__->add_unique_constraint("user_id_game_id_unique", ["user_id", "game_id"]);

=head1 RELATIONS

=head2 actions_actors

Type: has_many

Related object: L<Mafia::Schema::Result::Action>

=cut

__PACKAGE__->has_many(
  "actions_actors",
  "Mafia::Schema::Result::Action",
  { "foreign.actor_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 actions_targets

Type: has_many

Related object: L<Mafia::Schema::Result::Action>

=cut

__PACKAGE__->has_many(
  "actions_targets",
  "Mafia::Schema::Result::Action",
  { "foreign.target_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 game

Type: belongs_to

Related object: L<Mafia::Schema::Result::Game>

=cut

__PACKAGE__->belongs_to(
  "game",
  "Mafia::Schema::Result::Game",
  { id => "game_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 players

Type: has_many

Related object: L<Mafia::Schema::Result::Player>

=cut

__PACKAGE__->has_many(
  "players",
  "Mafia::Schema::Result::Player",
  { "foreign.vote_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role

Type: belongs_to

Related object: L<Mafia::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Mafia::Schema::Result::Role",
  { id => "role_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 team

Type: belongs_to

Related object: L<Mafia::Schema::Result::Team>

=cut

__PACKAGE__->belongs_to(
  "team",
  "Mafia::Schema::Result::Team",
  { id => "team_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<Mafia::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Mafia::Schema::Result::User",
  { id => "user_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 vote

Type: belongs_to

Related object: L<Mafia::Schema::Result::Player>

=cut

__PACKAGE__->belongs_to(
  "vote",
  "Mafia::Schema::Result::Player",
  { id => "vote_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-02-06 19:09:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+W+g6XUGGq5iAD0Ix3OszA

sub inflate_result {
  my $self = shift;
  my $ret = $self->next::method(@_);

  if( my $role = $ret->role ) {
    my $subclass = __PACKAGE__ . "::" . $role;
    $self->ensure_class_loaded($subclass);
    bless $ret, $subclass;
  }

  return $ret;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
