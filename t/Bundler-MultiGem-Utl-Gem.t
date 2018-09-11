#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More tests => 9;
use Test::Deep;

BEGIN {
    use_ok( 'Bundler::MultiGem::Utl::Gem' ) || print "Bail out!\n";
}

diag( "Testing Bundler::MultiGem::Utl::Gem, Perl $], $^X" );

ok( defined &gem_vname, 'gem_vname() is defined' );
ok( defined &gem_vmodule_name, 'gem_vmodule_name() is defined' );
ok( defined &norm_v, 'norm_v() is defined' );

# Context gem_vname
{
  is_deeply(gem_vname("jsonschema_serializer", "0.1.0"), "v010-jsonschema_serializer", "gem_vname()")
}

# Context gem_vmodule_name
{
   is_deeply(gem_vmodule_name("JsonschemaSerializer", "0.1.0"), "V010::JsonschemaSerializer", "gem_vmodule_name()");
   is_deeply(gem_vmodule_name("Rails", "6.0.0-preview"), "600::Preview::Rails", "gem_vmodule_name() complex");
}

# Context norm_v
{
  is_deeply(norm_v("0.1.0"), "v010", "norm_v() 0.1.0");
  is_deeply(norm_v("6.0.0-preview"), "v600-preview", "norm_v() 6.0.0-preview");
}
