#!/usr/bin/env perl
use 5.006;
use strict;
use warnings;

use Cwd qw( cwd );
use File::Find;
use File::Path qw( make_path remove_tree );
use File::Spec::Functions qw( catfile catdir );

use YAML::Tiny;
use Data::Dumper;

# Directories
my $yaml = YAML::Tiny->read(
  catfile(cwd(), "scripts", "yaml_gem_versions.yml")
);

my $gem = $yaml->[0]{gem};
# my $gemspec = $gem->{name} . ".gemspec";

my $dirs = $yaml->[0]{directories};
my $root_path = $dirs->{root} // cwd();
my $pkg_dir = catdir( $root_path, $dirs->{pkg} // "pkg");
my $target_dir = catdir( $root_path, $dirs->{target} // "versions");

my $cache =  $yaml->[0]{cache};
my $pkg_cache = $cache->{pkg} // 1;
my $target_cache = $cache->{target} // 0;


my $dir_cache_hash = {
  pkg => {
    dir => $pkg_dir,
    cache => $pkg_cache
  },
  target => {
    dir => $target_dir,
    cache => $target_cache
  }
};

# print Dumper($gem);

# # https://rubygems.org/downloads/jsonschema_serializer-0.1.0.gem
# my $gem = {
#   source => "https://rubygems.org",
#   name => "jsonschema_serializer",
#   main_module => "JsonschemaSerializer",
#   versions => [qw( 0.0.5 0.1.0 )]
# };


# Directory manipulation
sub reset_dir {
  my $directory = shift;
  if ( -d $directory ) {
    remove_tree $directory || die "Failed to remove path: $directory: $!";
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
    system("$cmd");
    rename( "${gem_vname}.gem", $gem_filepath );
  }
}

sub cleanup_cache {
  foreach my $k (keys %{$dir_cache_hash}) {
    if (grep /^$k$/, qw(pkg target) ) {
      if ( ! $dir_cache_hash->{$k}->{cache} ) {
        reset_dir $dir_cache_hash->{$k}->{dir}
      }
    } else {
      print "Forbidden key: $k \n";
    }
  }
}


sub main {

  cleanup_cache

  my $gem_name = $gem->{name};
  my $gem_main_module = $gem->{main_module};

  foreach my $v (@{$gem->{versions}}) {
    my $gem_vname = join('-', ($gem_name, $v));
    my $gem_path = catfile( $pkg_dir, "${gem_vname}.gem" );
    my $extracted_dir = catdir( $target_dir,  $gem_vname );

    fetch_gem($gem_path, $v, $gem_vname);
    unpack_gem($gem_path);

    # Normalize version name without dots
    my $norm_v;
    ($norm_v = $v) =~ s/\.//g;

    my $new_main_module = "V${norm_v}";
    my $new_gem_name = join('-', ("v${norm_v}", $gem_name));
    my $new_gem_main_module = join('::', ($new_main_module, $gem_main_module));

    my $gemspec = catfile($extracted_dir, "${gem_name}.gemspec");
    my $new_gemspec = catfile($extracted_dir, "${new_gem_name}.gemspec");

    # Process .gemspec
    open(GEMSPEC, "<${gemspec}") || die "Can't open ${gemspec}: $!";
    open(NEW_GEMSPEC, ">${new_gemspec}") || die "Can't open ${new_gemspec}: $!";

    while( my $line = <GEMSPEC> ){
      if ( $line =~ /${gem_name}\/version/ ) { next; }
      # Replace version reference from file
      $line =~ s/${gem_main_module}::VERSION/'$v'/;

      $line =~ s/${gem_name}/$new_gem_name/g;
      $line =~ s/${gem_main_module}/$new_gem_main_module/g;

      print NEW_GEMSPEC $line;
    }
    close(NEW_GEMSPEC);
    close(GEMSPEC);

    unlink $gemspec || warn "Could not unlink ${gemspec}: $!";


    my $lib_dir = catdir( $extracted_dir, 'lib' );
    # process main gem module
    my $main_module_file = catfile( $lib_dir, "${gem_name}.rb" );
    my $new_main_module_file = catfile( $lib_dir, "${new_gem_name}.rb" );

    if ( -e $main_module_file ) {
      open(ORIGINAL, "<${main_module_file}") ||
        die "Can't open ${main_module_file}: $!";
      my @file_content = <ORIGINAL>;
      close(ORIGINAL);

      open(NEW_FILE, ">${new_main_module_file}")  ||
        die "Can't open ${new_main_module_file}: $!";
      print NEW_FILE "module ${new_main_module}; end\n";
      foreach my $line (@file_content) { print NEW_FILE $line; }
      close(NEW_FILE);

      unlink $main_module_file;
    }

    # Rename gem name dir in lib directory
    rename( catdir( $lib_dir, $gem_name ), catdir( $lib_dir, $new_gem_name )) ||
     warn catdir( $lib_dir, $gem_name ) . "does not exists: $!";

    # Process all rb files in $extracted_dir
    my @ruby_files = ();
    find(
      {
        wanted => sub {
            my $F = $File::Find::name;
            push @ruby_files, $F if ($F =~ /rb$/)
          },
        no_chdir => 1
      },
      $extracted_dir
    );

    foreach my $f (@ruby_files) {
      my $bkp = $f . ".bak";
      rename($f, $bkp);
      open(I, "<$bkp");
      open(O, ">$f");
      while(my $line = <I>) {
        $line =~ s/${gem_name}/$new_gem_name/g;
        $line =~ s/${gem_main_module}/$new_gem_main_module/g;
        print O $line;
      }
      close(O);
      close(I);
      unlink $bkp;
    }

    print $gem_vname . " completed!\n";
  }
}

main;
