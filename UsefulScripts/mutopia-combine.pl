#!/usr/bin/perl

# Filename:         mutopia-combine.pl
# Original author:  Chris Sawer
#
# Description:
#   Script to combine together multiple .ly/.mid/.pdf/.ps.gz files into the
#   appropriate zip files for Mutopia and create .rdf file. Checks all necessary
#   files are present.
#   Note that if there are multiple .ly files, they should already be in the
#   $BASE_NAME-lys directory.
#
# Options:
#   $1 - "base name" of the piece
#   $2 - (optional) .ly file containing header information

use strict;
use warnings; 
use File::Basename;        # basename()
use File::Find;            # find()
use File::Copy;            # copy()
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use IO::Compress::Zip      qw(zip $ZipError) ;

# Print usage if no parameters given
unless (@ARGV) {
	my $me = basename($0);
    print "Usage: $me <base name> [<header file>]\n";
    exit 1;
}

# Set up variables
my $BASE_NAME = $ARGV[0];
my $HEADER_FILE;
if ($#ARGV > 0) {
	$HEADER_FILE = $ARGV[1];
} else {
	$HEADER_FILE = "$BASE_NAME.ly";
}

my @A4_PDF_COUNT  = glob "*-a4.pdf";
my @A4_PS_COUNT   = glob "*-a4.ps.gz";
my @LET_PDF_COUNT = glob "*-let.pdf";
my @LET_PS_COUNT  = glob "*-let.ps.gz";
my @MID_COUNT     = glob "*.mid";
my @ZIP_COUNT     = glob "*.zip";

# Check directory is clean
if ( @ZIP_COUNT || -f "$BASE_NAME.rdf" ) {
   die "Directory is not clean: aborting\n";
}

# Check files all exist
if ( ! -r $HEADER_FILE || 
   ( ! -d "$BASE_NAME-lys" && ! -f "$BASE_NAME.ly" ) ) {
   die "Unable to find .ly files: aborting\n";
}

unless ( @A4_PDF_COUNT  && @A4_PS_COUNT  && 
         @LET_PDF_COUNT && @LET_PS_COUNT ) {
	die "Unable to find all .pdf/.ps.gz files: aborting\n";
}

unless ( @MID_COUNT ) {
   die "Unable to find .mid files: aborting\n";
}

unless ( -r "$BASE_NAME-preview.png" ) {
   die "Unable to find preview image: aborting\n";
}

# Create zip files as appropriate
if ( -d "$BASE_NAME-lys" ) {
   find(\&wanted, "$BASE_NAME-lys"); # Zipping occurs in sub wanted {}
}

if ( @A4_PDF_COUNT > 1 ) {
	gunzip "<*-a4.ps.gz>" => "<*-a4.ps>"
			or die "gunzip failed: $GunzipError\n";
	gunzip "<*-let.ps.gz>" => "<*-let.ps>"
			or die "gunzip failed: $GunzipError\n";
	zip [ glob "*-a4.pdf" ] => "$BASE_NAME-a4-pdfs.zip"
			or die "zip failed: $ZipError\n";
	zip [ glob "*-a4.ps" ] => "$BASE_NAME-a4-pss.zip"
			or die "zip failed: $ZipError\n";
	zip [ glob "*-let.pdf" ] => "$BASE_NAME-let-pdfs.zip"
			or die "zip failed: $ZipError\n";
	zip [ glob "*-let.ps" ] => "$BASE_NAME-let-pss.zip"
			or die "zip failed: $ZipError\n";
	unlink_all("*-a4.pdf *-a4.ps *-let.pdf *-let.ps");
}

if ( @MID_COUNT > 1 ) {
	zip [ glob "*.mid" ] => "$BASE_NAME-mids.zip"
			or die "zip failed: $ZipError\n";
	unlink_all("*.mid");
}

# Create RDF (using copy of header file if necessary)
if ( -d "$BASE_NAME-lys" ) {
	copy($HEADER_FILE, "$BASE_NAME.ly") 
			or die "Copy failed: $!";
	create_rdf_files( "$BASE_NAME.ly" ); 
	unlink "$BASE_NAME.ly"
			or die "Cannot delete $BASE_NAME.ly, $!\n";
} else {
	create_rdf_files( "$BASE_NAME.ly" );
}

# Called from find().  $_ is file name.  Recursive zip without svn files.
sub wanted {
	unless ( /\.svn/ ) {
		zip $File::Find::name => "$BASE_NAME-lys.zip"
				or die "zip failed: $ZipError\n";
	}
}

# Create .rdf file from .ly files using Mutopia script
sub create_rdf_files {
	my $input_file = shift;
	my @args = ('Mutopia', '-r', $input_file);
	system (@args) == 0
			or die "system @args failed, exited with $?\n";
}

# Delete all files with a glob
sub unlink_all {
	my $files = shift;
	foreach my $file (glob $files) {
		unlink $file 
				or warn "Cannot delete $file, $!\n";
	}
}