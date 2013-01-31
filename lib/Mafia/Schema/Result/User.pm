use utf8;
package Mafia::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mafia::Schema::Result::User

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

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0
  size: 16

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 is_admin

  data_type: 'bit'
  default_value: 0
  is_nullable: 1
  size: 1

=head2 is_mod

  data_type: 'bit'
  default_value: 0
  is_nullable: 1
  size: 1

=head2 email

  data_type: 'text'
  is_nullable: 1
  size: 256

=head2 email2

  data_type: 'text'
  is_nullable: 1
  size: 256

=head2 active

  data_type: 'bit'
  default_value: 1
  is_nullable: 1
  size: 1

=head2 verified

  data_type: 'bit'
  default_value: 0
  is_nullable: 1
  size: 1

=head2 token

  data_type: 'text'
  is_nullable: 1
  size: 32

=head2 wins

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 losses

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 ties

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 games

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 last_mailed

  data_type: 'timestamp'
  is_nullable: 1

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
  "name",
  { data_type => "text", is_nullable => 0, size => 16 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "is_admin",
  { data_type => "bit", default_value => 0, is_nullable => 1, size => 1 },
  "is_mod",
  { data_type => "bit", default_value => 0, is_nullable => 1, size => 1 },
  "email",
  { data_type => "text", is_nullable => 1, size => 256 },
  "email2",
  { data_type => "text", is_nullable => 1, size => 256 },
  "active",
  { data_type => "bit", default_value => 1, is_nullable => 1, size => 1 },
  "verified",
  { data_type => "bit", default_value => 0, is_nullable => 1, size => 1 },
  "token",
  { data_type => "text", is_nullable => 1, size => 32 },
  "wins",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "losses",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "ties",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "games",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "last_mailed",
  { data_type => "timestamp", is_nullable => 1 },
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

=head1 UNIQUE CONSTRAINTS

=head2 C<email_unique>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("email_unique", ["email"]);

=head2 C<name_unique>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name_unique", ["name"]);

=head1 RELATIONS

=head2 games

Type: has_many

Related object: L<Mafia::Schema::Result::Game>

=cut

__PACKAGE__->has_many(
  "games",
  "Mafia::Schema::Result::Game",
  { "foreign.host_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 players

Type: has_many

Related object: L<Mafia::Schema::Result::Player>

=cut

__PACKAGE__->has_many(
  "players",
  "Mafia::Schema::Result::Player",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 posts

Type: has_many

Related object: L<Mafia::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "Mafia::Schema::Result::Post",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 setups

Type: has_many

Related object: L<Mafia::Schema::Result::Setup>

=cut

__PACKAGE__->has_many(
  "setups",
  "Mafia::Schema::Result::Setup",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-01-30 08:38:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Dtkbssj5vIta2j3WKlMQOQ

__PACKAGE__->add_columns(
  password => {
    passphrase       => 'rfc2307',
    passphrase_class => 'SaltedDigest',
    passphrase_args  => {
      algorithm   => 'SHA-1',
      salt_random => 20,
    },
    passphrase_check_method => 'check_password',
  },

  last_mailed => {data_type => 'timestamp', set_on_create => 1},

  created => {data_type => 'timestamp', set_on_create => 1},
  updated => {data_type => 'timestamp', set_on_create => 1, set_on_update => 1},
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
