use utf8;
package airfront::Schema::Result::Public_Card;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

airfront::Schema::Result::Public_Card

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<public.card>

=cut

__PACKAGE__->table("public.card");

=head1 ACCESSORS

=head2 airc

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'airfront_card_airc_seq'

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 authors

  data_type: 'text'
  is_nullable: 1

=head2 performers

  data_type: 'text'
  is_nullable: 1

=head2 date

  data_type: 'date'
  is_nullable: 1

=head2 ts

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "airc",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "airfront_card_airc_seq",
  },
  "title",
  { data_type => "text", is_nullable => 1 },
  "authors",
  { data_type => "text", is_nullable => 1 },
  "performers",
  { data_type => "text", is_nullable => 1 },
  "date",
  { data_type => "date", is_nullable => 1 },
  "ts",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</airc>

=back

=cut

__PACKAGE__->set_primary_key("airc");

=head1 RELATIONS

=head2 recordings

Type: has_many

Related object: L<airfront::Schema::Result::Public_Recording>

=cut

__PACKAGE__->has_many(
  "recordings",
  "airfront::Schema::Result::Public_Recording",
  { "foreign.airc" => "self.airc" },
  { cascade_copy => 1, cascade_delete => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2023-04-17 01:58:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ecTHjZzlQ1gX0sDP3JuJug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
