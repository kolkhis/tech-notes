# Docstrings in Perl


## Docstrings for Entire Scripts

Docstrings (documentation strings) for entire scripts can be put in a block at the
end of the script.  

This can be used with a `--help` case when parsing arguments.

This method requires using the `Pod::Usage` module.  

Simply add a `__END__` block and then format your help text with headers.  
```perl
#!/usr/bin/env perl
use strict;
use warnings;
use Pod::Usage;

print "This is the perl program\n"

__END__
=pod

=head1 NAME

foo.pl - Does the things

=head1 SYNOPSIS

  foo.pl [options]

 Options:
    --help      Print this help text
    --verbose   More verbose output
    --env       Set environment variable
```

- `__END__`: Specifies the end of the script and the start of the help text.  
- `=head1 NAME`: Specify a header 1 with the text `NAME`.  
    - `foo.pl - Does the things`: The text to show under the header in the terminal.  
- `=head1 SYNOPSIS`: Specify another header 1 with the text `SYNOPSIS`.  
    - The text underneath will be displayed in the terminal.  


## Resources

- [`perlpod` Documentation](https://perldoc.perl.org/perlpod)




