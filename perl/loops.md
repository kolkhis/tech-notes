# Loops in Perl

## `while` Loops

The `while` loop is a flexible part of perl that allows you to either loop while a
condition is met, or to loop over things available through the diamond operator (`<>`), 
like the output of a filehandle.  

Basic while loop with a counter:
```perl
my $i = 0;
while ($i < 5) {
    print "i is $i\n";
    $i++;
}
```

Using a filehandle/diamond operator loop to loop over input lines from a file, stdin,
or the diamond operator:
```perl
open(my $fh, '<', 'file.txt') or die $!;
while (my $line = <$fh>) {
    chomp($line);
    print "Line: $line\n";
}
close $fh;
```

You can also just rely on perl's default variable `$_` for this:
```perl
while (<$fh>) {
    chomp;
    print "Line: $_\n";
}
```

If you're reading from STDIN or piped input:
```perl
while (<STDIN>) {
    print "You typed: $_\n";
}
```

## `for` Loops
You can use `for` loops just like in C.  
```perl
for (my $i = 0; $i < 10; $i++) {
    print "Current iteration: $i\n";
}
```

You can also use `for` loops to loop over an array.  
```perl
my @arr = ('one', 'two', 'three');
for my $item (@arr) {
    print "Item: $item\n";
}
```
When iterating over arrays or lists, using `for` (rather than `foreach`) is
considered more idiomatic perl.  

You can also omit the variable declaration and use the default variable `$_`:
```perl
my @arr = ('one', 'two', 'three');
for (@arr) {
    print "Item: $_\n";
}
```

### `foreach` Loops
`for` is just an alias for `foreach`, so this is also valid.  

This is the type of loop that you want to use over an array.  
```perl
my @arr = ('one', 'two', 'three');
foreach my $item (@arr) {
    print "Item: $item\n";
}
```

You can also omit the variable declaration and use the default variable `$_`:
```perl
my @arr = ('one', 'two', 'three');
foreach (@arr) {
    print "Item: $_\n";
}
```

### Looping over Ranges
Perl can loop over numeric ranges directly, with similar syntax to Bash.  
```perl
for my $n (1..5) {
    print "Number: $n\n";
}
# or
for (1..5) {
    print "Number: $_\n";
}
```
Same `1..5` syntax to bash, but with parentheses instead of braces.  


## Perl Equivalents of `continue` (`next`) and `break` (`last`)
The `continue` function doesn't work the same way as in Bash or other languages.  
In Perl, `continue` is part of the `given`/`when` syntax (kind of like `switch`/`case`).  

What you want to use, to continue to the next iteration of the loop, is `next`.  
The `next` function is the equivalent of `continue` in Bash/others.  

---

If you want to `break` out of a loop, use the `last` keyword.  
This will break out of the loop and continue executing the program.  


