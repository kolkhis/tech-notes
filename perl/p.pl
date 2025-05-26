#!/usr/bin/env perl

use strict;
use warnings;
use File::Spec;

# Reading filenames from the notes dir
my $dir_name = '/home/kolkhis/notes';
opendir(my $dir, $dir_name) or die "Can't open $dir_name: $!";
my @files = grep { $_ ne '.' && $_ ne '..' && -f File::Spec->catfile($dir_name, $_)
} readdir($dir);
closedir($dir);
foreach my $f (@files) {
    print "File: $f\n";
}

# undef $/;

# What To Practice
#    Write a Perl script to find and delete all .bak files older than 7 days.
#       (Like: find . -name '*.bak' -mtime +7 -delete)
#    Convert a directory of Markdown files into HTML using regex substitutions.
#    Build a tool to search through logs and output matches (like grep).
#    Write a recursive file walker that builds a file index in a hash.
#    Build a CSV parser that works line-by-line, skipping malformed lines.

my @words=qw/red green blue/;
foreach my $w (@words) {
    print "word: $w\n";
}

my $testvar = "foo bar";
$testvar =~ s/foo/bar/;
print "Test var: $testvar\n";

use File::Find;
 
my @names;
@names = qx(find /home/kolkhis/notes -name '*.md');
chomp(@names);
foreach my $n (@names) {
    # -f $n && print "Regular file: $n\n";
}

# open(my $fh, '-|', 'find /home/kolkhis/notes -name "*.md"') or die $!;
# Pass each arg as separate args to use execvp()
open(my $fh, '-|', 'find', '/home/kolkhis/notes', '-name', '*.md') or die $!;
# chomp($fh);
foreach my $f (<$fh>) {
    chomp($f);
    print "File: $f\n";
}
close $fh;

undef $fh;

# open(my $fh, '|-', 'tee -a output.log') or die $!;
# safer with execvp():
open($fh, '|-', 'tee', '-a', 'output.log') or die $!;
print $fh "Hello log.\n";
close $fh;

