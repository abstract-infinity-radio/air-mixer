#!/usr/bin/perl -w


############################################
# adsox :: adhoc sox interface             #
# Gregor Pirs 2023 B-AIR / AIR EU CE       #
############################################

=pod

=encoding utf8

=head1 SYNOPSIS

B<adsox> :: simple perl interface for sox 
[ SoX - Sound eXchange, the Swiss Army knife of audio manipulation ]

=head2 USAGE

$S=adsox->B<new>;
$S->B<infile>(...)->B<outfile>(...)->[someoption][someparam]->[anotheroption][anotherparam]->B<execute>;

=head2 DEDICATED METHODS

=over

=item new 

object creator

=item infile

declare infile, this will persist until redefined

=item outfile

declare outfile, this will persist until redefined 

=item add

declare non-opt postamble, such as effect (which are barewords), for instance ->('gain', -1) means sox if of gain -1

=item execute 

execute the whole thing, clear options declaration, but keep infile and outfile declaration. 

=item debug (1/0)

turn debug messages on / off

=back

=head2 EXAMPLE

my $S=adsox->new;
$S->debug(1)->infile("/my/infile.wav")->outfile("/my/infile_converted.wav")->r(48000)->c(2)->b(16)->execute;
$S->debug(0)->outfile("/my/monofile.wav")->c(1)->execute;

convert infile to 48k 16bit stereo outfile with debugging output enabled

then convert the same original file by only changing stereo to mono without debugging output 

=head2 AUTHOR

Gregor Pirs 2023 gregor.pirs@guest.arnes.si

=cut

package adsox;

use feature qw/say/;
use vars '$AUTOLOAD';


my $SOXCMD="/usr/bin/sox -q";

sub new {
    my $class=shift;
    my $self=bless {'param' => { 'debug' => 0 }}, $class;
    return $self;
}#new

sub infile{
    my $self=shift;
#    $self->{'param'}{'infile'}=shift;
    $self->{'param'}{'infile'}="$_[0]";
    return $self;
};

sub outfile{
    my $self=shift;
    $self->{'param'}{'outfile'}=shift;
    return $self;
};

#adder of direct calls (non-opts, such as "gain")
sub add{
    my $self=shift;
    
    $self->{'param'}{'debug'} and say "add CALLED";
    $self->{'param'}{'postoptions'}.=" ".join(" ",@_);	
    $self->{'param'}{'debug'} and say "POSTOPTIONS: ",$self->{'param'}{'postoptions'};
    return $self;
};


#==== executer

sub execute{
    my $self=shift;
    my $a=($self->{'param'}{'infile'} or "");
    my $b=($self->{'param'}{'options'} or "");
    my $c=($self->{'param'}{'outfile'} or "");
    my $d=($self->{'param'}{'postoptions'} or "");

    my $ret=qx/$SOXCMD "$a" $b $c $d 2>&1/; #stderr to stdout #ALSO

#   say "SOX EXECUTE CALLED: ".$SOXCMD." ".$a." ".$b." ".$c;
#   say "SOX EXECUTE STDERR: ",$ret;
#   say "====================";
    
    $self->{'param'}{'options'}=undef; # BUT (!) KEEP INFILE AND OUTFILE
    $self->{'param'}{'postoptions'}=undef; # BUT (!) KEEP INFILE AND OUTFILE

    
    return ( $ret eq "" ? 1 : 0 );
};# *EOC*

sub debug{
    my $self=shift;
    my $param=shift;

    if (defined $param) {$self->{'param'}{'debug'}=$param};
    return $self;
};

sub AUTOLOAD {
    my $self=shift;
    our $AUTOLOAD;              # keep 'use strict' happy
    my $method = $AUTOLOAD;
    $method =~ s/.*:://;
    my (@ARGS)=@_;
    $self->{'param'}{'debug'} and say "AUTOLOAD CALLED: ",$method;
    $self->{'param'}{'debug'} and say @ARGS; 
    unless ($method eq 'DESTROY'){
	$self->{'param'}{'options'}.=" -".$method." ".join(" ",@ARGS);	
	$self->{'param'}{'debug'} and say "OPTIONS: ",$self->{'param'}{'options'};
    };
    return $self;
};#AUTO

sub DESTROY {
    my $self=shift;
    undef $self;
};


1;
