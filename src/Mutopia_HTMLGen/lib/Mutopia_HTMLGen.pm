#!/usr/bin/perl -w
#
# Mutopia_HTMLGen.pm
# Subroutines to help with generating HTML pages from html-in/* files.

package Mutopia_HTMLGen;

# use strict;	# Must declare variables with "my" or "use vars"
use Mutopia_Archive; # helpful subroutines
use POSIX qw(strftime);
use Time::Local;
use Carp; # croak() = like die(), but the error appears in the caller
use Cwd;  # getcwd(), like `pwd`
use File::Path qw(make_path remove_tree);
use utf8;
use vars qw(%RDF_DATA);

our $VERSION = '0.02';

my %RDF_DATA;
my $OUTPUT_FILE;

# File opens must be relative to webroot
my $webroot = $ENV{'MUTOPIA_WEB'}
	or croak("The environment variable MUTOPIA_WEB must be set\n");
$webroot =~ s|\\|/|g; # Change MSDOS file separators

# makeHTML(\%RDF_DATA)
# Read *.html-in, fill with generated data, and write *.html
#
sub makeHTML($) {
    my $rdf_ref = shift;
	
	# Clear and create an htdocs folder in $webroot for the HTML files
	remove_tree("$webroot/htdocs");
	make_path("$webroot/htdocs");

    %RDF_DATA = %$rdf_ref;
	my $starting_dir = getcwd();
    chdir "$webroot/html-in" or croak "cannot chdir to html-in: $!";
    my @infiles = glob("*.html-in");
    chdir $starting_dir;

    for my $infile(@infiles) {
        open (IN, "<:utf8", "$webroot/html-in/$infile") or croak "cannot open $infile: $!";
        local $_ = join "", <IN>;
        close IN;

        # stick warning message in
        my $msg = <<________EOM;$msg=~s/^ {8}//gm;s/<head/\n$msg\n<head/;
        <!--*********************************************************
            ** Automatically generated from $infile.
            ** Any changes made to this file will be lost!
            *********************************************************-->
________EOM

        ($OUTPUT_FILE = $infile) =~ s/\.html-in$/.html/
                or croak "invalid filename: $infile";

        replace_placeholders(\$_);

        open OUT, ">:utf8", "$webroot/htdocs/$OUTPUT_FILE" 
				or croak "cannot open >$webroot/htdocs/$OUTPUT_FILE: $!";
        print OUT $_;
        close OUT;

        undef $OUTPUT_FILE;
    }

    chdir "$webroot/html-in" or croak "cannot chdir to html-in: $!";
    @infiles = glob("*.rss-in");
    chdir $starting_dir;

    for my $infile(@infiles) {
        open (IN, "<:utf8", "$webroot/html-in/$infile") 
				or croak "cannot open $webroot/html-in/$infile: $!";
        local $_ = join "", <IN>;
        close IN;

        ($OUTPUT_FILE = $infile) =~ s/\.rss-in$/.rss/
                or croak "invalid filename: $infile";

        replace_placeholders(\$_);

        open OUT, ">:utf8", "$webroot/htdocs/$OUTPUT_FILE" 
				or croak "cannot open >$webroot/htdocs/$OUTPUT_FILE: $!";
        print OUT $_;
        close OUT;

        undef $OUTPUT_FILE;
    }
}


# replace_placeholders(\$html)
# Replaces placeholders like [[ code ]] with generated HTML
#
sub replace_placeholders($) {
    my $html = shift;

    # Execute the contents of [[ ]] brackets in the HTML, and substitute
    # the value returned.  The trickery with "eval" is to ensure that we
    # see the error messages generated, if there were any.

    1 while $$html =~ s(\[\[(.*?)\]\])(
        my $return;
        eval "\$return = (sub{$1})->()";
        die $@ if $@;
        $return;
    )ges;
}


###################################################################
# Subroutines to generate useful fragments of HTML.  The variable
# %RDF_DATA contains the collection data, and $OUTPUT_FILE contains
# the name of the file currently being outputted to.
###################################################################


sub BROWSE_BY_COMPOSER {
    my %comps = Mutopia_Archive::getData("$webroot/datafiles/composers.dat");
    my $html = "";
    for my $k (sort {Mutopia_Archive::byComposer($a,$b)} keys %comps) {

        # How many pieces by this composer?
		open (SEARCHCACHE, '<:utf8', "$webroot/datafiles/searchcache.dat")
			or croak "cannot open $webroot/datafiles/searchcache.dat: $!";
		my $noofpieces = 0;
		my $finish = 0;
		do {
			chomp(my $templine = <SEARCHCACHE>);
			if ($templine =~ /^composerK:$k/) { $noofpieces++ }
			if ($templine =~ /^date/) { $finish = 1 }
		} until (($finish == 1) || (eof SEARCHCACHE));
        close(SEARCHCACHE);

        $html .= "<a href='cgibin/make-table.cgi?Composer=$k'>";
        $html .= $comps{$k} . "</a> [$noofpieces]<br />\n";
    }
    return $html;
}


sub BROWSE_BY_INSTRUMENT {
    my %insts = Mutopia_Archive::getData("$webroot/datafiles/instruments.dat");
    my $html = "";
    for my $k (sort {Mutopia_Archive::byInstrument($a,$b)} keys %insts) {

		# How many pieces for this instrument?
		open (SEARCHCACHE, '<:utf8', "$webroot/datafiles/searchcache.dat")
			or croak "cannot open $webroot/datafiles/searchcache.dat: $!";
		my $noofpieces = 0;
		my $finish = 0;
		do {
			chomp(my $templine = <SEARCHCACHE>);
			if ( ($templine =~ /^instruments:/) &&
				 ( $templine =~ /$k/ )) { $noofpieces++ }
				if (($k eq "Harp") and ($templine =~ /Harpsichord/)) { $noofpieces-- }
			if ($templine =~ /^licence/) { $finish = 1 }
        } until (($finish == 1) || (eof SEARCHCACHE));
        close(SEARCHCACHE);

        $html .= "<a href='cgibin/make-table.cgi?Instrument=$k'>";
        $html .= $insts{$k} . "</a> [$noofpieces]<br />\n";
    }
    return $html;
}


sub BROWSE_BY_STYLE {
    my %styles = Mutopia_Archive::getData("$webroot/datafiles/styles.dat");
    my $html = "";
    for my $k (sort keys %styles) {

		# How many pieces in this style?
		open (SEARCHCACHE, '<:utf8', "$webroot/datafiles/searchcache.dat")
				or croak "cannot open $webroot/datafiles/searchcache.dat: $!";
		my $noofpieces = 0;
		my $finish = 0;
		do {
			chomp(my $templine = <SEARCHCACHE>);
			if ($templine =~ /^style:$styles{$k}/) { $noofpieces++ }
			if ($templine =~ /^title/) { $finish = 1 }
        } until (($finish == 1) || (eof SEARCHCACHE));
        close(SEARCHCACHE);

        $html .= "<a href='cgibin/make-table.cgi?Style=$k'>";
        $html .= $styles{$k} . "</a> [$noofpieces]<br />\n";
    }
    return $html;
}


sub BROWSE_COLLECTIONS {
    open (COLLECTIONS, '<:utf8', "$webroot/datafiles/collections.dat")
			or croak "cannot open $webroot/datafiles/collections.dat: $!";
    my $lineread;
    my $colname;
    my $coldesc;
    my $html = "<ul>\n";
    do {
        chomp($lineread = <COLLECTIONS>);
        $lineread =~ /^(\w+):([\w\W]+):/;
        $colname = $1;
        $coldesc = $2;

        $html .= "<li><a href=\"cgibin/make-table.cgi?collection=";
        $html .= $colname . "&amp;preview=1\">" . $coldesc . "</a></li>\n";
    } until (eof COLLECTIONS);

    $html .= "</ul>\n";
    close (COLLECTIONS);

    return $html;
}


sub COMPOSER_OPTIONS {
    my %comps = Mutopia_Archive::getData("$webroot/datafiles/composers.dat");
    my $html = "";
    for my $k (sort {Mutopia_Archive::byComposer($a,$b)} keys %comps) {
        $html .= "<option value='$k'>" . $comps{$k} . "</option>\n";
    }
    return $html;
}


sub COMPOSER_LIST {
    my %comps = Mutopia_Archive::getData("$webroot/datafiles/composers.dat");
    my $html = "";
    for my $k (sort {Mutopia_Archive::byComposer($a,$b)} keys %comps) {
        $html .= $k . ", ";
    }
    return substr($html, 0, -2);
}


sub INSTRUMENT_OPTIONS {
    my %insts = Mutopia_Archive::getData("$webroot/datafiles/instruments.dat");
    my $html = "";
    for my $k (sort {Mutopia_Archive::byInstrument($a,$b)} keys %insts) {
        $html .= "<option value='$k'>" . $insts{$k} . "</option>\n";
    }
    return $html;
}


sub STYLE_OPTIONS {
    my %styles = Mutopia_Archive::getData("$webroot/datafiles/styles.dat");
    my $html = "";
    for my $k (sort keys %styles) {
        $html .= "<option value='$k'>" . $styles{$k} . "</option>\n";
    }
    return $html;
}


sub STYLE_LIST {
    my %styles = Mutopia_Archive::getData("$webroot/datafiles/styles.dat");
    my $html = "";
    for my $k (sort keys %styles) {
        $html .= $k . ", ";
    }
    return substr($html, 0, -2);
}


sub NUMBER_OF_PIECES {
    # returns the number of pieces (counted from musiccache.dat)
	
	# Use Unix text record endings or seek will be off in Windows
	local $/ = "\n";

    open (CACHE, '<:utf8', "$webroot/datafiles/musiccache.dat")
			or croak "cannot open $webroot/datafiles/musiccache.dat: $!";
    chomp(my $headerlength = <CACHE>);
    my $numberofpieces = 0;
    while (1) {
        chomp(my $templine = <CACHE>);
        if ($templine =~ /^[0-9]+:[0-9]+$/) { $numberofpieces++ }
		last if $templine eq "**********";
    }
    close(CACHE);
    return $numberofpieces;
}


sub LATEST_ADDITIONS($) {
    # returns HTML of links to the most recent pieces.
    # argument is the number of pieces to display

    #order by ID, most recent first
    my @recent = sort {
        $a->{id} =~ /-(\d+)$/ or croak "invalid id: ", $a->{id};
        my $idA = $1;
        $b->{id} =~ /-(\d+)$/ or croak "invalid id: ", $b->{id};
        my $idB = $1;

        return $idB <=> $idA;
    } values %RDF_DATA;

    # generate HTML listing for most recent pieces
    my $html = "";
    my $last_piece = (shift) - 1;
    for my $piece(@recent[0 .. $last_piece]) {
        my($date, $id) = $piece->{id} =~ m|-(\d+/\d+/\d+)-(\d+)$|
                or croak "invalid id: " . $piece->{id};

        $html .= "<b>$date</b> - ";
        $html .= "<a href='cgibin/piece-info.cgi?id=$id'>";
        $html .= $piece->{title} . ", ";
        if ($piece->{composer} !~ /^(Anonymous|Traditional)$/) {
            $html .= "by ";
        }
        $html .= $piece->{composer};
        $html .= " - " . $piece->{opus} . " for " . $piece->{for};
        $html .= "</a><br />\n";
    }
    return $html;
}


sub LATEST_ADDITIONS_RSS($) {
    # returns XML of links to the most recent pieces.
    # argument is the number of pieces to display

    #order by ID, most recent first
    my @recent = sort {
        $a->{id} =~ /-(\d+)$/ or croak "invalid id: ", $a->{id};
        my $idA = $1;
        $b->{id} =~ /-(\d+)$/ or croak "invalid id: ", $b->{id};
        my $idB = $1;

        return $idB <=> $idA;
    } values %RDF_DATA;

    # generate XML listing for most recent pieces
    my $xml = "<pubDate>". strftime("%a, %d %b %Y %T %z", localtime()) . "</pubDate>\n";
    my ($fy, $fm, $fd) = $recent[0]->{id} =~ m|-(\d+)/(\d+)/(\d+)-\d+$|;
    $xml .= "<lastBuildDate>" . strftime("%a, %d %b %Y %T %z", localtime(timelocal(0, 0, 0, $fd, $fm - 1, $fy))) . "</lastBuildDate>\n\n";

    my $last_piece = (shift) - 1;
    for my $piece(@recent[0 .. $last_piece]) {
        my($y, $m, $d, $id) = $piece->{id} =~ m|-(\d+)/(\d+)/(\d+)-(\d+)$|
                or croak "invalid id: " . $piece->{id};

        $xml .= "<item>\n";
        $xml .= "<title>" . $piece->{composer} . ": " . $piece->{title} . "</title>\n";
        $xml .= "<link>http://www.mutopiaproject.org/cgibin/piece-info.cgi?id=" . $id . "</link>\n";
        $xml .= "<guid>http://www.mutopiaproject.org/cgibin/piece-info.cgi?id=" . $id . "</guid>\n";
        $xml .= "<description>" . $piece->{title} . ", ";
        if ($piece->{composer} !~ /^(Anonymous|Traditional)$/) {
            $xml .= "by ";
        }
        $xml .= $piece->{composer};
        $xml .= " - " . $piece->{opus} . " for " . $piece->{for};
        $xml .= "</description>\n";
        $xml .= "<pubDate>" . strftime("%a, %d %b %Y %T %z", localtime(timelocal(0, 0, 0, $d, $m - 1, $y))) . "</pubDate>\n";
        $xml .= "</item>\n\n";
    }
    return $xml;
}


sub ALL_PIECES {
    # returns HTML of links to all pieces in the archive (made from the cache)
    my $html = "";
	
	# Use Unix text record endings or seek will be off in Windows
	local $/ = "\n";

    open (CACHE, '<:utf8', "$webroot/datafiles/musiccache.dat")
			or croak "cannot open $webroot/datafiles/musiccache.dat: $!";

    chomp (my $headerlength = <CACHE>);
    seek CACHE, $headerlength, 0;

    until (eof CACHE) {
        chomp (my $checkline = <CACHE>);
        if ($checkline ne "**********") { carp "ERROR in the datafile - rebuild cache\n"; }
        chomp (my $idno = <CACHE>);
        chomp (my $midrif = <CACHE>);
        chomp (my $musicnm = <CACHE>);
        chomp (my $lyfile = <CACHE>);
        chomp (my $midfile = <CACHE>);
        chomp (my $a4psfile = <CACHE>);
        chomp (my $a4pdffile = <CACHE>);
        chomp (my $letpsfile = <CACHE>);
        chomp (my $letpdffile = <CACHE>);
        chomp (my $pngfile = <CACHE>);
        chomp (my $pngheight = <CACHE>);
        chomp (my $pngwidth = <CACHE>);
        chomp (my $title = <CACHE>);
        chomp (my $composer = <CACHE>);
        chomp (my $opus = <CACHE>);
        chomp (my $lyricist = <CACHE>);
        chomp (my $instrument = <CACHE>);
        chomp (my $date = <CACHE>);
        chomp (my $style = <CACHE>);
        chomp (my $metre = <CACHE>);
        chomp (my $arranger = <CACHE>);
        chomp (my $source = <CACHE>);
        chomp (my $copyright = <CACHE>);
        chomp (my $id = <CACHE>);
        chomp (my $maintainer = <CACHE>);
        chomp (my $maintaineremail = <CACHE>);
        chomp (my $maintainerweb = <CACHE>);
        chomp (my $extrainfo = <CACHE>);
        chomp (my $lilypondversion = <CACHE>);
        chomp (my $collections = <CACHE>);
        chomp (my $printurl = <CACHE>);

        if ($opus eq "") { $opus = "&nbsp;" }
        my $compLessDates;
        if (index($composer, "(") > 0) {
            $compLessDates = substr($composer, 0, index($composer, "(") - 1);;
        } else {
            $compLessDates = $composer;
        }

        $html .= "<tr><td>".$compLessDates."</td><td><a href=\"cgibin/piece-info.cgi?id=".$idno."\">";
        $html .= $title."</a></td><td>".$opus."</td><td>".$instrument."</td></tr>\n";
    }

    close(CACHE);
    return $html;
}


# A simple include routine
sub INCLUDE($) {
    my $infile = shift;
    if (! -e $infile) {
        $infile = "$webroot/html-in/$infile";
    }
    open (IN, "<:utf8", $infile) 
		or croak "cannot open include file $webroot/html-in/$infile: $!";
    local $htmlinc = join "", <IN>;
    close IN;
    return $htmlinc;
}


sub HEAD($) {
    my $dontlinkto = shift;
    my $html = <<____EOH; $html =~ s/^ *//gm; # trim leading whitespace
    <table class="masthead">
    <tr>
    <td><img src="images/logo-small.png" alt="Mutopia Project Logo" width="186" height="61" /></td>
    <td style="font-weight: bold;">All music in the Mutopia Project is free to download, print out, perform and distribute.<br />
    [[ NUMBER_OF_PIECES() ]] pieces of music are now available.</td>
    </tr>
____EOH
    return $html;
}


sub INDEXHEAD {
    my @composers = ("BachJS", "Bach",
                     "BeethovenLv", "Beethoven",
                     "ChopinFF", "Chopin",
                     "DiabelliA", "Diabelli",
                     "HandelGF", "Handel",
                     "MozartWA", "Mozart",
                     "SchumannR", "Schumann",
                     "SorF", "Sor"
        );
    my $sb_1 = "<p><b>Browse by composer:</b>";
    my $comma = "";
    for (my $comp = 0; $comp < (@composers); $comp += 2) {
        $sb_1 .= "$comma <a href=\"cgibin/make-table.cgi?Composer="
            . $composers[$comp] . "\">"
            . $composers[$comp+1] . "</a>";
        $comma = ",";
    }
    $sb_1 .= " <a href=\"browse.html#byComposer\">[Full list of composers]</a></p>";

    $comma = "";
    $sb_1 .= "<p><b>Browse by instrument:</b>";
    my @instruments = ("Piano", "Vocal", "Organ", "Violin", "Guitar", "Orchestra");
    foreach my $instr (@instruments) {
        $sb_1 .= "$comma <a href=\"cgibin/make-table.cgi?Instrument=$instr\">$instr</a>";
        $comma = ",";
    }
    $sb_1 .= " <a href=\"browse.html#byInstrument\">[Full list of instruments]</a></p>";

    return $sb_1;
}

# DEPRECATED routines

sub BANDWIDTH() {
    my $html = <<___EOB; $html =~ s/^ *//gm; # trim leading whitespace
    <p>Save our bandwidth - use a mirror!<br />
    <a href="http://www.mutopiaproject.org/" title="Main site in Canada"><b>Canada</b></a> |
    <a href="http://eremita.di.uminho.pt/mutopia/" title="Mirror in Portugal">Portugal</a>
    </p>
___EOB
    return $html;
}


sub BREAK {
    # When using HEAD and TAIL, use BREAK to start a new table.
    my $html = <<____EOH; $html =~ s/^ *//gm; # trim leading whitespace
    </div>

    <div class="main_section">
____EOH
    return $html;
}


# deprecated, replaced by template code.
sub TAIL($) {
    # returns index and disclaimer for bottom of document.  Puts
    # main body of document in a "window".  Must be used with HEAD.

    my $dontlinkto = shift;
    my $html = <<____EOH; $html =~ s/^ *//gm; # trim leading whitespace
    [[ BREAK() ]]

    <p class="link_list">
    [[ INDEX("$dontlinkto") ]]
    </p>

    <p class="disclaimer">Disclaimer: The Mutopia
    Project is run by volunteers, and the material within it is provided
    "as-is".  NO WARRANTY of any kind is made, including fitness
    for any particular purpose.<br />No claim is made as to the accuracy or the
    factual, editorial or musical correctness of any of the material
    provided here.</p>
    </div>

____EOH
    return $html;
}


# Create a list of links to the site's main pages. This is primarily
# used for navigation code.
sub INDEX($) {
    my $dontlinkto = shift;
    my $html = "";
    my @pages = ("index", "Home",
                 "browse", "Browse",
                 "advsearch", "Search",
                 "legal", "Licensing",
                 "contribute", "Contribute",
                 "projects", "In-Progress",
                 "contact", "Contact");

    # We don't want the current page to be made a link
    for (my $currpage = 0; $currpage < (@pages); $currpage += 2) {
        my $ref = "#";
        if ($pages[$currpage] eq $dontlinkto) {
            $html .= "<li class=\"active\">";
        } else {
            $html .= "<li>";
            $ref = $pages[$currpage] . ".html";
        }
        $html .= "<a href=\"$ref\">"
            . $pages[$currpage+1] . "</a></li>\n";
    }

    return $html;
}


#################################
# Non-English language support
# Moved here during HTML5 rework.
#################################


sub HEAD_DE($) {
    # returns nice index, to go at top of document.  Puts main body
    # of document in a table.  Must be used with TAIL.

    my $dontlinkto = shift;

    my $html = <<____EOH; $html =~ s/^ *//gm; # trim leading whitespace
    <table width="100%" border="0"><tr><td> </td></tr></table>

    <table border="1" width="95%" cellpadding="10" cellspacing="0"
       bgcolor="#edfaff" align="center" summary="Logo des Mutopia-Projektes
       und Links zu Mirrorsites"><tr>

    <td align="center"><img src="images/logo-small.png" alt="Logo des Mutopia-Projektes"
       width="186" height="61" /></td>
    <td align="center"><b>Die gesamte Musik aus dem Mutopia-Projekt kann frei
    heruntergeladen, ausgedruckt, aufgeführt und weitergegeben werden. Bisher
    sind <i>[[ NUMBER_OF_PIECES() ]]</i> Musikstücke vorhanden!</b></td>
    <td align="center">
    <table border="0" cellpadding="0" cellspacing="2">
    <tr><td align="center"><a href="http://www.MutopiaProject.org/">http://www.MutopiaProject.org/</a>
    </td><td align="center"><a href="http://www.MutopiaProject.org/"><img src="images/can.png" width="32" height="16" border="0" alt="Use server in Canada" /></a></td></tr>
    <tr><td align="center"><a href="http://ibiblio.org/mutopia/">http://ibiblio.org/mutopia/</a>
    </td><td align="center"><a href="http://ibiblio.org/mutopia/"><img src="images/usa.png" width="32" height="17" border="0" alt="Use server in the USA" /></a></td></tr>
    <tr><td align="center"><a href="http://mutopia-gd.tuwien.ac.at/">http://mutopia-gd.tuwien.ac.at/</a>
    </td><td align="center"><a href="http://mutopia-gd.tuwien.ac.at/"><img src="images/eu.png" width="32" height="21" border="0" alt="Use server in the EU" /></a></td></tr>
    <tr><td align="center"><a href="http://mutopia.planetmirror.com/">http://mutopia.planetmirror.com/</a>
    </td><td align="center"><a href="http://mutopia.planetmirror.com/"><img src="images/aus.png" width="32" height="16" border="0" alt="Use server in Australia" /></a></td></tr></table>
    </td>
    </tr>
    <tr><td colspan="3" align="center">

    [[ INDEX_DE("$dontlinkto") ]]

    [[ BREAK() ]]
____EOH
    return $html;
}


sub INDEXHEAD_DE {
    my $html = <<____EOH; $html =~ s/^ *//gm; # trim leading whitespace
    <p align="center"><b>Latest additions</b> (<a href="latestadditions.html">
       more...</a>)</p>
    <p>

    [[ LATEST_ADDITIONS(6) ]]

    </p>
    </td>

    <td align="center">
    <form action="cgibin/make-table.cgi" method="get">
    <input type="text" name="searchingfor" size="30" />
    <input type="submit" value="Search" />
    </form>
    <p><a href="piece-list.de.html">Alle Stücke anzeigen </a></p>
    <p>Alternatively try an <a href="advsearch.de.html">advanced search</a>,<br />
       or browse by... <a href="browse.de.html#byComposer">Composer</a>,
       <a href="browse.de.html#byInstrument">Instrument</a><br />
       or <a href="browse.de.html#byStyle">Musical Style</a></p>
    <!--<p><a href="http://www.cs.helsinki.fi/group/cbrahms/demoengine/">Search by melody with C-Brahms melody-based search</a></p>-->

    [[ BREAK() ]]
____EOH
    return $html;
}


sub TAIL_DE($) {
    # returns index and disclaimer for bottom of document.  Puts
    # main body of document in a "window".  Must be used with HEAD.

    my $dontlinkto = shift;
    my $html = <<____EOH; $html =~ s/^ *//gm; # trim leading whitespace
    [[ BREAK() ]]

    <!-- XXX Valid XHTML button -->
    <p align="center">

    [[ INDEX_DE("$dontlinkto") ]]

    </p>
	<p><font size="-1em"><b>Disclaimer: The Mutopia
    Project is run by volunteers, and the material within it is provided
    "as-is".  NO WARRANTY of any kind is made, including fitness
    for any particular purpose.  No claim is made as to the accuracy or the
    factual, editorial or musical correctness of any of the material
    provided here.</b></font></p>
    </td></tr></table>

    <!-- Spacer table -->
    <table width="100%" border="0"><tr><td> </td></tr></table>

____EOH
    return $html;
}

sub INDEX_DE($) {
    my $dontlinkto = shift;
    my $html = "";
    my $currpage = 0;

    my @pages = ("index", "Startseite",
                 "browse", "Archiv durchblättern",
                 "advsearch", "Erweiterte Suche",
                 "help", "Hilfe",
                 "legal", "Rechtliche Angelegenheiten",
                 "contribute", "Etwas beitragen",
                 "newsletters", "Newsletter",
                 "projects", "In Arbeit");

    # We don't want the current page to be made a link
    for($currpage = 0; $currpage < (@pages); $currpage += 2) {
        if ($pages[$currpage] eq $dontlinkto) {
            $html = $html . $pages[$currpage+1];
        } else {
            $html = $html . "<a href=\"" . $pages[$currpage] . ".de.html\">" .
                $pages[$currpage+1] . "</a>";
        }

        # The last link on the line doesn't want a "|" after it; the rest do
        if ($currpage != (@pages) - 2) { $html = $html . " |\n" }
        else { $html = $html . "\n" }
    }

    return $html;
};


1;

__END__

=head1 NAME

Mutopia_HTMLGen - routines to help with generating HTML pages

=head1 DESCRIPTION

It is best to think of this module as a very basic templating system.
All templates have an extension that ends in C<-in>, typically either
C<.html-in> or C<.rss-in> and may contain directives of the form,

=begin

    [[ DIRECTIVE-NAME() ]]

=end

When the template processor encounters this token, the enclosing
bracket tags are stripped off, the directive is called as a perl
subroutine, and the output is inserted into the template at that
point.

The output filename is derived from input name with the C<-in>
stripped from off.

=over

=item makeHTML()

Walk through B<all> input files (*.html-in and *.rss-in) and process
them, passing input to output and calling directives as they are
encountered.

=item replace_placeholders(infile)

Translate a directive name into a perl subroutine call. Kind of magic.

=item BROWSE_BY_COMPOSER()

=item BROWSE_BY_INSTRUMENT()

=item BROWSE_BY_STYLE()

=item BROWSE_COLLECTIONS()

=item COMPOSER_OPTIONS()

=item COMPOSER_LIST()

=item INSTRUMENT_OPTIONS()

=item STYLE_OPTIONS()

=item STYLE_LIST()

=item NUMBER_OF_PIECES()

=item LATEST_ADDITIONS($)

=item LATEST_ADDITIONS_RSS($)

=item ALL_PIECES()

=item INCLUDE($infile)

Read a file into the input stream. The given input file is checked for
existence and, if not found, the string is prepended with 
C<"$webroot/html-in/"> and the open is attempted.  ($webroot is the
MUTOPIA_WEB environment variable.)

Note that because all template files C<*.html-in> and C<*.rss-in> are
processed in C<makeHTML>, include files cannot have the extension,
C<.html-in>. Include file names can have any extension that doesn't
end in C<-in> but the preferred extension is C<.html-include>.

=back

=cut
