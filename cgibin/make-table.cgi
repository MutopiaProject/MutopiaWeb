#!/usr/bin/perl -wT

# The "shebang" line above may have to be changed in a Windows environment:
#
#	#!perl -wT

use strict;
use POSIX;
use utf8;
# since we aren't sure what the environment is for the site, make sure
# that our common module can be loaded.
my $rundir;
BEGIN {
    $rundir = ( (-e './HTMLcommon.pm') ? '.' : './cgibin');
}
use lib "$rundir";
use HTMLcommon;

binmode(STDOUT, ":utf8");

my %FORM = HTMLcommon::queryArgs();

# not used?
#open FTPB, '../ftpbase.dat';
#chomp($ftpbase = <FTPB>);
#close FTPB;

my $baseref = $HTMLcommon::FTPBASE;

my $EMPTY_CELL = "<td>&nbsp;</td>";
my $matchCount = -1;

HTMLcommon::startPage("Music Listing - "
                      . ($FORM{'preview'} ? "with" : "without")
                      . " preview images");

# Check if the user narrowed the search to recent history and whether
# it was weeks or days.
my $earliesttime = 0;
if ($FORM{'recent'} and $FORM{'recent'} == 1) {
    # Narrowing by time, check form requirements
    if ($FORM{'timelength'} && $FORM{'timelength'}) {
        if ($FORM{'timelength'} eq '') {
            $earliesttime = time;
        }
        else {
            my $timelen = $FORM{'timelength'};
            if ($FORM{'timeunit'} eq 'week') {
                $earliesttime = time - $timelen * 604800;
            }
            elsif ($FORM{'timeunit'} eq 'day') {
                $earliesttime = time - $timelen * 86400;
            }
            # else input form is borken
        }
    }
}

print qq(<table class="outer-table">\n);

if (!open( CACHE, '<:utf8', "../datafiles/musiccache.dat" )) {
    print qq(<div class="alert alert-danger" role="alert">\n);
    print qq(  <strong>Error:</strong> Failed to open the music cache.\nMessage is "$!".\n);
    print "</div>\n";
    last;
}

# Read the cache into local variables.
$matchCount = 0;
my $pageMax = $HTMLcommon::PAGE_MAX;
my $pageCount = 0;
my $startAt = $FORM{'startat'} || 0;
chomp(my $headerlength = <CACHE>);
seek CACHE, $headerlength, 0;
until (eof CACHE || $pageCount >= $startAt + $pageMax) {
    chomp(my $checkline = <CACHE>);
    if ($checkline ne '**********') {
        print qq(<div class="alert alert-danger" role="alert">\n);
        print qq(  <strong>Error:</strong> Illegal format in the datafile - cache needs to be rebuilt.\n);
        print "</div>\n";
        close(CACHE);
        # Modify the match count so the user doesn't get a second
        # alert saying that no matches were found.
        $matchCount = -1;
        last;
    }
    chomp(my $idno = <CACHE>);
    chomp(my $midrif = <CACHE>);
    chomp(my $musicnm = <CACHE>);
    chomp(my $lyfile = <CACHE>);
    chomp(my $midfile = <CACHE>);
    chomp(my $a4psfile = <CACHE>);
    chomp(my $a4pdffile = <CACHE>);
    chomp(my $letpsfile = <CACHE>);
    chomp(my $letpdffile = <CACHE>);
    chomp(my $pngfile = <CACHE>);
    chomp(my $pngheight = <CACHE>);
    chomp(my $pngwidth = <CACHE>);
    chomp(my $title = <CACHE>);
    chomp(my $composer = <CACHE>);
    chomp(my $opus = <CACHE>);
    chomp(my $lyricist = <CACHE>);
    chomp(my $instrument = <CACHE>);
    chomp(my $date = <CACHE>);
    chomp(my $style = <CACHE>);
    chomp(my $metre = <CACHE>);
    chomp(my $arranger = <CACHE>);
    chomp(my $source = <CACHE>);
    chomp(my $copyright = <CACHE>);
    chomp(my $id = <CACHE>);
    chomp(my $maintainer = <CACHE>);
    chomp(my $maintaineremail = <CACHE>);
    chomp(my $maintainerweb = <CACHE>);
    chomp(my $extrainfo = <CACHE>);
    chomp(my $lilypondversion = <CACHE>);
    chomp(my $collections = <CACHE>);
    chomp(my $printurl = <CACHE>);

    # Filter on composer, if present. Note that $midrif is actually
    # the ftp filespec (e.g., "AguadoD/OP3"). The Composer in the form
    # is given as our internal naming ("AguadoD") so only the first
    # part of the string is matched.
    next unless $FORM{'Composer'} ? $midrif =~ m[^$FORM{'Composer'}/] : 1;

    my $upyear = substr($id, 8, 4);
    my $upmonth = substr($id, 13, 2);
    my $upday = substr($id, 16, 2);
    my $update = mktime(59, 59, 23, $upday, $upmonth - 1, $upyear - 1900);

    # filter based on time span
    next unless ($update > $earliesttime);

    my $go = 1;

    if ($FORM{'searchingfor'}) {
        $FORM{'searchingfor'} =~ tr/a-z/A-Z/;
        if ($FORM{'searchingfor'} ne '') {
            my @searchlist = split(/ /, $FORM{'searchingfor'}, 0);
            my $keywords = join('|',
                                $title, $composer, $opus,
                                $lyricist, $instrument,
                                $date, $style, $metre, $arranger,
                                $source, $copyright, $id,
                                $maintainer, $maintaineremail,
                                $maintainerweb, $extrainfo,
                                $lilypondversion, $collections);
            foreach my $searchitem (@searchlist) {
                if (!(uc($keywords) =~ $searchitem)) {
                    $go = 0;
                    last;
                }
            }
        }
    }

    # Lilypond version check
    if ($FORM{'lilyversion'}) {
        my $okToCheckVersion = 0;
        my ($maj, $min, $tin);
        if ($lilypondversion =~ /^([0-9])\.([0-9]+)\.([0-9]+)/) {
            $maj = $1;
            $min = $2;
            $tin = $3;
            $okToCheckVersion = 1;
        }
        if ($okToCheckVersion == 1 and $go == 1) {
            if ($FORM{'lilyversion'} =~ /^([0-9])\.([0-9]+)\.([0-9]+)$/) {
                if ($maj != $1 or $min != $2 or $tin != $3) {
                    $go = 0;
                }
            }
            elsif ($FORM{'lilyversion'} =~ /^([0-9])\.([0-9]+)$/) {
                if ($maj != $1 or $min != $2) {
                    $go = 0;
                }
            }
            elsif ($FORM{'lilyversion'} =~ /^([0-9])$/) {
                if ($maj != $1) {
                    $go = 0;
                }
            }
        }
    }

    if ($FORM{'printav'}) {
        if ($go == 1 and $FORM{'printav'} == 1) {
            if ($printurl eq '') {
                $go = 0;
            }
        }
    }

    if ($FORM{'Instrument'}) {
        if ($go == 1 and $FORM{'Instrument'} eq 'Harp' and $instrument =~ /Harpsichord/) {
            $go = 0;
        }
    }
    if ($FORM{'solo'}) {
        if ($go == 1 and $FORM{'solo'} == 1 and $instrument =~ /[Dd]uet/ || $instrument =~ /[Tt]rio/ || $instrument =~ /[Qq]uartet/ || $instrument =~ /[Qq]uintet/ || $instrument =~ /Orchestra/ || $instrument =~ /[Ee]nsemble/ || $instrument =~ / and / || $instrument =~ /SATB/ || $instrument =~ /accompan/ || $instrument =~ /[0-9]/) {
            $go = 0;
        }
    }
    next unless $go;

    # Apply remaining filters in the input form
    next unless $FORM{'Instrument'} ? ($instrument =~ /$FORM{'Instrument'}/) : 1;
    next unless $FORM{'Style'} ? ($style eq $FORM{'Style'}) : 1;
    next unless $FORM{'id'} ? ($id =~ /-$FORM{'id'}$/) : 1;
    next unless $FORM{'collection'} ? ($collections =~ /(^|,)$FORM{'collection'}(,|$)/) : 1;

	# All filtering is done, but we may need to skip for pagination
	$pageCount++;
	next if $pageCount <= $startAt;
	
    # A match if we got this far. 
    $matchCount++;

    print qq(<tr><td>\n);       # start a row within the outer table
    print qq(<table class="table-bordered result-table">\n);

    # Add preview if requested. The image is presented as a table cell
    # that spans all 4 columns
    if ($FORM{'preview'} && $FORM{'preview'} == 1) {
        print qq(<tr class="preview"><td colspan="4" align="center">);
        print qq(<img src="$baseref$midrif$musicnm/$pngfile" );
        print qq(height="$pngheight" width="$pngwidth" alt="Preview image" />);
        print qq(</td></tr>\n);
    }
    print "<tr>";
    print qq(<td>$title</td>\n);
    if ($composer eq 'Anonymous' or $composer eq 'Traditional') {
        print qq(<td>$composer</td>\n);
    }
    else {
        print qq(<td>by $composer</td>\n);
    }
    print ($opus ne '' ? qq(<td>$opus</td>\n) : "$EMPTY_CELL\n" );

    if ($lyricist eq 'n/a') {
        print "<td><i>n/a</i></td>\n";
    }
    elsif ($lyricist ne '') {
        print "<td>$lyricist</td>\n";
    }
    else {
        print "$EMPTY_CELL\n";
    }
    print "</tr><tr>\n";
    print "<td>for $instrument</td>\n";

    print ($date ne '' ? qq(<td>$date</td>\n) : "$EMPTY_CELL\n" );
    print "<td>$style</td>\n";
    if ($arranger eq 'n/a') {
        print "<td><i>n/a</i></td>\n";
    }
    else {
        print "<td>$arranger</td>\n";
    }
    print "</tr><tr>\n";
    print ($source ne '' ? qq(<td>$source</td>\n) : "$EMPTY_CELL\n");

    if ($copyright eq 'Public Domain') {
        print qq[<td><a href="../legal.html#publicdomain">Public Domain</a></td>\n];
    }
    elsif ($copyright eq 'Creative Commons Attribution-ShareAlike') {
        print '<td><a href="../legal.html#ccasa">';
        print "Creative Commons Attribution-ShareAlike</a></td>\n";
    }
    elsif ($copyright eq 'Creative Commons Attribution-ShareAlike 2.0') {
        print '<td><a href="../legal.html#ccasa">';
        print "Creative Commons Attribution-ShareAlike 2.0</a></td>\n";
    }
    elsif ($copyright eq 'Creative Commons Attribution-ShareAlike 2.5') {
        print '<td><a href="../legal.html#ccasa">';
        print "Creative Commons Attribution-ShareAlike 2.5</a></td>\n";
    }
    elsif ($copyright eq 'Creative Commons Attribution-ShareAlike 3.0') {
        print '<td><a href="../legal.html#ccasa">';
        print "Creative Commons Attribution-ShareAlike 3.0</a></td>\n";
    }
    elsif ($copyright eq 'Creative Commons Attribution-ShareAlike 4.0') {
        print '<td><a href="../legal.html#ccasa">';
        print "Creative Commons Attribution-ShareAlike 4.0</a></td>\n";
    }
    elsif ($copyright eq 'Creative Commons Attribution 2.5') {
        print '<td><a href="../legal.html#cca">';
        print "Creative Commons Attribution 2.5</a></td>\n";
    }
    elsif ($copyright eq 'Creative Commons Attribution 3.0') {
        print '<td><a href="../legal.html#cca">';
        print "Creative Commons Attribution 3.0</a></td>\n";
    }
    elsif ($copyright eq 'Creative Commons Attribution 4.0') {
        print '<td><a href="../legal.html#cca">';
        print "Creative Commons Attribution 4.0</a></td>\n";
    }
    else {
        print "$EMPTY_CELL\n";
    }
    print '<td><a href="piece-info.cgi?';
    print qq[id=$idno">More Information</a></td>\n];
    print "<td>$upyear/$upmonth/$upday</td>\n";
    print "</tr><tr>\n";
    if ($lyfile =~ /\.zip$/) {
        print '<td class="zipped">Download: <a href="';
        print qq[$baseref$midrif$musicnm/$lyfile">.ly files (zipped)</a></td>\n];
    }
    else {
        print '<td>Download: <a href="';
        print qq[$baseref$midrif$musicnm/$lyfile">.ly file</a></td>\n];
    }
    if ($midfile =~ /\.zip$/) {
        print '<td class="zipped"><a href="';
        print qq[$baseref$midrif$musicnm/$midfile">.mid files (zipped)</a></td>\n];
    }
    else {
        print '<td><a href="';
        print qq[$baseref$midrif$musicnm/$midfile">.mid file</a></td>\n];
    }
    print qq(<td><a href="$baseref$midrif$musicnm/$pngfile">Preview image</a></td>\n);
    print qq[<td><a href="$baseref$midrif$musicnm/">Appropriate FTP area</a></td>\n</tr><tr>\n];
    if ($a4psfile =~ /\.zip$/) {
        print qq(<td class="zipped"><a href="$baseref$midrif$musicnm/$a4psfile">A4 .ps files (zipped)</a></td>\n);
        print qq(<td class="zipped"><a href="$baseref$midrif$musicnm/$a4pdffile">A4 .pdf files (zipped)</a></td>\n);
        print qq(<td class="zipped"><a href="$baseref$midrif$musicnm/$letpsfile">Letter .ps files (zipped)</a></td>\n);
        print qq(<td class="zipped"><a href="$baseref$midrif$musicnm/$letpdffile">Letter .pdf files (zipped)</a></td>\n);
    }
    else {
        if ($a4pdffile =~ /\.gz$/) {
            print qq(<td class="gzipped"><a href="$baseref$midrif$musicnm/$a4psfile">A4 .ps file (gzipped)</a></td>\n);
            print qq(<td class="gzipped"><a href="$baseref$midrif$musicnm/$a4pdffile">A4 .pdf file (gzipped)</a></td>\n);
            print qq(<td class="gzipped"><a href="$baseref$midrif$musicnm/$letpsfile">Letter .ps file (gzipped)</a></td>\n);
            print qq(<td class="gzipped"><a href="$baseref$midrif$musicnm/$letpdffile">Letter .pdf file (gzipped)</a></td>\n);
        }
        else {
            print qq(<td><a href="$baseref$midrif$musicnm/$a4psfile">A4 .ps file (gzipped)</a></td>\n);
            print qq(<td><a href="$baseref$midrif$musicnm/$a4pdffile">A4 .pdf file</a></td>\n);
            print qq(<td><a href="$baseref$midrif$musicnm/$letpsfile">Letter .ps file (gzipped)</a></td>\n);
            print qq(<td><a href="$baseref$midrif$musicnm/$letpdffile">Letter .pdf file</a></td>\n);
        }
    }
    print qq(</tr>\n</table>\n); # inner cell
    print qq(</tr></td>\n);      # outer table row element
}

if ($matchCount == 0) {
    print qq(<div class="alert alert-info" role="alert">\n);
    print qq(  Sorry, no matches were found for your search criteria.\n);
    print "</div>\n";
}

print qq(</table>\n);           # outer-table

print "<a href=\"make-table.cgi?startat=$pageCount"
		. "&searchingfor=$FORM{'searchingfor'}"
		. "&Composer=$FORM{'Composer'}"
		. "&Instrument=$FORM{'Instrument'}"
		. "&Style=$FORM{'Style'}"
		. "&timelength=$FORM{'timelength'}"
		. "&timeunit=$FORM{'timeunit'}"
		. "&lilyversion=$FORM{'lilyversion'}"
		. "&preview=$FORM{'preview'}\""
		. ">Next $pageMax</a>\n"
		unless eof CACHE;

close CACHE;

HTMLcommon::finishPage();
