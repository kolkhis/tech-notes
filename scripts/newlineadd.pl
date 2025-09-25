#!/usr/bin/env perl
# Add a newline before the first ordered/unordered list item in a list
# and markdown tables to make MkDocs happy.
# Can be used as a rough translator for GitHub flavored Markdown
# to MkDocs flavored Markdown.  

use strict;
use warnings;
use Data::Dump;

my @markdown_files;

if (!@ARGV) {
    print "No arguments provided. Searching docs/...\n";
    @markdown_files = <./docs/**/*.md>;
} else {
    print "File arguments found. Using filenames provided.\n";
    @markdown_files = grep { -f $_ && /\.md$/ } @ARGV;
}

print "Markdown files being converted:\n" . Data::Dump::dump(\@markdown_files) . "\n";

if (!@markdown_files) {
    die "[ERROR]: No files found for perl to modify!\n";
}

my $newline_pattern = qr/^(?:\s*[*-]|\s*\d{1,}\.|[|])/;
my $prev_pattern = qr/$newline_pattern|^\n/;

for my $file (@markdown_files) {
    local $^I = '';
    local @ARGV = ($file);

    my $prev = '';
    while (<>) {
        if (m/$newline_pattern/ && $prev !~ m/($prev_pattern)/) {
            print "\n";
        }
        print;
        $prev = $_;
    }
}

print "Conversion is complete.\n";
exit 0;
