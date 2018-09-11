#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More tests => 3;
use Test::Deep;

BEGIN {
    use_ok( 'Bundler::MultiGem::Utl::Gem' ) || print "Bail out!\n";
}

diag( "Testing Bundler::MultiGem::Utl::Gem, Perl $], $^X" );

ok( defined &gem_vname, 'gem_vname() is defined' );

# Context gem_vname
{
  is_deeply(gem_vname("jsonschema_serializer", "0.1.0"), "0.1.0-jsonschema_serializer", "gem_vname()")
}