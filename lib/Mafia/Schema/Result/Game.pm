use utf8;
package Mafia::Schema::Result::Game;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mafia::Schema::Result::Game

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

=head1 TABLE: C<games>

=cut

__PACKAGE__->table("games");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 host_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 setup_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 is_day

  data_type: 'bit'
  is_nullable: 1
  size: 1

=head2 gamedate

  data_type: 'integer'
  is_nullable: 1

=head2 end

  data_type: 'timestamp'
  is_nullable: 1

=head2 created

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "host_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "setup_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "is_day",
  { data_type => "bit", is_nullable => 1, size => 1 },
  "gamedate",
  { data_type => "integer", is_nullable => 1 },
  "end",
  { data_type => "timestamp", is_nullable => 1 },
  "created",
  { data_type => "timestamp", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 actions

Type: has_many

Related object: L<Mafia::Schema::Result::Action>

=cut

__PACKAGE__->has_many(
  "actions",
  "Mafia::Schema::Result::Action",
  { "foreign.game_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 host

Type: belongs_to

Related object: L<Mafia::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "host",
  "Mafia::Schema::Result::User",
  { id => "host_id" },
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
  { "foreign.game_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 setup

Type: belongs_to

Related object: L<Mafia::Schema::Result::Setup>

=cut

__PACKAGE__->belongs_to(
  "setup",
  "Mafia::Schema::Result::Setup",
  { id => "setup_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 threads

Type: has_many

Related object: L<Mafia::Schema::Result::Thread>

=cut

__PACKAGE__->has_many(
  "threads",
  "Mafia::Schema::Result::Thread",
  { "foreign.game_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-01-30 11:22:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DRrHizKWV5IU2AAiICE+yg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
