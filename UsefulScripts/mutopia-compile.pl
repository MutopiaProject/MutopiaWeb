#!/usr/bin/perl

# Filename:         mutopia-compile.pl
# Original author:  Chris Sawer
#
# Description:
#   Script to compile .ly files into .mid/.pdf/.ps.gz files.
#   Note that if there are multiple .ly files, they should already be in the
#   $BASE_NAME-lys directory.
#
# Options:
#   $1 - Switch to use, comprising:
#        -l - Use landscape hack
#        -s - Separate A4 and Letter versions (-a4.ly [specified] and -let.ly)
#   $@ - File names to process

use strict;
use warnings;
use Getopt::Long;   # GetOptions()
use File::Basename; # basename()
use Cwd;            # getcwd()
use IO::Compress::Gzip qw(gzip $GzipError);

# Globals
my $LY_BASE_NAME;
my $TARGET_BASE_NAME;
my $PREVIEW;
my $PS;
my $PDF;

# Environment
my $lilypond_version = $ENV{LILYPOND_VERSION} || "";
my $LILYPOND_BIN = $ENV{LILYPOND_BIN} || "";
my $me = basename $0;

# Determine OS (Windows, non-Windows) 
my $THIS_IS_WINDOWS = 0;
my $MIDI = "midi";
if ($^O =~ /MSWin32/) {
	$THIS_IS_WINDOWS = 1;
	$MIDI = "mid";
}

########################
# Start of main script #
########################

# Check environment variables are set up
die "LILYPOND_BIN environment variables must be set\n" 
		unless $LILYPOND_BIN;
	
# Get command line flags
my $landscape_hack;
my $compile_separately;
GetOptions(
	"l" => \$landscape_hack,
	"s" => \$compile_separately,
) or usage();	
#usage() if $landscape_hack && $compile_separately;

# Check .ly file(s) have been specified
usage() unless @ARGV;

# LilyPond version specific fixes
# Note - these will need to be updated as the default version changes
# Currently assumed default version: 2.18
if ( $lilypond_version =~ /2\.12\.?\d+?/ ) {
	$PS  = "";
	$PDF = "";
} else {
	$PS  = "--ps";
	$PDF = "--pdf"; 
}

if ( $lilypond_version =~ /2\.10\.?\d+?/ ) {
	$PREVIEW = "--preview";
} else {
	$PREVIEW = "-dpreview";
}

# Run .ly files through LilyPond
my $starting_dir = getcwd();

foreach my $parameter (@ARGV) {
	my($basename, $dirname, $suffix) = fileparse($parameter, ".ly");

	unless ($suffix eq ".ly") {
		warn "Error: file $dirname/$basename must end in .ly\n";
		next;
	}

	$TARGET_BASE_NAME = $LY_BASE_NAME = $basename;
	chdir $dirname or die "Cannot chdir to $dirname, $!";

	if ($landscape_hack) {
		# Compile separate A4 and Letter files (created using hack)
		$LY_BASE_NAME = "${TARGET_BASE_NAME}-a4";
		open TARGET, '<', "${TARGET_BASE_NAME}.ly"
				or die "Cannot open ${TARGET_BASE_NAME}.ly for reading, $!";
		my @target_lines = map { 
			s/set-default-paper-size "letter"/set-default-paper-size "a4"/ 
		} <TARGET>;
		open FH, ">> ${LY_BASE_NAME}.ly"
				or die "Cannot open ${LY_BASE_NAME}.ly for appending, $!";
		print FH @target_lines;
		close FH;
		close TARGET;
		compile_a4();
		unlink "${LY_BASE_NAME}.ly"
				or die "Cannot delete ${LY_BASE_NAME}.ly, $!";

		$LY_BASE_NAME = "${TARGET_BASE_NAME}-let";
		@target_lines = map { 
			s/set-default-paper-size "a4"/set-default-paper-size "letter"/ 
		} @target_lines;
		open FH, ">> ${LY_BASE_NAME}.ly"
				or die "Cannot open ${LY_BASE_NAME}.ly for appending, $!";
		print FH @target_lines;
		close FH;
		close TARGET;
		compile_let();
		rename_midi();
		unlink "${LY_BASE_NAME}.ly"
				or die "Cannot delete ${LY_BASE_NAME}.ly, $!";
	} elsif ($compile_separately) {
		# Compile separate A4 and Letter files
		unless ($TARGET_BASE_NAME =~ /-a4$/) {
			warn "Error: for separate compilation, name must end -a4.ly\n";
			chdir $starting_dir
					or die "Cannot chdir to $starting_dir, $!";
			next;
		}
			
		compile_a4();
		$LY_BASE_NAME = "${TARGET_BASE_NAME}-let";
		compile_let();
		rename_midi();
	} else {
		# Standard compilation
		compile_a4();
		compile_let();
		rename_midi();
	}

	chdir $starting_dir
			or die "Cannot chdir to $starting_dir, $!";
}

# compile_a4 - Compile A4 version of .ly file (and preview images)
sub compile_a4 {
	my @args = ("$LILYPOND_BIN",
		$PREVIEW,
		$PS,
		$PDF,
		"-dno-include-book-title-preview",
		"-dresolution=72",
		"-dno-point-and-click",
		'-dpaper-size=\"a4\"',
		"${LY_BASE_NAME}.ly");
	system(@args) == 0
			or die "system @args failed: $?";
	check_papersize("a4");
	rename "${LY_BASE_NAME}.ps", "${TARGET_BASE_NAME}-a4.ps"
			or die "Rename failed, $!";
	rename "${LY_BASE_NAME}.pdf", "${TARGET_BASE_NAME}-a4.pdf"
			or die "Rename failed, $!";
	rename "${LY_BASE_NAME}.preview.png", "${TARGET_BASE_NAME}-preview.png"
			or die "Rename failed, $!";
	unlink "${LY_BASE_NAME}.preview.eps"
			or die "Cannot delete ${LY_BASE_NAME}.preview.eps, $!";
	unlink "${LY_BASE_NAME}.preview.pdf"
			or die "Cannot delete ${LY_BASE_NAME}.preview.pdf, $!";
	# TODO this doesn't work well in connection with the landscape hack
	unlink "${LY_BASE_NAME}.$MIDI"
			or die "Cannot delete ${LY_BASE_NAME}.$MIDI, $!";
	gzip "${TARGET_BASE_NAME}-a4.ps" => "${TARGET_BASE_NAME}-a4.ps.gz"
			or die "gzip failed: $GzipError\n";
	unlink "${TARGET_BASE_NAME}-a4.ps"
			or die "Cannot delete ${TARGET_BASE_NAME}-a4.ps, $!";
}

# compile_let - Compile Letter version of .ly file (and fix .midi -> .mid)
sub compile_let {
	my @args = ("$LILYPOND_BIN",
		$PS,
		$PDF,
		"-dno-point-and-click",
		'-dpaper-size=\"letter\"',
		"${LY_BASE_NAME}.ly");
	system(@args) == 0
			or die "system @args failed: $?";
	check_papersize("letter");
	rename "${LY_BASE_NAME}.ps", "${TARGET_BASE_NAME}-let.ps"
			or die "Rename failed, $!";
	rename "${LY_BASE_NAME}.pdf", "${TARGET_BASE_NAME}-let.pdf"
			or die "Rename failed, $!";
	# TODO this doesn't work well in connection with the landscape hack
	rename "${LY_BASE_NAME}.$MIDI", "${TARGET_BASE_NAME}.$MIDI"
			or die "Rename failed, $!";; 
	gzip "$TARGET_BASE_NAME-let.ps" => "$TARGET_BASE_NAME-let.ps.gz";
	unlink "${TARGET_BASE_NAME}-let.ps"
			or die "Cannot delete ${TARGET_BASE_NAME}-let.ps, $!";
}

# check_papersize - Compare actual paper size in .ps to $PAPERSIZE
sub check_papersize {
	my $paper_size = shift;
	open FH, '<', "${LY_BASE_NAME}.ps"
			or die "Cannot open ${LY_BASE_NAME}.ps for reading, $!";
	my @ps_lines = <FH>;
	close FH;
	warn "Warning: Couldn't detect paper size.\n" 
			if !grep "^%%DocumentMedia:", @ps_lines;
	warn "Warning: Couldn't detect paper size $paper_size.\n" 
			if !grep "^%%DocumentMedia: $paper_size", @ps_lines;
}

# Rename midi to mid unless we're in Windows
sub rename_midi {
	unless ($THIS_IS_WINDOWS) {
		foreach my $t (glob "*.midi") {
			(my $s = $t) =~ s/i$//;
			rename $t, $s or die "Rename failed, $!";
		}
	}
}

sub usage {
	print <<END;
Usage: $me [-l] <files>
       $me [-s] <files>
       -l = Use landscape hack
       -s = Separate A4 and Letter versions (-a4.ly [specified] and -let.ly)
	   Flags are mutually exclusive
END
	exit 1;
}
