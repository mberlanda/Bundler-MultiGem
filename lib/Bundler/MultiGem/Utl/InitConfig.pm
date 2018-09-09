package Bundler::MultiGem::Utl::InitConfig {
  use 5.006;
  use strict;
  use warnings;

  use Exporter qw(import);
  our @EXPORT = qw();

  use Storable qw(dclone);
  use Hash::Merge qw(merge);

=head1 NAME

Bundler::MultiGem::Utl::InitConfig - The utility to install multiple versions of the same ruby gem

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

This module contains a default configuration for the package to work and the utility functions to manipulate it.

=cut

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


=head1 SUBROUTINES/METHODS

=head2 merge_configuration

=cut
  sub merge_configuration {
    my $custom_config = shift;
    my $result = merge($custom_config, dclone($DEFAULT_CONFIGURATION));
  }
};
1;
