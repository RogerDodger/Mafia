use utf8;
package Mafia::Schema::Result::Group;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mafia::Schema::Result::Group

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

=head1 TABLE: C<groups>

=cut

__PACKAGE__->table("groups");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 group_roles

Type: has_many

Related object: L<Mafia::Schema::Result::GroupRole>

=cut

__PACKAGE__->has_many(
  "group_roles",
  "Mafia::Schema::Result::GroupRole",
  { "foreign.group_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 group_setups

Type: has_many

Related object: L<Mafia::Schema::Result::GroupSetup>

=cut

__PACKAGE__->has_many(
  "group_setups",
  "Mafia::Schema::Result::GroupSetup",
  { "foreign.group_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 setups

Type: many_to_many

Composing rels: L</group_setups> -> setup

=cut

__PACKAGE__->many_to_many("setups", "group_setups", "setup");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-01-30 05:20:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JQWnKSNFc1IZD+KlOhUdUQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
