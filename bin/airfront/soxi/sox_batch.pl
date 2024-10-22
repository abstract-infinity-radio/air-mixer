#!/usr/bin/perl

#######################
# Name: sox_batch.pl
# Author: Max Crowe
# Purpose: A simple frontend for batch processing of audio files with SoX
#######################

use strict;
use warnings;
use Getopt::Long;

my $OVERWRITE;
my $NODITHER;
my $DEBUG;
my $SOURCEOBJ;
my $DESTFILE;
my $DESTDIR;
my $SAMPLERATE;
my $BITDEPTH;
my $HELP;
my $EFFECTS;
my $QUALITY;

GetOptions("s|source=s" => \$SOURCEOBJ,
           "f|file=s" => \$DESTFILE,
           "d|directory=s" => \$DESTDIR,
           "o|overwrite" => \$OVERWRITE,
           "r|rate=i" => \$SAMPLERATE,
           "b|bits=i" => \$BITDEPTH,
           "q|quality=s" => \$QUALITY,
           "n|nodither" => \$NODITHER,
           "e|effects=s" => \$EFFECTS,
           "g|debug" => \$DEBUG,
           "h|help" => \$HELP) || die("ERROR: Problem wile getting command line options\n");

# local path to SoX executable

my $soxPath = "/Applications/SoX";
my $soxOpts = "";
my $SOURCEPATH = $SOURCEOBJ;
my @dirContents;
my @dirContentsRaw;

if(! -x "$soxPath/sox") {

	print STDERR "ERROR: the sox executable does not seem to be located in $soxPath.\n";
	printUsage(3);
	
}

if($HELP) {

	print STDOUT "Usage for sox executable:\n\n";
	system("$soxPath/sox -h") == 0 || print STDERR "ERROR: problem attempting to call SoX executable at $soxPath/sox\n\n";
	print STDOUT "Usage for sox_batch.pl:\n\n";
	printUsage(0);
	
}

# a source object must be specified, and the command-line arguments must direct this script to either overwrite
# the original files or specify the output destination

if(!$SOURCEOBJ || (!$OVERWRITE && !$DESTDIR && !$DESTFILE)) {

	printUsage(1);
	
}

if($QUALITY && !$SAMPLERATE) {

	print STDERR "ERROR: a sample rate must be specified if the 'quality' option is invoked.\n";
	printUsage(2);
	
}

$EFFECTS = "" if !defined($EFFECTS);

$soxOpts .= " -b $BITDEPTH" if $BITDEPTH;
$soxOpts .= " -D" if $NODITHER;

if($SAMPLERATE) {

	# note: for some reason, using m// and the pattern '^(linear|intermediate|minimum)$' instead of the string inequality here causes a
	## problem later in cases where the source object does not contain a directory
	if(!$QUALITY || ($QUALITY ne "linear" && $QUALITY ne "intermediate" && $QUALITY ne "minimum") || $QUALITY eq "high") {
	
		if($QUALITY && $QUALITY ne "high") {
		
			print STDOUT "Warning: $QUALITY is not a valid argument to the 'quality' option. Valid arguments are 'high', 'linear',\n"
					   . "'intermediate', and 'minimum'. Defaulting to high quality setting.\n";
					   
		}
		
		$QUALITY = " rate -h -a $SAMPLERATE";
		
	}
	else {
	
		if($QUALITY eq "linear") {
		
			$QUALITY = " rate -v -s -L $SAMPLERATE";
			
		}
		
		if($QUALITY eq "intermediate") {
		
			$QUALITY = " rate -v -s -I $SAMPLERATE";
			
		}
		
		if($QUALITY eq "minimum") {
		
			$QUALITY = " rate -v -s -M $SAMPLERATE";
			
		}
		
	}
	
	$EFFECTS .= $QUALITY;

}

# if multiple files are specified for conversion, the target must be a directory

if(! -f $SOURCEOBJ) {

	$SOURCEOBJ =~ s/\/$//g;
	
	opendir(SOURCEDIR,$SOURCEOBJ);
	@dirContentsRaw = readdir(SOURCEDIR);
	
	foreach my $dirEntry (@dirContentsRaw) {
	
		push(@dirContents,$dirEntry) if -f "$SOURCEOBJ/$dirEntry";
		
	}
	
	if(scalar(@dirContents) > 1 && !$DESTDIR && !$OVERWRITE) {
	
		print STDERR "ERROR: the destination must be a directory if multiple files are specified for conversion.\n";
		printUsage(2);
		
	}
	
}
else { # prepare $SOURCEPATH and put $SOURCEOBJ in @dirContents

	$SOURCEPATH =~ /(.+)?\/[^\/]+$/;
	$SOURCEPATH = defined($1) ? $1 : ".";
	
	$SOURCEOBJ =~ /([^\/]+)$/;
	push(@dirContents,$1);
	
}

# create directory if it doesn't exist, or set destDir to current directory

if($DESTDIR) {

	$DESTDIR =~ s/\/$//g;
	mkdir($DESTDIR) if ! -d $DESTDIR;
	
}
else {

	$DESTDIR = ".";
	
}

foreach my $sourceFile (@dirContents) {

	# only process files whose extension is '.wav'
	
	if(-f "$SOURCEPATH/$sourceFile" && $sourceFile =~ m/\.wav$/) {
	
		my $outFile;
		
		# if behavior is to overwrite files, write output to intermediate temp file, then move to original file name
		
		if($OVERWRITE) {
		
			$outFile = "$SOURCEPATH/tmp_$sourceFile";
			
		}
		# if an output file was provided at the command line, use that
		elsif($DESTFILE) {
		
			$outFile = "$DESTDIR/$DESTFILE"
			
		}
		else {
		
			$outFile = "$DESTDIR/$sourceFile"
			
		}
		
		my $soxCmd = "$soxPath/sox \"$SOURCEPATH/$sourceFile\" $soxOpts \"$outFile\" $EFFECTS";
		
		if(!$DEBUG) {
		
			system("$soxCmd") == 0 || die "ERROR: failure while attempting to convert $SOURCEPATH/$sourceFile\n";
			rename($outFile,"$SOURCEPATH/$sourceFile") if $OVERWRITE;
		
		}
		else {
		
			print STDOUT $soxCmd . "\n";
			
		}
		
	}
	else {
	
		print STDOUT "Skipped non-wave file $SOURCEPATH/$sourceFile\n";
		
	}
	
}

exit(0);

sub printUsage {

	my $exitCode = shift;
	
	print STDOUT "Usage: sox_batch.pl [options]\n\n"
	           . "Valid options:\n"
	           . "  -s|source <source file or directory>\n"
	           . "     Specifies file(s) to be converted.\n"
	           . "  -f|file <destination file>\n"
	           . "     Writes output to specified file.\n"
	           . "  -d|directory <destination directory>\n"
	           . "     Writes output to specified directory (uses same name as input file if -f|file is not used).\n"
	           . "  -o|overwrite\n"
	           . "     Overwrites original file with converted output.\n"
	           . "  -r|rate <sample rate>\n"
	           . "     Creates output file with the specified sample rate.\n"
	           . "  -b|bits <bit depth>\n"
	           . "     Creates output file with the specified bit depth.\n"
	           . "  -q|quality <high,linear,intermediate,minimum>\n"
	           . "     Specifies the quality of the sample rate conversion to be used. Allowable arguments are as bracketed\n"
	           . "     above. They map to the following SoX options:\n"
	           . "       high => -h -a\n"
	           . "       linear => -v -s -L\n"
	           . "       intermediate => -v -s -I\n"
	           . "       minimum => -v -s -M\n"
	           . "     The use of any of the final three arguments implies that the 'very high' quality setting will be used.\n"
	           . "     If this option is not used, or any argument other than these four is specified, this script will print a\n"
	           . "     warning and default to the high quality setting.\n"
	           . "  -e|effects \"<effects>\"\n"
	           . "     Supplies the contents of <effects> as effects options for the output file. The contents of this\n"
	           . "     option must be enclosed in quotes.\n"
	           . "  -n|nodither\n"
	           . "     Deactivates dither.\n"
	           . "  -g|debug\n"
	           . "     Debug mode: this script only prints the command(s) it would attempt to execute in normal mode.\n"
	           . "  -h|help\n"
	           . "     Prints usage information for the SoX executable, as well as this script.\n";
	           
	exit($exitCode);
	
}

