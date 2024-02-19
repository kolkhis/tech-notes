

# Redirection in Bash  

## Table of Contents
* [Redirection in Bash](#redirection-in-bash) 
* [File Descriptor Redirection in Bash](#file-descriptor-redirection-in-bash) 
    * [Standard File Descriptors](#standard-file-descriptors) 
    * [Redirection Operators](#redirection-operators) 
        * [Duplicating Input File Descriptors](#duplicating-input-file-descriptors) 
        * [Duplicating Output File Descriptors](#duplicating-output-file-descriptors) 
    * [Visual Aid for FD Redirection](#visual-aid-for-fd-redirection) 
    * [Examples of File Descriptor Redirection](#examples-of-file-descriptor-redirection) 
        * [Redirecting stderr to stdout](#redirecting-stderr-to-stdout) 
        * [Saving stdout and stderr to separate files](#saving-stdout-and-stderr-to-separate-files) 
        * [Piping stderr while keeping stdout](#piping-stderr-while-keeping-stdout) 
        * [Closing File Descriptors](#closing-file-descriptors) 
        * [Redirecting Input from a File](#redirecting-input-from-a-file) 
        * [Redirecting Output to a File](#redirecting-output-to-a-file) 



## File Descriptor Redirection in Bash  

File descriptor (fd) redirection allows you to control where input/output  
(I/O) operations are performed.  
Useful for logging, error handling, and data processing tasks.  

* Redirection can manipulate not just standard fds but also custom fds  
  opened by the script using `exec`.  
    * Use `exec` with caution.  
    * It can affect the current shell environment or script execution context.  
* Management of fds is crucial in long-running scripts or daemons to  
  prevent resource leaks.  


### Standard File Descriptors  
- `0`: Standard Input (stdin)  
- `1`: Standard Output (stdout)  
- `2`: Standard Error (stderr)  


### Redirection Operators  
#### Duplicating Input File Descriptors  
* Syntax: `[n]<&word`
  * This redirects the file descriptor `n` to read from the same source as `word`.  
  * Default `n` is `0` (stdin) if not specified.  
  * If `word` is a number, `n` becomes a copy of that fd.  
  * An error occurs if `word` does not refer to an open input fd.  
  * To close an fd, `word` can be `-`, e.g., `0<&-` closes stdin.  

#### Duplicating Output File Descriptors  
* Syntax: `[n]>&word`
  * This attaches the output fd `n` to the target specified by `word`.  
  * Default `n` is `1` (stdout) if not specified.  
  * An error occurs if `word` does not refer to an open output fd.  
  * To close an fd, `word` can be `-`, e.g., `1>&-` closes stdout.  
  * Special case: without `n` and `word` not being a number or `-`, both stdout and stderr are redirected to `word`.  
    * This is commonly used to redirect both stdout and stderr to the same file or device.  


---  

### Visual Aid for FD Redirection  
The syntax is somewhat confusing.  
You would think that the arrow would point in the direction of the 
copy, but it's reversed.  
So it's effectively `target>&source`.  

If you have two file descriptors `s` and `t` like:  
```plaintext  
                  ---       +-----------------------+  
 a descriptor    ( s ) ---->| /some/file            |
                  ---       +-----------------------+  
                  ---       +-----------------------+  
 a descriptor    ( t ) ---->| /another/file         |
                  ---       +-----------------------+  
```

Using a `t>&s` (where `t` and `s` are numbers) it means:  
> Copy whatever file descriptor `s` contains into file descriptor `t`

So you got a copy of this descriptor:  
```plaintext  
                  ---       +-----------------------+  
 a descriptor    ( s ) ---->| /some/file            |
                  ---       +-----------------------+  
                  ---       +-----------------------+  
 a descriptor    ( t ) ---->| /some/file            |
                  ---       +-----------------------+  
```

---  

### Examples of File Descriptor Redirection  
#### Redirecting stderr to stdout  
```bash  
command 2>&1  
```
This redirects the stderr of `command` to stdout, useful for capturing all output in one stream.  

#### Saving stdout and stderr to separate files  
```bash  
command >out.txt 2>err.txt  
```
Redirects stdout to `out.txt` and stderr to `err.txt`.  

#### Piping stderr while keeping stdout  
```bash  
command 2>&1 1>/dev/null | grep 'error'  
```
This filters stderr for 'error', discarding stdout. The stderr is redirected to stdout, which is then piped to `grep`, while original stdout is discarded.  

#### Closing File Descriptors  
```bash  
exec 3>&- # Closes fd 3
```
Useful for explicitly releasing system resources.  

#### Redirecting Input from a File  
```bash  
exec 0< inputfile  
```
This redirects stdin to read from `inputfile`.  

#### Redirecting Output to a File  
```bash  
exec 1> outputfile  
```
Redirects stdout to `outputfile`, useful for logging or output capture.  


-----------------------------  
