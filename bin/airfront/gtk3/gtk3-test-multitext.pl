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

	my $T1 = Gtk3::Entry->new();
	my $T2 = Gtk3::Entry->new();
	my $T3 = Gtk3::Entry->new();
	# $T1->set_visibility(FALSE); #password-type entry
	# my $completion=Gtk3::EntryCompletion->new();
	# $T1->set_completion($completion);
	$T1->set_placeholder_text('Project name');
	$T2->set_placeholder_text('Project description');
	$T3->set_placeholder_text('Project remarks');
	
	$T1->signal_connect('activate', \&T1_cb);
	$T2->signal_connect('activate', \&T2_cb);
	$T3->signal_connect('activate', \&T3_cb);
	
	# add the Entry to the window
	#	$window->add($name_box);

	
	# # three labels
	# my $label_top_left = Gtk3::Label->new('This is Top Left');
	# my $label_top_right = Gtk3::Label->new('This is Top Right');
	# my $label_bottom = Gtk3::Label->new('This is Bottom');
	

	# my $label1 = Gtk3::Label->new();
	# $label1->set_text('Below, a horizontal separator.');
	# my $label2 = Gtk3::Label->new();
	# $label2->set_text('On the right, a vertical separator.');
	# my $label3 = Gtk3::Label->new();
	# $label3->set_text('On the left, a vertical separatoer');
	# # a horizotal separator
	my $hseparator = Gtk3::Separator->new('horizontal');
	# # a vertical separator
	my $vseparator = Gtk3::Separator->new('vertical');
	# # a grid to attach labels and separators

	my $grid = Gtk3::Grid->new();
	$grid -> attach ($T1, 0, 0, 3, 1);
	$grid -> attach ($hseparator, 0, 1, 3, 1);
	$grid -> attach ($T2, 0, 2, 1, 1);
#	$grid -> attach ($vseparator, 1, 2, 1, 1);
	$grid -> attach ($T3, 2, 2, 1, 1);
	$grid -> set_column_homogeneous(TRUE);
	# # add the grid to the window
	$window -> add($grid);
	$window->show_all();
}


# ENTRY HANDLER
# the content of the entry is used to write in the terminal
sub T1_cb {
	my $entry = $_[0];
	my $text = $entry->get_text();
	say "Project name: $text";
	}

sub T2_cb {
	my $entry = $_[0];
	my $text = $entry->get_text();
	say "Project description: $text";
	}

sub T3_cb {
	my $entry = $_[0];
	my $text = $entry->get_text();
	print "Project remarks: $text";
	}


#####################
sub _cleanup {
     	my ($app) = @_;
     	# Handle cleanup
     	say "_cleanup";
} 
