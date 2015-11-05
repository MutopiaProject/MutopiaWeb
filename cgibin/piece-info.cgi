#!/usr/bin/perl -wT

use strict;
use POSIX;

my @pairs = split(/\&/, $ENV{'QUERY_STRING'}, 0);
my %FORM;
foreach my $pair (@pairs) {
    my ($name, $value) = split(/=/, $pair, 3);
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack 'C', hex $1;/eg;
    $FORM{$name} = $value;
}

my $cacheoffset;
open CACHE, '../datafiles/musiccache.dat';
chomp($cacheoffset = <CACHE>);

my $baseref = '../ftp/';

my $firstjump = 13 * $FORM{'id'} + 5;
my $secondjump;
my $problem;

seek CACHE, $firstjump, 0;
read CACHE, $secondjump, 7;
if ($secondjump eq '*******' or $firstjump > $cacheoffset) {
    $problem = 1;
}
else {
    $problem = 0;
    seek CACHE, $cacheoffset + $secondjump, 0;
}

chomp(my $id = <CACHE>);

if ($problem == 0 and $id ne $FORM{'id'}) {
    $problem = 2;
}

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
chomp(my $for = <CACHE>);
chomp(my $date = <CACHE>);
chomp(my $style = <CACHE>);
chomp(my $metre = <CACHE>);
chomp(my $arranger = <CACHE>);
chomp(my $source = <CACHE>);
chomp(my $licence = <CACHE>);
chomp(   $id = <CACHE>);
chomp(my $maintainer = <CACHE>);
chomp(my $maintaineremail = <CACHE>);
chomp(my $maintainerweb = <CACHE>);
chomp(my $moreinfo = <CACHE>);
chomp(my $lilypondversion = <CACHE>);
chomp(my $collections = <CACHE>);
chomp(my $printurl = <CACHE>);
close CACHE;

if ($problem == 0) {
    if ($source eq '') {
        $source = '<i>Not known</i>';
    }
    if ($date eq '') {
        $date = '<i>Not known</i>';
    }
    my $licence = '';
    my $ccmetadata = '';
    if ($licence eq 'Public Domain') {
        $licence = qq[<a href="../legal.html#publicdomain">Public Domain</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/publicdomain/"><img src="../images/cc.primary.nrr.gif" alt="CC: No rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/pd.rdf" type="application/rdf+xml" />\n];
    }
    elsif ($licence eq 'Creative Commons Attribution-ShareAlike') {
        $licence = qq[<a href="../legal.html#ccasa">Creative Commons Attribution-ShareAlike</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/by-sa/1.0/"><img src="../images/cc.primary.srr.gif" alt="CC: Some rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/asa.rdf" type="application/rdf+xml" />\n];
    }
    elsif ($licence eq 'Creative Commons Attribution-ShareAlike 2.0') {
        $licence = qq[<a href="../legal.html#ccasa">Creative Commons Attribution-ShareAlike 2.0</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/by-sa/2.0/"><img src="../images/cc.primary.srr.gif" alt="CC: Some rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/asa2.rdf" type="application/rdf+xml" />\n];
    }
    elsif ($licence eq 'Creative Commons Attribution-ShareAlike 2.5') {
        $licence = qq[<a href="../legal.html#ccasa">Creative Commons Attribution-ShareAlike 2.5</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/by-sa/2.5/"><img src="../images/cc.primary.srr.gif" alt="CC: Some rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/asa25.rdf" type="application/rdf+xml" />\n];
    }
    elsif ($licence eq 'Creative Commons Attribution-ShareAlike 3.0') {
        $licence = qq[<a href="../legal.html#ccasa">Creative Commons Attribution-ShareAlike 3.0</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/by-sa/3.0/"><img src="../images/cc.primary.srr.gif" alt="CC: Some rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/asa3.rdf" type="application/rdf+xml" />\n];
    }
    elsif ($licence eq 'Creative Commons Attribution-ShareAlike 4.0') {
        $licence = qq[<a href="../legal.html#ccasa">Creative Commons Attribution-ShareAlike 4.0</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/by-sa/4.0/"><img src="../images/cc.primary.srr.gif" alt="CC: Some rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/asa4.rdf" type="application/rdf+xml" />\n];
    }
    elsif ($licence eq 'Creative Commons Attribution 2.5') {
        $licence = qq[<a href="../legal.html#cca">Creative Commons Attribution 2.5</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/by/2.5/"><img src="../images/cc.primary.srr.gif" alt="CC: Some rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/a25.rdf" type="application/rdf+xml" />\n];
    }
    elsif ($licence eq 'Creative Commons Attribution 3.0') {
        $licence = qq[<a href="../legal.html#cca">Creative Commons Attribution 3.0</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/by/3.0/"><img src="../images/cc.primary.srr.gif" alt="CC: Some rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/a3.rdf" type="application/rdf+xml" />\n];
    }
    elsif ($licence eq 'Creative Commons Attribution 4.0') {
        $licence = qq[<a href="../legal.html#cca">Creative Commons Attribution 4.0</a>\n &nbsp;&nbsp;&nbsp;<a href="http://creativecommons.org/licenses/by/4.0/"><img src="../images/cc.primary.srr.gif" alt="CC: Some rights reserved" width="88" height="31" border="0" style="vertical-align: middle;" /></a>];
        $ccmetadata = qq[<link rel="meta" href="../cc-rdfs/a4.rdf" type="application/rdf+xml" />\n];
    }
    my $software;
    if ($lilypondversion eq '') {
        $software = '<i>Not known</i>';
    }
    else {
        $software = qq[<a href="http://www.lilypond.org">LilyPond</a>, version $lilypondversion];
    }
    my @collectionName;
    my @collectionKey;
    my $collectionData;
    my $noOfCollections;
    for ($noOfCollections = 0; $collections ne ''; ++$noOfCollections) {
        if (index($collections, ',') == -1) {
            $collectionKey[$noOfCollections] = $collections;
            $collections = '';
        }
        else {
            $collectionKey[$noOfCollections] = substr($collections, 0, index($collections, ','));
            $collections = substr($collections, index($collections, ',') + 1);
        }
        open COLLECTION, '../datafiles/collections.dat';
        do {
            chomp($collectionData = <COLLECTION>)
        } until $collectionData =~ /^$collectionKey[$noOfCollections]:/ or eof COLLECTION;
        close COLLECTION;
        my $startOfTitle = index($collectionData, ':') + 1;
        my $lengthOfTitle = index($collectionData, ':', $startOfTitle) - $startOfTitle;
        $collectionName[$noOfCollections] = substr($collectionData, $startOfTitle, $lengthOfTitle);
    }
    my $printurlshop = '';
    my $printurlimg = '';
    my $printurlimgwidth = '';
    my $printurlimgheight = '';
    my $printurlurl = '';
    if ($printurl ne '') {
        my $startOfImg = index($printurl, ':') + 1;
        my $startOfWidth = index($printurl, ':', $startOfImg) + 1;
        my $startOfHeight = index($printurl, ':', $startOfWidth) + 1;
        my $startOfURL = index($printurl, ':', $startOfHeight) + 1;
        my $printurlshop = substr($printurl, 0, $startOfImg - 1);
        my $printurlimg = substr($printurl, $startOfImg, $startOfWidth - $startOfImg - 1);
        my $printurlimgwidth = substr($printurl, $startOfWidth, $startOfHeight - $startOfWidth - 1);
        my $printurlimgheight = substr($printurl, $startOfHeight, $startOfURL - $startOfHeight - 1);
        my $printurlurl = substr($printurl, $startOfURL);
    }
    my $upyear = substr($id, 8, 4);
    my $upmonth = substr($id, 13, 2);
    my $upday = substr($id, 16, 2);
    my(@month) = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
    my $month = $month[$upmonth - 1];
    print "Content-type:text/html\n\n";
    print qq[<?xml version="1.0" encoding="UTF-8"?>\n];
    print "<!DOCTYPE html\n";
    print qq[     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n];
    print qq[    "DTD/xhtml1-transitional.dtd">\n];
    print qq[<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n\n];
    if ($composer eq 'Anonymous' or $composer eq 'Traditional') {
        print "<head><title>$title ($composer)</title>\n";
    }
    else {
        print "<head><title>$title, by $composer</title>\n";
    }
    print '<meta content="text/html; charset=utf-8" ';
    print qq[http-equiv="Content-Type" />\n];
    print $ccmetadata;
    print "</head>\n";
    print qq[<body bgcolor="white">\n];
    print "<center>\n";
    print "<h2>$title</h2>\n";
    if ($composer eq 'Anonymous' or $composer eq 'Traditional') {
        print "<h4>($composer)</h4>\n\n";
    }
    else {
        print "<h4>by $composer</h4>\n\n";
    }
    print "<br /><br />\n\n";
    print qq[<img src="$baseref$midrif$musicnm/$pngfile" ];
    print qq[height="$pngheight" width="$pngwidth" border="0" ];
    print qq[alt="Music preview" />\n];
    print "<br /><br />\n\n";
    if ($printurlurl ne '') {
        print qq[<table align="center" border="1" cellpadding="0" cellspacing="0"><tr>\n];
        print qq[<td><table border="0" cellpadding="5" cellspacing="10"><tr>\n];
        print qq[<td><font size="+2"><b>New!</b></font></td>\n];
        print qq[<td><a href="$printurlurl">Buy printed sheet music of this piece</a> from $printurlshop.</td>\n];
        if ($printurlimg ne '') {
            print qq[<td><a href="$printurlurl"><img src="$printurlimg" border="0" width="$printurlimgwidth" height="$printurlimgheight" alt="Shop logo" /></a></td>\n];
        }
        print "</tr></table>\n";
        print "</td></tr></table>\n\n";
        print "<br /><br />\n\n";
    }
    print '<table align="center" border="1" width="90%" bgcolor="#fffee8" ';
    print qq[cellpadding="5" cellspacing="0">\n];
    print "<tr><td><b>Instrument(s):</b> $for</td>\n";
    print "<td><b>Style:</b> $style</td></tr>\n";
    if ($lyricist eq '' and $arranger eq '') {
        ();
    }
    elsif ($lyricist eq '<i>n/a</i>' and $arranger eq '<i>n/a</i>') {
        ();
    }
    else {
        print '<tr><td>';
        if ($lyricist ne '') {
            print "<b>Lyricist(s):</b> $lyricist";
        }
        else {
            print '&nbsp;';
        }
        print "</td>\n";
        print '<td>';
        if ($arranger ne '') {
            print "<b>Arranger(s):</b> $arranger";
        }
        else {
            print '&nbsp;';
        }
        print "</td></tr>\n";
    }
    if ($opus eq '') {
        if ($metre eq '') {
            print "<tr><td><b>Opus:</b> <i>Not known</i></td>\n";
        }
        else {
            print "<tr><td><b>Meter:</b> $metre</td>\n";
        }
    }
    else {
        if ($metre eq '') {
            print "<tr><td><b>Opus:</b> $opus</td>\n";
        }
        else {
            print "<tr><td><b>Opus:</b> $opus, <b>Meter:</b> $metre</td>\n";
        }
    }
    print "<td><b>Date of composition:</b> $date</td></tr>\n";
    print "<tr><td><b>Source:</b> $source</td>\n";
    print "<td><b>Copyright:</b> $licence</td></tr>\n";
    print "<tr><td><b>Last updated:</b> $upyear/$month/$upday";
    print qq[. <a href="$baseref$midrif$musicnm/$musicnm.log">View change history</a>];
    print "</td>\n";
    print "<td><b>Music ID Number:</b> $id</td></tr>\n";
    print "<tr><td><b>Typeset using:</b> $software</td>\n";
    if ($noOfCollections > 0) {
        print '<td><b>Part of the following collections:</b> ';
        for (my $collection = 0; $collection < $noOfCollections; ++$collection) {
            print '<a href="make-table.cgi?collection=' . $collectionKey[$collection] . '&amp;preview=1">';
            print $collectionName[$collection] . '</a>';
            if ($collection < $noOfCollections - 1) {
                print ', ';
            }
        }
        print "</td></tr>\n";
    }
    else {
        print "<td>\302\240</td></tr>\n"; # FIXTHIS
    }
    print "</table>\n\n";
    print "<br /><br />\n\n";
    print '<table align="center" border="1" width="90%" bgcolor="#fefefe" ';
    print qq[cellpadding="5" cellspacing="0">\n];
    print qq[<tr><td colspan="3"><b>Download:</b></td></tr>\n];
    print "<tr>\n";
    if ($lyfile =~ /\.ly$/) {
        print qq[<td><a href="$baseref$midrif$musicnm/$lyfile">];
        print "LilyPond file</a></td>\n";
    }
    else {
        print qq[<td><a href="$baseref$midrif$musicnm/$lyfile">];
        print "LilyPond files (zipped)</a></td>\n";
    }
    if ($midfile =~ /\.mid$/) {
        print qq[<td><a href="$baseref$midrif$musicnm/$midfile">];
        print "MIDI file</a></td>\n";
    }
    else {
        print qq[<td><a href="$baseref$midrif$musicnm/$midfile">];
        print "MIDI files (zipped)</a></td>\n";
    }
    print "</tr>\n<tr>\n";
    if ($a4pdffile =~ /\.zip$/) {
        print qq[<td><a href="$baseref$midrif$musicnm/$a4pdffile">];
        print "A4 PDF files (zipped)</a></td>\n";
        print qq[<td><a href="$baseref$midrif$musicnm/$letpdffile">];
        print "Letter PDF files (zipped)</a></td>\n";
    }
    else {
        print qq[<td><a href="$baseref$midrif$musicnm/$a4pdffile">];
        print "A4 PDF file</a></td>\n";
        print qq[<td><a href="$baseref$midrif$musicnm/$letpdffile">];
        print "Letter PDF file</a></td>\n";
    }
    print "</tr>\n</table>\n\n";
    print "<br /><br />\n\n";
    if ($moreinfo ne '') {
        print '<table align="center" border="1" width="90%" bgcolor="#e8e8ff" ';
        print qq[cellpadding="5" cellspacing="0">\n];
        print "<tr><td>$moreinfo</td></tr></table>\n\n";
        print "<br /><br />\n\n";
    }
    if ($noOfCollections > 0) {
        for (my $collection = 0; $collection < $noOfCollections; ++$collection) {
            my $collectFile = '../collections/' . $collectionKey[$collection] . '/collection-info.dat';
            if (-r $collectFile) {
                print '<table align="center" border="1" width="90%" bgcolor="#e8ffe8" ';
                print qq[cellpadding="5" cellspacing="0">\n<tr><td>];
                print '<center><b>' . $collectionName[$collection] . '</b></center>';
                open COLLECTIONDATA, $collectFile;
                do {
                    chomp(my $collectionLine = <COLLECTIONDATA>);
                    print $collectionLine . "\n"
                } until eof COLLECTIONDATA;
                close COLLECTION;
                print "</td></tr></table>\n\n";
                print "<br /><br />\n\n";
            }
        }
    }
    print '<table align="center" border="1" width="90%" bgcolor="#ffe8e8" ';
    print qq[cellpadding="5" cellspacing="0">\n];
    print "<tr>\n<td><b>Maintainer:</b> $maintainer</td>\n";
    if ($maintaineremail =~ /@/) {
        $maintaineremail =~ s/\@/ (at) /;
        print "<td>$maintaineremail</td>\n";
    }
    elsif ($maintaineremail ne '') {
        print "<td>$maintaineremail</td>\n";
    }
    if ($maintainerweb ne '') {
        print qq[<td><a href="$maintainerweb">$maintainerweb</a></td>\n];
    }
    print "</tr>\n</table>\n\n";
    print "<br /><br />\n\n";
    print '<table align="center" border="0" width="90%" bgcolor="#fefefe" ';
    print qq[cellpadding="5" cellspacing="0">\n];
    print qq[<tr>\n<td align="center">Free music from <a href="http://www.mutopiaproject.org">Mutopia Project</a></td>\n];
    print "</tr>\n</table>\n\n";
    print "</center></body>\n</html>\n";
}
elsif ($problem == 1) {
    print "Content-type:text/html\n\n";
    print qq[<?xml version="1.0" encoding="UTF-8"?>\n];
    print "<!DOCTYPE html\n";
    print qq[     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n];
    print qq[    "DTD/xhtml1-transitional.dtd">\n];
    print qq[<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n\n];
    print "<head><title>Mutopia Error</title></head>\n";
    print qq[<body bgcolor="#ffffff">\n\n];
    print '<p>The piece you have requested information on does not ';
    print 'seem to exist. If you followed a link, please inform the person whose ';
    print "link you followed.</p>\n\n</body></html>\n";
}
elsif ($problem == 2) {
    print "Content-type:text/html\n\n";
    print qq[<?xml version="1.0" encoding="UTF-8"?>\n];
    print "<!DOCTYPE html\n";
    print qq[     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n];
    print qq[    "DTD/xhtml1-transitional.dtd">\n];
    print qq[<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n\n];
    print "<head><title>Mutopia Error</title></head>\n";
    print qq[<body bgcolor="#ffffff">\n\n];
    print '<p>Internal system error: Mutopia cache needs to be rebuilt.</p>';
    print "\n\n</body></html>\n";
}
else {
    print "Content-type:text/html\n\n";
    print qq[<?xml version="1.0" encoding="UTF-8"?>\n];
    print "<!DOCTYPE html\n";
    print qq[     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n];
    print qq[    "DTD/xhtml1-transitional.dtd">\n];
    print qq[<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n\n];
    print "<head><title>Mutopia Error</title></head>\n";
    print qq[<body bgcolor="#ffffff">\n\n];
    print '<p>Unknown internal system error</p>';
    print "\n\n</body></html>\n";
}
