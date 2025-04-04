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


