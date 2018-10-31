package Bundler::MultiGem;

use 5.006;
use strict;
use warnings;
use App::Cmd::Setup -app;

=head1 NAME

Bundler::MultiGem - bundle-multigem utility for gem versions benchmarking

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

This package install a command line utility named C<bundle-multigem>

    $ bundle-multigem -h
      bundle-multigem <command> [-?h] [long options...]
        -? -h --help  show help

      Available commands:

        commands: list the application's commands
            help: display a command's help screen

      initialize: Generate a configuration file (alias: init bootstrap b)
           setup: Create multiple gem versions out of a configuration file (alias: install i s)

=head1 SUBROUTINES/METHODS

=head2 opt_spec

=cut

sub opt_spec {
  my ( $class, $app ) = @_;
  return (
    [ 'help' => "this usage screen" ],
    $class->options($app),
  )
}

1;
