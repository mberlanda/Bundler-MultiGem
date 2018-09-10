#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More tests => 1;

BEGIN {
    use_ok( 'Bundler::MultiGem' ) || print "Bail out!\n";
}

diag( "Testing Bundler::MultiGem $Bundler::MultiGem::VERSION, Perl $], $^X" );
