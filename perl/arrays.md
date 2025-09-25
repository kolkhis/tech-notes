# Arrays in Perl
Arrays in perl are usually denoted with the `@` symbol.  
For instance, a default array is `@ARGV`, which is the argument vector. It holds all
the command line arguments passed to the script.  

Associative arrays, called "Hashes" in Perl, are denoted with the `%` symbol.  

## Table of Contents
* [Accessing Variables in Arrays](#accessing-variables-in-arrays) 
* [Reading Data into an Array](#reading-data-into-an-array) 
    * [Reading Lines from a File](#reading-lines-from-a-file) 
    * [Other ways to read in lines from a file](#other-ways-to-read-in-lines-from-a-file) 
* [Array Operations](#array-operations) 
    * [Getting the Length of an Array](#getting-the-length-of-an-array) 
    * [One-liner File Slurp with UTF-8](#one-liner-file-slurp-with-utf-8) 
    * [Reading a List of Filenames into an Array](#reading-a-list-of-filenames-into-an-array) 
* [Hashes (Associative Arrays)](#hashes-associative-arrays) 
    * [Declaring and Defining Hashes](#declaring-and-defining-hashes) 
    * [Keys and Values](#keys-and-values) 
    * [Adding, Modifying, and Accessing Hash Values](#adding-modifying-and-accessing-hash-values) 
    * [Accessing References in Hashes](#accessing-references-in-hashes) 
        * [tl;dr: Accessing References](#tldr-accessing-references) 
    * [Checking for Existence in a Hash](#checking-for-existence-in-a-hash) 
    * [Deleting a Key in a Hash](#deleting-a-key-in-a-hash) 
    * [Looping over a Hash](#looping-over-a-hash) 
        * [`keys`](#keys) 
        * [`each`](#each) 
    * [Sorting a Hash by Key or Value](#sorting-a-hash-by-key-or-value) 
    * [Hash tl;dr](#hash-tldr) 
* [Example of Accessing Arrays in a Hash](#example-of-accessing-arrays-in-a-hash) 

## Defining an Array

You define an array in Perl by using the `@` variable prefix, and then list the
elements in parentheses, separated by commas.  
```perl
my @nums = ('one', 'two', 'three');
```

You can also create array from sequences using `..` to specify ranges.  
```perl
my @nums = (1..10);
my @letters = (a..z);
```
This will create a `@nums` array that contains the numbers 1 through 10, and a
`@letters` array that contains the entire lowercase alphabet.  

## Accessing Variables in Arrays

Each element of an array is usually a scalar value (a single unit of data).  

Access individual elements with the square bracket notation `[ ]`.
```perl
my @lines = ('line one', 'line two', 'line three', 'line four', 'line five')
print $lines[0];        # first element
print $lines[-1];       # last element
print $lines[$#lines];  # last element
```
The last one (`$lines[$#lines]`) uses the `$#lines` syntax.  
This is used to get the last index of the array.  
It will evaluate to the length of the array minus 1.  

---

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

Loop over an array with a `for`/`foreach` loop.
```perl
foreach my $line (@lines) {
    print "$line\n";
}
# or, just use `for` (does the same thing)
for my $line (@lines) {
    print "$line\n";
}
```

This will store each element in the `$line` variable for each iteration.  

If you omit `my $line`, you can simply use the default variable (`$_`) to
access the current element.
```perl
for (@lines) {
    print "$_\n";
}
```

---

Loop over only a select number of elements:
```perl
my @first_5 = @lines[0..4]
for my $line (@first_5) {
    print "Line: $line\n"
}
```

---

### Getting the Length of an Array
Get the length of an array (or hash) using the `scalar` function (not the `length()` function).  
```perl
# Array size:
scalar(@array);

# The number of items in a hash:
scalar(keys %hash);
```
This forces the `@array` or `keys %hash` list into scalar context, which always
returns the number of elements.  

---

Why not use `length()`?  

The `length()` function works on strings, and forces the arguments passed to it into
scalar context.
So, when a list is passed in, it's forced into scalar context (returning the number 
of elements), and the result is a single number.  
It will resolve to `length(n)`, and `n` will be the string length of the number of 
elements.


### One-liner File Slurp with UTF-8
```perl
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';

my $filename = 'file.txt';
open(my $fh, '<', $filename) or die $!;
my $contents = do { local $/; <$fh> }; # Slurp entire file into one scalar
close $fh;
```

### Reading a List of Filenames into an Array
If you wanted to read a list of filenames into an array, you could use a 


## Hashes (Associative Arrays)
In perl, associative arrays (or dictionaries) are called "hashes."  

### Declaring and Defining Hashes
A hash is denoted by a percent sign (`%`).  
```perl
# declare a hash variable
my %fruits;
```
A hash uses parentheses when defining the values.  

The values in a hash are mapped with `=>` (rather than `:` or `=` in other langs).  
```perl
# define a hash variable
my %fruits = (
    apple => 'red',
    banana => 'yellow',
);
```

The left side is auto-quoted with `=>`, but you can use strings as keys:
```perl
my %fruits = (
    "apple" => "red",
    "banana" => "yellow",
);
```

The `=>` is just Perl syntactic sugar for `,`. So you could technically just use `,`
instead of `=>`, but it's far less readable and doesn't auto-quote the left side.  

### Keys and Values

Only scalars can be used as keys. Perl will stringify any numbers that are used as keys.  
Keys can **not** be arrays, hashes, or references.  

For values, anything scalar can be used: strings, numbers, references (arrays, hashes, code).  
So this is totally valid:
```perl
my %stuff = (
    name    => "Kolkhis",
    score   => 42,
    colors  => ['red', 'green'],        # Array reference
    nested  => { admin => 1 },          # Hash reference
    action  => sub { print "Hello\n" }, # Code reference
);
```

So any of these can be values:

* `@array`: an array (list context)
* `%hash`: a hash
* `\@array`: a scalar reference to that array
* `\%hash`: a scalar reference to that hash

So when you do this:
```perl
colors => ['red', 'green'],
nested => { admin => 1 },
```

You're assigning array and hash *references*, which are scalars under the hood:

* `['red', 'green']` is a reference to an anonymous array, so it's a scalar.
* `{ admin => 1 }` is a reference to an anonymous hash, so it's a scalar. 

Doing it this way, you can store arrays, hashes, or even code in a hash as references.


### Adding, Modifying, and Accessing Hash Values
When accessing hash values, use braces `{ ... }` (not brackets `[ ... ]` like other
languages).  

- Access a value in a hash:
  ```perl
  my $color = $fruits{'apple'};
  ```
  You can also access multiple values at once:
  ```perl
  my @colors = $fruits{'apple', 'banana'};
  ```

- Adding/modifying values in a hash
  ```perl
  $fruits{"grape"} = "purple";
  ```

---

### Accessing References in Hashes
Since hashes support storing references to arrays, subroutines, and other hashes, you
need a way to access those values as well.  

If you need to access a hash value that's a reference (e.g., an array, a hash, or a
submodule), you will need to dereference it first.  
There are two main ways to do this:

- `->`: Dereference with this operator.  
    - Usually called the "arrow operator" or "method/dereference" operator.  
    - It serves two purposes:
        - Dereferences a reference (array, hash, or code) and accesses a memeber. 
          ```perl
          $hashref->{key};   # dereference a hashref
          $arrayref->[0];    # dereference an arrayref
          $coderef->();      # dereference and call a coderef
          ```
        - Also calls methods on objects (in OOPerl).  

- `${ ... }`: Dereference a reference by using this syntax.  
    - This is usually called **manual dereferencing** or scalar dereferencing syntax.  
    - This method is less common in modern perl (5.10+) but still valid and sometimes
      necessary (clarity/edge cases).  
      ```perl
      ${ $hashref }{key};    # manually dereference a hashref
      @{ $arrayref };        # dereference to an array
      &{ $coderef }();       # dereference and call a coderef
      ```


```perl
# Hashes can store all types of scalars
my %stuff = (
    name    => "Kolkhis",
    score   => 42,
    colors  => ['red', 'green'],        # Anonymous Array reference, technically a scalar
    nested  => { admin => 1 },          # Anonymous Hash reference, technically a scalar
    action  => sub { print "Hello\n" }, # Anonymous Code reference, technically a scalar
);

my %otherstuff = (
    stuff => \%stuff,  # Store reference to the `%stuff` hash
    some_code => sub { print "Hi!\n"; },
);

# Access the `%stuff` hash through the `%otherstuff` hash
print "name: $otherstuff{stuff}->{name}\n";
print "is admin: $otherstuff{stuff}->{nested}->{admin}\n";
print "The color red: $otherstuff{stuff}->{colors}[0]\n";

my $red = ${ $otherstuff{stuff} }{colors}[0];
my $green = ${ $otherstuff{stuff} }{colors}[1];

# Call the code in `some_code` (arrow style)
$otherstuff{some_code}->();

# Call the code in `some_code` (manual style)
${ $otherstuff{some_code} }();

# Call the code in `action` (arrow style)
$otherstuff{stuff}->{action}->();

# Call the code in `action` (manual style)
# the `&{ ... }` syntax dereferences a coderef
&{ ${ $otherstuff{stuff} }{action} }();

# Mixed:
${ $otherstuff{stuff} }{action}->();
```


#### tl;dr: Accessing References
```perl
my $colors  = ['red', 'green'];        # arrayref
my $nested  = { admin => 1 };          # hashref
my $action  = sub { print "hi" };      # coderef

# You access them like this:
print $colors->[0];        # arrayref dereferenced
print $nested->{admin};    # hashref dereferenced
$action->();               # coderef called
```


### Checking for Existence in a Hash
Perl made this simple.  
Check for the existence of an element in a hash using the `exists` function:
```perl
if (exists $fruits{"banana"}) {
    print "Banana is in the hash!\n";
}
```

### Deleting a Key in a Hash
Perl also made this simple.  
Use the `delete` function to delete an element from a hash:  
```perl
delete $fruits{"banana"};
```

### Looping over a Hash
There are a couple of ways to iterate over a hash in Perl.  

- Using `keys` with a `foreach` loop
- Using `each` with a `while` loop (more modern/efficient)
    - This method avoids looking up values manually.

#### `keys`
The `keys` function can used to iterate over a hash's keys in a `foreach` loop.  
```perl
foreach my $fruit (keys %fruits) {
    print "A $fruit has the color: $fruits{$fruit}\n";
}
```

#### `each`
The `each` function is more like Python in that it will read both the keys and the
values to loop over.  
```perl
while (my ($fruit, $color) = each %fruits) {
    print "A $fruit has the color: $color\n";
}
```

### Sorting a Hash by Key or Value
To sort a hash by its keys, combine `keys` with the `sort` function:
```perl
foreach my $fruit (sort keys %fruits) {
    print "A $fruit has the color: $color\n";
}
```

To sort by value, it's a little more verbose, and uses the `cmp` (string comparison
operator) along with the special `$a` and `$b` vars from `sort`.  
```perl
foreach my $fruit (sort { $fruits{$a} cmd $fruits{$b} } keys %fruits) {
    print "$fruit => $fruits{$fruit}\n";
}
```

- `keys %fruits`: Returns a list of all keys (`"apple"`, `"banana"`, ...)
- `sort { ... }`: Sorts that list using a custom comparison block.  
    - `sort { ... } LIST`: The braces are a code block (an anonmymous subroutine)
      that perl uses to compare to elements at a time. 
- `$a` and `$b`: Special variables used by `sort` to compare two elements.  
- `fruits{$a}` and `$fruits{$b}`: Uses those special vars uto look up the values of
  the keys
- `cmp`: String comparison operator.
    - Returns `-1` if left is less than right (lexographically)
    - Returns `0` if equal
    - Returns `1` if greater (lexographically)
    - It's the string version of `<=>` (spaceship operator), which is for comparing numbers.  

So this sorts by value, alphabetically.  



### Hash tl;dr:
```perl
# Hash declaration: either `=>` or `,` works
my %h1 = ( key => 'value' );
my %h2 = ( 'key', 'value' );  # same thing

# Keys are strings or numbers (scalars)
# Values can be any scalar, including references

# Sorting by value
foreach my $k (sort { $hash{$a} cmp $hash{$b} } keys %hash) {
    print "$k => $hash{$k}\n";
}

# Hashes can store all types of scalars
my %stuff = (
    name    => "Kolkhis",
    score   => 42,
    colors  => ['red', 'green'],        # Anonymous Array reference, technically a scalar
    nested  => { admin => 1 },          # Anonymous Hash reference, technically a scalar
    action  => sub { print "Hello\n" }, # Anonymous Code reference, technically a scalar
);

# Adding a reference to an existing hash
my %otherstuff = (
    stuff => \%stuff,
);
```

Access the hash that was referenced in the `%otherstuff` hash by dereferencing it
with `->`:
```perl
# access the elements of %stuff with the `->` syntax
print "Name: $otherstuff{stuff}->{name}\n";
```


Another way to dereference it (`${ reference }{key}`):
```perl
# access via manual dereferencing 
print "Name: ${ $otherstuff{stuff} }{name}"
```

* `$otherstuff{stuff}`: Returns a referene to the `%stuff` hash.
* `->{name}` dereferences the `stuff` hash and accesses the `name` key.


| Expression |  Meaning 
|-|-
| `$hash{key}`              |  Regular hash access
| `$hash{key}->{subkey}`    |  Access nested hash reference (clean way)
| `${ $hash{key} }{subkey}` |  Same, manual deref (no arrow syntax)

## Example of Accessing Arrays in a Hash

Let's say we have a hash:

```perl
my %unit_resources = (
    1 => [],
    2 => [],
    3 => [],
    4 => [],
    5 => [],
    '' => [],
);
```
This has keys `1` through `5`, and an additional empty key.  
Each of these keys corresponds to an array reference.  

We can access the array reference:
```perl
print "$unit_resources{$unit}";
```
But this will only access the reference.  
So we need to dereference it using "sigil syntax" (`@{ ... }`):  
```perl
print "@{ $unit_resources{$unit} }";
```
This accesses the actual array that holds the values.

So now we can append items to this array.  
```perl
push(@{ $final_resources{1} }, "https://example.com");
```

Now, the hash looks like this:
```perl
my %unit_resources = (
    1 => ['https://exmple.com'],
    2 => [],
    ...
```

## Printing the Contents of an Array

When printing out the contents of an array, you can use a `for` loop.  

```perl
for my $element (@my_array) {
    print "Element: $element\n"
}
```
This loops over the values in `my_array`, and saves each value to `$element`
for each iteration.  

If we excluded the `my $element`, we'd be able to use the default variable
instead.  
```perl
for (@my_array) {
    print "Element: $_\n";
}
```

---

The easiest and cleanest way to output the contents of an array on a single
line is to use an inline for-loop.  
```bash
print "Element: $_\n" for @my_array;
```

## Reading Filenames into an Array

Saving a list of files into an array is a pretty important thing to know.  

There are a few ways to do this.  

### Filename Globbing
This is probably the easiest method of getting a list of filenames in Perl.  
We can use globbing in Perl just like in Bash.  

Use a glob inside the diamond operator to make it expand into the filenames.  

```perl
#!/usr/bin/env perl
use strict;
use warnings;

my @filenames = <*.md>;
for my $file (@filenames) {
    chomp($file);
    print("File: $file\n");
}
```
The `*.md` will grab all files with the `.md` extension in **the current
directory**.

Then we loop over the filenames and do whatever we need to do with them.  

---

We can also use recursive globbing to grab all markdown files in the current
directory and **all subdirectories**.  
```perl
#!/usr/bin/env perl
use strict;
use warnings;

my @filenames = <**/*.md>;
for my $file (@filenames) {
    chomp($file);
    print("File: $file\n");
}
```

---

We can also just loop over the filenames without saving to an array just by
using the diamond operator.  

```perl
for my $file (<**/*.md>) {
    chomp($file);
    print("File: $file");
}
```

---

If we only wanted to print the filenames, we can do this with an inline
for-loop.  
```perl
print "File: $_\n" for <**/*.md>;
```

This would also work if we saved them into an array.  
```perl
print "File: $_\n" for @filenames;
```


### Passing Filesnames as CLI Args
We can pass in the filesnames as command line arguments
```bash
./example.pl file1.txt file2.txt
```

Then we'd save them into an array via the `@ARGV` array.  
```perl
my @filenames = @ARGV;
```

### Reading Filenames from a Directory
We can also use some Perl builtin functions to get a list of filenames by
reading them from a directory.  
Use the `opendir()` function to get a directory handle, then use `readdir()` to
get the contents.  

```perl
#!/usr/bin/env perl
use strict;
use warnings;

my $dir = '.';
opendir(my $dh, $dir) or die("Can't open $dir: $!");

my @files = grep { -f "$dir/$_" } readdir($dh);
closedir($dh);
print "$_\n" for @files;
```


