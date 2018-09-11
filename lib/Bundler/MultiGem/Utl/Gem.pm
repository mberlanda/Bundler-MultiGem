package Bundler::MultiGem::Utl::Gem {
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

};
1;