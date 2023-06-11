#    #FORK 
# if(!defined($pid = fork())) {
#    # fork returned undef, so unsuccessful
#    die "Cannot fork a child: $!";
# } elsif ($pid == 0) {
#    print "Printed by child process\n";
#    system 'rsync --info=progress2 --stats /home/gregor/audio/pd-projects/work/wavedata/air/recorded/* gregor@morrigan:/home/gregor/foo/';
   
#  #  exec("date") || die "can't exec date: $!";
# } else {
#    # fork returned 0 nor undef
#    # so this branch is parent
#    print "Printed by parent process\n";
# #   $ret = waitpid($pid, 0);
#    # rsync --info=progress2
#    # progress2 writes to stdout
   
#    my $AFUI=airfrontui->new($AFDB);
#    $AFUI->progressbar_gtk3;

#    print "Completed process id: $ret\n";
# }#else

    ########## fork with pipe

#    my $cmd    = 'rsync --info=progress2 --stats /home/gregor/audio/pd-projects/work/wavedata/air/recorded/* gregor@morrigan:/home/gregor/foo/';
$my $cmd    = "/usr/bin/who -a" ;  


# $|=1;
 #
 # Create a pipe with the system call
 #
 #$smoke = pipe(PIPE_R, PIPE_W);
 #
 # Fork off (almost) immediately.
 #
# if ($pid = fork) {
#     printf "\n Parent:";
#     close PIPE_R;          # <-- the handle you do not need.
#     #
#     # now write to the child.
#     #
#     select PIPE_W;
#     for ($i=0;$i<5;$i++) {
#        sleep 1;
#        printf PIPE_W "[Sending: %d]\n", $i;
#        }
#     }
#     else
#     {
#     printf "\n Child:";
#     close PIPE_W;   # <- won't be writing to it.
#     #
#     # now read from parent
#     #
#     for ($i=0;$i<5;$i++) {
#         $buf = <PIPE_R>;
#         # For fixed length records you would use:
#          read PIPE_R,$buf,20;
#         print "Child: Received $buf \n";
#         }
#     }   

# pipe(PARENTREAD, PARENTWRITE);
# pipe(CHILDREAD, CHILDWRITE);

# PARENTWRITE->autoflush(1);
# CHILDWRITE->autoflush(1);
#     STDOUT->autoflush(1);
    
# if ($child = fork) { # Parent code
#    close CHILDREAD; # We don't need these in the parent
#    close PARENTWRITE;
#    print CHILDWRITE "34+56;\n";
#    chomp($result = <PARENTREAD>);
#    print "Got a value of $result from child\n";
#    close PARENTREAD;
#    close CHILDWRITE;
#    waitpid($child,0);
# } else {
#    close PARENTREAD; # We don't need these in the child
#    close CHILDWRITE;
#    chomp($calculation = <CHILDREAD>);
#    print "Got $calculation\n";
#    $result = eval "$calculation";
# #   print PARENTWRITE "$result\n";

#    close( STDOUT );
#    close( STDERR );
#    *STDOUT = *WRITER ;
#    *STDERR = *WRITER ;
#    system 'ls';   
#    close CHILDREAD;
#    close PARENTWRITE;
#    exit;
# }

#pipe test1    
# pipe( READER, WRITER ) ;
# my $child = fork() ;
# if ( $child ) {
#     print "I am the parent: My pid = $$ junior = $child\n" ;
#     close( WRITER ) ;

#     while (<READER>){
# 	print $_;
# 	#	my @output = <READER> ;
# 	print "MOO: ",@output ;
#     };
#     print "parent is DONE\n" ;
# } else {
#     print "I am the child. My pid = $$\n" ;

#     close( READER ) ;
#     close( STDOUT );
#     close( STDERR );
#     *STDOUT = *WRITER ;
#     *STDERR = *WRITER ;

   
#     # system('rsync' => (
#     # 	       '--info'=>'progress2',
#     # 	       '--stats'=>1,
#     # 	       "/home/gregor/audio/pd-projects/work/wavedata/air/recorded/*",
#     # 	       'gregor@morrigan:/home/gregor/foo/',
#     # 	       "1>*WRITER"
#     # 	       )) or exit(1);

    
#     #    print WRITER "XXX ouput before exec....\n" ;
#     print "XXX ouput before exec....\n" ;
#     say "MAMA";
#     print "JOO",Dumper('tata');

#     system($cmd) or exit(1) ;
#     $|=1;
# }

