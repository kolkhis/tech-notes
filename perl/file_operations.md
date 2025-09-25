# File Operations in Perl

## Table of Contents
- [Opening and Closing Files](#opening-and-closing-files) 
- [File Operations](#file-operations) 


---

## File Functions
### Opening Files
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
        - `-|`: Open a filehandle to read from an Input Stream (for use with shell commands)
        - `|-`: Open a filehandle to write to an Output Stream (for use with shell commands)
    - `'file.txt'`: The file to open
    - `or die $!;`: If `open` fails, this will terminate the script and print the
      system error msg from `$!`.

### Closing Files
Close files with the `close` function, passing the file handle as an argument:
```perl
close $fh;
```
Always close files when you're done with them!
It's a good practice to free up system resources.  

If you forget to close, Perl may close it automatically when the script ends.
But, in long-term running scripts, not closing the file can cause **file descriptor leaks**. 

---

### Reading from Files (Diamond Operator)
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

#### Slurping a Whole File
To read the contents of a file into a single scalar variable, undefine 
the `$/` variable (input record separator) before reading from the file handle:

```perl
open(my $fh, '<', 'file.txt') or die "Couldn't open file: $!";
undef $/;
my $contents = <$fh>;
close $fh;

print $contents;
```

In bash it would be something like:
```bash
contents=$(<file.txt)
printf "%s\n" "$contents"
```

---

### Writing to Files
Writing to files requires `open`ing the file first, then you can `print` into it.  

To truncate (overwrite) a file, open with the `>` mode. 
```perl
open(my $fh, '>', 'output.txt') or die $!;
print $fh "Hello, world.\n";
close $fh;
```

- `print $fh "...";`: The `print` function can take a filehandle as an argument.  
    - The output of the print statement will be directed to that filehandle.  

To append to the file, open with the `>>` mode.  
```perl
open(my $fh, '>>', 'output.txt') or die $!;
print $fh "Hello, world.\n";
close $fh;
```

In bash, this is equivalent to:
```bash
printf "Hello, world.\n" > output.txt
printf "Hello, world.\n" >> output.txt
```


## Reading Filenames from a Directory
There are specific perl directory functions to help with this kind of thing.  

- `opendir`
- `closedir`
- `readdir`

Ex, opening the `notes` directory and reading the filenames inside:
```perl
my $dir_name = '/home/kolkhis/notes';
openddir(my $dir, $dir_name) or die "Can't open dir: $dirname: $!";
my @files = readdir($dir);
closedir($dir);

foreach my $f (@files) {
    print "File: $f\n";
}
```
- `opendir()` opens a directory and returns a directory handle.
- `readdir()` reads all filenames in the directory into an array.
- `closedir()` closes the directory handle.

---

### Excluding `.` and `..`
- Use a `grep` to exclude the `.` (current) and `..` (parent) directories.  
  ```perl
  my $dir_name = '/home/kolkhis/notes';
  openddir(my $dir, $dir_name) or die "Can't open dir: $dirname: $!";
  my @files = grep { $_ ne '.' && $_ ne '..' } readdir($dir);
  closedir($dir);
  
  foreach my $f (@files) {
      print "File: $f\n";
  }
  ```
  Using `grep { ... } readdir($dir)` filters out unwanted entries.  
  It accepts the `ne` (not equal) function for conditionals.  
  
- Just add a `-f` check in the `grep` to only get regular files.
  ```perl
  my $dir_name = '/home/kolkhis/notes';
  openddir(my $dir, $dir_name) or die "Can't open dir: $dirname: $!";
  my @files = grep {
      $_ ne '.' && $_ ne '..' && -f $_
  } readdir($dir);
  closedir($dir);
  
  foreach my $f (@files) {
      print "File: $f\n";
  }
  ```
  This has some limitations though. It will only print the filenames, so if the
  script isn't being run in `$dir_name`, it may break.  

  If we just used `"$dir_name/$_"`, it would break on Windows and not be
  cross-platform.  

  We can fix that with `File::Spec` (or `Path::Tiny`).  

---

### Getting Regular Files Only with `File::Spec`
`File::Spec` is a perl module.
```perl
my $dir_name = '/home/kolkhis/notes';
openddir(my $dir, $dir_name) or die "Can't open dir: $dirname: $!";
my @files = grep {
    $_ ne '.' && $_ ne '..' && -f File::Spec->catfile($dir_name, $_)
} readdir($dir);
closedir($dir);

foreach my $f (@files) {
    print "File: $f\n";
}
```
- `File::Spec->catfile($dir_name, $_)`: 
    - Safely joins the directory path and filename regardless of OS.  
    - So instead of `"$dir_name/$_"`, we use `catfile`.
- `-f`: Tests if the path is a regular file. Skips directories, pipes, symlinks, etc. 
    - Just like bash. 

### Getting Regular Files Only with `Path::Tiny`
`File::Spec` is great, but `Path::Tiny` is more "ergonomic."  
`Path::Tiny` is an official CPAN module. It's not in the Perl core but it's common in 
modern Perl codebases.  
Using this module abstracts away all of the lower level things like `opendir` and
`closedir`.  
```perl
use Path::Tiny;

my $dir = path("/home/kolkhis/notes"); # The `path` function from `Path::Tiny`
my @files = $dir->children(qr/\.md$/); # All the .md files

foreach my $file (@files) {
    print "File: $file\n";
}
```

- The `path()` function returns a `dir` object.  
- This `dir` object has a method `children()`.
    - `qr/`: The `qr` means "quote regex." It compiles regex as an object.
      ```perl
      my $regex = qr/\.md$/;
      ```
      You can pass that object around or use it like a regular regex. It's like
      `r'...'` in Python.
    - Inside `children(qr/\.md$/);`, it's filtering filenames with `.md` file
      extensions. 

This is more platform agnostic. It handles the platform differences (slashes,
symlinks, etc.) more cleanly.  


## File Test Operations (File Conditionals)
Perl and Bash have a lot in common. This is true for file tests as well.  
Perl supports a lot of conditionals that Bash has for checking the state of files
(e.g., `-f $FILE`).  

A list of Perl file test operators (and their bash equivalents):
- `-f`: Is a regular file   
    - `[[ -f "$file" ]]`
- `-d`: Is a directory  
    - `[[ -d "$dir" ]]`
- `-e`: Exists  
    - `[[ -e "$path" ]]`
- `-s`:  Size > 0    
    - `[[ -s "$file" ]]`
- `-r`, `-w`, `-x`: Readable / writable / executable   
    - Same as Bash
- `-z`: Size is zero
    * `[[ -z "$file" ]]`
    * `[[ ! -s "$file" ]]`
- `-l`: Is a symlink 
    * `[[ -L "$file" ]]`

An example:
```perl
if (-d $path) {
    print "$path is a directory\n";
}
```

## Recursive Directory Traversal (like `find`)
You can use `File::Find` to emulate the behavior of the `find` command:
```perl
use File::Find;

find(sub{
    return unless -f;  # only regular files
    print "Found file: $File::Find::name\n";

}, '/some/directory');
```
The `File::Find::find` function takes a submodule as an argument (a perl function).  

- TODO: `File::Find` also supports `-exec` functionality.

The bash equivalent:
```bash
find /some/directory -type f
```


## Modifying File Permissions (`chmod`, `chown`, `utime`)
Perl has direct functions like bash to do these things:

```bash
chmod 0755, 'script.pl';
```
Though Perl allows you to leave out parentheses for function calls like Bash, it's
usually better to use them (avoids ambiguity).  
```perl
chmod(0755, 'script.pl');
chown($uid, $gid, 'file.txt');
utime($atime, $mtime, 'file.txt');
```

In bash, this would be:
```bash
chmod 755 script.pl
chown user:group file.txt
touch -t 202201010000 file.txt
```

## Temporary Files
You can create temporary files with `File::Temp`.  
```perl
use File::Temp qw/tempfile/; # qw = a list of quoted words. same as ('tempfile')

my ($fh, $filename) = tempfile(); 
print $fh "Hello!\n";
close $fh;
print "File written to $filename\n"
```

- `use File::Temp qw/tempfile/;`: The `qw` stands for "quote words." It's a perl shortcut for
  space-separatesd strings.
    - So this is the same as `('tempfile')`.
    - `File::Temp` is passing a list of symbols to import. So using `qw/tempfile/;`
      only imports the `tempfile()` function from the module. 

## File Locks (`flock`)
For safe concurrent writing, you can implement file locks with `flock()`.  
File locking prevents multiple processes from writing to the same file at the same
time (i.e., avoiding race conditions or corruption).  

- It's like a mutex but for files
- If one process locks a file, others have to wait (or fail) if they try to lock it too.  
```perl
open(my $fh, '>>', 'shared.log') or die $!;
flock($fh, 2) or die "Can't lock: $!";
print $fh "Some log entry\n";
close($fh); 
```

- `flock($fh, 2)`: Lock the file with an exclusive lock (write lock).  
- The 2 means "Exclusive Lock". There are others:

  | Number | Constant  | Meaning |
  |--------|-----------|---------|
  |   1    | `LOCK_SH` | Shared Lock (read)
  |   2    | `LOCK_EX` | Exclusive Lock (write)
  |   8    | `LOCK_NB` | Non-blocking

If you'd rather use the constants, you can do that -- it's probably more readable. 
```perl
flock($fh, LOCK_EX)
```

In bash, this would be:
```bash
flock -x log.lock -c 'echo "Some log entry" >> shared.log'
```
This says:

- Lock the file `log.lock` exclusively (`-x`)
- Then run the command (`-c '...'`)
- While that command runs, the lock is held
- Other processes trying to `flock log.lock` will wait

This prevents two scripts from writing to `shared.log` at the same time.  

## Combining Bash and Perl to Read Filenames
Also see: [operators](./operators.md).  

If using `File::Find` is too cumbersome, you can use `qx` (or backticks) to
spawn a subshell and execute a shell command (`find`).  

```perl
my @names;
@names = qx(find /home/kolkhis/notes -name '*.md');
chomp(@names); # get rid of the newlines at the end
foreach my $n (@names) {
    -f $n && print "Regular file: $n\n";
}
```
If you don't use `chomp(@names);` then the files will contain newlines, and `-f` will
not work on them.  

## Reading from a Piped Input Stream
You can utilize the `open` function with the `-|` operator to indicate a piped input
stream.  
```perl
open(my $fh, '-|', 'find /home/kolkhis/notes -name "*.md"') or die $!;
# or, use multiple argument form (this is safer, and faster)
open(my $fh, '-|', 'find', '/home/kolkhis/notes', '-name', '*.md') or die $!;
while (my $filename = <$fh> ) {
    chomp($filename);  # Get rid of the newline
    print "File: $filename\n";
}
close $fh;
```
The `-|` opens a pipe for reading the output of a command.  

This runs the `find` command in a subprocess and produces a filehandle to read from
its `stdout`.  

You can also utilize `open` to write output to pipes.  

---

> Which one should I use?  

Both commands use Perl's internal `exec()` function to execute the command.  
But, `exec()` behaves differently when it's passed a single string vs. an array (list) of items.  

- When `exec()` is passed only a **single string** as the command, it uses the shell (`$SHELL`) to execute it.  
- When `exec()` is passed an **array**, it behaves like C's `execvp()` syscall and skips
  the shell.  

So, these two `open` commands behave a bit differently:
- The first `open` only has one single string command, so it relies on the shell to
  parse it.
    - Spawns a shell (like `sh -c 'find ...'`).  
    - This version is vulnerable to quoting bugs or shell injection if any part of the 
      command comes from user input.
- The second `open` has each argument being passed as an array (list items), so Perl
  can bypass the shell and directly invoke the command with `execvp()`-like behavior.  
    - Perl uses `fork()` to create a child process.  
    - Then it uses perl's builtin `exec()` function, which wraps C's `execvp()` syscall.  
    - Since it's *not* a string, it does not invoke a shell.  

---

## Writing to a Piped Output Stream
You can also utilize `open` with the `|-` operator to specify that you want to write
to a pipe.  
```perl
open(my $fh, '|-', 'tee output.log') or die $!;
print $fh "Hello!\n";
close $fh;
```
This spawns a shell since the command is one string.  
Like above, it's safer to pass an array instead of a string to `open` when using
pipes:
```perl
open(my $fh, '|-', 'tee', 'output.log') or die $!;
```
This will open a filehandle that pipes out to the command `tee output.log`.  

You can also specify `tee -a` to append to the file instead:
```bash
open(my $fh, '|-', 'tee -a output.log') or die $!;
# or, to avoid using the shell:
open(my $fh, '|-', 'tee', '-a', 'output.log') or die $!;
print $fh "Hello again!\n";
close $fh;
```

---

Just like with reading from a pipe (`-|`), the form you use matters:

- If you pass a single string:
    * Perl will invoke the shell (`sh -c "tee -a output.log"`)
    * This is less safe and can cause quoting issues or shell injection
- If you pass a list of arguments:
    * Perl directly invokes the command using `execvp()` (no shell)
    * Safer and more predictable:
      ```perl
      open(my $fh, '|-', 'tee', '-a', 'output.log') or die $!;
      ```

### Using `open()` to Fork and Exec a Command
Like I pointed out earlier when reading from and writing to pipes, formatting your
command as an array is safer.  
```perl
open(my $ls, '-|', 'ls', '-alh', '/tmp') or die $!;
```

- This tells Perl:
    - Do not spawn a subshell. 
    - Fork the current Perl process.
    - Use `exec()` to run this command directly with those exact arguments.

This works more like how `execvp()` works in C.  

This is safer than using shell pipelines (e.g., spawning subshells with `qx(ls -alh /tmp)` or ``` `ls -alh /tmp` ```):

- Those versions use the shell (`$SHELL`) to run the command, and are basically
  equivalent to `bash -c 'ls -alh /tmp'`.  
- They involve parsing the command string, so quoting and escaping can be tricky. 
  ```perl
  qx(ls -l "$some_path"); # can break if $some_path has spaces
  ```
- No shell parsing means no injection risk.  
- No need to escape quotes, backslashes, or whitespace in paths.
- No reliance on `$SHELL`

So if you're using `open` to run the command, it bypasses the shell (avoids quoting 
issues), and you pass arguments directly to the command.  

---

Behind the scenes, this is what's happening:
```c
fork();
exec("ls", "-alh", "/tmp");
```
That's why this works:
```perl
open(my $fh, '-|', 'ls', '-alh', '/tmp');
```

- `'-|'`: Tells Perl to create a child process (a fork).  
- The child process then does an `exec` of the given command.  
- The parent gets a filehandle to read from the child's STDOUT.  


### Using `select` to Redirect Output
The `select()` function in perl allows you to switch the "currently selected" filehandle.  
The currently selected filehandle determines where all your ouput will go.  

If an argument is given, and it's a filehandle, it will set the 'selected' filehandle
to the one given. This will redirect any `print`/`write`/`say` calls to that
filehandle until you switch back.  

Without arguments, `select()` returns the currently selected filehandle.  
The currently selected filehandle is `STDOUT` by default (a constant filehandle).  

```perl
open(my $fh, '>>', 'file.txt') or die $!;
select($fh);
print "Hey\n"; # goes into file.txt
select(STDOUT); # switch back to stdout
print "Hey\n"; # goes to stdout
```

You can keep track of your old filehandle before switching by saving it to a
variable:
```perl
my $old_fh = select;
```

To print to standard error:
```perl
my $stderr_fh = select(STDERR);
print "Hello stderr.\n";
select(STDOUT);
print "Hello stdout.\n";
print $stderr_fh "Hello again, stderr.\n";
```

---

Any variables related to output will also be affected by `select()`.  
This includes input/output record separators (`$/`, `$\` respectively) and the
autoflush output buffer variable (`$|`).  

When setting `$|` to autoflush (disable buffering before output), it will honor the
filehandle that is currently selected.  
```perl
open(my $log, '>', 'output.log') or die $!;
select($log);

$| = 1;     # Autoflush now applies to $log
$\ = "\n";  # Output record separator (automatically add newline to print statements)

print "Logging started.";   # Goes to output.log
select(STDOUT);             # Restore default output location
```



### Reading from STDIN
You can read from standard input (`STDIN`) using a `while` loop with the diamond
operator (`<>`).  
```perl
while (<STDIN>) {
    chomp;
    print "You typed: $_\n";
}
```
The `STDIN` is a constant filehandle, so it works with the diamond operator.  

## In-Place Editing (Emulating `-i` Behavior)

The edit-in-place behavior that is enabled via the `-i` option (`man perlrun`)
can also be enabled by setting the `$^I` variable (`man perlvar`).  

This method **only** works on the `ARGV` file handle.  

So, you must either manually insert the file into `ARGV`, or pass the file(s)
as command-line arguments to the perl script itself.  

```perl
#!/usr/bin/env perl
use strict;
use warnings;

for my $file (<*.md>) {
    chomp($file);
    our $^I = '.bak';
    our @ARGV = ($file);
    while(<>) {
        s/old/new/g; 
        print;
    }
}

```

Note that we're using `our` instead of `my` for the variables. This is because
they're global, and `my` creates a lexical variable for the current scope only,
and won't be recognized by the diamond operator.  

Using `local` would also work for this operation. This method is probably 
better, since it doesn't modify the global `ARGV`.  

```perl
#!/usr/bin/env perl
use strict;
use warnings;

for my $file (<*.md>) {
    chomp($file);
    our $^I = '.bak';
    our @ARGV = ($file);
    while(<>) {
        s/old/new/g; 
        print;
    }
}
```

