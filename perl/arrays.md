# Arrays in Perl
Arrays in perl are usually denoted with the `@` symbol.  
For instance, a default array is `@ARGV`, which is the argument vector. It holds all
the command line arguments passed to the script.  

## Accessing Variables in Arrays
Each element of an array is usually a scalar value (a single unit of data).  

If you have an array `@days`, you can access its elements:

## Reading Data into an Array

### Reading Lines from a File
You can open a file with the `open` function, then use the `<>` diamond operator to
read the lines into an array.
```perl
my $filename = 'file.md';

# Open file in read-only mode
open my $fh, '<', $filename or die "Could not open '$filename': $!";

# Read all lines into an array and chomp the newline characters
chomp(my @lines = <$fh>);

# Always close your filehandle
close $fh;
```
- `my $filename = 'file.md';`: Declares a scalar variable containing the filename.
- `open my $fh, '<', $filename;`: Opens the file as readonly mode (`<`), and saves 
  the file handle into the `$fh` variable.  
    - Modes:
        - `<`: Read
        - `>`: Write (truncate/overwrite)
        - `+<`: Read and Write
        - `>>`: Append
    - The file handle is like a reference to the file.  
      This is what you use to close the file.  
    - If the file can't be opened, `die` will stop the program and print
      the error (`$!`).
- `chomp(my @lines = <$fh>);`: 
    - `chomp` strips the newlines off of each element (assuming `$/` is default).
    - `<$fh>`: The diamond operator
        - In scalar context, it returns the next line
        - In list context, it slurps the file into an array of lines.
        - Each element includes the trailing newline unless using `chomp`.  
    - `my @lines = <$fh>`: 
        - `<$fh>`: Expands into an array containing the lines of the file.
        - `my @lines = <$fh>`: Essentially duplicates the array of lines. 
- `close $fh;`: Closes the file. Best practice. You should really always do this.
    - Perl will auto-close when the script exits. 
    - But, for long running scripts, not closing can cause file descriptor leaks. 

---

### Other ways to read in lines from a file
Read a file into an array using `$ARGV` (reads from stdin or a file given to
the script):
```perl
# ./script.pl < file.txt
# ./script.pl file.txt
chomp(my @lines = <>);
```

Filter lines with `grep` before saving to a new array:
```perl
my @markdown_links = grep { /^\s*-/ } @lines;
```

Transforming lines with `map`:
```perl
my @uppercased = map { uc($_) } @lines;
```
- `map` creates a new list based on the expression.
    - It evaluates the expression (`{ ... }`) and saves the results in the new list.
    * Map always returns a list, and can be assigned to a hash where the elements
      become key/value pairs. See `perldoc -m perldata`.



## Array Operations

Loop over an array with a `foreach` loop.
```perl
foreach my $line (@lines) {
    print "$line\n";
}
```

---

Access individual elements with the square bracket notation `[ ]`.
```perl
print $lines[0];        # first element
print $lines[-1];       # last element
print $lines[$#lines];  # last element
```
The last one - `$lines[$#lines]` - uses the `$#lines` syntax.  
This is used to get the last index of the array.  
It will evaluate to the length of the array minus 1.  

---

Loop over only a select number of elements:
```perl
my @first_5 = @lines[0..4]
foreach my $line (@first_5) {
    print "Line: $line\n"
}
```

### Reading a List of Filenames into an Array
If you wanted to read a list of filenames into an array, you could use a 


## Hashes (Associative Arrays)
In perl, associative arrays (or dictionaries) are called "hashes."  
A hash is denoted by a percent sign (`%`).  
```perl
my %hash;
```

