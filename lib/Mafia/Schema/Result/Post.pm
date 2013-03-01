use utf8;
package Mafia::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Mafia::Schema::Result::Post

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

=head1 TABLE: C<posts>

=cut

__PACKAGE__->table("posts");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 thread_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 is_op

  data_type: 'bit'
  default_value: 0
  is_nullable: 1
  size: 1

=head2 class

  data_type: 'text'
  is_nullable: 1

=head2 plain

  data_type: 'text'
  is_nullable: 1

=head2 render

  data_type: 'text'
  is_nullable: 1

=head2 gamedate

  data_type: 'integer'
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
  "thread_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "is_op",
  { data_type => "bit", default_value => 0, is_nullable => 1, size => 1 },
  "class",
  { data_type => "text", is_nullable => 1 },
  "plain",
  { data_type => "text", is_nullable => 1 },
  "render",
  { data_type => "text", is_nullable => 1 },
  "gamedate",
  { data_type => "integer", is_nullable => 1 },
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

=head2 thread

Type: belongs_to

Related object: L<Mafia::Schema::Result::Thread>

=cut

__PACKAGE__->belongs_to(
  "thread",
  "Mafia::Schema::Result::Thread",
  { id => "thread_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-02-06 19:09:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iziOIlOlSJone0y/POBPVA

require Mafia::Helpers;
require Text::Markdown;
require Text::SmartyPants;

sub _markup {
  my $self = shift;
  local $_ = join "", @_;
  my @cites;

  s/</&lt;/g;
  s/^#/\\#/mg;

  $_ = Text::Markdown->new->markdown($_);
  $_ = Text::SmartyPants->process($_, 2);

  my $tokens = Text::SmartyPants::_tokenize($_);

  my $skip = 0;
  for my $token (@$tokens) {
    if($token->[0] eq 'tag') {
      if($token->[1] =~ m`<(/?)(?:pre|code|kbd|a)[\s>]`) {
        $skip += $1 eq '/' ? -1 : 1;
      }
    }
    elsif($skip == 0) {
      $token->[1] =~ s`(?<!&)#([0-9]+)\b`
        push @cites, $1;
        qq{<a class="cite" href="/post/$1">#$1</a>};
      `eg;
    }
  }

  return { html => join("", map { $_->[1] } @$tokens), cites => \@cites };
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
