use utf8;
package Mafia::Schema::Result::Action;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mafia::Schema::Result::Action

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

=head1 TABLE: C<actions>

=cut

__PACKAGE__->table("actions");

=head1 ACCESSORS

=head2 game_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 actor_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 target_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "game_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "actor_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "target_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</actor_id>

=item * L</target_id>

=back

=cut

__PACKAGE__->set_primary_key("actor_id", "target_id");

=head1 RELATIONS

=head2 actor

Type: belongs_to

Related object: L<Mafia::Schema::Result::Player>

=cut

__PACKAGE__->belongs_to(
  "actor",
  "Mafia::Schema::Result::Player",
  { id => "actor_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
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

=head2 target

Type: belongs_to

Related object: L<Mafia::Schema::Result::Player>

=cut

__PACKAGE__->belongs_to(
  "target",
  "Mafia::Schema::Result::Player",
  { id => "target_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-01-30 05:20:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tajHebJ28N7TZYaxuNAprQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
