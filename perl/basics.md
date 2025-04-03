# Perl Basics

## Table of Contents
* [Running Perl](#running-perl) 
* [Scalar Variables](#scalar-variables) 
    * [Examples of Scalars in Perl](#examples-of-scalars-in-perl) 
    * [Scalar Operations](#scalar-operations) 
    * [Scalar Context vs List Context](#scalar-context-vs-list-context) 
        * [Scalar Context](#scalar-context) 
        * [List Context](#list-context) 
* [Perl File Structure](#perl-file-structure) 
* [Pragmas](#pragmas) 
* [Subroutines](#subroutines) 
    * [Passing arguments to subroutines](#passing-arguments-to-subroutines) 
    * [Returning values from subroutines](#returning-values-from-subroutines) 
    * [Example subroutine: Check if a file exists](#example-subroutine-check-if-a-file-exists) 
* [Using Arrays in Perl](#using-arrays-in-perl) 
* [Using `Data::Dumper` to Print Data](#using-datadumper-to-print-data) 
* [Accessing Command Line Arguments](#accessing-command-line-arguments) 
* [Command Line Options](#command-line-options) 
* [BEGIN and END Blocks](#begin-and-end-blocks) 
* [Resources](#resources) 

## Getting Help
`man perl` is available, but it is not as robust as some man pages.
The `man` page recomands `perldoc`. This is a separate package that will need to be
installed. 
```bash
sudo apt-get install -y perl-doc
man perldoc
```

For runtime options/flags:
```bash
perldoc perlrun
```

To get help with a perl function, use `perldoc -f func`:
```bash
perldoc -f chomp
```

For perl variables, use `perldoc -v var`
```bash
perldoc -v ARGV
```

For perl modules, use `perldoc -m module`
```bash
perldoc -m data
```

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
perl -E 'say "Hello, world"'
# Hello, world
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




## Variables
Types of variables in perl are:
- Scalar
- Array
- Hash

Every variable type has its own namespace, along with some non-variable identifiers.  
Basically meaning, you can use the same name for a scalar variable and an array
variable and they won't conflict.  
```perl
my @var = (1, 2, 3);
my $var = "Hello, world.";
print "@var\n";
# 1 2 3
print "$var\n"
# Hello, world.
```

Not "technically" variables, but the same rule applies to these:
- Handles
    - File Handle
    - Directory Handle  
- Subroutine names
- Format names
- Labels

Just because you *can* doesn't mean you *should*.  

### Scalar Variables
In perl, anything that is a single unit of data is a `scalar` value.  
That unit of data could be a string, number, or reference.  
Scalars are represented with the dollar `$` sign prefix.  

A scalar always holds one value at a time.  
There's really no need for different types since perl is dynamically typed.  
So, scalar is kind of its own data type in perl.  


### Examples of Scalars in Perl
Dynamically typed scalar:
```perl
my $var = 42;  # $var scalar holds a number
$var = "Hi";   # Now it holds a string
```

Strings:
```perl
my $greeting = "Hello, perl.\n";
print $greeting;
```

References:
```perl
my $array_ref = [1, 2, 3]; # This is a *reference* to an array.
print $array_ref->[0];     # outputs: 1
```

---

#### Scalar Operations
---

* Scalars can holds numbers and perform mathmatical operations.  
  ```perl
  my $a = 10;
  my $b = 21;
  my $sum = $a + $b;
  print $sum;
  ```

* Scalars can also holds strings, and you can perform concatenation.  
  ```perl
  my $first = "Hello";
  my $second = "World";
  my $combined = $first . ", " . $second;
  print $combined;  
  ```
  Use `.` to concatenate strings in perl.  

* Scalars can be evaluated to `true` or `false` for boolean operations.  
    * Non-zero numbers and non-empty strings are `true`.  
    * Zero `0` and empty strings `""` are `false`.  
      ```bash
      my $x = 44;
      if ($x) {
          print "True. Variable exists and is not 0.\n"
      }
      ```

* Scalar context is *the* way to get the length of an array.  
  ```perl
  my @colors = ('red', 'green', 'blue');
  my $count = @colors;  # get the number of elements
  print "Number of colors: $count\n"; 
  ```

### Accessing Variables

From `perldoc -m data`:
```perl
$days               # the simple scalar value "days"
$days[28]           # the 29th element of array @days
$days{'Feb'}        # the 'Feb' value from hash %days
$#days              # the last index of array @days
@days[$#days]       # the last element of array @days
@days               # ($days[0], $days[1],... $days[n])
@days[3,4,5]        # same as ($days[3],$days[4],$days[5])
@days{'a','c'}      # same as ($days{'a'},$days{'c'})
%days               # (key1, val1, key2, val2 ...)
```

## Scalar Context vs List Context with Arrays
In perl, context determines how expressions are evaluated.  
Scalars are always evaluated in scalar context, but arrays/hashes are a little
different.  
You set the context by using the prefix `$` or `@` for scalar and list respectively.  

### Scalar Context
In scalar context, if an operation or function is expected to return a singel value,
it operates in a scalar context.  
An example of this:
```perl
my @arr = (1, 2, 3);
my $count = @arr;  # In scalar context, @arr returns its size
print $count; # 3
```
Using `$count` as the variable, with `$`, sets the context as scalar.  

---

#### List Context
If an operation or function is expected to return a list of values, it operates in 
list context.  

Example:
```perl
my @arr = (1, 2, 3);
my @copy = @arr;  # in list context, @arr returns all its elements
print @copy; # outputs: 123 (flattened)
```
Using `@copy` as the variable, with `@` to specify an array, it sets the context as list.  

---


## Perl File Structure

```perl
#!/bin/perl
 
use strict;
use warnings;
 
print "Hello, world!\n";
 
1;
```

Each line in a Perl script should be ended with a semicolon `;`.  
A perl file will start with a shebang line (`#!/bin/perl` or `/usr/bin/env perl`).

The lines starting with `use` are called **pragmas**.
There are a lot of pragmas that can be used to enable or disable certain features

The return code can be stated at the bottom.  




## Pragmas
Pragmas in perl change the way the code behaves.  
They're compiler directives. Instructions that modify the behavior of Perl during compilation.  
They're not functions or modules, but rather flags that control the compilation and
execution of the script.  
They're included using the `use` keyword.  

Some common pragmas:
* `strict`: Enforces stricter programming rules, like declaring variables before using them.  
    * Helps catch typos and errors early.  
    ```bash
    use strict;
    my $var = 42;  # Without `my`, perl would throw an error
    ```

* `warnings`: Outputs warnings for potentially problematic code
    * For example, if you're using an uninitialized variable.  
      ```bash
      use warnings; 
      my $x;
      print $x; # warns: use of uninitialized value $x
      ```

* `utf8`: Enables utf-8 encoding for the script's source code.  
  ```bash
  use utf8;
  my $str = "こんにちは"; # Japanese greeting
  ```

* `autodie`: Makes file operations (e.g., `open`) throw exceptions on failure.  
  ```perl
  use autodie; 
  open my $gh, '<', 'nonexistent.txt'; # dies if the file doesn't exist
  ```

## Subroutines
Functions in perl are called subroutines.  
Subroutines are reusable blocks of code that perform a specific task.  

Use the `sub` keyword to define a subroutine.  
```perl
use warnings;
use strict;
 
sub say_hello {
    print "Hello, world.\n"
}

say_hello(); # Call the subroutine. 
```

### Passing arguments to subroutines
You can access any arguments passed to a subroutine using the `@_` array.  

```perl
use warnings;
use strict;
 
sub say_hello {
    my ($name) = @_;
    print "Hello, $name.\n"
}

say_hello("Kolkhis"); # Call the subroutine. 
# Outputs: Hello, Kolkhis.
```
The parentheses in `($name)` says you want to assign the first value from the list
`@_` to the variable.

Without the parentheses, perl would not treat the right-hand side as a list.
It would assign `$name` to the number of elements in the `@_` list.  


### Returning values from subroutines

Subroutines return values using the `return` keyword.  
Or, they implicitly return the last evaluated expression.  
```perl
sub add {
    my ($a, $b) = @_;
    return $a + $b;
}

my $sum = add(2, 3)
print $sum; # outputs: 5
```

### Example subroutine: Check if a file exists
```perl
sub file_exists {
    my ($file) = @_;
    return -e $file; # Returns 1 if file exists, 0 otherwise. 
}
```

## Using Arrays in Perl
Arrays are generally accessed by using `@` (the whole array) or `$` to get a single value.  

Perl can have arrays that are simply references to an array, and not actually arrays themselves.  


## Using `Data::Dumper` to Print Data
Normal `print` statements will flatten any sort of data structures. 
Arrays, dictionaries/hashes, and nested combinations won't be seen correctly with `print`.  

`Data::Dumper` is used to format these data structures into human-readable strings.  

```perl
use Data::Dumper;

my $input = $ARGV[0];
print "First argument: $input\n";
print "Remaining arguments: ", Dumper(\@ARGV); 

my $input = shift;
print "First argument: $input\n";
print "Remaining arguments: ", Dumper(\@ARGV); 
```
* `Data::Dumper`: A perl module that converts complex data structures (arrays,
  dictionaries/hashes, etc) into a human-readable string.  
    * Regular `print` statements won't give you the output, it will flatten this data.  
* `\@ARGV`: The `\` is used to pass a reference to the array `@ARGV`.  
    * This creates a reference so that `Dumper` knows you're passing a whole array, not 
      the contents of the array.  


* The difference between `$ARGV[n]` and `@ARGV` comes from how variables are accessed in Perl:
    * `@ARGV`: Refers to the entire array. I.e., all the command-line arguments.
    * `$ARGV[0]`: Accesses a single element (scalar) from the array `@ARGV`.  
    * `$ARGV` (without `[]`, scalar context): Holds file name passed in via command line 
      arguments or stdin when used in scalar context. 

Accessing elements in arrays:
* `$` = Single value (scalar).
* `@` = Full array.

To output an array:
If we pass an array to `Data::Dumper` without a reference (`\@`), then the output will look different:
```bash
$VAR1 = 1;
$VAR2 = 2;
$VAR3 = 3;
```
If we pass the array with a reference, the output will look like how the array
is actually structured:
```bash
$VAR1 = [
          1,
          2,
          3
        ];
```

If we use `print` to output a list, it will flatten all the elements into one string.
```perl
print "All elements of the array: @ARGV\n"
```
Then at the command line:
```bash
./argtest.pl this is a test
# output:
# All elements of the array: this is a test
```



## Accessing Command Line Arguments
You can access CLI arguments from a script in a couple different ways.
* `$ARGV`: An array that holds all the CLI arguments.  
    * Stands for "Argument Vector."
    * Using `$ARGV[0]` will not modify the `@ARGV` array.  
* `shift`: Command that **removes and returns** the first element from `@ARGV`.  
    * If called inside a subroutine (function), it pulls from the default array `@_`.  
    * Just like `shift` in bash.  





## Command Line Options
Some CLI arguments for perl:

* `-p`: Places a printing loop around your command so that it acts on each line of standard input.
    * Use to loop over the contents of a file line by line and output every line after being processed.  
    * This is similar to what `awk` does.  

* `-e`: Allows you to provide the perl script as an argument rather than in a file.
    * Identical to `-c` in Python or Bash.  

* `-i`: Edit the file in place, making a backup of the original.
    * Allows you to modify files without `{copy, delete-original, rename}`.

* `-n`: Places a non-printing loop around your command.
    * Use to loop over the contents of a file line by line and NOT output anything
      other than what you specify.  
* `-w`: Activates some warnings. 
    * Someone said "Any good Perl coder will use this."

* `-d`: Run the command under the Perl debugger.  

* `-t`: Taint mode. Treats **certain** operations as "tainted" code.  
    * It treats any external input (i.e., CLI args) as tainted until it's sanitized.  
    * Use to beef up Perl security, e.g., when running as setuid scripts.  

* `-T`: Taint mode, for a whole script.
    * Doesn't just use taint mode for certain operations, it treats **all** external data as taineted until sanitized.   
    * This is used to prevent bad actors for performing destructive operations. 
      ```bash
      ./script.pl '; rm -rf /'
      ```
    * Use in scripts to check input.  
      ```perl
      #!/usr/bin/env perl -T
      use strict;
      use warnings;
  
      my $input = $ARGV[0];
      my $input = shift;
      if ($input =~ /^(\w+)$/) {
          print "Safe input: $1\n"
      } else {
          die "Tainted input detected.\n"
      }
      ```
  
## BEGIN and END Blocks
Like `awk`, `perl` has a `BEGIN` and `END` block.  
Anything inside the `BEGIN` block will run once, before the main code block starts execution.  
Likewise, anything in the `END` block runs once, after the main code block finishes execution.  
This is really only useful when doing one-liners from the command line.  

---

Example: print the total word count of a file in the `END` block  
```bash
perl -ne 'END { print $t } @w = /(\w+)/g; $t += @w' file.txt
```
* `-n`: Loop over the file, line by line.  
    * Same as `while(<>)`
* `-e`: Allows execution of the code provided directly as a string.  
    * Similar to `-c` in other tools.  
* `END { print $t }`
    * The `END` block is executed once after all lines of the file have been processed.  
    * It prints the value of `$t`, which is the total word count.  
* `@w = /(\w+)/g`:
    * `@w` is an array.
    * `/(\w+)/g`: Regex that matches every `word` in the current line.  
        * `\w+`: Matches one or more word characters (letters, digits, or underscores).  
        * `g`: Global modifier. Ensures all matches in the line are captured.  
    * For each line, `@w` contains all words found in that line.  
* `$t += @w`: 
    * `$t`: Scalar variable, initialized to `0` by default.  
    * `@w`: In scalar context, gives the number of elements in the array (words).  
    * `$t` holds the total number of words across all lines.  
* `file.txt`: The input file.  

---

## File Operations
You can open files with the `open` function:
```perl
open my $fh, '<', 'file.txt' or die $!; 
```
- `open`: Builtin perl function to open a file.
    - `my $fh`: Defines `$fh` as a file handle. Like a pointer to the opened file.
        - The `my` keyword makes it lexically scoped (only available in that block)
    - `'<'`: Open in read-only mode.
        - `<`: Read
        - `>`: Write (truncate/overwrite)
        - `+<`: Read and Write
        - `>>`: Append
    - `'file.txt'`: The file to open
    - `or die $!;`: If `open` fails, this will terminate the script and print the
      system error msg from `$!`.

Close files with the `close` function, passing the file handle as an argument:
```perl
close $fh;
```
Always close files when you're done with them!
It's a good practice to free up system resources.  
If you forget to close, Perl may close it automatically when the script ends.
But, in long-term running scripts, not closing the file can cause **file descriptor leaks**. 

---

When you have opened a file and assigned a file handle, you can read from the file
using the **diamond operator** (`<>`).

You can use `while (<$fh>)` to loop over the lines of the file:
```perl
open my $fh, '<', 'file.txt' or die $!;
while (<$fh>) {
    print "$_";
}
close $fh;
```
This is the idiomatic way to loop over a file's lines.  

---

If you want, you can also save the line into a variable to use in the `while` loop:
```perl
open my $fh, '<', 'file.txt' or die $!;
while (my $line = <$fh>) {
    print $line;
}
close $fh;
```
Do this if you want to make the variable name clear, or if you're working with 
multiple filehandles in the same scope and don't want to rely on `$_`.  

---

File operation workflow:
```bash
Open -> Assign FileHandle -> Read from filehandle using `<>` -> close filehandle
```


---

## Resources
* [Perl Command Line Options - perl.com](https://www.perl.com/pub/2004/08/09/commandline.html/)


