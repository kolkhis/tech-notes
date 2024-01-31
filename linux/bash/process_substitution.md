# Process Substitution  
`man bash; /Process Substitution`

* Note: Process substitution is not POSIX-compliant.  
    It's promarily supported in Bash and Zsh.  

## Process Substitution in Bash  
Process substitution is for treating command outputs as files.  
  
This is useful for using commands instead of files, where only  
files are accepted.  

## Overview  

* Process substitution is used to treat the output of a process  
  as a filename, which can then be passed to other commands.  
* This feature is available in Bash and other shells that support it, like Zsh.  

## Syntax  

* **`<(list)`**: This form is used when you want to treat the output of `list` as an input file. For example, `cat <(ls)` will execute `ls` and then `cat` the output as if it were a file.  
* **`>(list)`**: This form is for treating the input to the process as an output file. For example, `echo "Hello" > >(cat)` will pass "Hello" to `cat` as its input.  

## How It Works  

* Bash replaces each `>(list)` and `<(list)` with a filename.  
    * This filename points to a FIFO (named pipe), or a file 
      in `/dev/fd` that is connected to standard input (stdin) or  
      output of the `list` process.  
* The `list` process is executed asynchronously, meaning the 
  main command and `list` can run at the same time.  

## Examples  

1. **Comparing Two Dynamic Sets of Data**  
    ```bash  
    diff <(ls dir1) <(ls dir2)  
    ```
    * This command compares the output of `ls` in two different directories.

2. **Passing Dynamic Input to a Command**
    ```bash
    cat > >(grep "pattern")
    ```
    * This sets up a `grep` process that will receive input from `cat`.

`<(list)` and `>(list)` can be used in any context where a filename is expected.
For example, you can use them in a loop.

```bash
#  <(list)
wc -l < <(for i in {1..5}; do printf "asdf: %d\n" "$i"; done;)
# output: 5
wc -l <(for i in {1..5}; do printf "asdf: %d\n" "$i"; done;)
# output: 5 /dev/fd/63

file <(for i in {1..5}; do printf "asdf: %d\n" "$i"; done;)
# outputs: /dev/fd/63: symbolic link to pipe:[16626856]


#  >(list)
for i in {1..5}; do printf "asdf: %d\n" "$i"; done > >(wc -l)
# output:
# 5

for i in {1..5}; do printf "asdf: %d\n" "$i"; done; >(wc -l)
# output:
# asdf: 1
# asdf: 2
# asdf: 3
# asdf: 4
# asdf: 5
# -bash: /dev/fd/63: Permission denied

file >(wc -l)
/dev/fd/63: symbolic link to pipe:[16644073]
0

```

Or, for `>(list)`, you can use it to write the output of a command to a file.
```bash
echo "Hello" > >(cat)
```


### Process Substitution Mechanism

When you use process substitution in Bash with `>(list)` or `<(list)`, Bash
does something quite clever:

1.  **Creates a Pipe or File Descriptor**
    * For both `>(list)` and `<(list)`, Bash sets up a special kind of file known 
      as a FIFO (First In, First Out) named pipe, or it uses a file descriptor 
      in `/dev/fd`.
    * A pipe is like a temporary file that acts as a buffer for data between processes.

2.  **Substitutes with a Filename**
    * Bash then replaces the `>(list)` or `<(list)` expression in your command 
      with a filename.
        * This filename is not a regular file but a reference to the pipe or
          file descriptor it created.
    * This allows the rest of your command to interact with this filename as if it was a regular file.

3.  **Connects to the Process (`list`)**
    * The created pipe or file descriptor is connected to the standard 
      input (stdin) or output (stdout) of the process you specified in `list`.
    * For `>(list)`, the pipe/file descriptor is connected to the stdin of `list`.
    * For `<(list)`, it's connected to the stdout of `list`.



## Process Substitution Examples

## Examples of `<(list)`
You have a command that generates some data, and you want
to pass this data, as a *file*, to another command as input.

### Comparing the Contents of Two Directories
```bash
diff <(ls dir1) <(ls dir2)
```

1. Bash executes `ls dir1` and `ls dir2` and directs their outputs
   to two pipes (or file descriptors).
2. It then replaces `<(ls dir1)` and `<(ls dir2)` with filenames that
   represent these pipes.
3. `diff` then reads from these filenames as if they were regular files
   containing the output of the `ls` commands.

* Merging Two Files Side-by-Side
```bash
paste -d "\n" <(cat file1.txt) <(cat file2.txt) > merged.txt
```
1. Combines `file1.txt` and `file2.txt` side-by-side into `merged.txt`.
    * This is useful for comparing or merging files line by line.

### Filtering Log Files
```bash
grep ERROR <(zcat /var/log/app.log.gz)
```
1. If you have compressed log files (like `.gz` files), this command lets
   you grep them directly without manual decompression.
    * `zcat` is identical to `gunzip -c`
    * `zcat` uncompresses either a list of files on the command line or its
      standard input and writes the uncompressed data on standard output.



## Examples of `>(list)`

`>(list)` is used to direct the output of a command into another
command as its input.
This treats the output of the first command as a file, rather than
the command inside the parentheses.

You have a command that generates some data, and you want
to pass this data directly to another command for further 
handling.

### Transforming a String to All Caps
 
```bash
echo "Hello, world" > >(tr 'a-z' 'A-Z')
```
 
* Here, `echo "Hello, world"` generates a string.
* `>(tr 'a-z' 'A-Z')` sets up a process substitution.
* The output of `echo`, which is `"Hello, world"`, is directed to
  the `tr` command (translate command) 
* This uses the named pipe or file descriptor created by `>(...)` to pass 
  the input to `tr`.
* `tr 'a-z' 'A-Z'` then converts this input to uppercase.
* The final output will be "HELLO, WORLD".


### Logging and Displaying Output
 
```bash
printf "Application started at: %s\n" "$(date)" | tee >(logger -t myapp)
```
* This command writes a log message to both the standard output and the system logger.
  It's useful for logging and monitoring.
    * `logger` is a command that writes to the system log.
    * The system log can be accessed using the `journalctl` command.
        * i.e.,
          ```bash
          journalctl -t myapp
          ```

### Real-time Processing of Command Output
 
```bash
cat /var/log/syslog | grep --line-buffered "CRON" > >(notify-send -t 10000 "Cron Alert")
```
* This command monitors the syslog for CRON entries 
  and sends desktop notifications in real-time for each match.
* Great for real-time monitoring of logs.


### Transcoding a Video File
 
```bash
ffmpeg -i input.mp4 >(x264 -o output.mkv -)
```
* In this example, `ffmpeg` reads a video file and pipes the output 
  to `x264` for transcoding.
* It's useful for video processing.





### In Plain English

* **`<(list)`**
    * Think of this as creating a temporary file that contains the output of `list`.
    * Your command then reads from this temporary file.
* **`>(list)`**
    * Imagine this as directing the output of your *last* command into a temporary file, which is then used as input for `list`.









## Limitations

* **Portability**
    * Process substitution is not POSIX-compliant, so it might
      not work in all Unix-like shells.
    * It's primarily supported in Bash and Zsh.
* **Filesystem Support**
    * It requires support for named pipes (FIFOs) or `/dev/fd`.
* **Read or Write, Not Both**
    * Each instance of process substitution can be used either for reading or 
      writing, but not both simultaneously.
