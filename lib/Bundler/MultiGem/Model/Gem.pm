package Bundler::MultiGem::Model::Gem {
  use 5.006;
  use strict;
  use warnings;

  use Exporter qw(import);
  our @EXPORT = qw(gem_vname gem_vmodule_name norm_v);
  use common::sense;

  use Bundler::MultiGem::Utl::InitConfig qw(ruby_constantize);

=head1 NAME

Bundler::MultiGem::Utl::Gem - The utility to install multiple versions of the same ruby gem

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

This module contains utility functions for manipulating gems

=head1 EXPORTS

=head2 new
  Take config as argument
=cut
  sub new {
    my $class = shift;
    my $self = { config => shift };
    bless $self, $class;
    return $self;
  }

=head2 config
  config getter
=cut
  sub config {
    my ($self, $key) = @_;
    if (!defined $key) {
      return $self->{config};
    }
    return $self->{config}->{$key}
  }

=head2 name
  name getter
=cut
  sub name {
    my $self = shift;
    return $self->config("name")
  }

=head2 source
  source getter
=cut
  sub source {
    my $self = shift;
    return $self->config("source")
  }

=head2 main_module
  main_module getter
=cut
  sub main_module {
    my $self = shift;
    return $self->config("main_module")
  }

=head2 versions
  versions getter
=cut
  sub versions {
    my $self = shift;
    return $self->config("versions")
  }

=head2 vname
  vname getter e.g. v010-foo for gem 'foo', '0.1.0'
=cut

  sub vname {
    my ($self, $v) = @_;
    if (!defined $v) {
      die "You need to provide a version to vname method";
    }
    return Bundler::MultiGem::Model::Gem::gem_vname($self->name, $v);
  }

=head2 vmodule_name
  vmodule_name getter e.g. v010::Foo for gem 'foo', '0.1.0'
=cut

  sub vmodule_name {
    my ($self, $v) = @_;
    if (!defined $v) {
      die "You need to provide a version to vmodule_name method";
    }
    return Bundler::MultiGem::Model::Gem::gem_vmodule_name($self->main_module, $v);
  }

=head2 gem_vname

=cut
  sub gem_vname {
    my ($gem_name, $v) = @_;
    join('-', (norm_v($v), $gem_name));
  }

=head2 gem_vmodule_name
=cut
  sub gem_vmodule_name {
    my ($gem_module_name, $v) = @_;
    ruby_constantize(join('-', (norm_v($v), $gem_module_name)));
  }

=head2 norm_v

Normalize version name

=cut
  sub norm_v {
  	my $v = shift;
  	for ($v) {
      s/\.//g;
  	}
  	"v${v}";
  }

=head2 unpack_gem
=cut

  sub unpack_gem {
    my ($gem_filepath, $target_dir) = @_;
    system("gem unpack ${gem_filepath} --target ${target_dir}");
  }

=head2

  sub fetch_gem {
    my ( $gem_filepath, $gem_version, $gem_vname ) = (@_);
    if (! -f $gem_filepath ) {
      my $cmd = "gem fetch " . $gem->{name} . " --version ${gem_version}" .
                " --source $gem->{source}";
      system("$cmd");
      rename( "${gem_vname}.gem", $gem_filepath );
    }
  }
=cut

};
1;