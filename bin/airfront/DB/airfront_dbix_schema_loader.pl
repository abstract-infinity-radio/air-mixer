#!/usr/bin/perl -w
use File::Path qw /remove_tree/;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;

remove_tree ("./airfront");

#dbicdump -o ...

make_schema_at(
	       'airfront::Schema',
	       { 
#		   rescan => '%',
		   debug => 1,
		   dump_directory => '.',
# might_have = unique _to_ unique 
# has_many = unique _to_ non_unique
# both have to cascade since we have afid_node that mounts swallow_list and arsfile via might_have, and arsfile parts that are connected via has_many
		   db_schema => '%',
		   moniker_parts  => ['schema', 'name'],
		   moniker_part_separator => '_',
		   relationship_attrs => {
					has_many   => { cascade_delete => 1, cascade_copy => 1 },
					might_have => { cascade_delete => 1, cascade_copy => 1 },
				       },
	       },
	       [ 'dbi:Pg:dbname="airfront"', 'gregor', 'hvala'  ],
	      );

#rebuild the airfront manpages:
#system ('./rebuild-man');


# These are the default attributes:

# has_many => {
#     cascade_delete => 0,
#     cascade_copy   => 0,
# },
# might_have => {
#     cascade_delete => 0,
#     cascade_copy   => 0,
# },
# belongs_to => {
#     on_delete => 'CASCADE',
#     on_update => 'CASCADE',
#     is_deferrable => 1,
# },
