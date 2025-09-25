#!/usr/bin/env perl
# Add a newline before the first ordered/unordered list item in a list
# and markdown tables to make MkDocs happy.
# Can be used as a rough translator for GitHub flavored Markdown
# to MkDocs flavored Markdown.  

my @markdown_files = <./**/*.md>;
my $newline_pattern = qr/^(?:\s*[*-]|\s*\d{1,}\.|[|])/;

for my $file (@markdown_files) {
    local $^I = '';
    local @ARGV = ($file);
    print "Converting File: $file\n";

    my $prev = '';
    while (<>) {
        if (m/$newline_pattern/ && $prev !~ m/($newline_pattern|^\n)/) {
            print "\n";
        }
        print;
        $prev = $_;
    }
}

