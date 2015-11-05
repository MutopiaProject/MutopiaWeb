#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Mutopia_Archive' ) || print "Bail out!\n";
}

diag( "Testing Mutopia_Archive $Mutopia_Archive::VERSION, Perl $], $^X" );
