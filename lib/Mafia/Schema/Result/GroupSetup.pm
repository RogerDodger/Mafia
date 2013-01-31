use utf8;
package Mafia::Schema::Result::GroupSetup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mafia::Schema::Result::GroupSetup

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

=head1 TABLE: C<group_setup>

=cut

__PACKAGE__->table("group_setup");

=head1 ACCESSORS

=head2 group_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 setup_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "group_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "setup_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</group_id>

=item * L</setup_id>

=back

=cut

__PACKAGE__->set_primary_key("group_id", "setup_id");

=head1 RELATIONS

=head2 group

Type: belongs_to

Related object: L<Mafia::Schema::Result::Group>

=cut

__PACKAGE__->belongs_to(
  "group",
  "Mafia::Schema::Result::Group",
  { id => "group_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 setup

Type: belongs_to

Related object: L<Mafia::Schema::Result::Setup>

=cut

__PACKAGE__->belongs_to(
  "setup",
  "Mafia::Schema::Result::Setup",
  { id => "setup_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-01-30 08:38:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s7VwoksoB5/7+3RXe2va+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
