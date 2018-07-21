#!/usr/bin/env perl
use 5.006;
use strict;
use warnings;

use Cwd qw(cwd);
use File::Path qw( make_path remove_tree );
use File::Copy qw(move);

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

# Directory manipulation

sub reset_dir {
  my $directory = shift;
  if ( -d $directory ) {
    remove_tree $directory or die "Failed to remove path: $directory";
  }
  make_path $directory;
}

# Gem manipulation
sub unpack_gem {
  my $gem_filepath = shift;
  system("gem unpack $gem_filepath --target $target_dir");
}

sub fetch_gem {
  my ( $gem_filepath, $gem_version, $gem_vname ) = (@_);
  if (! -f $gem_filepath ) {
    my $cmd = "gem fetch " . $gem->{name} . " --version ${gem_version}" .
              " --source $gem->{source}";
    `$cmd`;
    move( "${gem_vname}.gem", $gem_filepath );
  }
}

sub main {
  reset_dir $target_dir;

  foreach my $v (@{$gem->{versions}}) {
    my $gem_vname = join('-', ($gem->{name}, $v));
    my $gem_path = "$pkg_dir/${gem_vname}.gem";
    print $gem_path . "\n";

    fetch_gem($gem_path, $v, $gem_vname);
    unpack_gem($gem_path);
  }
}

main;
