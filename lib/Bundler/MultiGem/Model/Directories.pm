package Bundler::MultiGem::Model::Directories {
  use 5.006;
  use strict;
  use warnings;
  use File::Spec qw(catpath);
  use Bundler::MultiGem::Utl::Directories qw(mk_dir rm_dir);
  use constant REQUIRED_KEYS => qw(cache directories);
=head1 NAME
Bundler::MultiGem::Model::Directory - Manipulate directories and cache

=head1 SUBROUTINES
=cut

=head2 new
  Take config as argument
=cut
  sub new {
    my $class = shift;
    my $self = shift // {};
    bless $self, $class;
    return $self;
  }

=head2 validates
  Validates current configuration
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
  cache getter
=cut
  sub cache { return shift->{cache}; }

=head2 dirs
  dirs getter
=cut
  sub dirs { return shift->{directories}; }

=head2 apply_cache
  apply_cache current configuration
=cut
sub apply_cache {
  my $self = shift;
  my $root = $self->dirs->{root};
  mk_dir($root);
  foreach my $k (keys(%${self->cache})){
    my $d = catpath($root, $self->dirs->{$k});
    if (! $self->cache->{$k}) {
      rm_dir $d;
    }
    mk_dir $d;
  }
}

};
1;