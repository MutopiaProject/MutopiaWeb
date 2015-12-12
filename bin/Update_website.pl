#!/usr/bin/perl -w
#
# Update_website.pl (was new-update.pl)
#
# Generates datafiles/musiccache.dat (used when displaying music),
#           datafiles/searchcache.dat (used for searching/sorting),
#  and updates index page (if required)

use strict;           # Must declare variables with "my" or "use vars"
use File::Basename;   # dirname() 
use File::Find;       # find()
use Cwd;              # getcwd()
use Mutopia_Archive;  # subroutines for manipulating the archive
use Mutopia_HTMLGen;  # subroutines for generating HTML
use vars qw(%RDFData %replacers @rdfFiles);

# Find the root of our data by assuming the script we are executing is
# in a 'bin' folder which is a sibling to 'datafiles'. Allow an
# environment variable MUTOPIA_WEB to override this.
my $webroot = dirname($0) . "/.." ;
$webroot = $ENV{'MUTOPIA_WEB'} || $webroot;
$webroot =~ s|\\|/|g; # change MSDOS file separators

# we want to read rdfs from the "real" ftp location if possible
my $muroot = $ENV{'MUTOPIA_BASE'} || $webroot;

# Generate datafiles/*  ####################################################
my @files = getRDFFileList("$muroot/ftp/");
%RDFData = getAllRDFData("$muroot/ftp/", @files);

makeCache();        # new format
makeSearchCache();
Mutopia_HTMLGen::makeHTML(\%RDFData);

############################################################################

# getRDFFileList($basedir)
# returns a list of subdirs containing a musicname.rdf file
#
sub getRDFFileList {
    my $basedir = shift;
	find(\&wanted, $basedir); # side effect, adds to @rdfFiles
    my @files = sort {byFileName($a,$b)} @rdfFiles;
    s/\s*//g for @files;
    die "Can't find any *.rdf files below $basedir" unless @files;
    return @files;
}

# Used by find(), equivalent to `find . -name "*.rdf"`
# $_ is the file name and extension
# Sets global @rdfFiles as a side effect
#
sub wanted {
    if ( /^.*\.rdf\z/s ) {
		(my $file = $File::Find::name) =~ s|\\|/|g; # change MSDOS file separators
		push @rdfFiles, $file;
	}
}

# byFileName($a, $b)
# sort function to put musicname.rdf files in the correct order.
# This means piece-list.html is in a sensible order
#
sub byFileName($$) {
    my ($a, $b) = @_;
    my($compA) = ($a =~ /(\w+)/);
    my($compB) = ($b =~ /(\w+)/);

    my $diff = Mutopia_Archive::byComposer($compA, $compB);
    return $diff if $diff;

    # composers are the same; compare whole string.

    ($compA, $compB) = ($a, $b);

    # XXX now do nasty kludge to deal with numerical sorting.  If
    # it ever breaks, just uncomment the next line to get something
    # that will do.

    die "crap sort function barfing on too many digits: $1"
        if ("$compA $compB") =~ /(\d{11})/;
    s/(\d+)/("0" x (10 - length $1)) . $1/ge for $compA, $compB;

    return $compA cmp $compB;
}


# getAllRDFData($basedir, @files)
# reads all musicname.rdf files in @files into a big data structure.
#
sub getAllRDFData {
    my ($basedir, @files) = @_;
    my %data;
    my $olddir = getcwd();
    chdir $basedir or die "Cannot chdir to $basedir: $!";
    for my $file (@files) {
        $file =~ m|^(.*)/([^/]+)$| or die "bad filename: $file";
        print "reading $file\n";
        $data{$file} = { Mutopia_Archive::readRDFFile($file) };
    }
    chdir $olddir or die "Cannot return to directory $olddir: $!";
    return %data;
}


# makeCache()
# makes the cache file, containing all details of all pieces.
#
sub makeCache {
    open (COLLECTIONS, '<:utf8', "$muroot/datafiles/collections.dat")
        or die "cannot open $muroot/datafiles/collections.dat: $!";
    my @collections;
    my $noOfCollections;
    for ($noOfCollections = 0; !(eof COLLECTIONS); $noOfCollections++) {
        chomp($collections[$noOfCollections] = <COLLECTIONS>);
    }
    close (COLLECTIONS);

    open (PRINTURLS, '<:utf8', "$muroot/datafiles/printurls.dat")
        or die "cannot open $muroot/datafiles/printurls.dat: $!";
    my @printurls;
    my $noOfPrintUrls;
    for ($noOfPrintUrls = 0; !(eof PRINTURLS); $noOfPrintUrls++) {
        chomp($printurls[$noOfPrintUrls] = <PRINTURLS>);
    }
    close (PRINTURLS);
	
	# Use Unix text record endings or seek will be off in Windows
	local $/ = "\n";

    open TEMPCACHE, ">:utf8", "$webroot/datafiles/tempmusiccache.dat"
        or die "cannot open >$webroot/datafiles/tempmusiccache.dat: $!";
	binmode(TEMPCACHE, ":raw:utf8"); # Be sure we're writing Unix line endings (LF)
	
    for (sort {byFileName($a,$b)} keys %RDFData) {
	
		# Parse Opus and Piece Name from path
		my $opus;
		my $name;
		if ( m|^(?:[A-Z]:)?\.?(?:/[^/]+)*/ftp/(.*)/([^/]+)/[^/]+.rdf$| ) {
			$opus = $1;
			$name = $2;
		} elsif ( m|^(?:\./)?(.*)/([^/]+)/[^/]+.rdf$| ) {
			$opus = $1;
			$name = $2;
		} else {
			die "invalid piece: $_";
		}
		
        my @data = Mutopia_Archive::RDFtoCACHE %{ $RDFData{$_} };
        my $allCollections = "";
        my $printURL = "";

        # find the id number of each piece
        my $date;
        my $id;
        foreach my $dataitem (@data) {
            if ($dataitem =~ /^Mutopia-/) {
                ($date, $id) = $dataitem =~ m|-(\d+/\d+/\d+)-(\d+)$|
                    or die "invalid id: " . $dataitem;
            }
        }

        # is the piece a member of any collections?
        for (my $loop = 0; $loop < $noOfCollections; $loop++) {
            if ($collections[$loop] =~ /(,|:)$id(,|$)/) {
                $allCollections .= substr($collections[$loop],0,index($collections[$loop],":")) . ",";
            }
        }

        # does the piece have a print URL?
        for (my $loop = 0; $loop < $noOfPrintUrls; $loop++) {
            if ($printurls[$loop] =~ /^$id:/) {
                $printURL = substr($printurls[$loop],index($printurls[$loop],":") + 1);
            }
        }

        # output to cache file
        print TEMPCACHE "**********\n$id\n$opus/\n$name\n";
        print TEMPCACHE "$_\n" for @data;
        print TEMPCACHE substr($allCollections, 0, -1) . "\n";
        print TEMPCACHE $printURL . "\n";
    }
    close (TEMPCACHE);

    # Now create the offset table at the beginning of the 'proper' cache

    # NB. ID numbers are padded to give 0001 to 9999. If we get more pieces than
    #     that, then we'll need to change the system (!)

    # Also, offsets are padded up to ~10Mb (10000000). Again, if the cache gets
    #       bigger than this, things will break

	local $/ = "\n"; # Read text with Unix line endings
	
    open (TEMPCACHE, '<:utf8', "$webroot/datafiles/tempmusiccache.dat") 
		or die "cannot open $webroot/datafiles/tempmusiccache.dat";
    open CACHE, ">:utf8", "$webroot/datafiles/musiccache.dat"
        or die "cannot open >$webroot/datafiles/musiccache.dat: $!";
	binmode(CACHE, ":raw:utf8"); # Be sure we're writing Unix line endings (LF)
	
	my @offsets;
	my $piecenumber = 0;

	do {
        chomp(my $templine = <TEMPCACHE>);
        if ($templine ne "**********") { die "ERROR in the cache" }
        my $offset = tell TEMPCACHE;
        chomp(my $id = <TEMPCACHE>);

        s/(\d+)/("0" x (4 - length $1)) . $1/ge for $id;
        s/(\d+)/("0" x (7 - length $1)) . $1/ge for $offset;

        $offsets[$piecenumber] = $id . ":" . $offset;

        for (my $i = 0; $i < 30; $i++) { my $null = <TEMPCACHE> }
        $piecenumber++;
	} until (eof TEMPCACHE);

	close (TEMPCACHE);

	my @sortedoffsets = sort(@offsets);
	@offsets = @sortedoffsets;

	# Now fill in pieces which /don't/ exist with ******

	my $idstep = 1;
	my @emptyids;

	foreach my $piece (@offsets) {
        my $thisid = substr($piece,0,4);
        do {
            if ($thisid > $idstep) {
                s/(\d+)/("0" x (4 - length $1)) . $1/ge for $idstep;
                push @emptyids,$idstep . ":*******";
            }
            $idstep++;
        } until ($thisid == $idstep-1)
	}

	push @offsets,@emptyids;
	@sortedoffsets = sort(@offsets);

	# The 'header' consists of the total header length, then a line for each
	# piece (inluding non-existant ones) with its individual offset. Each
	# piece has an offset of 13 (inc. carriage return), and so does the total
	# header length when padded. Therefore:
	#      total header length = (no. of pieces + 1) * 13
	#                          = ($idstep-1 + 1) * 13 = $idstep * 13

	my $totalheaderlength = 13 * $idstep;
	s/(\d+)/("0" x (12 - length $1)) . $1/ge for $totalheaderlength;
	print CACHE $totalheaderlength . "\n";
	print CACHE "$_\n" for @sortedoffsets;

	open (TEMPCACHE, '<:utf8', "$webroot/datafiles/tempmusiccache.dat");

	do {
        chomp(my $templine = <TEMPCACHE>);
        print CACHE $templine . "\n";
	} until (eof TEMPCACHE);

	close(TEMPCACHE);
	close(CACHE);

	unlink "$webroot/datafiles/tempmusiccache.dat"
			or warn "Cannot delete $webroot/datafiles/tempmusiccache.dat";
}

# makeSearchCache()
# makes the cache file, containing all details of all pieces.
#
sub makeSearchCache {
    open TEMPSEARCHCACHE, ">:utf8", "$webroot/datafiles/tempsearchcache.dat"
        or die "cannot open >$webroot/datafiles/tempsearchcache.dat: $!";

    for (keys %RDFData) {

        # output to cache file
        my @data = Mutopia_Archive::RDFtoSEARCHCACHE %{ $RDFData{$_} };

        # find the id number of each piece
        my $date;
        my $id;
        foreach my $dataitem (@data) {
            if ($dataitem =~ /^id/) {
                ($date, $id) = $dataitem =~ m|-(\d+/\d+/\d+)-(\d+):$|
                    or die "invalid id: " . $dataitem;
            }
        }
        print TEMPSEARCHCACHE "$_$id\n" for @data;
    }
    close(TEMPSEARCHCACHE);

    open (TEMPSEARCHCACHE, '<:utf8', "$webroot/datafiles/tempsearchcache.dat");
    open SEARCHCACHE, ">:utf8", "$webroot/datafiles/searchcache.dat"
        or die "cannot open >$webroot/datafiles/searchcache.dat: $!";

    my @thedata = ();
    do {
        chomp(my $templine = <TEMPSEARCHCACHE>);
        push @thedata, $templine;
    } until (eof TEMPSEARCHCACHE);

    close(TEMPSEARCHCACHE);
    my @sorteddata = sort(@thedata);

    print SEARCHCACHE "$_\n" for @sorteddata;
    close (SEARCHCACHE);

    unlink "$webroot/datafiles/tempsearchcache.dat"
			or warn "Cannot delete $webroot/datafiles/tempsearchcache.dat";
}
