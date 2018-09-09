package Bundler::MultiGem::Command::initialize;

use Bundler::MultiGem -command;

sub execute {
  my ($self, $opt, $args) = @_;

  print "Everything has been initialized.  (Not really.)\n";
}

sub usage_desc { "bundle-multigem %o [dbfile ...]" }

sub opt_spec {
  return (
    [ "skip-refs|R",  "skip reference checks during init", ],
    [ "skip-refs|R",  "skip reference checks during init", ],
    [ "values|v=s@",  "starting values", { default => [ 0, 1, 3 ] } ],
  );
}

sub validate_args {
  my ($self, $opt, $args) = @_;

  # we need at least one argument beyond the options; die with that message
  # and the complete "usage" text describing switches, etc
  $self->usage_error("too few arguments") unless @$args;
}

1;
