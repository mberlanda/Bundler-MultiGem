package Bundler::MultiGem::Utl::Gem {
  use 5.006;
  use strict;
  use warnings;

  use Exporter qw(import);
  our @EXPORT = qw(gem_vname);

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
  	join('-', ($v, $gem_name));
  }


};
1;