# Bash / Shell Conditional Flags

* [Files and Directories](#Files-and-Directories)
* [Checking if Certain Shell Options are Enabled](#Checking-if-Certain-Shell-Options-are-Enabled)


## Files and Directories

*   -a *FILE*
    * True if file exists.  
*   -b *FILE*
    * True if file is block special.  
*   -c *FILE*
    * True if file is character special.  
*   -d *FILE*
    * True if file is a directory.  
*   -e *FILE*
    * True if file exists.  
*   -f *FILE*
    * True if file exists and is a regular file.  
*   -g *FILE*
    * True if file is set-group-id.  
*   -h *FILE*
    * True if file is a symbolic link.  
*   -L *FILE*
    * True if file is a symbolic link.  
*   -k *FILE*
    * True if file has its `sticky` bit set.  
*   -p *FILE*
    * True if file is a named pipe.  
*   -r *FILE*
    * True if file is readable by you.  
*   -s *FILE*
    * True if file exists and is not empty.  
*   -S *FILE*
    * True if file is a socket.  
*   -u *FILE*
    * True if the file is set-user-id.  
*   -w *FILE*
    * True if the file is writable by you.  
*   -x *FILE*
    * True if the file is executable by you.  
*   -O *FILE*
    * True if the file is effectively owned by you.  
*   -G *FILE*
    * True if the file is effectively owned by your group.  
*   -N *FILE*
    * True if the file has been modified since it was last read.  
*   *FILE1* -ef *FILE2*
    * True if file1 is a hard link to file2.
*   *FILE1* -nt *FILE2*
    * True if file1 is newer than file2 (according to modification date).
*   *FILE1* -ot *FILE2*
    * True if file1 is older than file2.  
*   -t *FD*  
    *   True if "File Descriptor" (*FD*) is opened on a terminal.  
### File Descriptor (fd)
In Unix and Unix-like systems, a file descriptor is a non-negative 
number that uniquely identifies an open file for the process.  
Standard file descriptors are 0 (standard input), 1 (standard output), and 2 (standard error).  
#### Usage example:
```bash
if [ -t 0 ]; then
    echo "Standard Input is attached to a terminal."
else
    echo "Standard Input is not attached to a terminal."
fi

if [ -t 1 ]; then
    echo "Standard Output is attached to a terminal."
else
    echo "Standard Output is not attached to a terminal."
fi
```

### Name Reference
Like a pointer in C.  
A name reference in Bash is a variable that *refers* to another variable.  
This is different from a normal variable assignment, as the name reference
creates a kind of alias to the other variable.  
A name reference is created using the declare -n command.  
#### Usage example:
```bash
declare -n ref=original
original="data"
if [ -R ref ]; then
    echo "ref is a name reference."
else
    echo "ref is not a name reference."
fi
```

## Checking if Certain Shell Options are Enabled
* -o *optname*
    * True if the shell option optname is enabled. The list of options appears in the description of the -o option to the set builtin (see The Set Builtin).


