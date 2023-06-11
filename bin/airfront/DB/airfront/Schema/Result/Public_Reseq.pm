use utf8;
package airfront::Schema::Result::Public_Reseq;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

airfront::Schema::Result::Public_Reseq

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<public.reseq>

=cut

__PACKAGE__->table("public.reseq");
__PACKAGE__->result_source_instance->view_definition(" SELECT reseq.airc,\n    reseq.airr\n   FROM reseq() reseq(airc, airr)");

=head1 ACCESSORS

=head2 airc

  data_type: 'bigint'
  is_nullable: 1

=head2 airr

  data_type: 'bigint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "airc",
  { data_type => "bigint", is_nullable => 1 },
  "airr",
  { data_type => "bigint", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2023-04-17 01:58:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hRsy8NKfiu61mCWWZJ86QA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
