package Bundler::MultiGem::Model::Directories {
  use 5.006;
  use strict;
  use warnings;

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

};
1;