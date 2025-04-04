# File Operations in Perl

## Table of Contents
* [Opening and Closing Files](#opening-and-closing-files) 
* [File Operations](#file-operations) 


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
* `opendir()` opens a directory and returns a directory handle.
* `readdir()` reads all filenames in the directory into an array.
* `closedir()` closes the directory handle.

---

### Excluding `.` and `..`
* Use a `grep` to exclude the `.` (current) and `..` (parent) directories.  
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
  
* Just add a `-f` check in the `grep` to only get regular files.
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
* `File::Spec->catfile($dir_name, $_)`: 
    - Safely joins the directory path and filename regardless of OS.  
    - So instead of `"$dir_name/$_"`, we use `catfile`.
* `-f`: Tests if the path is a regular file. Skips directories, pipes, symlinks, etc. 
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
* `-f`: Is a regular file   
    - `[[ -f "$file" ]]`
* `-d`: Is a directory  
    - `[[ -d "$dir" ]]`
* `-e`: Exists  
    - `[[ -e "$path" ]]`
* `-s`:  Size > 0    
    - `[[ -s "$file" ]]`
* `-r`, `-w`, `-x`: Readable / writable / executable   
    - Same as Bash
* `-z`: Size is zero
    * `[[ -z "$file" ]]`
    * `[[ ! -s "$file" ]]`
* `-l`: Is a symlink 
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
* Lock the file `log.lock` exclusively (`-x`)
* Then run the command (`-c '...'`)
* While that command runs, the lock is held
* Other processes trying to `flock log.lock` will wait

This prevents two scripts from writing to `shared.log` at the same time.  

## Combining Bash and Perl to Read Filenames
If using `File::Find` is not to your liking, you can use `qx` (or backticks) to
execute a shell command (`find`).  
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

## Writing to a Piped Output Stream
You can also utilize `open` with the `|-` operator to specify that you want to write
to a pipe.  
```perl
open(my $fh, '|-', 'tee output.log') or die $!;
print $fh "Hello!\n";
close $fh;
```
This will open a filehandle that pipes out to the command `tee output.log`.  

You can also specify `tee -a` to append to the file instead:
```bash
open(my $fh, '|-', 'tee -a output.log') or die $!;
print $fh "Hello again!\n";
close $fh;
```

