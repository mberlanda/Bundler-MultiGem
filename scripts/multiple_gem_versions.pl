#!/usr/bin/env perl
use 5.006;
use strict;
use warnings;

use Cwd qw(cwd);
use File::Path qw( make_path remove_tree );

# Directories
my $root_path = cwd();
my $target_dir = "${root_path}/versions";
my $pkg_dir = "${root_path}/pkg";

print $root_path . "\n";
print $target_dir . "\n";
print $pkg_dir . "\n";

# https://rubygems.org/downloads/jsonschema_serializer-0.1.0.gem
my $gem = {
  source => "https://rubygems.org",
  name => "jsonschema_serializer",
  main_module => "JsonschemaSerializer",
  versions => [qw( 0.0.5 0.1.0 )]
};

print $gem->{source} . "\n";
print $gem->{name} . "\n";
print $gem->{main_module} . "\n";
print join(', ', @{$gem->{versions}}) . "\n";

my $gemspec = $gem->{name} . ".gemspec";
print $gemspec . "\n";

sub reset_dir {
  my $directory = shift;
  if ( -d $directory ) {
    remove_tree $directory or die "Failed to remove path: $directory";
  }
  make_path $directory;
}

sub main {
  reset_dir $pkg_dir
}

main;
