# Special Variables
Special variables in perl are sometimes called "sigil variables" or "punctuation variables."


## Table of Contents
- [List of Special Variables](#list-of-special-variables) 
    * [Advanced/Less Common Special Vars](#advancedless-common-special-vars) 
- [`$/` and `$\`](#-and-) 
    * [`$/` - Input Record Separator](#---input-record-separator) 
        * [`$/` (Input Record Separator) Examples](#-input-record-separator-examples) 
    * [`$\` - Output Record Separator](#---output-record-separator) 
        * [`$\` (Output Record Separator) Examples](#-output-record-separator-examples) 
- [Practical Usage Examples](#practical-usage-examples) 
    * [Print the Current Line Number](#print-the-current-line-number) 
    * [Using Environment Variables](#using-environment-variables) 
    * [Showing the Last Error](#showing-the-last-error) 
    * [Auto-flushing Output with `$|`](#auto-flushing-output-with-) 
- [Memorize These](#memorize-these) 
- [Perl Special Variable Cheatsheet](#perl-special-variable-cheatsheet) 


## List of Special Variables

- `$_`: Default variable. Holds the current line when processing text or the
  default input.  
    - Most common, used in `while (<>) {...}`, `foreach`, `map`, regex, etc.
    - In one-liners, this is the current line.  
- `$.`: Current line number.
    - In a file read loop, it increments every line. 
- `$0`: Name of the running script.
    - Just like `$0` in bash. Shows the name of the perl script being executed.  
- `$?`: Exit status of last system command. 
    - Just like `$?` in bash. Shows exit code.  
- `@ARGV`: Command line arguments. 
    - Equivalent to `$@` in Bash.
- `$ARGV`: The name of the current file when looping over `@ARGV` in `while (<>)`.
    - Used inside `while (<>)` loops.  
      ```perl
      while (<>) {
          print "Reading from file: $ARGV\n";
      }
      ```
      So if you're running:
      ```bash
      perl script.pl file1.md file2.md
      ```
      While reading `file1.md`, `$ARGV` will the `"file1.md"`, etc..

- `$!`: Last system error message.  
    - Like `strerror(errno)` in C. 
    - E.g.: `die "Error: $!"`
- `$^O`: Operating system name. 
    - `linux`, `darwin`, `MSWin32`, etc.  
- `$ENV{VAR}`: Environment variables.  
    - Access shell env vars. E.g., `$HOME` would be `$ENV{HOME}`
- `$|`: Autoflush output buffer.
    - Normally, Perl buffers output and flushes it to the terminal when a newline
      is found.  
    - Setting `$| = 1;` disables buffering, so output is immediately written.  
    - Useful for progress bars, interactive output, long running scripts, etc. 
- `$&`: Matched string in last regex.  
    - Holds the whole matched string from the last regex.  
    - Like `${BASH_REMATCH[0]}`
- `$1`, `$2`, etc.: Capture groups in Regex.  
    - Like bash regex captures, but instead of `\1`, it's `$1`.  

---

The difference between `$ARGV[n]` and `@ARGV` comes from how variables are accessed in Perl:

- `@ARGV`: Refers to the entire array. i.e., all the command-line arguments.
- `$ARGV[0]`: Accesses a single element (scalar) from the array `@ARGV`.  
- `$ARGV` (without `[]`, scalar context): Holds file name passed in via command line 
  arguments or stdin when used in scalar context. 
    - This will hold the filename that is currently being processed if there are
      multiple files.  


### Advanced/Less Common Special Vars

- `$^I`: Stores the in-place edit extension (used with the `-i` flag).  
    - Define this variable to enable in-place editing. Use `undef $^I` to
      disable in-place editing.  
    - Like using `sed -i.bak`, perl supports the same thing.  
    - `$^I` stores the backup extension you set (`perl -p -i.bak -e '..'`).
    - If you set it (e.g., `our $^I = '.bak'`), Perl will create a backup of the original file.  
    - Example from the command-line: 
      ```bash
      perl -pi.bak -e 's/foo/bar/' file.txt
      ```
      will back up the original file to `file.txt.bak`.

- `$^W`: Current value of `warnings`.
    - Shows if warnings are enabled.
    - Rarely used directly. Instead, use `use warnings;`.

- `$.`: Line number in the current input file.  
- `$/`: Input record separator (default is newline).  
    - Changing it lets you change how Perl reads input.
    - You can change it to read whole files in one go.  
    - Example: `undef $/;` reads the entire file at once.
- `$\`: Output record separator. 
    - Adds a string after every `print`.
    - Ex:
      ```perl
      $\ = "\n";
      print "Hello";
      print "World";
      # Output:
      # Hello
      # World
      ```
      (Every print automatically ends with `\n`.)
- `$"`: Separator when interpolating arrays (default is a space `" "`).
    - Default is a space `" "`. Example:  
      ```perl
      my @arr = (1, 2, 3);
      print "@arr\n";  # Outputs: 1 2 3
      local $" = ", ";
      print "@arr\n";  # Outputs: 1, 2, 3
      ```

## `$/` and `$\`
These can be changed to modify input/output behavior:
| Variable | Behavior |
|----------|----------|
|   `$/`   | Input record separator. Default is newline. Example: `undef $/;` reads the whole file at once.
|   `$\`   | Output record separator. Example: `$\ = "\n";` automatically adds newline after every print.

### `$/` - Input Record Separator
`$/` defines what Perl considers the "end of a record" when reading input.
It's set to a newline `\n` by default, meaning one line at a time.

#### `$/` (Input Record Separator) Examples:
If you want to read the entire file contents into one variable, you can use `undef`
to unset this variable:
```perl
undef $/;  # Remove the newline separator
open my $fh, '<', 'file.txt' or die $!;
my $file_contents = <$fh>;
close $fh;
print $file_contents;
```

- `open`: Builtin perl function to open a file.
    - `my $fh`: Defines `$fh` as a file handle. Like a pointer to the opened file.
        - The `my` keyword makes it lexically scoped (only available in that block)
    - `'<'`: Open in read-only mode. Other options:
        - `'>'`: Write (overwrite)
        - `'>>'`: Append
    - `'file.txt'`: The file to open
    - `or die $!;`: If `open` fails, this will terminate the script and print the
      system error msg from `$!`.
- `my $file_contents = <$fh>;`
    - The angle brackets around `$fh` are called the **diamond operator**.
    - Reads input from a filehandle or from `@ARGV` if no file handle is specified
    - Normally this would only read one line from `$fh` by default,
        - But, because we did `undef $/;`, it changed the behavior to read the
          entire file in one shot (called "slurping").

---

If you want to read files where entries are separated by blank lines (like
paragraphs, config entries, etc.) you can change this to a blank line (`""`):
```perl
$/ = "";
while (<>) {
    print "Paragraph: $_ \n";
}
```

---

If you're parsing delimited records, like CSV, without a CSV parser:
```perl
$/ = ",";
open my $fh, '<', 'file.csv' or die $!;
while (<$fh>) {
    print "CSV field: $_\n";
}
close $fh;
```

### `$\` - Output Record Separator
The `$\` variable is the output record separator.  
This variable controls what will happen at the end of any output statements (`print`,
`say`, etc.).  

For instance, setting `$/ = "\n";` will append a newline to the end of all `print`
calls.  

The default value of this variable is nothing `""`.  

This is useful for formatting data (e.g., `$/ = ",";` for formatting data into CSV).  

#### `$\` (Output Record Separator) Examples

Perl will append the contents of the `$\` variable to every single `print`
statement. By default, it's empty (`""`).  

If you wanted to automatically add a newline to every `print` statement:
```perl
$\ = "\n";
print "Hello";
print "World"; 
# Will output each with a newline at the end
```
If you didn't want to add `\n` to the end of every print statement. 

---

If you wanted to auto-separate output records or lines with something else:
```perl
$\ = " --- ";
print "Item1";
print "Item2";
print "Item3";
# Item1 --- Item2 --- Item3
```

---

If you wanted to format output as CSV, you can set `$/` to `,`:
```perl
$\ = ",";
print "Item1";
print "Item2";
print "Item3";
# Item1,Item2,Item3
```

---



## Practical Usage Examples

### Print the Current Line Number

The `$.` variable stores the current line number while looping over a file.  

```bash
perl -ne 'print "$. $_"' file.md
```
The `-n` wraps the code in an implicit `while (<>) { ... }` loop.
So, this is an alternative to `-p` if you want to print modified versions of the
lines.  

If you did this with `-p`, you'd get two copies of the lines. Since the `-e` code
is run before `-p` prints the `$_` variable, it would print what's in the `print` 
statement first, then it would print the actual line from the file (`$_`).  

### Using Environment Variables
```bash
perl -ne 'print "Home dir: $ENV{HOME}\n"'
```

### Showing the Last Error
```perl
open(my $fh, "<", "missing_file.txt") or die "Can't open file: $!";
```

### Auto-flushing Output with `$|`
Setting `$|` stops perl from buffering output, and flushes it directly to the
terminal.  
```bash
$| = 1;  # Autoflush stdout
printf "Processing...";
sleep 2;
print "Done.\n"
```

Without `$| = 1`, Perl will buffer output and only display "`Processing...`" after a 
newline (`\n`) or when the buffer is flushed.

With `$| = 1`, the text is immediately flushed and visible on the screen without waiting.

## Memorize These

- `$_`: Current line
- `$.`: Current line number
- `$1`, `$2`, `$&`: Regex captures
    - `$&` is the entire match, not capture groups.  
- `$!`: Last system error
- `@ARGV`: Command-line args
- `$ARGV`: Current file in @ARGV
- `$ENV{VAR}`: Environment vars
- `$?`: Exit code
- `$^O`: OS name
- `$|`: Output autoflush
- `$/`: Input separator
- `$\`: Output separator



## Perl Special Variable Cheatsheet

| Variable | Description | Example
|----------|-------------|---------
| `$_`     | Default variable. Holds the current line when processing input. |
| `$.`     | Current line number when reading a file. |
| `$0`     | Name of the running script. |
| `$?`     | Exit status of the last system command (like Bash). |
| `@ARGV`  | Array of command-line arguments (like Bash's `$@`). |
| `$ARGV`  | Current file being read when looping over `@ARGV` using `while (<>)`. |
| `$!`     | Last system error message. |
| `$^O`    | Operating system name (`linux`, `darwin`, `MSWin32`, etc.). |
| `$ENV{VAR}` | Access shell environment variables. |
| `$\|`     | **Autoflush** output buffer (`1` = no buffering, `0` = default buffering). |
| `$&`     | Entire matched string from the last regex match. |
| `$1`, `$2`, etc. | Capture groups in regex. |
| `$^I`    | In-place edit extension (for `-i` flag). | `perl -pi.bak -e 's/foo/bar/' file.txt` |
| `$^W`    | Warnings flag. | Rarely used — instead, use `use warnings;`. |
| `$/`     | Input record separator (default: `\n`). | `undef $/;` reads entire file at once. |
| `$"`     | Array element separator when interpolated. | Default: `" "` |
| `$\`     | Output record separator. | Example: `$\ = "\n"; print "Hello";` adds newline after every `print`. |


## Regular Variables
Variables have three typical data types in Perl, indicated by their [sigil](#sigils):

- `$var`: Scalars
- `@var`: Arrays
- `%var`: Hashes

Everything is basically a string or a number.  

## Variable Contexts
Variables act differently when they're in different "contexts."  

There are four *main* contexts, which defines what perl wants:

- Scalar: Perl wants a single value.  
- List: A list of values.  
- Void: Throwaway result.  
- Boolean: True/false evaluation.  


Another way to look at it:  
Context is how Perl decides what kind of value it wants from an expression.  

- A single value: scalar context
- A list of values: list context
- A boolean test: boolean context (a special case of scalar)
- A void context: the value is thrown away

```perl
$x = @array;            # Scalar context (returns number of elements)
@x = split /,/, $str;   # List context (returns full list)
split /,/, $str;        # Void context (result ignored)
if (@array) { ... };    # Boolean context (true if array is non-empty)
```

---

There are other types of contexts, but the four main ones are what we usually care
about. 
Another one worth mentioning is reference context.  
Reference context is used when coercing into a reference (`\@array`, `\%hash`, etc.).  


### Scalar Context
When using the `$var = ...` syntax, this is known as **scalar context**.
```perl
my $count = @array;  # @array is in scalar context → returns length
```

### List Context
When perl expects a list of values, it's list context.  
E.g., using `@var = ...`, this is **list** context.  

List context is used when assigning to arrays, list assignments, `foreach` loops,
function arguments, and when returning a list.  
```perl
print join(", ", @items);  # join gets a list context

sub names { return ("alice", "bob"); }
my @n = names();  # names() in list context
```

You can assign scalars from list context by using parentheses. For instance, to
assign the first element of an array to a scalar:
```perl
my ($first_name) = @name_list;
# or to grab the first two elements:
my ($first_name, $second_name) = @name_list;
```
The right hand side is still in list context. This just grabs the first few elements.  


### Void Context
Void context is used when the result of an expression is ignored.  
```perl
split(/ /, $sentence);  # Return value is discarded
```

### Boolean Context
Boolean context is used when evaluating truthiness, like with `if` statements:
```perl
if (@items) { ... }; # true if array is not empty
```

## Sigils
Sigils are what come before variables to define what kind of variable they are.  

| Sigil |   Used for |
|-|-
| `$`   | Scalars    |
| `@`   | Arrays     |
| `%`   | Hashes     |
| `&`   | Subroutines (code) |



## Keywords for Declaring Variables

There are three main keywords used to declare variables.  

- `my`: The most common one. Makes a new lexical variable (which is privately
  scoped to the current block).  
  ```perl
  my $var = 1;
  ```
  This is what you'll use 99% of the time in a perl script.  

- `our`: Makes a lexical **alias** to a **package global**. The real global
  lives in a package, usually `main::`.  
  ```bash
  our @ARGV = ('file1.txt', 'file2.txt');
  ```

- `local`: Temporarily changes the value of a package global for the duration
  of a block (then it auto-restores).  

When we're creating normal variables for your script, use `my`.  
When we want to **permanently** change a global, e.g., `@ARGV`, we can use `our`.  
When we want to **temporarily** change a global, e.g., `@ARGV` or `$^I`, we can use `local`.  

```bash
for my $file (<*.md>) {
    chomp($file);
    local $^I = '.bak';
    local @ARGV = ($file);
    while (<>) {
        s/old/new/g;
        print;
    }
}
```

---

There's also `use vars`, which can be used to declare **package global
variables**.  

This does **the same exact thing as `our`**, but pre-dates `our`.  

```perl
use vars qw(@markdown_files)
# same as
our @markdown_files;
```

This one basically tells perl that "there's going to be a **global** variable
named `@markdown_files` available in this package, don't warn me about it."

We can specify multiple different variable names here in this statement as
well.  
```perl
use vars qw(@markdown_files $some_scalar %some_hash)
```

## Globrefs and Typeglobs

A globref is a *reference* to a **typeglob**, which can hold multiple variable
types.  

A typeglob is a special kind of variable that can hold multiple values of
multiple types (incl. scalars, arrays, hashes). Allows you to access all the 
variables associated with a particular name in a single reference.    

The main use of typeglobs in modern Perl is to create symbol table aliases.

### Using a Typeglob for Aliases

A single globref can reference multiple values of different types.

For instance:
```perl
*this = *that;
```

This makes:

- `$this` an alias for `$that`
- `@this` an alias for `@that`
- `%this` an alias for `%that`
- `&this` an alias for `&that`
- etc...

It's generally safer to use a **reference**/**alias**.  
```perl
local *Here::blue = \$There::green;
```
This `$Here::blue` (scalar) a temporary alias for `$There::green` (scalar) but 
does not apply to other types/values. E.g., It does not alias `@Here::blue`
(array) to `@There::green`, and does not apply to the other types either.  

<!-- TODO: Is this due to the `local` keyword? -->



<https://perldoc.perl.org/perldata>
[Symbol Tables](https://perldoc.perl.org/perlmod#Symbol-Tables)

