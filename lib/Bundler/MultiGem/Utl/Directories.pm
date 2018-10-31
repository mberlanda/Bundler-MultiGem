package Bundler::MultiGem::Utl::Directories;

use 5.006;
use strict;
use warnings;

=head1 NAME

Bundler::MultiGem::Util::Directories - Wrapper of utility functions for directories

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

use Exporter qw(import);
our @EXPORT = qw(mk_dir rm_dir);

use File::Path qw( make_path remove_tree );

=head1 SYNOPSIS

Wrapper of utility functions for directories

    use Bundler::MultiGem::Directories qw(mk_dir rm_dir);

    mk_dir($path); # create path if not exists
    rm_dir($path); # remove path if exists

=head1 EXPORT

=head2 mk_dir

creates a path if not exists

=cut

sub mk_dir {
  my $dir = shift;
  if ( !-d $dir ) {
    make_path $dir or die "Failed to create path: ${dir}";
  }
}

=head2 rm_dir

removes a path if exists

=cut

sub rm_dir {
  my $dir = shift;
  if ( -d $dir ) {
    remove_tree $dir or die "Failed to remove path: ${dir}";
  }
}

1;
