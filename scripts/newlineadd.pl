#!/usr/bin/env perl
# Author: Connor W. (https://github.com/kolkhis)
# Add a newline before the first ordered/unordered list item in a list
# and markdown tables to make MkDocs happy.
# Can be used as a rough translator for GitHub flavored Markdown
# to MkDocs flavored Markdown.  

use strict;
use warnings;
use Data::Dumper ();
local *dump = \&Data::Dumper::Dumper;

my @markdown_files;

print "File arguments found. Using filenames provided.\n" if @ARGV;
print "No arguments provided. Searching docs/...\n" unless @ARGV;

@markdown_files = @ARGV 
    ? grep { -f $_ && /\.md$/ } @ARGV 
    : <./docs/**/*.md>;

print "Markdown files being converted:\n" . main::dump(\@markdown_files) . "\n";

die "[ERROR]: No files found for perl to modify!\n" unless @markdown_files;

my $newline_pattern = qr/^(?:\s*[*-]|\s*\d{1,}\.|[|])/;
my $prev_pattern = qr/$newline_pattern|^\n/;

for my $file (@markdown_files) {
    local $^I = '';
    local @ARGV = ($file);

    my $prev = '';
    while (<>) {
        print "\n" if (m/$newline_pattern/ && $prev !~ m/($prev_pattern)/);
        print;
        $prev = $_;
    }

}

print "Conversion is complete.\n";
exit 0;
