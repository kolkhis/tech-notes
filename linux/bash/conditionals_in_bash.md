# Bash / Shell Conditional Flags  
Bash conditionals are essential.  
Conditionals in bash are done with flags and equality operators.  


## Table of Contents
* [Bash / Shell Conditional Flags](#bash-/-shell-conditional-flags) 
* [Files and Directories](#files-and-directories) 
* [Arithmetic Operators](#arithmetic-operators) 
* [Conditionals for Strings and Variables](#conditionals-for-strings-and-variables) 
* [File Descriptors](#file-descriptors) 
    * [File Descriptor Usage Example](#file-descriptor-usage-example) 
* [Name Reference](#name-reference) 
    * [Name Reference Usage Example](#name-reference-usage-example) 
* [Checking if Certain Shell Options are Enabled](#checking-if-certain-shell-options-are-enabled) 
* [Bash Conditional Flags Table](#bash-conditional-flags-table) 


## Files and Directories  
These are the "primaries," the primary unary or binary conditional operators.  

By default, primaries that operate on files follow symbolic links and  operate  
on the target of the link, rather than the link itself.  

When used with `[[`, the `<` and `>` operators sort lexicographically using the current locale.  
The `test` command sorts using ASCII ordering.  

| Flag | True if |
|-|-  
| `-a file` |  File exists.  
| `-b file` |  File is block special.  
| `-c file` |  File is character special.  
| `-d file` |  File is a directory.  
| `-e file` |  File exists.  
| `-f file` |  File exists and is a regular file.  
| `-s file` |  File exists and has a size greater than zero (not empty).  
| `-r file` |  File is readable by you.  
| `-w file` |  File is writable by you.  
| `-x file` |  File is executable by you.  
| `-O file` |  File is owned by you.  
| `-G file` |  File is owned by your group.  
| `-h file` |  File is a symbolic link.  
| `-L file` |  File is a symbolic link.  
| `-g file` |  File is `set-group-id`.  
| `-u file` |  File is `set-user-id`.  
| `-k file` |  File has its `sticky` bit set.  
| `-p file` |  File is a named pipe.  
| `-S file` |  File is a socket.  
| `-N file` |  File has been modified since it was last read.  
| `file1 -ef file2` |  `file1` is a hard link to `file2`.  
| `file1 -nt file2` |  `file1` is newer than `file2` (uses the modification date).  
| `file1 -ot file2` |  `file1` is older than `file2`.  
| `-t fd`   |  ["file descriptor"](#file-descriptors) is opened on a terminal.  

## Arithmetic Operators:  

These are the arithmetic operators that are allowed inside bracket notation (either
double `[[ ... ]]` or single `[ ... ]` brackets):

* `-eq`: Is equal to   
* `-ne`: Not equal to   
* `-lt`: Less Than   
* `-le`: Less than or equal to 
* `-gt`: Greater than  
* `-ge`: Greater than or equal to  

These arithmetic operators in Bash can be used inside double parentheses `(( ... ))`,
in `let` statements, and in `declare` statements when using `-i` (`declare -i ...`).  

- `==`: Is equal to   
- `!=`: Not equal to   
- `<`: Less Than   
- `<=`: Less than or equal to 
- `>`: Greater than  
- `>=`: Greater than or equal to  


## Conditionals for Strings and Variables  
* `-v varname`: True if the shell variable varname is set (has been assigned a value).  
* `-R varname`: True if the shell variable varname is set and is a name reference.  
 
* `-z string`: True if the length of string is zero.  
* `-n string`: True if the length of string is non-zero.  
 
* `string1 == string2`
    * string1 = string2
    * True if the strings are equal.  
    * `=` should be used with the `test` command for POSIX-compliance. 
    * When  used  with  the `[[` command, this performs pattern matching as 
      described in (`man://bash 280`).  

* `string1 =~ regex`: True if `string1` matches the regular expression `regex`.  
    * This is **not** POSIX-compliant (bash-only).  
 
* `string1 != string2`: True if the strings are not equal.  
* `string1 < string2`: True if string1 sorts before string2 lexicographically (alphabetically).  
* `string1 > string2`: True if string1 sorts after string2 lexicographically (alphabetically).  


## File Descriptors  
In Linux/Unix, a file descriptor is a non-negative number that 
uniquely identifies an open file for the process.  

Standard file descriptors: 

* `0`: standard input (stdin)  
* `1`: standard output (stdout)  
* `2`: standard error (stderr)  


### File Descriptor Usage Example:  
```bash  
if [[ -t 0 ]]; then  
    printf "Standard Input is attached to a terminal.\n"  
else  
    printf "Standard Input is not attached to a terminal.\n"  
fi  

if [[ -t 1 ]]; then  
    printf "Standard Output is attached to a terminal.\n"  
else  
    printf "Standard Output is not attached to a terminal.\n"  
fi  
```

## Name Reference  
Like a pointer in C.  
A name reference is a variable that *refers* to another variable.  

This is different from a normal variable assignment. 
The name reference creates a kind of alias to the other variable.  
A name reference is created using the `declare -n` command.  

### Name Reference Usage Example:  
```bash  
declare -n ref=original  
original="data"  
if [[ -R ref ]]; then  
    echo "ref is a name reference."  
else  
    echo "ref is not a name reference."  
fi  
```

## Checking if Certain Shell Options are Enabled  
* `-o optname`
    * True if the shell option `optname` is enabled.  
    * The list of options appears in the output of `set -o`.  

---  


## Bash Conditional Flags Table
See `man://bash 2069`.  

| Flag      | True if |
|-|-  
| `-a file` | File exists.  
| `-b file` | File exists and is a block special file.  
| `-c file` | File exists and is a character special file.  
| `-d file` | File exists and is a directory.  
| `-e file` | File exists.  
| `-f file` | File exists and file is a regular file.  
| `-g file` | File exists and is set-group-id.  
| `-h file` | File exists and is a symbolic link.  
| `-k file` | File exists and its `sticky` bit is set.  
| `-p file` | File exists and is a named pipe (FIFO).  
| `-s file` | File exists and has a size greater than zero.  
| `-t fd`   | File descriptor `fd` is open and refers to a terminal.  
| `-u file` | File exists and its set-user-id bit is set.  
| `-r file` | File exists and is readable.  
| `-w file` | File exists and is writable.  
| `-x file` | File exists and is executable.  
| `-G file` | File exists and is owned by the effective group id.  
| `-L file` | File exists and is a symbolic link.  
| `-N file` | File exists and has been modified since it was last read.  
| `-O file` | File exists and is owned by the effective user id.  
| `-S file` | File exists and is a socket.  
| `file1 -ef file2` | `file1` and `file2` refer to the same device and inode numbers.  
| `file1 -nt file2` | `file1` is newer than `file2`, or if `file1` exists and `file2` does not (uses modification date).  
| `file1 -ot file2` | `file1` is older than `file2`, or if `file2` exists and `file1` does not.  
| `-v varname`  | True if the shell variable varname is set (has been assigned a value).  
| `-R varname`  | True if the shell variable varname is set and is a name reference.  
| `-z string`   | True if the length of string is zero.  
| `-n string`   | True if the length of string is non-zero.  
| `string1 == string2`  | True if the strings are equal.  
| `string1 =~ regex`    | True if `string1` matches the regular expression `regex` (bash-only).  
| `string1 != string2`  | True if the strings are not equal.  
| `string1 < string2` | True if string1 sorts before string2 lexicographically (alphabetically).  
| `string1 > string2` | True if string1 sorts after string2 lexicographically (alphabetically).  


---  

mapfile  

```help  
*mapfile* [-d delim] [-n count] [-O origin] [-s count]  
        [-t] [-u fd] [-C callback] [-c quantum] [array]  
```

Read lines from the standard input into the indexed array variable array, or  
from file descriptor `fd` if the `-u` option is supplied.  
The variable `MAPFILE` is the default array.  


