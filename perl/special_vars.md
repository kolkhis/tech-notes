
# Special Variables
Special variables in perl are sometimes called "sigil variables" or "punctuation variables."

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
    - Like `strerror(errno)`
        <!-- TODO: What language is `strerror(errno)` from? -->
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

### Advanced/Less Common Special Vars
- `$^I`: Stores the in-place edit extension (used with the `-i` flag).  
    * Like using `sed -i.bak`, perl supports the same thing.  
    - `$^I` stores the backup extension you set (`perl -p -i.bak -e '..'`).
    * If you set it to `.bak`, Perl will create a backup of the original file.  
    * Example: 
      ```bash
      perl -pi.bak -e 's/foo/bar/' file.txt
      ```
      will back up the original file to `file.txt.bak`.

- `$^W`: Current value of `warnings`.
    * Shows if warnings are enabled.
    - Rarely used directly. Instead, use `use warnings;`.
- `$.`: Line number in the current input file.  
- `$/`: Input record separator (default is newline).  
    * Changing it lets you change how Perl reads input.
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
    * Default is a space `" "`. Example:  
      ```perl
      my @arr = (1, 2, 3);
      print "@arr\n";  # Outputs: 1 2 3
      local $" = ", ";
      print "@arr\n";  # Outputs: 1, 2, 3
      ```


<!-- TODO: Please give some more information on these variables. Their use cases, some examples, etc. -->

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




## Practical Usage Examples

### Print the Current Line Number
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
* `$1`, `$2`, `$&`: Regex captures
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
| `$|`     | **Autoflush** output buffer (`1` = no buffering, `0` = default buffering). |
| `$&`     | Entire matched string from the last regex match. |
| `$1`, `$2`, etc. | Capture groups in regex. |
| `$^I`    | In-place edit extension (for `-i` flag). | `perl -pi.bak -e 's/foo/bar/' file.txt` |
| `$^W`    | Warnings flag. | Rarely used — instead, use `use warnings;`. |
| `$/`     | Input record separator (default: `\n`). | `undef $/;` reads entire file at once. |
| `$"`     | Array element separator when interpolated. | Default: `" "` |
| `$\`     | Output record separator. | Example: `$\ = "\n"; print "Hello";` adds newline after every `print`. |
