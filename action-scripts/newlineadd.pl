#!/usr/bin/env perl
# Add a newline before list items (for mkdocs)

my @markdown_files = <./docs/**/*.md>;
my $newline_pattern = qr/^(?:\s*[-*]\s+|\d{1,}\.\s+|[|])/;

for my $file (@markdown_files) {
    local $^I = '';
    local @ARGV = ($file);

    my $prev = '';
    while (<>) {
        if (m/$newline_pattern/ && $prev !~ m/$newline_pattern/) {
            print "\n";
        }
        print;
        my $prev = $_;
    }
}

