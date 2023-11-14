#!/usr/bin/perl -w


#########################################################################################################
# Load a data-structure from puredata processed yaml file => CORE MODULE    		                #
# Due to puredata text processing limitations, spaces are encoded as \# so they are to be regained here #
#########################################################################################################

#2023 Gregor Pirš, B-AIR Project EU CE

use YAML ();
use Data::Dumper;

use feature qw/say/;

package pd2yml;

sub load{
    use File::Slurp;
    my $file_content = read_file(shift);
    $file_content =~ s/\#/ /g;
    return YAML::Load($file_content);
};

sub dump{
    use File::Slurp;
    my $file_content=YAML::Dump(shift);
    my $path=shift;
#    $file_content =~ s/\s/\#/g;
    write_file($path,$file_content);
    return 1;
};


1;
