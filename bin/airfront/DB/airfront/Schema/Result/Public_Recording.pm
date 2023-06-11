use utf8;
package airfront::Schema::Result::Public_Recording;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

airfront::Schema::Result::Public_Recording

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<public.recording>

=cut

__PACKAGE__->table("public.recording");

=head1 ACCESSORS

=head2 airc

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 airr

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'airfront_recording_airr_seq'

=head2 host

  data_type: 'text'
  is_nullable: 1

=head2 path

  data_type: 'text'
  is_nullable: 1

=head2 channels

  data_type: 'integer'
  is_nullable: 1

=head2 samplerate

  data_type: 'integer'
  is_nullable: 1

=head2 duration

  data_type: 'time'
  is_nullable: 1

=head2 duration_ms

  data_type: 'double precision'
  is_nullable: 1

=head2 bitrate

  data_type: 'integer'
  is_nullable: 1

=head2 encoding

  data_type: 'text'
  is_nullable: 1

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 ts

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "airc",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "airr",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "airfront_recording_airr_seq",
  },
  "host",
  { data_type => "text", is_nullable => 1 },
  "path",
  { data_type => "text", is_nullable => 1 },
  "channels",
  { data_type => "integer", is_nullable => 1 },
  "samplerate",
  { data_type => "integer", is_nullable => 1 },
  "duration",
  { data_type => "time", is_nullable => 1 },
  "duration_ms",
  { data_type => "double precision", is_nullable => 1 },
  "bitrate",
  { data_type => "integer", is_nullable => 1 },
  "encoding",
  { data_type => "text", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "ts",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</airr>

=back

=cut

__PACKAGE__->set_primary_key("airr");

=head1 RELATIONS

=head2 airc

Type: belongs_to

Related object: L<airfront::Schema::Result::Public_Card>

=cut

__PACKAGE__->belongs_to(
  "airc",
  "airfront::Schema::Result::Public_Card",
  { airc => "airc" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 source

Type: might_have

Related object: L<airfront::Schema::Result::Public_Source>

=cut

__PACKAGE__->might_have(
  "source",
  "airfront::Schema::Result::Public_Source",
  { "foreign.airr" => "self.airr" },
  { cascade_copy => 1, cascade_delete => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2023-04-17 01:58:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FqiJWtQpxvo2f8LA3b5cYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
