package Bundler::MultiGem::Model::Directories;

use 5.006;
use strict;
use warnings;
use File::Spec::Functions qw(catpath);
use Bundler::MultiGem::Utl::Directories qw(mk_dir rm_dir);
use constant REQUIRED_KEYS => qw(cache directories);

=head1 NAME

Bundler::MultiGem::Model::Directory - Manipulate directories and cache

=head1 VERSION

Version 0.02

=cut
our $VERSION = '0.02';

=head1 SYNOPSIS

This package contain an object to manipulate directories and cache

=head1 SUBROUTINES

=head2 new

Takes an optional hash reference parameter

    my $empty = Bundler::MultiGem::Model::Directories->new(); # {}

    my $config = {
      foo => 'bar',
      cache => [],
      directories => [],
    };
    my $foo = Bundler::MultiGem::Model::Directories->new($config);

=cut
sub new {
  my ($class, $self) = @_;
  if (!defined $self) { $self = {}; }
  bless $self, $class;
  return $self;
}

=head2 validates

C<validates> current configuration to contain REQUIRED_KEYS:

     use constant REQUIRED_KEYS => qw(cache directories);
     $dir->validates;

=cut
sub validates {
  my $self = shift;
  my %keys = map { $_ => 1 } keys(%$self);
  foreach my $k (REQUIRED_KEYS) {
    if (! defined($keys{$k}) ) {
      die "Missing key: $k for Bundler::MultiGem::Model::Directories";
    }
  }
  return $self;
}

=head2 cache

C<cache> getter: if no arguments, return an hash reference

    $dir->{cache} = { foo => 1 };
    $dir->cache; # { foo => 1 }
    $dir->cache('foo'); # 'bar'
    $dir->cache('baz'); # undef

=cut
sub cache {
  my ($self, $key) = @_;
  if (!defined $key) {
    return $self->{cache};
  }
  return $self->{cache}->{$key}
}

=head2 dirs

C<dirs> getter: if no arguments, return an hash reference

    $dir->{directories} = { foo => 'bar/' };
    $dir->dirs; # { foo => 'bar/' }
    $dir->dirs('foo'); # '/root/bar'
    $dir->dirs('baz'); # undef

=cut

sub dirs {
  my ($self, $key) = @_;
  if (!defined $key) {
    return $self->{directories};
  }
  elsif ($key eq 'root') {
    return $self->{directories}->{root};
  }
  return catpath($self->dirs('root'), $self->{directories}->{$key});
}

=head2 apply_cache

C<apply_cache> handle configuration cache on the folder:

    $dir->cache('foo'); # 1
    $dir->dirs('foo'); # creates foo dir if not existing

    $dir->cache('bar'); # 0
    $dir->dirs('bar'); # deletes bar dir if existing and recreate it

=cut
sub apply_cache {
  my $self = shift;
  my $root = $self->dirs('root');
  mk_dir($root);
  foreach my $k (keys(%{$self->cache})){
    if (! $self->cache->{$k}) {
      rm_dir $self->dirs($k);
    }
    mk_dir $self->dirs($k);
  }
}

1;
