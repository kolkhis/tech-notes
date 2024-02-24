
# Perl Basics


## Running Perl

From the command line, you can run a perl script like any other language.
Type `perl` then the name of the script.
```bash
perl myscript.pl
```


To run perl commands from the command line, use the `-e` flag.
```bash
perl -e 'print "Hello, world\n"'
```
Double quotes interpolate variables, so single quotes are preferred.  


Use the `-E` flag to run the commands to enable some of the pro core features (i.e., the `use strict` pragma.)
```bash
perl -E 'print "Hello, world\n"'
# Hello, world
perl -E 'say "Hello, world\n"'
```
`say` automatically adds a newline at the end of a string.
Does not work with `-e`, because features are not enabled with `-e`.  

---

```bash
perl -E 'while(<>) { say uc $_ }'
```
* `while(<>)` reads from STDIN
* `say uc $_` prints (`say`) the uppercase (`uc`) version of the current line (`$_`)
This will wait for user input and print it back in uppercase.



## Perl File Structure

```perl
#!/bin/perl
 
use strict;
use warnings;
 
print "Hello, world!\n"
 
1;
```

Each line in a Perl script should be ended with a semicolon `;`.  
A perl file will start with a shebang line (`#!/bin/perl` or `/usr/bin/env perl`).

The lines starting with `use` are called **pragmas**.
There are a lot of pragmas that can be used to enable or disable certain features



