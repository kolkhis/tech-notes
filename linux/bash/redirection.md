

# Redirection in Bash  


Notes taken from:  
* `man://bash`
* [Bash Hacker's Wiki](https://web.archive.org/web/20230315225157/https://wiki.bash-hackers.org/howto/redirection_tutorial#illustrated_redirection_tutorial)  



## Table of Contents
* [Redirection in Bash](#redirection-in-bash) 
* [Overview](#overview) 
* [Primary Redirection Operators](#primary-redirection-operators) 
* [`stdin`, `stdout`, `stderr`](#stdin-stdout-stderr) 
* [Output Redirection in Bash (`cmd > file`)](#output-redirection-in-bash-cmd->-file) 
    * [Overwriting a File](#overwriting-a-file) 
    * [Appending to a File](#appending-to-a-file) 
* [Input Redirection in Bash (`cmd < file`)](#input-redirection-in-bash-cmd-<-file) 
* [Pipes in Bash](#pipes-in-bash) 
* [Closing File Descriptors](#closing-file-descriptors) 
* [Duplicating File Descriptors](#duplicating-file-descriptors) 
* [Order of Redirection](#order-of-redirection) 
* [Using `exec` for Redirection](#using-exec-for-redirection) 
* [Additional Information](#additional-information) 
    * [`exec` with Redirection](#exec-with-redirection) 
    * [Why `sed 's/foo/bar/' file >file` Doesn't Work](#why-sed-'s/foo/bar/'-file->file-doesn't-work) 
    * [Redirection Examples](#redirection-examples) 
        * [Redirecting `stderr` to `stdout`](#redirecting-stderr-to-stdout) 
        * [Saving `stdout` and `stderr` to separate files](#saving-stdout-and-stderr-to-separate-files) 
        * [Piping `stderr` while keeping `stdout`](#piping-stderr-while-keeping-stdout) 
        * [Closing a File Descriptor](#closing-a-file-descriptor) 
        * [Redirecting Input from a File](#redirecting-input-from-a-file) 
        * [Redirecting Output to a File](#redirecting-output-to-a-file) 



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
- `>`: Redirects `stdout` to a file, overwriting the file.
- `<`: Reads input from a file into a command.
- `2>`: Redirects `stderr` to a file.
- `&>`: Redirects both `stdout` and `stderr` to a file.
- `>>`: Appends `stdout` to a file.
- `<&n`: Redirects input from file descriptor `n`.
- `>&n`: Redirects output to file descriptor `n`.
- `|`: Pipes the `stdout` of one command to the `stdin` of another command.



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

## Duplicating File Descriptors
You can create clones of file descriptors:
```bash
exec 3>&1
```
This duplicates `stdout` (`1`) as fd `3`.  
So anything written to fd `3` will go to `stdout`.  


## Order of Redirection
While it doesn't matter where the redirections appears on the command line, their  
order does matter.  
The order matters because redirections are processed from left to right.  
To redirect both `stdout` and `stderr` to a file:
```bash
cmd >file 2>&1
```
This ensures `stderr` is redirected to where `stdout` is currently directed (i.e., `file`).



## Using `exec` for Redirection
Using `exec` with no command, but with redirection, applies that 
redirection to the rest of the script or shell session:
```bash
exec 2>error.log
```
Now anything written to `stderr` in the current shell will be written to `error.log`.  
Or, if used in a script, it will affect the rest of the script.  

---

## Additional Information

### `exec` with Redirection
In Bash the `exec` built-in replaces the shell with the specified program.  
`exec` also allow us to manipulate the file descriptors.  
 
If you don't specify a program, the redirection after `exec` modifies the 
standard file descriptors of the current shell, which are then
inherited by any commands.  

For example:  
```bash  
exec 2>file  
```
All the the errors sent to `stderr` by the commands after the `exec 2>file` will 
go to the `file`, just as if you had the command in a script  
and ran `myscript 2>file`.  

`exec` can be used if you want to log the errors the commands in your script  
produce, just add `exec 2>myscript.errors` at the beginning of your script.  

---


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
This redirects the `stderr` of `command` to `stdout`, useful for capturing all output in one stream.  


#### Saving `stdout` and `stderr` to separate files  
```bash  
command >out.txt 2>err.txt  
```
Redirects `stdout` to `out.txt` and `stderr` to `err.txt`.  


#### Piping `stderr` while keeping `stdout`  
```bash  
command 2>&1 1>/dev/null | grep 'error'  
```
This filters `stderr` for 'error', and discards `stdout`.
 
The `stderr` is redirected to `stdout`, which is then piped to `grep`, while
original `stdout` is discarded.  


#### Closing a File Descriptor
```bash  
exec 3>&- # Closes fd 3
```
Useful for explicitly releasing system resources.  


#### Redirecting Input from a File  
```bash  
exec 0< inputfile  
```
This redirects `stdin` to read from `inputfile`.  


#### Redirecting Output to a File  
```bash  
exec 1> outputfile  
```
Redirects `stdout` to `outputfile`, useful for logging or output capture.  


-----------------------------  




