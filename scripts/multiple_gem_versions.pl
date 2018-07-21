#!/usr/bin/env perl
use 5.006;
use strict;
use warnings;

use Cwd qw( cwd );
use File::Path qw( make_path remove_tree );
use File::Copy qw( move );

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

  my $gem_name = $gem->{name};
  my $gem_main_module = $gem->{main_module};

  foreach my $v (@{$gem->{versions}}) {
    my $gem_vname = join('-', ($gem_name, $v));
    my $gem_path = "$pkg_dir/${gem_vname}.gem";
    my $extracted_dir = "${target_dir}/${gem_vname}";
    print $gem_path . "\n";
    print $extracted_dir . "\n";

    fetch_gem($gem_path, $v, $gem_vname);
    unpack_gem($gem_path);

    # Normalize version name without dots
    my $norm_v;
    ($norm_v = $v) =~ s/\.//g;
    print $v . "\n";
    print $norm_v . "\n";

    my $new_gem_name = join('-', ("v${norm_v}", $gem_name));
    my $new_gem_main_module = join('::', ("V${norm_v}", $gem_main_module));
    print $new_gem_name . "\n";
    print $new_gem_main_module . "\n";

    chdir("${extracted_dir}") || die "$!";
    # Process .gemspec
    open(GEMSPEC, "<${gem_name}.gemspec") ||
      die "Can't open ${gem_name}.gem: $!";
    open(NEW_GEMSPEC, ">${new_gem_name}.gemspec")  ||
      die "Can't open ${new_gem_name}.gem: $!";

    while( my $line = <GEMSPEC> ){
      # Replace version reference from file
      if ( $line =~ /${gem_name}\/version/ ) { next; }
      $line =~ s/${gem_main_module}::VERSION/'$v'/;

      $line =~ s/${gem_name}/$new_gem_name/g;
      $line =~ s/${gem_main_module}/$new_gem_main_module/g;

      print NEW_GEMSPEC $line;
    }
    close(GEMSPEC);
    close(NEW_GEMSPEC);

    unlink "${gem_name}.gemspec" || warn "Could not unlink ${gem_name}.gemspec: $!";
  }
}

main;
