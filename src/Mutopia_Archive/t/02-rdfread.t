#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use File::Temp qw(tempfile);

plan tests => 2;

use Mutopia_Archive;

my $TOPREL = "../../";

# Create the temporary rdf file.
my ($rdfh,$rdfname) = tempfile();
binmode($rdfh, ":utf8");
print $rdfh <<__EOH;
<?xml version="1.0"?>
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:mp="http://www.mutopiaproject.org/piece-data/0.1/">

    <rdf:Description rdf:about=".">
    <mp:title>Study in A Minor</mp:title>
    <mp:composer>AguadoD</mp:composer>
    <mp:opus/>
    <mp:lyricist/>
    <mp:for>Guitar</mp:for>
    <mp:date/>
    <mp:style>Classical</mp:style>
    <mp:metre/>
    <mp:arranger/>
    <mp:source>Statens musikbibliotek - The Music Library of Sweden</mp:source>
    <mp:licence>Creative Commons Attribution-ShareAlike 3.0</mp:licence>

    <mp:lyFile>aminor-study.ly</mp:lyFile>
    <mp:midFile>aminor-study.mid</mp:midFile>
    <mp:psFileA4>aminor-study-a4.ps.gz</mp:psFileA4>
    <mp:pdfFileA4>aminor-study-a4.pdf</mp:pdfFileA4>
    <mp:psFileLet>aminor-study-let.ps.gz</mp:psFileLet>
    <mp:pdfFileLet>aminor-study-let.pdf</mp:pdfFileLet>
    <mp:pngFile>aminor-study-preview.png</mp:pngFile>
    <mp:pngHeight>85</mp:pngHeight>
    <mp:pngWidth>485</mp:pngWidth>

    <mp:id>Mutopia-2015/09/24-1833</mp:id>
    <mp:maintainer>Glen Larsen</mp:maintainer>
    <mp:maintainerEmail>glenl.glx at gmail dot com</mp:maintainerEmail>
    <mp:maintainerWeb/>
    <mp:moreInfo/>
    <mp:lilypondVersion>2.18.2</mp:lilypondVersion>
    </rdf:Description>

    </rdf:RDF>
__EOH
close $rdfh;

# Read the rdf file back in, verify a value.
my %rdf_data = Mutopia_Archive::readRDFFile($rdfname);

# rdf data should compare exactly
is( $rdf_data{'id'}, "Mutopia-2015/09/24-1833", 'rdf file parsing');

my %tcomps = Mutopia_Archive::getData($TOPREL . 'datafiles/composers.dat');

# Lookup composer from rdf data to verify cross-structure use
isnt( $tcomps{ $rdf_data{'composer'} }, '', 'use rdf data to lookup composer');
