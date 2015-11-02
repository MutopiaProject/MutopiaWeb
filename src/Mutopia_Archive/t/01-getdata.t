#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 5;

use Mutopia_Archive;

my $TOPREL = "../../";

# read composer data into a hash
my %tcomps = Mutopia_Archive::getData($TOPREL . 'datafiles/composers.dat');

isnt( $tcomps{'MozartWA'}, '', 'known composer key lookup');
is( $tcomps{'FramptonP'}, undef, 'illegal composer undefined (expected)');

# should work this way as well
my %tcomps_also = Mutopia_Archive::getData($TOPREL . 'datafiles/composers.dat');
ok ($tcomps{'MozartWA'} eq $tcomps_also{'MozartWA'} , 'alternate data location') ;

# check sort routines
ok( Mutopia_Archive::byComposer('MozartWA', 'Anonymous') == -1, 'sort: MozartWA < Anonymous');
ok( Mutopia_Archive::byComposer('AguadoD', 'Anonymous') == -1, 'sort: AguadoD < Anonymous');

done_testing;

1;
