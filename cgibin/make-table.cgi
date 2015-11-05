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

# not used?
#open FTPB, '../ftpbase.dat';
#chomp($ftpbase = <FTPB>);
#close FTPB;

open CACHE, '../datafiles/musiccache.dat';

my $baseref = '../ftp/';
my $matchCount = 0;
print "Content-type:text/html\n\n";
print qq[<?xml version="1.0" encoding="UTF-8"?>\n];
print "<!DOCTYPE html\n";
print qq[     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n];
print qq[    "DTD/xhtml1-transitional.dtd">\n];
print qq[<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n\n];
my $w_or_wout = ($FORM{'preview'} ? "with" : "without" );
print qq[<head><title>Music Listing - $w_or_wout preview images</title>\n];
print qq[<meta content="text/html; charset=utf-8"];
print qq[http-equiv="Content-Type" />\n</head>\n\n];
print qq[<body bgcolor="#ffffff">\n\n];
print qq[<center><h2>Music Listing - $w_or_wout preview images</h2></center>\n\n];
print qq[<table align="center" border="0" width="100%" ];
print qq[cellpadding="0" cellspacing="25">\n];

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

chomp(my $headerlength = <CACHE>);
seek CACHE, $headerlength, 0;
until (eof CACHE) {
    chomp(my $checkline = <CACHE>);
    if ($checkline ne '**********') {
        print 'ERROR in the datafile - rebuild cache';
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

    if ($FORM{'Composer'}) {
        next unless $midrif =~ m[^$FORM{'Composer'}/];
    }
    my $upyear = substr($id, 8, 4);
    my $upmonth = substr($id, 13, 2);
    my $upday = substr($id, 16, 2);
    my $update = mktime(59, 59, 23, $upday, $upmonth - 1, $upyear - 1900);
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
    next unless ($update > $earliesttime);
    next unless $FORM{'Instrument'} ? ($instrument =~ /$FORM{'Instrument'}/) : 1;
    next unless $FORM{'Style'} ? ($style eq $FORM{'Style'}) : 1;
    next unless $FORM{'id'} ? ($id =~ /-$FORM{'id'}$/) : 1;
    next unless $FORM{'collection'} ? ($collections =~ /(^|,)$FORM{'collection'}(,|$/) : 1;
    
    $matchCount++;
    print qq[<tr><td>\n<table align="center" border="1" width="100%" ];
    print qq[bgcolor="#fffee8" cellpadding="3" cellspacing="0">\n<tr>\n];
    if ($FORM{'preview'} && $FORM{'preview'} == 1) {
        print '<td colspan="4" align="center" bgcolor="#ffffff">';
        print qq[<img src="$baseref$midrif$musicnm/$pngfile" ];
        print qq[height="$pngheight" width="$pngwidth" alt="Preview image" />];
        print "</td></tr>\n<tr>\n";
    }
    print "<td>$title</td>\n";
    if ($composer eq 'Anonymous' or $composer eq 'Traditional') {
        print "<td>$composer</td>\n";
    }
    else {
        print "<td>by $composer</td>\n";
    }
    if ($opus ne '') {
        print "<td>$opus</td>\n";
    }
    else {
        print "<td>&nbsp;</td>\n";
    }
    if ($lyricist eq 'n/a') {
        print "<td><i>n/a</i></td>\n";
    }
    elsif ($lyricist ne '') {
        print "<td>$lyricist</td>\n";
    }
    else {
        print "<td>&nbsp;</td>\n";
    }
    print "</tr><tr>\n";
    print "<td>for $instrument</td>\n";
    if ($date ne '') {
        print "<td>$date</td>\n";
    }
    else {
        print "<td>&nbsp;</td>\n";
    }
    print "<td>$style</td>\n";
    if ($arranger eq 'n/a') {
        print "<td><i>n/a</i></td>\n";
    }
    else {
        print "<td>$arranger</td>\n";
    }
    print "</tr><tr>\n";
    if ($source ne '') {
        print "<td>$source</td>\n";
    }
    else {
        print "<td>&nbsp;</td>\n";
    }
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
        print "<td>&nbsp;</td>\n";
    }
    print '<td><a href="piece-info.cgi?';
    print qq[id=$idno">More Information</a></td>\n];
    print "<td>$upyear/$upmonth/$upday</td>\n";
    print "</tr><tr>\n";
    if ($lyfile =~ /\.zip$/) {
        print '<td bgcolor="#cdeef4">Download: <a href="';
        print qq[$baseref$midrif$musicnm/$lyfile">.ly files (zipped)</a></td>\n];
    }
    else {
        print '<td>Download: <a href="';
        print qq[$baseref$midrif$musicnm/$lyfile">.ly file</a></td>\n];
    }
    if ($midfile =~ /\.zip$/) {
        print '<td bgcolor="#cdeef4"><a href="';
        print qq[$baseref$midrif$musicnm/$midfile">.mid files (zipped)</a></td>\n];
    }
    else {
        print '<td><a href="';
        print qq[$baseref$midrif$musicnm/$midfile">.mid file</a></td>\n];
    }
    print '<td><a href="';
    print qq[$baseref$midrif$musicnm/$pngfile">Preview image</a></td>\n];
    print qq[<td><a href="ftp://ibiblio.org/pub/multimedia/mutopia/$midrif$musicnm/">Appropriate FTP area</a></td>\n</tr><tr>\n];
    if ($a4psfile =~ /\.zip$/) {
        print '<td bgcolor="#cdeef4"><a href="';
        print qq[$baseref$midrif$musicnm/$a4psfile">A4 .ps files (zipped)</a></td>\n];
        print '<td bgcolor="#cdeef4"><a href="';
        print qq[$baseref$midrif$musicnm/$a4pdffile">A4 .pdf files (zipped)</a></td>\n];
        print '<td bgcolor="#cdeef4"><a href="';
        print qq[$baseref$midrif$musicnm/$letpsfile">Letter .ps files (zipped)</a></td>\n];
        print '<td bgcolor="#cdeef4"><a href="';
        print qq[$baseref$midrif$musicnm/$letpdffile">Letter .pdf files (zipped)</a></td>\n];
    }
    else {
        if ($a4pdffile =~ /\.gz$/) {
            print '<td bgcolor="#f7dcdc"><a href="';
            print qq[$baseref$midrif$musicnm/$a4psfile">A4 .ps file (gzipped)</a></td>\n];
            print '<td bgcolor="#f7dcdc"><a href="';
            print qq[$baseref$midrif$musicnm/$a4pdffile">A4 .pdf file (gzipped)</a></td>\n];
            print '<td bgcolor="#f7dcdc"><a href="';
            print qq[$baseref$midrif$musicnm/$letpsfile">Letter .ps file (gzipped)</a></td>\n];
            print '<td bgcolor="#f7dcdc"><a href="';
            print qq[$baseref$midrif$musicnm/$letpdffile">Letter .pdf file (gzipped)</a></td>\n];
        }
        else {
            print '<td><a href="';
            print qq[$baseref$midrif$musicnm/$a4psfile">A4 .ps file (gzipped)</a></td>\n];
            print '<td><a href="';
            print qq[$baseref$midrif$musicnm/$a4pdffile">A4 .pdf file</a></td>\n];
            print '<td><a href="';
            print qq[$baseref$midrif$musicnm/$letpsfile">Letter .ps file (gzipped)</a></td>\n];
            print '<td><a href="';
            print qq[$baseref$midrif$musicnm/$letpdffile">Letter .pdf file</a></td>\n];
        }
    }
    print "</tr>\n</table>\n</tr></td>\n";
}

close CACHE;

print "</table>\n\n";
if (!$matchCount) {
    print "<p>Sorry, no matches were found for your search criteria.</p>\n\n";
}
print "<hr /><br />\n";
print qq[<center><p><a href="../advsearch.html">Return to the advanced search page</a><br /><br />\n];
print qq[<a href="../index.html">Return to the Mutopia home page</a></p></center>\n];
print "</body>\n</html>\n";
