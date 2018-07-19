#!/usr/bin/env perl
use 5.006;
use strict;
use warnings;

use Cwd qw(cwd);

# Directories
my $root_path = cwd();
my $target_dir = "${root_path}/versions";
my $pkg_dir = "${root_path}/pkg";

print $root_path . "\n";
print $target_dir . "\n";
print $pkg_dir . "\n";
