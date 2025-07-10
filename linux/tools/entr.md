# `entr`

---

`entr` is a tool available on Debian-based systems. 
It's used for running arbitraty commands when a file is changed.  

This tool is not available in the default RedHat repositories. To get similar
functionality on RedHat-based systems, look into [`inotify-tools`](./inotify-tools.md), 
specifically `inotifywait`.  

> Note: If you're looking to use `entr` on a logfile to monitor for new logs or
> changes, you might want `tail -F` instead.  


## Using `entr` with a single file  

`entr` expects the path of a file (or list of files) as standard input. 
This can be done with redirection `<` or with a pipe `|`.  

* The `realpath` command can be used to get the absolute path of a file if needed.  

The `entr` program can rerun a program each time the given file is changed (written).  
```bash  
entr bash -c "clear; ./my_script" <<< my_script  
```

* This tells `entr` to run `bash -c "clear; ./my_script"` each time `my_script` is changed.  
    * Clears the screen, and then runs the file `./my_script`.  
* `<<<` is a `herestring` operator (bash-only).  
    * It allows a string to be used as the standard input to a command.  
    * It means "take this string and send it to `stdin` as if it were a file."  
    * Not POSIX-compliant.  

* Alternatively, for a POSIX-compliant solution, pipe the output of an `ls` or `find` 
  command to `entr`.  
  ```bash
  find . -type f -name 'my_script' | entr bash -c 'clear; ./my_script'
  ```

* Another alternative would be using [process substitution](../bash/process_substitution.md), 
  using the `<()` syntax (bash-only).  
  ```bash
  entr bash -c "clear; ./my_script" < <(realpath ./my_script)
  ```

---  

To automatically clear the screen, use the `-c` flag for `entr` (`entr -c`).  
Then you don't have to call `clear;` in the command passed to `bash`.  
```bash  
entr -c bash -c "/tmp/t.sh;" < <(realpath /tmp/t.sh)  
# or  
realpath /tmp/t.sh | entr -c bash -c "/tmp/t.sh;"  
```

## Using `entr` with multiple files  
You can set `entr` to run a command when any file in a list of files changes.  
Pass in a list of files as input:  
```bash  
entr -c bash -c "./my_script" < <(find . -name '*.sh')  
```
This will run `./my_script` each time any file with a `.sh` extension  
in the current directory or any subdirectoriesis changed.  


### Example with Golang Project Testing  

```bash  
entr bash -c "clear; go test -v ./..." < <(find . -name '*.go')  
 
# Or, with globstar enabled:  
entr bash -c "clear; go test -v ./..." < <(ls **/*.go) 
```
The syntax `./...` is Go's way of saying "all packages in the current directory  
and subdirectories."  



## Other ways to automate  
### Using `watch`
Another option is `watch`.  
This will (by default) run the given command every 2 seconds.  
It will clear the screen for each iteration, so there's no need to put a `clear;` in.  
```bash  
watch "./my_script"  
```
`man watch`


### Infinite Loop (Generally a Bad Idea)  
A noob option is to use a loop (poor man's `watch`).  
```bash  
while true; do ./my_script; sleep 1; done  
```
This will run the script every second.  
If you do this, remember to use `sleep`!  


