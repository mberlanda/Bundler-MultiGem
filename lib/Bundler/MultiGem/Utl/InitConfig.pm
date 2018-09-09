package Bundler::MultiGem::Utl::InitConfig {
  use 5.006;
  use strict;
  use warnings;

  our $DEFAULT_CONFIGURATION = {
    'gem' => {
      'source' => 'https://rubygems.org',
      'name' => undef,
      'main_module' => undef,
      'versions' => [()]
    },
    'directories' => {
      'root' => undef,
      'pkg' => undef,
      'target' => undef
    },
    'cache' => {
      'pkg' => 1,
      'target' => 0
    }
  };
};
1;
