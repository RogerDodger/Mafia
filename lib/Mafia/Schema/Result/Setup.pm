use utf8;
package Mafia::Schema::Result::Setup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mafia::Schema::Result::Setup

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

=head1 TABLE: C<setups>

=cut

__PACKAGE__->table("setups");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1
  size: 64

=head2 final

  data_type: 'bit'
  default_value: 0
  is_nullable: 1
  size: 1

=head2 private

  data_type: 'bit'
  default_value: 1
  is_nullable: 1
  size: 1

=head2 created

  data_type: 'timestamp'
  is_nullable: 1

=head2 updated

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1, size => 64 },
  "final",
  { data_type => "bit", default_value => 0, is_nullable => 1, size => 1 },
  "private",
  { data_type => "bit", default_value => 1, is_nullable => 1, size => 1 },
  "created",
  { data_type => "timestamp", is_nullable => 1 },
  "updated",
  { data_type => "timestamp", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 games

Type: has_many

Related object: L<Mafia::Schema::Result::Game>

=cut

__PACKAGE__->has_many(
  "games",
  "Mafia::Schema::Result::Game",
  { "foreign.setup_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 group_setups

Type: has_many

Related object: L<Mafia::Schema::Result::GroupSetup>

=cut

__PACKAGE__->has_many(
  "group_setups",
  "Mafia::Schema::Result::GroupSetup",
  { "foreign.setup_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
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

=head2 groups

Type: many_to_many

Composing rels: L</group_setups> -> group

=cut

__PACKAGE__->many_to_many("groups", "group_setups", "group");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-01-30 08:38:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:471doKhRn3svpV5OgxTgZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
