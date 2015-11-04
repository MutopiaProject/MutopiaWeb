#!/usr/bin/perl -wT

use POSIX;
@pairs = split(/\&/, $ENV{'QUERY_STRING'}, 0);
foreach $pair (@pairs) {
    ($name, $value) = split(/=/, $pair, 3);
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack 'C', hex $1;/eg;
    $FORM{$name} = $value;
}
open FTPB, '../ftpbase.dat';
chomp($ftpbase = <FTPB>);
close FTPB;
open CACHE, '../datafiles/musiccache.dat';
$baseref = '../ftp/';
$noMatches = 1;
print "Content-type:text/html\n\n";
print qq[<?xml version="1.0" encoding="UTF-8"?>\n];
print "<!DOCTYPE html\n";
print qq[     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n];
print qq[    "DTD/xhtml1-transitional.dtd">\n];
print qq[<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n\n];
print '<head><title>Music Listing - with';
if ($FORM{'preview'} == 0) {
    print 'out';
}
print " preview images</title>\n";
print '<meta content="text/html; charset=utf-8" ';
print qq[http-equiv="Content-Type" />\n</head>\n\n];
print qq[<body bgcolor="#ffffff">\n\n];
print '<center><h2>Music Listing - with';
if ($FORM{'preview'} == 0) {
    print 'out';
}
print " preview images</h2></center>\n\n";
print '<table align="center" border="0" width="100%" ';
print qq[cellpadding="0" cellspacing="25">\n];
if ($FORM{'recent'} == 1) {
    if ($FORM{'timelength'} eq '') {
        $earliesttime = time;
    }
    elsif ($FORM{'timeunit'} eq 'week') {
        $earliesttime = time - $FORM{'timelength'} * 604800;
    }
    elsif ($FORM{'timeunit'} eq 'day') {
        $earliesttime = time - $FORM{'timelength'} * 86400;
    }
}
else {
    $earliesttime = 0;
}
chomp($headerlength = <CACHE>);
seek CACHE, $headerlength, 0;
until (eof CACHE) {
    chomp($checkline = <CACHE>);
    if ($checkline ne '**********') {
        print 'ERROR in the datafile - rebuild cache';
    }
    chomp($idno = <CACHE>);
    chomp($midrif = <CACHE>);
    chomp($musicnm = <CACHE>);
    chomp($lyfile = <CACHE>);
    chomp($midfile = <CACHE>);
    chomp($a4psfile = <CACHE>);
    chomp($a4pdffile = <CACHE>);
    chomp($letpsfile = <CACHE>);
    chomp($letpdffile = <CACHE>);
    chomp($pngfile = <CACHE>);
    chomp($pngheight = <CACHE>);
    chomp($pngwidth = <CACHE>);
    chomp($title = <CACHE>);
    chomp($composer = <CACHE>);
    chomp($opus = <CACHE>);
    chomp($lyricist = <CACHE>);
    chomp($instrument = <CACHE>);
    chomp($date = <CACHE>);
    chomp($style = <CACHE>);
    chomp($metre = <CACHE>);
    chomp($arranger = <CACHE>);
    chomp($source = <CACHE>);
    chomp($copyright = <CACHE>);
    chomp($id = <CACHE>);
    chomp($maintainer = <CACHE>);
    chomp($maintaineremail = <CACHE>);
    chomp($maintainerweb = <CACHE>);
    chomp($extrainfo = <CACHE>);
    chomp($lilypondversion = <CACHE>);
    chomp($collections = <CACHE>);
    chomp($printurl = <CACHE>);
    if ($FORM{'Composer'} eq '' or $midrif =~ m[^$FORM{'Composer'}/]) {
        $upyear = substr($id, 8, 4);
        $upmonth = substr($id, 13, 2);
        $upday = substr($id, 16, 2);
        $update = mktime(59, 59, 23, $upday, $upmonth - 1, $upyear - 1900);
        $FORM{'searchingfor'} =~ tr/a-z/A-Z/;
        $go = 1;
        if ($FORM{'searchingfor'} ne '') {
            @searchlist = split(/ /, $FORM{'searchingfor'}, 0);
            foreach $searchitem (@searchlist) {
                unless (uc($title . $composer . $opus . $lyricist . $instrument . $date . $style . $metre . $arranger . $source . $copyright . $id . $maintainer . $maintaineremail . $maintainerweb . $extrainfo . $lilypondversion . $collections) =~ /$searchitem/) {
                    $go = 0;
                }
            }
        }
        $okToCheckVersion = 1;
        if ($lilypondversion =~ /^([0-9])\.([0-9]+)\.([0-9]+)/) {
            $maj = $1;
            $min = $2;
            $tin = $3;
        }
        else {
            $okToCheckVersion = 0;
        }
        if ($okToCheckVersion == 1 and $FORM{'lilyv'} == 1 and $go == 1) {
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
        if ($go == 1 and $FORM{'printav'} == 1) {
            if ($printurl eq '') {
                $go = 0;
            }
        }
        if ($go == 1 and $FORM{'Instrument'} eq 'Harp' and $instrument =~ /Harpsichord/) {
            $go = 0;
        }
        if ($go == 1 and $FORM{'solo'} == 1 and $instrument =~ /[Dd]uet/ || $instrument =~ /[Tt]rio/ || $instrument =~ /[Qq]uartet/ || $instrument =~ /[Qq]uintet/ || $instrument =~ /Orchestra/ || $instrument =~ /[Ee]nsemble/ || $instrument =~ / and / || $instrument =~ /SATB/ || $instrument =~ /accompan/ || $instrument =~ /[0-9]/) {
            $go = 0;
        }
        if ($go == 1 and $FORM{'Instrument'} eq '' || $instrument =~ /$FORM{'Instrument'}/ and $FORM{'Style'} eq '' || $style eq $FORM{'Style'} and $FORM{'id'} eq '' || $id =~ /-$FORM{'id'}$/ and $FORM{'collection'} eq '' || $collections =~ /(^|,)$FORM{'collection'}(,|$)/ and $update > $earliesttime) {
            $noMatches = 0;
            print qq[<tr><td>\n<table align="center" border="1" width="100%" ];
            print qq[bgcolor="#fffee8" cellpadding="3" cellspacing="0">\n<tr>\n];
            if ($FORM{'preview'} == 1) {
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
    }
}
close CACHE;
print "</table>\n\n";
if ($noMatches == 1) {
    print "<p>Sorry, no matches were found for your search criteria.</p>\n\n";
}
print "<hr /><br />\n";
print qq[<center><p><a href="../advsearch.html">Return to the advanced search page</a><br /><br />\n];
print qq[<a href="../index.html">Return to the Mutopia home page</a></p></center>\n];
print "</body>\n</html>\n";
