#!/usr/bin/perl

# Deploy files and folder to the htdocs folder of your httpd server.
# This script would typically be run after Update_website.pl.

use strict;
use warnings;
use File::Path qw(remove_tree);
use File::Copy::Recursive qw(rcopy);

my $webroot = $ENV{'MUTOPIA_WEB'} || "..";
$webroot =~ s|\\|/|g;
my $docroot = $ENV{'DOCUMENT_ROOT'} || ".";
$docroot =~ s|\\|/|g;

print "Mutopia root: $webroot\n";
print "Document root: $docroot\n";
print "\nDocument root will be deleted.  Continue? (y,n): ";
my $ans = <STDIN>;
exit if $ans =~ /^n/i;

remove_tree($docroot) or die "Cannot delete $docroot, $!\n";
chdir $webroot or die "Cannot change to directory $webroot, $!\n";
my @files = qw(
    cgibin/                                     
    robots.txt                                  
    latestadditions.rss                         
    datafiles/                                  
    images/                                     
    bootstrap/                       
    css/   
	ftp/
);
push @files, glob "*.html";
push @files, glob "*.ico";
push @files, glob "*.xml";

for my $file (@files) {
	print "$file...\n";
	rcopy($file, "$docroot/$file") 
			or die "Cannot copy $file to $docroot, $!\n";
}

print "Finished\n";