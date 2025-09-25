#!/usr/bin/env perl
# Add a newline before list items (for mkdocs)

my @markdown_files = <./**/*.md>;
my $newline_pattern = qr/^(?:\s*[*-]|\s*\d{1,}\.|[|])/;
# my $prev_pattern = qr/^(?!\s*\n|\s*[-*]|[|])/;

for my $file (@markdown_files) {
    local $^I = '';
    local @ARGV = ($file);
    print "Converting File: $file\n";

    my $prev = '';
    while (<>) {
        if (m/$newline_pattern/ && $prev !~ m/$newline_pattern/) {
            print "\n";
        }
        print;
        $prev = $_;
    }
}

