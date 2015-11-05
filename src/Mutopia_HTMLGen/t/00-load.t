#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Mutopia_HTMLGen' ) || print "Bail out!\n";
}

diag( "Testing Mutopia_HTMLGen $Mutopia_HTMLGen::VERSION, Perl $], $^X" );
