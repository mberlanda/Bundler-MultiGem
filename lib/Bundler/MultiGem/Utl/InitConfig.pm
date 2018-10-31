package Bundler::MultiGem::Utl::InitConfig;

use 5.006;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT = qw(ruby_constantize merge_configuration);

use Storable qw(dclone dclone);
use Hash::Merge qw(merge);
use common::sense;

=head1 NAME

Bundler::MultiGem::Utl::InitConfig - The utility to install multiple versions of the same ruby gem

=head1 VERSION

Version 0.02

=cut
our $VERSION = '0.02';

=head1 SYNOPSIS

This module contains a default configuration for the package to work and the utility functions to manipulate it.

=cut

=head1 DEFAULT_CONFIGURATION

Default configuration used to build the yaml configuration file:

    our $DEFAULT_CONFIGURATION = {
      'gem' => {
        'source' => 'https://rubygems.org',
        'name' => undef,
        'main_module' => undef,
        'versions' => [()]
      },
      'directories' => {
        'root' => undef,
        'pkg' => 'pkg',
        'target' => 'versions'
      },
      'cache' => {
        'pkg' => 1,
        'target' => 0
      }
    };

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
    'pkg' => 'pkg',
    'target' => 'versions'
  },
  'cache' => {
    'pkg' => 1,
    'target' => 0
  }
};

=head1 EXPORTS

=head2 merge_configuration

Wrapper for merging a custom configuration with C<$DEFAULT_CONFIGURATION>

=cut
sub merge_configuration {
  my $custom_config = shift;
  my $result = merge($custom_config, dclone($DEFAULT_CONFIGURATION));
  default_main_module($result);
}

=head2 default_main_module

Assing a default C<main_module> name to a gem if not set

    my $gem_config = $custom_config->{gem};
    ruby_constantize($gem_config->{name});

E.g. C<foo> -> C<Foo>, C<foo_bar> -> C<FooBar>, C<foo-bar> -> C<Foo::Bar>

=cut

sub default_main_module {
  my $custom_config = shift;
  my $gem_config = $custom_config->{gem};
  if ( !defined $gem_config->{main_module}) {
    $gem_config->{main_module} = ruby_constantize($gem_config->{name});
  }
  $custom_config
}

=head2 ruby_constantize

Format string as a ruby constant

    ruby_constantize("foo"); # Foo
    ruby_constantize("foo_bar"); # FooBar
    ruby_constantize("foo-bar"); # Foo::Bar
    ruby_constantize("foo-bar_baz"); # Foo::BarBaz

=cut

sub ruby_constantize {
  my $name = shift;
  for ($name) {
    s/_(\w)/\U$1/g;
    s/-(\w)/::\U$1/g;
  }
  ucfirst $name;
}

1;
