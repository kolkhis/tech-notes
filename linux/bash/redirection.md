# Redirection in Bash  


Notes taken from:  

* `man://bash`
* [Bash Hacker's Wiki](https://web.archive.org/web/20230315225157/https://wiki.bash-hackers.org/howto/redirection_tutorial#illustrated_redirection_tutorial)  



## Table of Contents
* [Overview](#overview) 
* [Primary Redirection Operators](#primary-redirection-operators) 
* [`stdin`, `stdout`, `stderr`](#`stdin`,-`stdout`,-`stderr`) 
* [Output Redirection in Bash (`cmd > file`)](#output-redirection-in-bash-(`cmd->-file`)) 
    * [Overwriting a File](#overwriting-a-file) 
    * [Appending to a File](#appending-to-a-file) 
* [Input Redirection in Bash (`cmd < file`)](#input-redirection-in-bash-(`cmd-<-file`)) 
* [Pipes in Bash](#pipes-in-bash) 
* [Closing File Descriptors](#closing-file-descriptors) 
* [Order of Redirection](#order-of-redirection) 
* [Using `exec` for Redirection](#using-`exec`-for-redirection) 
    * [Examples of using `exec` redirection](#examples-of-using-`exec`-redirection) 
* [Duplicating File Descriptors](#duplicating-file-descriptors) 
* [Additional Information](#additional-information) 
    * [Why `sed 's/foo/bar/' file >file` Doesn't Work](#why-`sed-'s/foo/bar/'-file->file`-doesn't-work) 
    * [Redirection Examples](#redirection-examples) 
        * [Redirecting `stderr` to `stdout`](#redirecting-`stderr`-to-`stdout`) 
        * [Saving `stdout` and `stderr` to separate files](#saving-`stdout`-and-`stderr`-to-separate-files) 
        * [Piping `stderr` while discarding `stdout`](#piping-`stderr`-while-discarding-`stdout`) 
        * [Closing a File Descriptor](#closing-a-file-descriptor) 
        * [Redirecting Input from a File](#redirecting-input-from-a-file) 
        * [Redirecting Output to a File](#redirecting-output-to-a-file) 
    * [Standard Examples](#standard-examples) 


## Overview  
Redirection works entirely using file descriptors (fd) and special  
files called pipes (or FIFOs).  

A file descriptor is a number that refers to a file or a process.  

* Redirection can manipulate not just standard fds but also custom fds  
  opened by the script using `exec`.  
    * Use `exec` with caution.  
    * It can affect the current shell environment or script execution context.  
* Management of fds is crucial in long-running scripts or daemons to  
  prevent resource leaks.  

## Primary Redirection Operators  
* `>`: Redirects `stdout` to a file, overwriting the file.  
* `2>`: Redirects `stderr` to a file.  
* `<`: Reads input from a file into a command.  
    * See [process substitution](./process_substitution.md)
* `&>`: Redirects both `stdout` and `stderr` to a file.  
* `>>`: Appends `stdout` to a file.  
* `<&n`: Redirects input from file descriptor `n`.  
* `>&n`: Redirects output to file descriptor `n`.  
* `|`: Pipes the `stdout` of one command to the `stdin` of another command.  
* `<<<`: Herestring. This treats the string after it as a file for `stdin`.  

## Obscure Redirection Operators
Some lesser known redirection operators:

- `<>`: **Opens** the file for both reading *and* writing.  
    - This should be directed into a file descriptor.  
      E.g.:
      ```bash
      # Open file for read/write using fd 3
      exec 3<> myfile.txt

      # Read the first line
      read -r line <&3 && printf "%s\n" "$line"

      # Write something to the file
      printf >&3 "Log updated!\n" 

      # Close fd 3
      exec 3>&-
      ```
      This can be used to modify a file in-place using file descriptors (e.g.,
      locking, FIFs, or bidirectional communication).  
    - This is called the "diamond operator" in Perl.  

- `>|`: Force overwrite with `noclobber` enabled.  
    - The `noclobber` option will fail any redirections using `>` to a file that
      already exists.  
      ```bash
      set -o noclobber # or set -C
      touch ./file.txt
      printf "This won't write!\n" > ./file.txt
      ```
      This won't work since `file.txt` already exists.  
      ```bash
      printf "This will write!\n" >| ./file.txt
      ```
      This will ignore `noclobber` and write to `file.txt` whether it exists or not.  



## `stdin`, `stdout`, `stderr`  
When bash starts, 3 file descritors are opened:  

* `0`: Standard Input (`stdin`)  
* `1`: Standard Output (`stdout`)  
* `2`: Standard Error (`stderr`)  
 
These are known as the standard file descriptors.  


```bash  
# lsof +f g -ap $BASHPID -d 0,1,2
COMMAND    PID    USER   FD   TYPE FILE-FLAG DEVICE SIZE/OFF NODE NAME  
bash    710386 kolkhis    0u   CHR     RW,AP  136,3      0t0    6 /dev/pts/3
bash    710386 kolkhis    1u   CHR     RW,AP  136,3      0t0    6 /dev/pts/3
bash    710386 kolkhis    2u   CHR     RW,AP  136,3      0t0    6 /dev/pts/3
```

* `lsof`: List open files.  
    * `+f g`: Show file flag abbreviations  
    * `-a`: List selection is `AND`ed together.  
    * `-p`: Specify a process ID.  
    * `-d`: Specifiy a list of file descriptors.  

* The `/dev/pts/3` is a pseudo-terminal, used to emulate a real terminal.  
    * Bash reads input from `stdin` from this terminal, and outputs `stdout` and 
      `stderr` to this terminal.  
* Here you can see the file descriptor numbers under the `FD` column.  
* When commands are executed, they send their output to the file descriptors  
  above, which are inherited from the shell.  


## Output Redirection in Bash (`cmd > file`)  

### Overwriting a File  
```bash  
printf "This is a line\n" > output.txt  
# This is the same as  
printf "This is a line\n" 1> output.txt  
```

* `> output.txt` is the same as `1>output.txt`
* The `> output.txt` alters the file descriptors belonging to the command `printf`.  
    * It changes the fd `1` (`stdout`) so that it points to the file `output.txt`.  
    * Now anything `printf` sends to `stdout` (fd `1`) are sent to `output.txt` instead.  

In the same way, `cmd 2> output.txt` will change the `stdout` fd, and make it point to `output.txt`.  

### Appending to a File  
```bash  
printf "Another line\n" >> output.txt  
```
This appends `"Another line"` to `output.txt` without overwriting existing content.  



## Input Redirection in Bash (`cmd < file`)  
Using `command < file` changes the file descriptor `0`.  
 
If `command` reads from `stdin`, then `command < file` will read  
from `file` instead.  



## Pipes in Bash  
Using pipes `|`, you connect the standard output of the first command to the  
standard input of the second command.  
 
It creates a special file (a pipe), which is opened as a write destination  
for the first command, and a read source for the second command.  

```bash  
echo foo | cat  
```
Bash makes this work like this:  
1. The redirections are set up by the shell *before* the commands are executed.  
2. The commands inherit the file descriptors from the shell.  



## Closing File Descriptors  
To prevent a command from writing to a file descriptor (e.g., `stderr`),
you can close it:  
```bash  
cmd 2>&-  
```
This effectively silences `stderr` for `cmd`.  


## Order of Redirection  
<!-- order of redirection, redirection order, redirect order, ordering redirects order of redirects -->
While it doesn't matter where the redirections appears on the command line, their  
order does matter.  
The order matters because redirections are processed from left to right.  
To redirect both `stdout` and `stderr` to a file:  
```bash  
cmd > file 2>&1  
```
This ensures `stderr` is redirected to where `stdout` is currently directed (i.e., `file`).  



## Using `exec` for Redirection  
<!-- redirect whole file, redirect entire file, redirect with exec, exec redirection, logging -->  

In Bash the `exec` built-in replaces the shell with the specified program.  
`exec` also allow us to manipulate the file descriptors.  

If you don't specify a program, the redirection after `exec` modifies the 
standard file descriptors of the current shell.  

Since all commands inherit the file descriptors from the shell,  
all output of the commands will also inherit the redirection.  

---  

Using `exec` with no command, but with redirection, applies that 
redirection to the rest of the script or shell session:  
```bash  
exec 2>error.log  
```
Now anything written to `stderr` in the current shell will be written to `error.log`.  
Or, if used in a script, it will affect the rest of the script.  

### Examples of using `exec` redirection
 
For example:  
```bash  
exec 2>error_file  
```

* `2>`: Redirects `stderr` - in this case, to a file.  
    * If you don't specify a file descriptor with the `>` operator, it
      defaults to `1` (`stdout`).  

Before running this, errors will be sent to `stderr`.  

All the the errors sent to `stderr` by the commands *after* the `exec 2>error_file` will 
go to the `error_file`.  
just as if you had the command in a script  
and ran `myscript 2>error_file`.  

`exec` can be used if you want to log the errors the commands in your script  
produce, just add `exec 2>myscript.errors` at the beginning of your script.  

---  

Another example:  
```bash  
exec >/tmp/all_output.log 2>&1  
```
This will redirect both `stdout` and `stderr` to `/tmp/all_output.log`.  

* `exec >`: Redirects `stdout` - in this case, to a file.  
* `2>&1`: Redirects `stderr` to `stdout`. 

---  

## Duplicating File Descriptors  
<!-- redirect file descriptors, copy file descriptors, clone file descriptors, duplicate file descriptors dupe fd -->  
You can create clones of file descriptors:  
```bash  
exec 3>&1  
```
This duplicates `stdout` (`1`) as fd `3`.  
So anything written to fd `3` will go to `stdout`.  




---  

## Additional Information  

### Why `sed 's/foo/bar/' file >file` Doesn't Work  

This is a common error.  
```bash  
sed 's/foo/bar/' file >file  
```
The problem here is that the redirections are setup before the command  
is actually executed.  
 
BEFORE `sed` starts, standard output has already been redirected, with the  
additional side effect that, because we used `>`, `"file"` gets truncated  
(overwritten).  
When `sed` starts to read the file, it contains nothing.  

A workaround is to use a temporary file:  
```bash  
sed 's/foo/bar/' file > temp && mv temp file  
```


---  


### Redirection Examples  
#### Redirecting `stderr` to `stdout`  
```bash  
command 2>&1  
```
This redirects the `stderr` of `command` to `stdout`, capturing all output in one stream.  


#### Saving `stdout` and `stderr` to separate files  
```bash  
command >out.txt 2>err.txt  
```
Redirects `stdout` to `out.txt` and `stderr` to `err.txt`.  


#### Piping `stderr` while discarding `stdout`  
```bash  
command 2>&1 1>/dev/null | grep 'error'  
```
This filters `stderr` for 'error', and discards `stdout`.  
  
The `stderr` is redirected to `stdout`, which is then piped to `grep`, while 
original `stdout` is discarded.  
So, `stderr` effectively replaces `stdout`, and `grep` only receives `stderr`.  


#### Closing a File Descriptor  
```bash  
exec 3>&- # Closes fd 3
```
Useful for explicitly releasing system resources.  


#### Redirecting Input from a File  
```bash  
exec 0< inputfile  
```
This redirects `stdin` to read from `inputfile`.  `0` is implied.
Effectively this reads from `inputfile` instead of `stdin`.


#### Redirecting Output to a File  
```bash  
exec 1> outputfile  
```
Redirects `stdout` to `outputfile`, useful for logging or output capture. `1` is 
implied.  


---



### Standard Examples

```bash
cat file.txt > file2.txt    # redirects stdout of `cat`, overwrites file2.txt
cat file.txt >> file2.txt   # redirects stdout of `cat`, appends to file2.txt
cat file.txt 2> file2.txt   # redirects stderr of `cat`, overwrites file2.txt
cat file.txt 2>> file2.txt  # redirects stderr of `cat`, appends to file2.txt

cat file.txt > file2.txt 2>&1   # redirects stdout of `cat`, redirects stderr to stdout
cat file.txt 2> file2.txt 1>&2  # redirects stderr of `cat`, redirects stdout to stderr

printf 1>&2 "This will be printed to stderr.\n"  # redirects stdout to stderr
printf >&2 "This will be printed to stderr.\n"   # redirects stdout to stderr (1 is implied)
cat < file.txt > file2.txt # reads stdin for `cat` from file.txt, redirects stdout of `cat`

cat < <(find . -name 'file.txt')    # Uses process substitution. Reads stdin for `cat`
                                    # from the output of the process substitution `<()` 

# Loop over lines in a file
# Redirect a file to the read command to loop over it
while read -r line; do echo "Current line: $line"; done < file.txt 
# Redirect the output of a command to the read command with process substitution
while read -r line; do echo "Current line: $line"; done < <(ls -alh) 

# Redirect the output of a command to the read command with a herestring and subshell
while read -r line; do echo "Current line: $line"; done <<< $(ls -alh)
```


