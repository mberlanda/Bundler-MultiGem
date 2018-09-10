#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More tests => 14;
use Test::Deep;

BEGIN {
    use_ok( 'Bundler::MultiGem::Utl::InitConfig' ) || print "Bail out!\n";
}

diag( "Testing Bundler::MultiGem::Utl::InitConfig, Perl $], $^X" );

#  what has to be defined by Bundler::MultiGem::Utl::InitConfig.pm
ok( defined ${Bundler::MultiGem::Utl::InitConfig::DEFAULT_CONFIGURATION}, '$DEFAULT_CONFIGURATION is defined' );
ok( defined &Bundler::MultiGem::Utl::InitConfig::merge_configuration, 'merge_configuration() is defined' );
ok( defined &Bundler::MultiGem::Utl::InitConfig::default_main_module, 'default_main_module() is defined' );
ok( defined &Bundler::MultiGem::Utl::InitConfig::ruby_constantize, 'ruby_constantize() is defined' );

# DEFAULT_CONFIGURATION context
{
  my $config = ${Bundler::MultiGem::Utl::InitConfig::DEFAULT_CONFIGURATION};
  is_deeply(
  	[sort keys %$config], [qw(cache directories gem)], 'keys of $DEFAULT_CONFIGURATION'
  );

  my $gem_config = $config->{gem};
  ok($gem_config->{source}, "https://rubygems.org");
  ok(! defined $gem_config->{name}, 'DEFAULT_CONFIGURATION->gem->name undef');
  ok(! defined $gem_config->{main_module}, 'DEFAULT_CONFIGURATION->gem->main_module undef');
  is_deeply(
  	$gem_config->{versions}, [()], 'DEFAULT_CONFIGURATION->gem->versions empty'
  );
}

# merge_configuration context
{
  my $custom_config = {
  	'gem' => {
	  'name' => 'jsonschema_serializer',
  	  'versions' => [qw(0.0.5 0.1.0)]
  	}
  };
  my $actual = Bundler::MultiGem::Utl::InitConfig::merge_configuration($custom_config);

  my $gem_config = $actual->{gem};
  ok($gem_config->{source}, "https://rubygems.org");
  ok($gem_config->{name}, "jsonschema_serializer");
  ok($gem_config->{main_module}, "jsonschema_serializer");
  is_deeply(
  	$gem_config->{versions}, [qw(0.0.5 0.1.0)], 'DEFAULT_CONFIGURATION->gem->versions empty'
  );
}