package Bundler::MultiGem::Command::setup {

  use Bundler::MultiGem -command;
  use Data::Dumper qw(Dumper);
  use YAML::Tiny;
  use Bundler::MultiGem::Directories;
  use Bundler::MultiGem::Model::Gem;

=head1 NAME

Bundler::MultiGem::Command::run - Run multigem command

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

This module includes the commands to create multiple versions of the same gem out of a config yml file

=head1 SUBROUTINES/METHODS

=head2 command_names

=cut

  sub command_names {
    qw(setup install i s)
  }

=head2 usage_desc

=cut

  sub usage_desc { "bundle-multigem %o <path>" }

=head2 opt_spec

=cut

  sub opt_spec {
    return (
      [ "file|f=s", "provide the yaml configuration file (default: ./.bundle-multigem.yml)" ],
    );
  }
=head2 validate_args

=cut
  sub validate_args {
    my ($self, $opt, $args) = @_;

    $opt->{file} = $opt->{file} // '.bundle-multigem.yml';
    if (!-f $opt->{file}){
      $self->usage_error("You should provide a valid path ($opt->{file} does not exists)");
    }
    $self->usage_error("No args allowed") if @$args;
  }

  sub execute {
    my ($self, $opt, $args) = @_;
    print Dumper($opt);

    my $yaml = YAML::Tiny->read($opt->{file});

	my $gem = Bundler::MultiGem::Model::Gem->new($yaml->[0]{gem});
	$gem->set_dirs($yaml->[0]{directories});

	my $cache =  $yaml->[0]{cache};

	print Dumper($gem);

    print "Completed!";
  }
}

1;