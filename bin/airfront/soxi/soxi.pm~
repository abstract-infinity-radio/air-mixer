#!/usr/bin/perl -w


##############################################################################################
# soxi :: perl frontend for soxi [ Sound eXchange Information, display sound file metadata ] #
##############################################################################################

    
package soxi;

sub new {
    my $class=shift;
    my $self=bless {}, $class;
    return $self;
}#new

#sub verbosity{
#    $self->{'verbosity'}=shift;
#    return $self;
#};

sub path{
    my $self=shift;
    $self->{'path'}=shift;
    return $self;
};

sub type{
    my $self=shift;
    $ret=qx/soxi -t "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub samplerate{
    my $self=shift;
    my $ret=qx/soxi -r "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub channels{
    my $self=shift;
    my $ret=qx/soxi -c "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub samples{
    my $self=shift;
    my $ret=qx/soxi -s "$self->{'path'}"/;
    chomp $ret;
    return $ret;
    
};

sub duration{
    my $self=shift;
    my $ret=qx/soxi -d "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub duration_sec{
    my $self=shift;
    my $ret=qx/soxi -D "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub bps{
    my $self=shift;
    my $ret=qx/soxi -b "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub bitrate{
    my $self=shift;
    my $ret=qx/soxi -B "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub precision{
    my $self=shift;
    my $ret=qx/soxi -p "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub encoding{
    my $self=shift;
    my $ret=qx/soxi -e "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};

sub annotations{
    my $self=shift;
    my $ret=qx/soxi -a "$self->{'path'}"/;
    chomp $ret;
    return $ret;
};


1;
