#!/usr/bin/perl

# Make a binding to the Gio API in the Perl program (just copy&paste ;-))
# This is necessary mainly for Gtk3::Application
# Alternatively you find an early implementation as a Perl module
# on https://git.gnome.org/browse/perl-Glib-IO (not yet published on CPAN!)
# Hopefully this module simplifies the use of the Gio API in the future
# (see also the notes above).
BEGIN {
  use Glib::Object::Introspection;
  Glib::Object::Introspection->setup(
    basename => 'Gio',
    version => '2.0',
    package => 'Glib::IO');
}

use strict;
use warnings;
use utf8; #needed for gtk3 !!


use Gtk3;
use Glib qw/TRUE FALSE/;

use feature qw/say/;

# The MAIN FUNCTION should be as small as possible and do almost nothing except creating 
# your Gtk3::Application and running it
# The "real work" should always be done in response to the signals fired by Gtk3::Application.
# see below
my $app = Gtk3::Application->new('app.test', 'flags-none');
 
$app->signal_connect('startup'  => \&_init     );
$app->signal_connect('activate' => \&_build_ui );
$app->signal_connect('shutdown' => \&_cleanup  );
 
$app->run(\@ARGV);
 
exit;
 

#################################
# The CALLBACK FUNCTIONS to the SIGNALS fired by the main function.
# Here we do the "real work" (see above)
sub _init {
	my ($app) = @_;
 
	# Handle program initialization
     	say "_init";
 
 }


################
sub _build_ui {
 
     	my ($app) = @_;
 
     	my $window = Gtk3::ApplicationWindow->new($app);
     	$window->set_title ('DROWENSCHIELD');
     	$window->set_default_size (200, 200);
     	$window->signal_connect( 'delete_event' => sub {$app->quit()} );

	# create an image
#	my $image = Gtk3::Image->new();
	
	# set the content of the image as the file filename.png
#	$image->set_from_file('/home/gregor/Pictures/StoneSun.jpg');
	
	# add the image to the window
#	$window->add($image);

	# create a label
#	my $label = Gtk3::Label->new();
	
	# set the text of the label
#	$label -> set_text('THE PLACE OF ETERNAL STRUGGLE');
	
	# add the label to the window
#	$window->add($label);
#	$label->set_angle(25);
#	$label->set_halign(Gtk.Align.END);


	# # three labels
	# my $label_top_left = Gtk3::Label->new('This is Top Left');
	# my $label_top_right = Gtk3::Label->new('This is Top Right');
	# my $label_bottom = Gtk3::Label->new('This is Bottom');
	
	# # a grid
	# my $grid = Gtk3::Grid->new();
	# $grid->set_column_spacing(20);
	# # in the grid:
	# # attach the first label in the top left corner
	# $grid->attach($label_top_left,0,0,1,1);
	# # attach the second label
	# $grid->attach($label_top_right,1,0,1,1);
	# # attach the third label below the first label
	# $grid->attach_next_to($label_bottom, $label_top_left, 'bottom', 2, 1);
	# # add the grid to the window
	# $window->add($grid);

	# three labels
	# my $label1 = Gtk3::Label->new();
	# $label1->set_text('Below, a horizontal separator.');
	# my $label2 = Gtk3::Label->new();
	# $label2->set_text('On the right, a vertical separator.');
	# my $label3 = Gtk3::Label->new();
	# $label3->set_text('On the left, a vertical separatoer');
	# # a horizotal separator
	# my $hseparator = Gtk3::Separator->new('horizontal');
	# # a vertical separator
	# my $vseparator = Gtk3::Separator->new('vertical');
	# # a grid to attach labels and separators
	# my $grid = Gtk3::Grid->new();
	# $grid -> attach ($label1, 0, 0, 3, 1);
	# $grid -> attach ($hseparator, 0, 1, 3, 1);
	# $grid -> attach ($label2, 0, 2, 1, 1);
	# $grid -> attach ($vseparator, 1, 2, 1, 1);
	# $grid -> attach ($label3, 2, 2, 1, 1);
	# $grid -> set_column_homogeneous(TRUE);
	# # add the grid to the window
	# $window -> add($grid);


	# # the scrolled window
	# my $scrolled_window=Gtk3::ScrolledWindow->new();
	# $scrolled_window->set_border_width(10);
	# # there is always the scrollbar (otherwise: automatic - only if needed - or never
	# $scrolled_window->set_policy('always', 'always');
	# # add the image to the scrolled window
	# $scrolled_window->add_with_viewport($image);
	# # add the scrolled window to the window
	# $window->add($scrolled_window);

	#NAME BOX
	# $window->set_title ('What is your name?');
	# $window->set_default_size(300,100);
	# $window->set_border_width(10);
	# $window->signal_connect('delete_event' => sub {Gtk3->main_quit()});
	# # a single line entry
	# my $name_box = Gtk3::Entry->new();
	# # emits a signal when Enter key is pressed, connected to the
	# # callback function cb_activate
	# #	$name_box->set_visibility(FALSE); #password-type entry
	# my $completion=Gtk3::EntryCompletion->new();
	# $name_box->set_completion($completion);
	# $name_box->set_placeholder_text('enter your shit here');
	# $name_box->signal_connect('activate', \&cb_activate);
	# add the Entry to the window
	#	$window->add($name_box);


	# a scrollbar for the child widget (that is going to be the textview!)
	# my $scrolled_window = Gtk3::ScrolledWindow->new();
	# $scrolled_window->set_border_width(5);
	# # we scroll only if needed
	# $scrolled_window->set_policy('automatic','automatic');
	# # a text buffer (stores text)
	# my $buffer1 = Gtk3::TextBuffer->new();
	# # a textview
	# my $textview = Gtk3::TextView->new();
	# # displays the buffer
	# $textview->set_buffer($buffer1);
	# # wrap the text, if needed, breaking lines in between words
	# $textview->set_wrap_mode('word');
	# # textview is scrolled
	# $scrolled_window->add($textview);
	# $window->add($scrolled_window);

my $label = Gtk3::Label->new();
$label->set_text('This appliccation goes boom');

# a menubar created in the method create_menubar (see below)
my $menubar = create_menubar();

# pack the menubar and the label in a vertical box
my $vbox = Gtk3::Box->new('vertical', 0);
# Pack a menubar always in a vertical box with option Expand and Fill false!
# alternatively you can use a grid (see the other examples)
$vbox->pack_start($menubar,FALSE,FALSE,0);
$vbox->pack_start($label,TRUE,TRUE,0);

$window->add($vbox);
	

# show the window and run the Application
	

	$window->show_all();


# DIALOG HANDLERS
sub create_menubar {
	# create a menubar
	my $menubar=Gtk3::MenuBar->new();

	# create a menubar item
	my $menubar_item=Gtk3::MenuItem->new('Anwendung');

	# add the menubar item to the menubar
	$menubar->insert($menubar_item,0);

	# create a menu
	my $menu=Gtk3::Menu->new();

	# add 2 items to the menu
	my $item1=Gtk3::MenuItem->new('Message');
	$item1->signal_connect('activate'=>\&message_cb);

	my $item2=Gtk3::MenuItem->new('Quit');
	$item2->signal_connect('activate'=> sub {Gtk3->main_quit();});

	$menu->insert($item1,0);
	$menu->insert($item2,1);

	# add the menu to the menubar(_item!)
	$menubar_item->set_submenu($menu);
	
	# return the complete menubar
	return $menubar;	
	}

# callback function for the signal 'activate' from the message_action
# in the menu of the parent window
sub message_cb {
	# a Gtk3::MessageDialog
	# the options are (parent,flags,MessageType,ButtonType,message) 
	my $messagedialog = Gtk3::MessageDialog->new(	$window,
							'modal',
							'warning',
							'ok_cancel',
							'This action will cause the universe to stop existing.');
	# connect the response (of the button clicked to the function
	# dialog_response
	$messagedialog->signal_connect('response'=>\&dialog_response);
	# show the messagedialog
	$messagedialog->show();
	}

	
}

# ENTRY HANDLER
# the content of the entry is used to write in the terminal
sub cb_activate {
	# retrieve the content of the widget
	my $entry = $_[0];
	my $name = $entry->get_text();
	# print it in a nice form in the terminal 
	#(ohne "\n" kommt keine Ausgabe auf dem Terminal, bis das Programm beendet wird!
	print "Hello $name! \n";
	}




#####################
sub _cleanup {
 
     	my ($app) = @_;
 
     	# Handle cleanup
     	say "_cleanup";
     
} 
