#!/usr/bin/perl -w

package airfrontui;

use strict;

use warnings;
#use diagnostics;
#use feature ':5.14';

use Term::ReadLine;
use Term::ANSIColor (qw/:constants/);
use utf8;
use feature qw/say/;
use Data::Dumper;

use Glib ('TRUE','FALSE');
use Gtk3 -init;

###########################
# airfront user interface #
# (B-AIR project) EU CE   #
###########################

#LIST OF *INPUT* FIELDS. ALL INPUT METHODS WILL ADAPT TO THIS.
my @INF=(
    {'key'=>'title',label=>'Project Title'},
    {'key'=>'authors',label=>'Author(s)'},
    {'key'=>'performers',label=>'Performer(s)'},
    {'key'=>'date',label=>'Date of Recording [dd.mm.yyyy]'},
    );


##########

sub new{
    my $class=shift;
    my $afdb=shift; #airfront db 
    return (bless {'afdb'=>$afdb,'cardsel'=>"",'card'=>{}},$class);
};
#cardsel hashref = dbix class 'search' selector


sub input_gtk3{
    my $self=shift;

    my $window = Gtk3::Window->new('toplevel');    
    $window->set_title ('AIR INSERTION CARD :: '.'AIRC.'.$self->{'nextcn'});
    $window->set_default_size (500,500);
#close win icon

    $window->set_border_width(5);
    $window->set_position('GTK_WIN_POS_MOUSE');

    my $windowR = Gtk3::Window->new('toplevel');    #recordings window
    $windowR->set_title ('AIRFRONT :: RECORDINGS FOUND :: '.'AIRC.'.$self->{'nextcn'});
    $windowR->set_default_size (1000,1200);
#close win icon
    $windowR->signal_connect('delete_event' => sub {$windowR->destroy; $window->destroy; Gtk3->main_quit;});
    $window->signal_connect('delete_event' => sub {$window->destroy; $windowR->destroy; Gtk3->main_quit;});
    $windowR->set_border_width(5);
    $windowR->move(0,0);
    
    my $scrolled_window = Gtk3::ScrolledWindow->new();
    $scrolled_window->set_border_width(5);
    $scrolled_window->set_policy( "automatic", "automatic" ); 
    $scrolled_window->set_max_content_height(1200);
    $scrolled_window->set_max_content_height(1000);
    
    my $grid = Gtk3::Grid->new();
    $grid->set_row_spacing(7);
    $grid->set_column_spacing(20);

    my $airlogo = Gtk3::Image->new();
    $airlogo->set_from_file('/home/gregor/audio/pd-projects/work/wavedata/air/airfront/logo/airlogo.png');

#    say "SOURCE: ",$self->{'source'};
#    say "NEXTCN: ",$self->{'nextcn'};
    
    my $Lsource=Gtk3::Label->new();
    $Lsource->set_text("LOCAL SOURCE DIRECTORY:\n".$self->{'source'});
    $Lsource->set_alignment(0.0,0.5);
    $grid->attach($Lsource,5,-1,24,1);

    my $Lhome=Gtk3::Label->new();
    $Lhome->set_text("REMOTE HOME DIRECTORY:\n".$self->{'remotehost'}.":".$self->{'remotehome'});
    $Lhome->set_alignment(0.0,0.5);
    $grid->attach($Lhome,5,0,24,1);

    my $Lairc=Gtk3::Label->new();
    $Lairc->set_markup("CARD NUMBER: <b>AIRC.".$self->{'nextcn'}."</b>");
    $Lairc->set_alignment(0.0,0.5);
    $grid->attach($Lairc,5,1,24,1);
   
    
    my $L=2; #line number1;    
    for(@INF){

	$_->{'_entry'}=Gtk3::Entry->new();
	#NOTE: THE THIRD signal_connect ARG IS user defined, and will be passed as $_[2] to the callback sub.
	$_->{'_entry'}->signal_connect('focus-out-event',sub{$_[2][1]->{'card'}{$_[2][0]->{'key'}} = $_[0]->get_text();},[$_,$self]);
#	$_->{'_entry'}->set_text('foo_'.$L); 
	$_->{'_entry'}->set_placeholder_text($_->{'label'});

	
#	$_->{'_label'} = Gtk3::Label->new();
#	$_->{'_label'}->set_text($_->{'label'});
#	$_->{'_label'}->set_alignment(0.0,0.5);

#	$grid->attach($_->{'_label'},0,$L,4,1);
	$grid->attach($_->{'_entry'},5,$L,24,1);
	$grid->attach($airlogo,32,-2,6,6); #airlogo: 200x200 png
	
 	$L++;
    };

#
    
#    print "INF ",Dumper (@INF);


    
    #LIST OF RECORDING TO BE FLUSHED

    my $R=0;
    my $gridR = Gtk3::Grid->new();
    $gridR->set_row_spacing(4);
    $gridR->set_column_spacing(20);

    my $Lrh=Gtk3::Label->new();
    $Lrh->set_markup("<b>".$self->{'source'}."</b>");
    $gridR->attach($Lrh,5,$R++,24,1);
    
    for (sort @{$self->{'audio'}}){
	$R++; #$L still alive here 
	my $Lrec=Gtk3::Label->new;
	$Lrec->set_text($_->{'path'}." | ".$_->{'duration'}." | ".($_->{'channels'} eq 2 ? "STEREO" : "MONO")." | ".$_->{'samplerate'}." - ".$_->{'bitrate'}." - "."ENC ".$_->{'encoding'});
	$Lrec->set_alignment(0.0,0.5);
	$gridR->attach($Lrec,5,$R,24,1);
    }
	
    
    #SUBMIT buton
    my $button=Gtk3::Button->new();
    $button->set_label("SUBMIT");
    $button->set_can_focus(TRUE); #take over focus from the last entry
    $button->signal_connect('clicked' => sub{$window->destroy; $windowR->destroy; Gtk3->main_quit; $self->{'submitted'}=1;});
    # NOTE Gtk3->main_quit HERE!
    $L++;
    $grid -> attach ($button, 5, $L, 8, 1);
    $button->grab_focus;

    my $cancel=Gtk3::Button->new();
    $cancel->set_label("ABORT");
#    $cancel->set_can_focus(TRUE); #take over focus from the last entry
    $cancel->signal_connect('clicked' => sub {$window->destroy; $windowR->destroy; $self->{'submitted'}=0; Gtk3->main_quit;});

    $grid -> attach ($cancel, 14, $L, 15, 1);
    $scrolled_window->add($gridR);
    $windowR -> add($scrolled_window);

    $window -> add($grid);

    $windowR->show_all();
    $window->show_all();

    Gtk3->main();

}#input_gtk3


sub card{
    my $self = shift;
    return $self->{'card'};
};

sub self{
    my $self = shift;
    return $self;
};

sub cardsel{
    my $self = shift;
    my $arg = shift;
    
    if ($arg) { $self->{'cardsel'}=$arg} else { return $self->{'cardsel'} };
};

sub source{
    my $self = shift;
    my $arg = shift;
    
    if ($arg) { $self->{'source'}=$arg} else { return $self->{'source'} };
};

sub audio{
    my $self = shift;
    my $arg = shift;
    
    if ($arg) { $self->{'audio'}=$arg} else { return $self->{'audio'} };
};

#whether the user's ui confirmed calling submitted (=called submit at input card)
sub submitted{
    my $self = shift;
    my $arg = shift;
    
    if ($arg) { $self->{'submitted'}=$arg} else { return $self->{'submitted'} };
};


sub nextcn{
    my $self = shift;
    my $arg = shift;
    
    if ($arg) { $self->{'nextcn'}=$arg} else { return $self->{'nextcn'} };
};

sub airc{
    my $self = shift;
    
    if ($self->{'nextcn'}){return "AIRC.".$self->{'nextcn'} };
};





sub remotehome{
    my $self = shift;
    my $arg = shift;
    
    if ($arg) { $self->{'remotehome'}=$arg} else { return $self->{'remotehome'} };
};

sub remotehost{
    my $self = shift;
    my $arg = shift;
    
    if ($arg) { $self->{'remotehost'}=$arg} else { return $self->{'remotehost'} };
};




#-----------------4

#TERMINAL INPUT
sub input_readline{

}


#BROWSER
sub list_gtk3{
    my $self=shift;
    my $cardno=shift;
    
    my $window = Gtk3::Window->new('toplevel');
    $window->set_title ('AIR LISTING');
    $window->set_default_size (500, 800);
    #close win icon
    $window->signal_connect('delete_event' => sub {$window->destroy; Gtk3->main_quit;});

    ###
    my @columns = map {$_->{'key'}} @INF;
    push @columns,'ts';
  #  print Dumper(\@columns);
    my @selection;

    # cook the real selector
  #  print "CARDSEL ",Dumper ($self->cardsel);
    my $h;
    if ($self->cardsel){
	if ($self->cardsel =~ m/^:(\d+)/ ){$h={'airc' => $1}}
	elsif ($self->cardsel =~ m/^\@(.*)/){$h={'date' => $1}}
	elsif ($self->cardsel){$h={'title' => {-ilike => "%".$self->cardsel."%"}}};
    };
  #  print "H ",Dumper ($h);

 #   print "AFDB ",ref $self->{'afdb'};
    
    #a fast solution, should be modelled after @columns
    my $store = Gtk3::TreeStore->new('Glib::String');
    
    for my $r ($self->{'afdb'}->resultset('Public_Card')->search($h,{order_by => { -asc => 'airc' }})->all) {
	my $iter = $store->append();
	$store->set($iter, 0 => "[".$r->airc."] ".$r->title);
	
	for my $c ($self->{'afdb'}->source('Public_Card')->columns,'recordings'){
	    unless ($c eq 'title' or $c eq 'ts'){ #exclude header and timestamp
		my $iter_child = $store->append($iter);
		if ($c eq 'airc'){$store->set($iter_child, 0 => 'AIRC_'.$r->$c)}elsif($c eq 'recordings'){$store->set($iter_child, 0 => "number of recordings: ".$r->recordings->count)}else{$store->set($iter_child, 0 => $c.": ".$r->$c)}
	    }#unless;
	};#columns
    };
    
    ####
    my $view = Gtk3::TreeView->new();
    $view->set_model($store);

    # the cellrenderer for the column - text
    my $renderer_books = Gtk3::CellRendererText->new();
    # the column is created
    my $column_books = Gtk3::TreeViewColumn->new_with_attributes('AIRFRONT FOLDERS', $renderer_books, 'text'=>0);
    # and it is appended to the treeview
    $view->append_column($column_books);
    
    # the books are sortable by authors
    $column_books->set_sort_column_id(0);

    

    $window->add($view);

    $window->show_all;
    Gtk3->main();

};#list_gtk3


sub progressbar_gtk3{

    my $self=shift;

    say "PROGRESSBAR CALLED";
    
    my $window = Gtk3::Window->new('toplevel');
    $window->set_title("RSYNCING....");
    $window->set_position("mouse");
    $window->set_default_size(250, 100);
    $window->set_border_width(5);
    $window->signal_connect (delete_event => sub { Gtk3->main_quit });

    my $vbox = Gtk3::Box->new("vertical", 5);
    $window->add($vbox);
    my $progress = Gtk3::ProgressBar->new;
    $progress->set_orientation("horizontal");
    $progress->set_inverted(FALSE);
    $progress->set_text(undef);
    $progress->set_show_text(FALSE); #PERCENTAGE

    $vbox->add($progress);

        
my $hbox = Gtk3::Box->new("horizontal", 2);
$vbox->add($hbox);
my $increment = 0.001;
my $timer = Glib::Timeout->add (100, \&update);

$window->show_all;
Gtk3->main;

sub update {
	if ( $progress->get_fraction >= 1 ) {
		$increment = -0.001;
	}
	if ( $progress->get_fraction <= 0 ) {
		$increment = 0.001;
	}
	$progress->set_fraction( $progress->get_fraction + $increment );
	return TRUE;
}


    
};





sub donedialog_gtk3{
    my $self=shift;

    say "DONEDIALOG CALLED";

    Gtk3->main_quit;
};


sub yesnodialog{
    my $self = shift;
    my $num=shift;
    
    my $window = Gtk3::Window->new('toplevel');
    $window->set_title ('REALLY REVERT THE DB TO FREE THE LISTED AIRC ENTRIES '.$num.' AND ABOVE?');
    $window->set_default_size(250,100);
    $window->signal_connect('delete_event' => sub {Gtk3->main_quit()});

    my $grid = Gtk3::Grid->new();
    $grid->set_row_spacing(7);
    $grid->set_column_spacing(20);

    
    # a button on the parent window
    my $buttonY = Gtk3::Button->new('YES');
    # connect the signal 'clicked' of the button with the function
    # on_button_click()
    $buttonY->signal_connect('clicked', \&on_button_YES);
    # add the button to the window

    $grid->attach($buttonY,0,1,40,1);

    
    # a button on the parent window
    my $buttonN = Gtk3::Button->new('NO');
    # connect the signal 'clicked' of the button with the function
    # on_button_click()
    $buttonN->signal_connect('clicked', \&on_button_NO);
    # add the button to the window
    $grid->attach($buttonN,0,0,40,1);

    $window->add($grid);
    
    
    # show the window and run the Application
    $window -> show_all();
    Gtk3->main();
    
    # callback function for the signal 'clicked' of the button in the parent 
    # window
    
    sub on_button_YES{
	$window->destroy;
	Gtk3->main_quit;
	$self->{'yesnoval'}=1;
    };
    
    sub on_button_NO{
	$window->destroy;
	Gtk3->main_quit;
	$self->{'yesnoval'}=0;
    };
    
    return $self->{'yesnoval'};
    
};#yesnodialog

#----------------

#accessors for all data gathered
sub AUTOLOAD {
    my $self=shift;
    our $AUTOLOAD;              # keep 'use strict' happy
    my $method = $AUTOLOAD;
    $method =~ s/.*:://;
    $self->{'submitted'}=0; #undef submitted with EACH CALL to enable to be set from within = signalizes the caller that submission should be done
    unless ($method eq 'DESTROY'){
	if (exists $self->{'card'}{$method}){return $self->{'card'}{$method}};
	if (exists $self->{$method}){return $self->{$method}};
    };
    return $self;
};

sub DESTROY {
    my $self=shift;
    undef $self;
};






1;



# Useful methods for Entry widget
# In line 12 the signal 'activate' is connected to the callback function cb_activate() using $widget‑>signal_connect("signal", \&callback function). See Signale und Callbacks for a more detailed explanation. Some of the signals that a Gtk3::Entry widget can emit are: 'activate' (emitted when the user activates the Entry key); 'backspace' (emitted when the user activates the Backspace or Shift-Backspace keys); 'copy-clipboard' (Ctrl-c and Ctrl-Insert); 'paste-clipboard' (Ctrl-v and Shift-Insert); 'delete-from-cursor' (Delete, for deleting a character; Ctrl-Delete, for deleting a word); 'icon-press' (emitted when the user clicks an activatable icon); 'icon-release' (emitted on the button release from a mouse click over an activatable icon); 'insert-at-cursor' (emitted when the user initiates the insertion of a fixed string at the cursor); 'move-cursor' (emitted when the user initiates a cursor movement); 'populate-popup' (emitted before showing the context menu of the entry; it can be used to add items to it).
#     • get_buffer() and set_buffer($buffer), where $buffer is a Gtk3::EntryBuffer object, can be used to get and set the buffer for the entry.
#     • get_text() and set_text('some text') can be used to get and set the content for the entry.
#     • get_text_length() is self-explanatory.
#     • get_text_area() gets the area where the entry's text is drawn.
#     • If we set set_visibility(FALSE) the characters in the entry are displayed as the invisible char. This is the best available invisible character in the current font, but it can be changed with set_invisible_char(ch), where ch is a Unicode charcater. The latter method is reversed by unset_invisbile_char().
#     • set_max_length(int), where int is an integer, truncates every entry longer than int to have the desired maximum length.
#     • By default, if you press the Entry key the Gtk3::Entry emits the signal 'activate'. If you would like to activate the default widget for the window (set using set_default($widget) on the window), then use set_activates_default(TRUE).
#     • To set a frame around the entry: set_has_frame(TRUE).
#     • set_placeholder_text('some text') sets the text to be displayed in the entry when it is empty and unfocused.
#     • set_overwrite_mode(TRUE) and set_overwrite_mode(FALSE) are self-explanatory.
#     • If we have set_editable(FALSE) the user cannot edit the text in the widget.
#     • set_completion($completion), where $completion is a Gtk3::EntryCompletion, sets completion - or disables it if $completion is 'None'.
#     • An Entry widget can display progress or activity information behind the text. We use set_progress_fraction(fraction), where fraction is a float between 0.0 and 1.0 inclusive, to fill in the given fraction of the bar. We use set_progress_pulse_step() to set the fraction of total entry width to move the progress bouncing block for each call to progress_pulse(). The latter method indicates that some progress is made, and causes the progress indicator of the entry to enter 'activity mode', where a block bounces back and forth. Each call to progress_pulse() causes the block to move by a little bit (the amount of movement per pulse is determined, as said before, by set_progress_pulse_step()).
#     • An Entry widget can also show icons. These icons can be activatable by clicking, can be set up as drag source and can have tooltips. 
#       To add an icon, you can use set_icon_from_stock(icon_position, stock_id), or one of set_icon_from_pixbuf(icon_position, pixbuf), set_icon_from_icon_name(icon_position, icon_name), where icon_position is one of "primary"1 (to set the icon at the beginning of the entry) "secondary"2 (to set the icon at the end of the entry). To set a tooltip on an icon, use set_icon_tooltip_text('tooltip text') or set_icon_tooltip_markup('tooltip text in Pango markup language').



#------------------
    # $T1->set_visibility(FALSE); #password-type entry
    # my $completion=Gtk3::EntryCompletion->new();
    # $T1->set_completion($completion);
#    $T1->set_placeholder_text('Project name');
#    $T2->set_placeholder_text('Authors');
#    $T3->set_placeholder_text('Performers');
#    $T4->set_placeholder_text('Recording Date');


#    my $T1 = Gtk3::Entry->new();
#    my $T2 = Gtk3::Entry->new();
#    my $T3 = Gtk3::Entry->new();
#    my $T4 = Gtk3::Entry->new();

    #->set_text('...');
    #
#    $T1->signal_connect('focus-out-event', sub{$IDT->{'name'} = $_[0]->get_text();});        
#    $T2->signal_connect('focus-out-event', sub{$IDT->{'authors'} = $_[0]->get_text();});
#    $T3->signal_connect('focus-out-event', sub{$IDT->{'performers'} = $_[0]->get_text();});
#    $T4->signal_connect('focus-out-event', sub{$IDT->{'date'} = $_[0]->get_text();});
    
    # my $L1 = Gtk3::Label->new();
    # $L1->set_text('Project name');
    # $L1->set_alignment(0.0,0.5);
    # my $L2 = Gtk3::Label->new();
    # $L2->set_text('Authors');
    # $L2->set_alignment(0.0,0.5);
    # my $L3 = Gtk3::Label->new();
    # $L3->set_text('Performers');
    # $L3->set_alignment(0.0,0.5);
    # my $L4= Gtk3::Label->new();
    # $L4->set_text('Recording date');
    # $L4->set_alignment(0.0,0.5);
