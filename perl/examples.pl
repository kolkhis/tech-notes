#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;


### Parsing Command Line Arguments
my $input = $ARGV[0];
if ($input !~ /""/) {
    print "Input was: $input\n";
} else {
    print "No input was provided.\n";
    die "No input!\n"
}

print "Full list of arguments with print:\n@ARGV\n";
# View it with Data::Dumper
print "Full list of arguments with Dumper:\n", Dumper(\@ARGV); 
# \@ARGV (with a backslash) passes a reference to the @ARGV array


# Get the next CLI argument with the shift function
my $next_input = shift;
if ($next_input !~ /[^;]/) {
    print "Input was: $input\n\n";
} else {
    print "No input was provided.\n"
}

print "After shifting:\n";
print "Full list of arguments with print:\n@ARGV\n";
print "Full list of arguments with Dumper:\n", Dumper(\@ARGV), "\n\n";

print "Home dir: $ENV{HOME}\n"; # Access environment variables

my $t = 0;
# if passing a file, this will loop over each line
while (<>) {  
    my @w = /(\w+)/g;
    $t += @w;
    print "$ARGV\n"; # $ARGV stores the filename when used in this context
}
print "Word count: $t\n";

1;
