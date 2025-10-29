# Perl Basics

## Table of Contents
* [Getting Help](#getting-help) 
* [Importing Modules](#importing-modules) 
    * [Importing as an Alias](#importing-as-an-alias) 
* [Running Perl](#running-perl) 
    * [Running Perl Scripts](#running-perl-scripts) 
    * [Running Perl One-Liners](#running-perl-one-liners) 
    * [Piping to Perl](#piping-to-perl) 
    * [Setting the IRS from the CLI](#setting-the-irs-from-the-cli) 
        * [Paragraph Mode](#paragraph-mode) 
* [Variables](#variables) 
    * [Scalar Variables](#scalar-variables) 
    * [Examples of Scalars in Perl](#examples-of-scalars-in-perl) 
        * [Scalar Operations](#scalar-operations) 
    * [Accessing Variables](#accessing-variables) 
* [Scalar Context vs List Context with Arrays](#scalar-context-vs-list-context-with-arrays) 
    * [Scalar Context](#scalar-context) 
        * [List Context](#list-context) 
* [Lowercase Input](#lowercase-input) 
* [Perl File Structure](#perl-file-structure) 
    * [Pragmas](#pragmas) 
* [Subroutines](#subroutines) 
    * [Passing arguments to subroutines](#passing-arguments-to-subroutines) 
    * [Returning values from subroutines](#returning-values-from-subroutines) 
    * [Example subroutine: Check if a file exists](#example-subroutine-check-if-a-file-exists) 
    * [Passing `@_` to Subroutines](#passing-_-to-subroutines) 
    * [Subroutine Prototypes](#subroutine-prototypes) 
* [Using Arrays in Perl](#using-arrays-in-perl) 
* [Using `Data::Dumper` to Print Data](#using-datadumper-to-print-data) 
* [Accessing Command Line Arguments](#accessing-command-line-arguments) 
* [Command Line Options](#command-line-options) 
* [BEGIN and END Blocks](#begin-and-end-blocks) 
* [Using Subshells in Perl](#using-subshells-in-perl) 
* [Error Handling](#error-handling) 
* [Using Perl like Awk](#using-perl-like-awk) 
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

## Importing Modules
To import a module, use the `use` keyword.
```perl
use Data::Dumper;
```
This loads the module *and* imports its default symbols into our namespace.  

So, then we could use the `Dumper` subroutine from this module by simply calling
it by name (since it's in our namespace):
```perl
my @arr = ('one', 'two', 'three');
print "Array contents:\n" . Dumper(\@arr);
```

The fully scoped path to this subroutine would normally be 
`Data::Dumper::Dumper()`. But since the `use` populates our namespace, we don't
have to fully scope in.  

---

If we want to load the module but **not** pollute the namespace with all the
module's symbols, we can add an empty import list.  
```perl
use Data::Dumper ();
```

This will require you to call the module with the fully qualified (scoped)
name.  
```perl
Data::Dumper::Dumper(\@arr)
```

This method keeps things cleaner.

### Importing as an Alias

You can alias your imports. You can also alias specific subroutines that are
available from a module.  
```perl
*dumper = \&Data::Dumper;     # Alias a module
*dump = \&Data::Dumper::dump; # Alias a specific subroutine
```

- `*dumper = ...`: Assigns a globref (glob reference) to the typeglob `*dumper`.  
    - This creates a new symbol in the current package.  
    - A globref is 
    - A typeglob is a special kind of variable that can hold multiple values of
      multiple types (incl. scalars, arrays, hashes). Allows you to access all the 
      variables associated with a particular name in a single reference.    
- `\&Data::Dumper;`: A **reference** to the module `Data::Dumper`.  




## Running Perl

> `perldoc perlrun`

### Running Perl Scripts
From the command line, you can run a perl script like any other language.
Type `perl` then the name of the perl script.
```bash
perl myscript.pl
```
Alternatively, if you have the correct shebang line (e.g., `#!/usr/bin/local/perl` or
`#!/usr/bin/env perl`) then you can just execute the script directly.  
```bash
./myscript.pl
```

---

### Running Perl One-Liners

To run perl commands from the command line, use the `-e` flag.
```bash
perl -e 'print "Hello, world\n"'
```
If you use double quotes in your `-e` expression, the shell expands variables.  
Single quotes are preferred for that reason.  

---

Use the `-E` flag to run the commands to enable some of the pro core features (i.e., the `use strict` pragma.)
```bash
perl -E 'print "Hello, world\n"'
# Hello, world
perl -E 'say "Hello, world"'
# Hello, world
```
The `-E` option behaves just like `-e` but enables **all** optional features.  

`say` automatically adds a newline at the end of a string.
Does not work with `-e`, because features are not enabled with `-e`.  


---

```bash
perl -E 'while(<>) { say uc $_ }'
```
- `while(<>)` reads from STDIN
    - This could also be done with the `-n` option.  
- `say uc $_` prints (`say`) the uppercase (`uc`) version of the current line (`$_`)
This will wait for user input and print it back in uppercase.

### Piping to Perl

If you're piping input to Perl, use either `-p` or `-n` to loop over the input.  
```bash
printf "Hello, world.\n" | perl -pe 's/Hello/Hi/'
```
The `-p` options is usually what you want for basic substutitions.  
It wraps the input in a **printing loop**.  
This means that it will print each line as it is being processed.  

Basically, it is equivalent to this perl program:  
```perl
while (<>) {
    print $_;
}
```

Whatever code you have in `-e` will also be inside this while loop.  

```perl
while (<>) {
    $_ =~ s/Hello/Hi/;
    print $_;
}
```

> Note: The `=~` operator serves as both a comparison operator and an assignment
> operator.  

---

If you use `-n` (e.g., `perl -ne`), the input will be wrapped in a **non-printing
loop**.  

So doing this:
```bash
perl -ne 'print "The current line is: $_\n"'
```

Will not print the lines by default, unless explicitly printing the `$_` variable.  
This is what that command is doing:
```perl
while (<>) {
    print "The current line is: $_\n";
}
```


### Setting the IRS from the CLI
The IRS (Input Record Separator) is a special variable (`$/`) which determines how 
Perl reads in lines. By default, `$/` is set to newline (`\n`), which means it reads 
input line-by-line.  

Use the `-0` flag to set the input record separator when running Perl.  
```bash
perl -pi -0<OCTAL_VALUE> 
```
The `-0` option accepts any octal or hexadecimal value to use as the IRS.  

If you're specifying a hexadecimal value, add an `x`:
```bash
perl -pi -0x<HEX_VALUE>
```
When using hexadecimal, you can actually specify a unicode character... if you have
weirdly-delimited input.  

---

Using `-0` without any arguments will set the IRS (`$/`) to `NUL`.  
```bash
perl -pi -0 ...
```
This will set the separator to `NUL` (`\0`), which is good for working with tools
that output `NUL`-delimited text. For example, using `find -print0` or `xargs -0`.  


#### Paragraph Mode

```bash
perl -pi -00 
```

The `-00` option is special, it causes Perl to "slurp" files in **paragraph mode**, 
which sets the IRS to an empty string, and forces Perl to read in paragraphs
separated by one or more blank lines, e.g., **two consecutive newline characters** (`\n\n`).  

One newline to end the paragraph, and another to represent a blank line.  

---


## Variables
See [variables](./variables.md) for more indepth explanations.  


Types of variables in perl are:

- Scalar: A single values.  
- Array: A single-vector list of values.  
- Hash: An array of key/value pairs.  

Every variable **type** has its own namespace, along with some non-variable identifiers.  

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
    - File handles
    - Directory handles  
- Subroutine names
- Format names
- Labels

Just because you *can* doesn't mean you *should*.  
As a best practice, you should always give your variables and functions unique names
for clarity.  

### Scalar Variables
In perl, anything that is a single unit of data is a `scalar` value.  
That unit of data could be a string, number, or reference.  
Scalars are represented with the dollar `$` sign prefix.  

A scalar always holds one value at a time.  

There's really no need for different types since perl is dynamically typed.  
So, scalar is kind of its own data type in perl. There are still numbers and
strings, but they're dynamically cast into the correct type based on the context
they're used in.  


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

- Scalars can holds numbers and perform mathmatical operations.  
  ```perl
  my $a = 10;
  my $b = 21;
  my $sum = $a + $b;
  print $sum;
  ```

- Scalars can also holds strings, and you can perform concatenation.  
  ```perl
  my $first = "Hello";
  my $second = "World";
  my $combined = $first . ", " . $second;
  print $combined;  
  ```
  Use `.` to concatenate strings in perl.  

- Scalars can be evaluated to `true` or `false` for boolean operations.  
    * Non-zero numbers and non-empty strings are `true`.  
    * Zero `0` and empty strings `""` are `false`.  
      ```bash
      my $x = 44;
      if ($x) {
          print "True. Variable exists and is not 0.\n"
      }
      ```

- Scalar context is *the* way to get the length of an array.  
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

If we wanted to force array context for a scalar variable:
```perl
my ($string) = @list;
```

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

## Lowercase Input

```bash
ls -alh | perl -pe '$_ = lc $_'
```
This turns all input to lowercase.  
This doesn't actually use any regular expressions, it utilizes the "default"
variable (holds the current line) and the `lc` (lowercase) perl function.  

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
A perl file will start with a shebang line (`#!/usr/bin/perl` or `#!/usr/bin/env perl`).

The lines starting with `use` are imports. Any modules imported with all
lowercase names are called **pragmas** (in Perl itself). Any imports with 
uppercase letters are regular modules.

There are a lot of pragmas that can be used to enable or disable certain features.  

The return code can be stated at the bottom.  




### Pragmas

Pragmas (pragmatic modules) in perl change the way the code behaves. These are
written in all lowercase, because all lowercase module names are reserved for
Perl itself.  

They're compiler directives. Instructions that modify the behavior of Perl during compilation.  
They're not functions or modules, but rather flags that control the compilation and
execution of the script.  
They're included using the `use` keyword.  

Some common pragmas:

- `strict`: Enforces stricter programming rules, like declaring variables before using them.  
    * Helps catch typos and errors early.  
    ```bash
    use strict;
    my $var = 42;  # Without `my`, perl would throw an error
    ```

- `warnings`: Outputs warnings for potentially problematic code
    * For example, if you're using an uninitialized variable.  
      ```bash
      use warnings; 
      my $x;
      print $x; # warns: use of uninitialized value $x
      ```

- `utf8`: Enables utf-8 encoding for the script's source code.  
  ```bash
  use utf8;
  my $str = "こんにちは"; # Japanese greeting
  ```

- `autodie`: Makes file operations (e.g., `open`) throw exceptions on failure.  
  ```perl
  use autodie; 
  open my $gh, '<', 'nonexistent.txt'; # dies if the file doesn't exist
  ```

---

You can specify what to load from a pragma by giving it an argument.  
```perl
use charnames ":full";
```

- `":full"`: This is a pragma argument, or "tag."  
    - It's not normal Perl syntax, it's now certain pragmas (`open`, `charnames`,
      `strict`, `warnings`) allow you to configure what they load or activate.  

View the `perldoc` page for the pragma to see what tags you can specify and what they do.  


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
It would assign `$name` to the number of elements in the `@_` list, since the right
hand side is being evaluated in **scalar context** due to the left hand side being a
scalar assignment.  

So, using parentheses around the scalar variable assignment allows the RHS to be 
evaluated in **array context** (sort of).  
It's like a tuple assignment in Python. It will take the first argument from `@_`,
and assign that to the scalar variable `$name`.  


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

### Passing `@_` to Subroutines

There are two ways to call a subroutine.  

1. The first one is the most obvious way:
   ```perl
   file_exists "somefile";
   file_exists("somefile");
   ```

2. Then, we can use `&` to also call the subroutine, but this can have side
   effects. It passes the current `@_` (default array), unless prentheses are
   used. It also bypasses [prototypes](#subroutine-prototypes).  
   ```bash
   &file_exists;  # Pass in the current `@_`
   &file_exists("somefile");  # Bypass prototypes
   ```
    - Subroutine prototypes define the expected number and types of arguments for a subroutine.  

| Syntax  |  Action                            
|---------|------------------------------------
| foo()   |  Calls sub `foo`                      
| &foo    |  Calls sub `foo` with current `@_`        
| \&foo   |  Reference to subfoo(for callbacks)

### Subroutine Prototypes

Subroutine prototypes define the expected number and types of arguments for a 
subroutine.  

In the subroutine definition, you specify one sigil per argument that is 
expected within the parentheses after the sub name.  
For example, one `$` per scalar, one `@` per array, etc.  

```perl
sub test($$) { print "Args: @_"; } # Expects two scalar arguments
test("one", "two")
&test("one")
```

- This subroutine expects two scalar arguments.  

## Using Arrays in Perl
Also see [arrays.md](./arrays.md).  

Arrays are generally accessed by using `@` (the whole array, or "array context") or 
with `$` ("scalar context") to get a single value.  

Perl can have arrays that are simply references to an array, and not actually arrays 
themselves, using the syntax `\@array_name`. This creates a reference to the array
`@array_name`.  


## Using `Data::Dumper` to Print Data
Normal `print` statements will flatten any sort of data structures. 
Arrays, dictionaries/hashes, and nested combinations won't be seen correctly with `print`.  

The `Data::Dumper` sub from the `Data` module is used to format these data structures 
into human-readable strings.  

```perl
use Data::Dumper;

my $input = $ARGV[0];
print "First argument: $input\n";
print "Remaining arguments: ", Dumper(\@ARGV); 

my $input = shift;
print "First argument: $input\n";
print "Remaining arguments: ", Dumper(\@ARGV); 
```

- `Data::Dumper`: A perl module that converts complex data structures (arrays,
  dictionaries/hashes, etc) into a human-readable string.  
    * Regular `print` statements won't give you the output, it will flatten this data.  
- `\@ARGV`: The `\` is used to pass a reference to the array `@ARGV`.  
    * This creates a reference so that `Dumper` knows you're passing a whole array, not 
      the contents of the array.  


- The difference between `$ARGV[n]` and `@ARGV` comes from how variables are accessed in Perl:
    * `@ARGV`: Refers to the entire array. I.e., all the command-line arguments.
    * `$ARGV[0]`: Accesses a single element (scalar) from the array `@ARGV`.  
    * `$ARGV` (without `[]`, scalar context): Holds file name passed in via command line 
      arguments or stdin when used in scalar context. 
        - This will hold the filename that is currently being processed if there are
          multiple files.  

Accessing elements in arrays:

- `$` = Single value (scalar).
- `@` = Full array.

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

- `@ARGV`: An array that holds all the CLI arguments.  
    * Stands for "Argument Vector."
    * Using `$ARGV[0]` will not modify the `@ARGV` array.  
- `shift`: Command that **removes and returns** the first element from `@ARGV`.  
    * If called inside a subroutine (function), it pulls from the default array `@_`.  
    * Just like `shift` in bash.  





## Command Line Options
Some CLI arguments for perl:

- `-p`: Places a printing loop around your command so that it acts on each line of standard input.
    * Use to loop over the contents of a file line by line and output every line after being processed.  
    * This is similar to what `sed` and `awk` do by default.  

- `-n`: Places a non-printing loop around your command.
    * Use to loop over the contents of a file line by line and NOT output anything
      other than what you specify.  

- `-e`: Allows you to provide the perl script as an argument rather than in a file.
    * Identical to `-c` in Python or Bash.  

- `-E`: Same as `-E` but also enables **all** optional features.  
    * Identical to `-c` in Python or Bash.  


- `-i`: Edit the file in place, making a backup of the original.
    * Allows you to modify files without `{copy, delete-original, rename}`.

- `-w`: Activates some warnings. 
    * Someone said "Any good Perl coder will use this."

- `-d`: Run the command under the Perl debugger.  

- `-t`: Taint mode. Treats **certain** operations as "tainted" code.  
    * It treats any external input (i.e., CLI args) as tainted until it's sanitized.  
    * Use to beef up Perl security, e.g., when running as setuid scripts.  

- `-T`: Taint mode, for a whole script.
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

- `-n`: Loop over the file, line by line.  
    * Same as `while(<>)`
- `-e`: Allows execution of the code provided directly as a string.  
    * Similar to `-c` in other tools.  
- `END { print $t }`
    * The `END` block is executed once after all lines of the file have been processed.  
    * It prints the value of `$t`, which is the total word count.  
- `@w = /(\w+)/g`:
    * `@w` is an array.
    * `/(\w+)/g`: Regex that matches every `word` in the current line.  
        * `\w+`: Matches one or more word characters (letters, digits, or underscores).  
        * `g`: Global modifier. Ensures all matches in the line are captured.  
    * For each line, `@w` contains all words found in that line.  
- `$t += @w`: 
    * `$t`: Scalar variable, initialized to `0` by default.  
    * `@w`: In scalar context, gives the number of elements in the array (words).  
    * `$t` holds the total number of words across all lines.  
- `file.txt`: The input file.  

---

## Using Subshells in Perl
Subshells are a thing in perl. You can capture the output of shell commands.  

In order to achieve the same result as `$(...)` (bash) in perl, you can do one of two
things:

- Wrap a shell command in backticks(``` `cmd` ```)
- Use the [`qx` operator](./operators.md) (`qx/cmd/` or `qx(cmd)`)

Then save the output to a variable.  

This is idiotmatic, core Perl and doesn't rely on external packages.  

Example:
```perl
my $hostname = qx(hostname)
```
This will save the literal output of the command `hostname`.  
Since the output is literal, it will contain the newline at the end.  
To get rid of the trailing newline, use `chomp()`:
```perl
chomp($hostname);
```
This will modify it in-place to get rid of the trailing newline.  


## Error Handling
In perl, we can use the `or` operator along with the `die` function to handle errors.
```perl
open(my $fh, '<', 'file.txt') or die $!;
```

- This attempts to open the file `file.txt` in readonly mode.  
- If it fails, it will trigger the `or` (since the exit code of the `open` will be non-zero).
- `die` will exit with an error message. 
- `$!` holds the last error message that the program encountered.  

## Using Perl like Awk

We can use perl just like awk to print specific columns of output.  

This can be done by using `-a` (autosplit mode) and `-n` (non-printing loop).  

When using `-a`, the split line is automatically saved into the `@F` array.  

- For example, to print the first column of `ls -l` (permissions):
  ```bash
  ls -l | perl -ane 'print "$F[0]\n"'
  ```
    - Using `-a` implicitly sets `-n`, so this is a bit redundant.  
      We could omit the `-n` and get the same result:  
      ```bash
      ls -l | perl -ae 'print "$F[0]\n"'
      ```

- Another example, to print the major/minor device numbers from `stat` output:
  ```bash
  stat /dev/null | perl -ae 'print "$F[8]\n" if ($. == 3);'
  ```
  This prints the 9th column (zero-based indexing), but only if the line number
  (`$.`) is equal to three.  


This can also be done by passing `-F` with a character to split on (just like `awk`),
along with a custom array name for the split lines.   

- Print the first column of input (0-based indexing).  
  ```bash
  ls -l | perl -F' ' -ane 'my @f = split; print "$f[0]\n";'
  ```

!!! info "Using a Custom Array Name with `-F`"

    Note that we're using a custom array name here and calling `split` on the
    input line.  
    That's because `-F` will make the `@F` array contain the line
    **character-by-character** rather than splitting on the desired
    pattern/character provided to `-F`.  

- Extract the major/minor device numbers from `stat` output:
  ```bash
  stat /dev/null | perl -F' ' -e 'my @f = split; print "$f[8]\n" if ($. == 3);'
  # 1,3
  ```

The `-F` option implicitly sets the `-a` and `-n` options, so we can omit them.  

- `-F<pattern>`: Split on the character/pattern specified for `-a`
    - `-a`: Turns on autosplit mode when used with a `-n` or `-p`.  
        - An implicit split command to the `@F` array is done as the first thing
          inside the implicit loop while produced by the `-n` or `-p` options.  


## Resources

- `perldoc perlrun`
- [Perl Command Line Options - perl.com](https://www.perl.com/pub/2004/08/09/commandline.html/)
- [List of Pragmas (Pragmatic Modules)](https://perldoc.perl.org/modules#Pragmatic-Modules)


