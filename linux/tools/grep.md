# Grep

Grep is a coreutil that prints lines that match patterns.  

## tl;dr:
Syntax:
```bash
grep -E '^expression$' [filename]
grep -n -r -E '^#?#\s\s?.*$'  # Get all markdown H1 and H2s
#
# -n: Line Numbers; -r: recusive; -E: Extended Regex
```

- `-i`: Ignore case.  
* `-v`: In`v`ert the match. Will print the lines that *don't* match the pattern.  
    * Matches/prints **non-matching** lines.  
* `-n`: Output the line number of the match.  
* `-E`: Enable *Extended* regex.
* `-r`: Recursively search starting from working directory. 
    * When a regular file is provided, this doesn't have any effect.
    * `-R` is the same as `-r`, but will also follow symlinks.
    * Functionally equivalent to `grep -d recurse`
* `-l` will only print the filenames of files with matches.
    * `-L` will output the filenames of files WITHOUT matches.
- `-d <ACTION>`: Specify an action to take on directories. Available actions:
    - `skip`: Silently skip any directories.  
    - `read`: Read directories as if they were normal files.  
    - `recurse`: Recurse through directories, reading all files under each directory.  
- `--exclude=glob`: Skip any files that match the glob pattern.  
- `--exclude-dir=glob`: Skip any directories that match the glob pattern.  

## Using Grep  
The greps:  
```bash  
grep
egrep  
fgrep  
rgrep 
```

* `grep`: Uses Basic Regular Expressions (BREs) by default.  
* `egrep`: Uses Extended Regular Expressions (EREs).  
    * Equivalent to `grep -E`
* `fgrep`: Treats the pattern as a fixed string, not a regular expression.  
    * Equivalent to `grep -F`
* `rgrep`: Recursively searches directories.  
    * Equivalent to `grep -r` or `grep -d recurse`

There's also [`pgrep`](#pgrep), but that's not for searching through files. `pgrep` is used to
grep through currently running processes and lists the PIDs that match the pattern.  

###  Basic vs Extended Regular Expressions:  

* Basic Regular Expressions (BRE)  
    * In basic regular expressions the meta-characters 
      `?`, `+`, `{`, `|`, `(`, and `)` lose their special meaning. 
    * Use the backslashed versions instead: `\?`, `\+`, `\{`, `\|`, `\(`, and `\)`.  

* Extended Regular Expressions (ERE)  
    * Used with `egrep` or `grep -E`
    * The meta-characters keep their special meanings  
      without needing to be escaped: `?`, `+`, `{`, `|`, `(`, and `)`.  

### Alternation (matching any one of multiple expressions)  

* The "alternation operator" or "infix operator" (`|`, the `OR` operator) 
  is used to match any one of multiple expressions.  
* It acts as an `or` operator between multiple regular expressions.  
* For example, `grep 'cat|dog' filename` will match any line containing 'cat' or 'dog'.  

### Other Useful `grep` Options  

- `-i`: Ignore case distinctions in both the pattern and the input files.  
- `-v`: Invert the sense of matching, to select non-matching lines.  
- `-c`: Count the number of lines that match the pattern.  
- `-n`: Prefix each line of output with the line number within its input file.  
- `-l`: List only the names of files with matching lines, once for each file.  
- `-r` or `-R`: Recursively search directories for the pattern.  
- `--color`: Highlight the matching text.  
- `--exclude-dir=PATTERN`: Skip any directory with a name that matches the given pattern.
    * Uses shell globbing.


## Character Classes and Bracket Expressions
##### See `man://grep 304`
A bracket expression is a `set` of characters inside square
brackets `[ ]`, which is used to match a single character.

### What can go inside the brackets

* Sets accept a single character, a range of characters, a set of characters, or a 
  combination of those.
    * E.g.: `[a]`, `[abc]`, `[a-z]`, `[A-Z]`, or `[0-9]`
    * As a combo: `[A-Z_-]` will match `A-Z` and the `-` and `_` characters.

### Character Classes and Their Matches
Character classes can also be used to specify a set of characters, using
the syntax `[:class:]`.

* `[:alnum:]`: Matches any alphanumeric character.  Same as `[a-zA-Z0-9]`.
* `[:alpha:]`: Matches any alphabetic character.  Same as `[a-zA-Z]`.
* `[:blank:]`: Matches any horizontal whitespace character, including space and tab.
* `[:cntrl:]`: Matches any control character.  
    * Control characters are non-printing characters that control how text
      is processed, like newline (`\n`), carriage return (`\r`), tab (`\t`), etc.
* `[:digit:]`: Matches any digit.  Same as `[0-9]`.
* `[:graph:]`: Matches any printable character excluding space.  
    * It includes characters that are visible and can be printed, excluding whitespace.
* `[:lower:]`: Matches any lowercase alphabetic character.  Same as `[a-z]`.
* `[:print:]`: Matches any printable character including space.  
    * It's similar to `[:graph:]` but also includes the space character.
* `[:punct:]`: Matches any punctuation character.  
    * It includes characters like `.`, `,`, `!`, `?`, `;`, `:`, and other symbols
      that are not alphanumeric.
* `[:space:]`: Matches any whitespace character. 
    * Includes spaces, tabs, newlines (`\n`), carriage returns (`\r`),
      form feeds (`\f`), and vertical tabs (`\v`).
* `[:upper:]`: Matches any uppercase alphabetic character.  Same as `[A-Z]`.
* `[:xdigit:]`: Matches any hexadecimal digit.  Same as `[0-9a-fA-F]`.

### Inverting the Matches (Match Non-Matching)
If the first character of the `set` is the caret `^`, then it matches any
character **not** in the list.  
E.g., `[^abc]` will match everything except one of `abc`.  

* Note: Using the `-v` option also has this effect: It matches everything that does not match
  the pattern.
    * This applies to the entire pattern passed to `grep`. 
    * Using the caret `^` in a `set` only inverts the matches within the `set`.  
    * Using the caret `^` with the `-v` option will have the opposite effect.  

### Output Only the Matched Parts of the Line
You can effictively extract matched text without the use of capture groups 
using `grep -o`.  

For example, you can extract the paths from an `ldd` output:
```bash
ldd /bin/bash | grep -o '/[^ ]*'
```
This will filter out any lines that don't match the pattern, and output only the
matched part of the lines.  
The regex being used here:
- `'/[^ ]*`: 
    - `/`: Match starts with a forward slash.
    - `[^ ]*`: Matches any non-space characters (match until the first space).  

The output:
```plaintext
/lib/x86_64-linux-gnu/libtinfo.so.6
/lib/x86_64-linux-gnu/libc.so.6
/lib64/ld-linux-x86-64.so.2
```


## Examples  

### Count Occurrences of a Word:  
```bash  
grep -c 'word' filename  
```

---  

### Search Recursively in Directory:  
```bash  
grep -r 'pattern' /path/to/directory  
```

---  

### Find Lines Not Containing the Pattern:  
```bash  
grep -v 'pattern' filename  
```

---  

### Search While Ignoring Case:  
```bash  
grep -i 'pattern' filename  
```

---  

## Note on `fgrep` (Fixed Strings)  

`fgrep` or `grep -F` treats the pattern as a fixed string.  
It matches the literal text provided as the pattern.  

This means no regular expression is involved, making it faster for plain string matching.  
For instance, fgrep "example.com" filename will match lines containing "example.com" as a fixed string, not as a regex.  



## Grep Colors  

* Note: `-v` matches NON-MATCHING lines.  
Specifies the colors and other attributes used to highlight various parts of `grep` output.  
Its value is a colon-separated list of capabilities that defaults to:  
```bash  
# Default:  
GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36' 
```
The `rv` and `ne` boolean capabilities are unset / omitted (false) by default.  

Boolean capabilities have no `=...` part. 
They are unset (i.e., false) by default, and become true if they're set.  

 These substring values are integers in decimal representation and can be concatenated with  
 semicolons. 

* Common values to concatenate include 
    * 1 for bold.  
    * 4 for underline.  
    * 5 for blink.  
    * 7 for inverse.  
    * 39 for default foreground color.  
    * 30 to 37 for foreground colors.  
    * 90 to 97 for 16-color mode foreground colors.  
    * 38;5;0 to 38;5;255 for 88-color and 256-color modes foreground colors.  
    * 48;5;0 to 48;5;255 for 88-color and 256-color modes background colors.  
    * 49 for default background color.  
    * 40 to 47 for background colors.  
    * 100 to 107 for 16-color mode background colors.  

Note: `grep` takes care of assembling the result into a complete SGR sequence (`\33[...m`).  


### Breakdown  

* `cx=`: context  
    * Color for the context (lines where there's a match, but not the match itself)  
    * The default is empty (i.e., the terminal's default color pair).  

* `rv`: reverse  
    * Boolean value. Invert match and context colors. 
    * Default false, true if set.  

* `mt=01;31`: matching text  (same as `ms`?)
    * Color for matching txt in any matching line.  
    * Setting this is the same as setting `ms=` and `mc=` at once to the same value.  
    * The default is a bold red text foreground over the current line background.  

* `ms=01;31`: matching selected (matched text)  
    * Color for matches in a selected line. 
    * The effect of the `sl=` (or `cx=` if `rv`) remains active when this kicks in.  
    * The default is a bold red text foreground over the current line background.  

* `sl=`: 
    * Color for whole matching lines.  
    * The default is empty (i.e., the terminal's default color pair).  

* `mc=01;31`: matching context  
    * Color for matching text in a context line  
    * The effect of the `cx=` (or `sl=` if `rv`) capability remains active when this kicks in.  
    * The default is a bold red text foreground over the current line background.  

* `fn=35`: file names  
    * Color for filenames that come at the beginning of any line  
    * The default is a magenta text foreground over the terminal's default background.  

* `ln=32`: line numbers  
    * Color for line numbers in any line  
    * The default is a green text foreground over the terminal's default background.  

* `bn=32`:  
    * Color for byte offsets before any line  
    * The default is a green text foreground over the terminal's default background.  

* `se=36`:  
    * Color for separators between selected lines. 
        * `:` = selected lines  
        * `-` = context lines  
        * `--` = adjacent context lines  
    * The default is a cyan text foreground over the terminal's default background.  

* `ne`:  
    * Boolean value. Disables Erase in Line (`EL`).  
    * Prevents clearing to the end of line using Erase in Line (`EL`) to  
      Right (`\33[K`) each time a colorized item ends.  
    * The default is false (unset). True if set.  

## `pgrep`

`pgrep` (process grep) is a tool that helps you find the PIDs of running processes by
their names or other attributes.  

It's part of the `procps` package on most Linux distros.  

```bash
sudo apt-get install procps
# Or on RedHat-based systems
sudo dnf install procps-ng
```

---

- Find the PID of a process by its name:
  ```bash
  pgrep bash
  ```
  This will return the PIDs of all processes whose name matches `bash`.  

- Find the PIDs of processes owned by a specific user:
  ```bash
  pgrep -u root
  ```
  This will list all the PIDs of all the running processes that are **owned by `root`**.  

- To get the process name as well as the PID, use `-l`.  
  ```bash
  pgrep -u root -l
  ```

- Or, to get the **entire command used** to invoke the process, use `-a`.  
  ```bash
  pgrep -u root -a
  ```


---

A more practical example, finding currently running SSH processes.  
```bash
pgrep sshd
```

You can also narrow this down further by specifying a user with `-u`.  
```bash
pgrep -u root sshd
```
This will only show the PIDs of the `sshd` processes that are **owned by `root`**.  

You can also specify multiple users, comma-delimited.  
```bash
pgrep -u root,daemon sshd
```
This will show the PIDs of all processes owned by the users `root` or `daemon` with
the name `sshd`.  

You can also just view the PIDs that are owned by users without providing a process
name.  
```bash
pgrep -u root,daemon
```

---

List the process name as well as the PID with `-l`:
```bash
pgrep -u root,daemon -l
```

---

Using `-c` you can count the number of processes instead of listing the PIDs.  
```bash
pgrep -c -u root
```

---

If you need to format the PIDs a certain way, you can specify a delimiter. It
defaults to newline, printing each PID on its own line.  
```bash
pgrep -u root -d,
```
This will set the delimiter to a comma (`,`) and output the PIDs as
comma-delimited.  


---

When you specify a process by name, it *only* matches the name of the base process.  
Using `-f`, you can match the entire command that was run to execute that process.  
```bash
pgrep -f 'daemon'
```
This will match any options that were used to invoke the process (e.g.,
`--no-daemon`).  

---





