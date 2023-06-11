#!/usr/bin/perl -w

use IO::Socket::UNIX;
use IO::Handle::Record;
 
($p, $c)=IO::Socket::UNIX->socketpair( AF_UNIX,
                                       SOCK_STREAM,
                                       PF_UNSPEC );
while( !defined( $pid=fork ) ) {sleep 1}
 
if( $pid ) {
  close $c; undef $c;
 
  $p->fds_to_send=[\*STDIN, \*STDOUT];
  $p->record_opts={send_CODE=>1};
  $p->write_record( {a=>'b', c=>'d'},
                    sub { $_[0]+$_[1] },
                    [qw/this is a test/] );
} else {
  close $p; undef $p;
 
  $c->record_opts={receive_CODE=>sub {eval $_[0]}};
 ($hashref, $coderef, $arrayref)=$c->read_record;
  readline $c->received_fds->[0];       # reads from the parent's STDIN
}
