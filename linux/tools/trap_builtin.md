# `trap`

The `trap` builtin is used for error handling, debugging, and other behavior.  

See the [kill builtin](./kill.md) for more info on signal specs (`SIGSPEC`).

## Syntax and Basic Usage
You'll want to set your traps at the top of the script.  

### Syntax  
```bash  
trap [-lp] [[action] signal_spec(s)]  
```
You can optionally specify an action to take when the signal is triggered.  

Options:

* `-l`: Prints a list of signal names and their corresponding numbers.  
* `-p`: Displays the trap commands associated with each `SIGNAL_SPEC`
 
The return value (exit status) of the `trap` command is `0` unless
a `SIGSPEC` is invalid or an invalid option is given.  


### Usage

Anything inside the quotes will be executed when the signal is triggered.  
```bash
trap "rm -f ./tmpfile && printf 'Trap triggered.\n'" SIGINT SIGTERM EXIT ERR
```
This will remove the file `./tmpfile` when the user presses Ctrl+C, Ctrl+D, or exits the script.  

- The `trap` is triggered when any of the `SIGNALS` are encountered.  
  The signals being `trap`ped here:
    - `SIGINT`: Interrupt (e.g., `^C`)
    - `SIGTERM`: Terminate (e.g., `kill`)
    - `EXIT`: Special signal in Bash. Any time the program exits.  
    - `ERR`: Special signal in Bash.  

---

### Trap Usage Example

An example, creating a FIFO pipe, using `tail -F` to write to that pipe, then 
backgrounding the process. We need to clean up the FIFO pipe and the background 
process when the script is exited so that `tail -F` doesn't turn into a zombie 
process, and to remove the unused FIFO pipe.  
```bash
trap 'kill $TAIL_PID; rm -f $logfile_fifo; exit;' SIGINT SIGTERM SIGHUP SIGILL SIGQUIT EXIT ERR
declare logfile_fifo="./logfile_fifo"
tail -F "$WATCH_FILE" >> "$logfile_fifo" &
declare TAIL_PID=$!
```

- That the `trap` command is using single quotes.

    - This is because we want the `$TAIL_PID` variable to expand when the
      trap is **triggered**, *not* when the trap is **defined**.  

    - Prefer single quotes when referencing variables that are not defined when
      you're defining the trap.  

- Each command in the `trap` string is delimited by a semicolon.  

    - This is how you run multiple commands in a single line.  


## Linux Signals Used with `trap`
```bash  
trap -l  
```
The above command **`-l`ists** all signals that Linux uses (also see `kill -l`).  

Some common signals are:  

* `SIGINT`: Signal interrupt, typically sent when the user presses Ctrl+C.  
* `SIGTERM`: Signal terminate, a request to gracefully terminate the process.  
* `EXIT`: Triggered when a script exits (0).  
* `ERR`: Triggered when a script command returns a non-zero exit status.  


All Signals have numeric representations (up to 64), along with the "symbolic names" given to them.  
Use `trap -l` for all of the linux-wide signals.  

Not an exhaustive list:  

|   **SIGNAL**     |      **TRIGGER**   |
|------------------|--------------------|
| `SIGHUP (1)`    | Hangup detected on controlling terminal or death of controlling process.  |
| `SIGINT (2)`    | Interrupt from keyboard (Ctrl+C).  |
| `SIGQUIT (3)`   | Quit from keyboard (`kill -SIGQUIT {PID}` command).  |
| `SIGILL (4)`    | Illegal Instruction.  |
| `SIGABRT (6)`   | Abort signal from abort system call.  |
| `SIGFPE (8)`    | Floating-point exception.  |
| `SIGKILL (9)`   | Kill signal.  |
| `SIGSEGV (11)`  | Invalid memory reference.  |
| `SIGPIPE (13)`  | Broken pipe: write to pipe with no readers.  |
| `SIGALRM (14)`  | Timer signal from alarm system call.  |
| `SIGTERM (15)`  | Termination signal (can be done with `kill -SIGTERM {PID}`).  |
| `SIGUSR1 (10) and SIGUSR2 (12)`| User-defined signals.  |

## Bash-specific Signals

Bash has four signals available that are not POSIX-compliant signals.  
These signals are really useful, as they can basically catch a number of different 
signals in a programmer-friendly way.  

They're technically "pseudo-signals" since they're not actually real signals. They
just kind of alias to a bundle of other signals.  

* ### `ERR`  

This pseudo-signal is trapped whenever a command in the script  
returns a non-zero exit status (indicating failure).  

It allows you to execute a specific action (e.g., cleanup or logging) when an error 
occurs in the script.  

> Use `set -o errtrace` (or `set -E`) if you want an `ERR` trap to apply to functions 
> and subshells as well.  

* ### `DEBUG`  

This is used to execute a command before every statement in a script or function.  
It's particularly useful for debugging purposes,
as it can provide detailed insight into the flow of execution.  

> Use `set -o functrace` if you want a `DEBUG` trap to apply to functions 
> and subshells as well.  

* ### `EXIT`  

This pseudo-signal is trapped when the script exits, either normally or through an 
unhandled signal.  
It's commonly used for cleanup actions that should occur regardless of how the script 
terminates.  

> The `EXIT` trap will also fire on `SIGINT` and errors when the shell 
> option `errexit` (`set -e`) is set.  

* ### `RETURN`  

Trapped when a shell function or a sourced script executes its last command.  
This allows actions to be taken just before the function or the sourced script completes.  

## Signals Available to the `kill` Command
The default signal for kill is TERM (`SIGTERM`).  
You can just run `kill -l` (or `-L`) to get the list of available signals.  
Too lazy? Here.  

|   1 - SIGHUP  | 2 - SIGINT | 3 - SIGQUIT | 4 - SIGILL | 5 - SIGTRAP |
|-|-|-|-|-|
|  6 - SIGABRT |  7 - SIGBUS |  8 - SIGFPE |  9 - SIGKILL | 10 - SIGUSR1|
| 11 - SIGSEGV | 12 - SIGUSR2 | 13 - SIGPIPE | 14 - SIGALRM | 15 - SIGTERM|
| 16 - SIGSTKFLT | 17 - SIGCHLD | 18 - SIGCONT | 19 - SIGSTOP | 20 - SIGTSTP|
| 21 - SIGTTIN | 22 - SIGTTOU | 23 - SIGURG | 24 - SIGXCPU | 25 - SIGXFSZ|
| 26 - SIGVTALRM | 27 - SIGPROF | 28 - SIGWINCH | 29 - SIGIO | 30 - SIGPWR|
| 31 - SIGSYS | 34 - SIGRTMIN | 35 - SIGRTMIN+1 | 36 - SIGRTMIN+2 | 37 - SIGRTMIN+3|
| 38 - SIGRTMIN+4 | 39 - SIGRTMIN+5 | 40 - SIGRTMIN+6 | 41 - SIGRTMIN+7 | 42 - SIGRTMIN+8|
| 43 - SIGRTMIN+9 | 44 - SIGRTMIN+10 | 45 - SIGRTMIN+11 | 46 - SIGRTMIN+12 | 47 - SIGRTMIN+13|
| 48 - SIGRTMIN+14 | 49 - SIGRTMIN+15 | 50 - SIGRTMAX-14 | 51 - SIGRTMAX-13 | 52 - SIGRTMAX-12|
| 53 - SIGRTMAX-11 | 54 - SIGRTMAX-10 | 55 - SIGRTMAX-9 | 56 - SIGRTMAX-8 | 57 - SIGRTMAX-7|
| 58 - SIGRTMAX-6 | 59 - SIGRTMAX-5 | 60 - SIGRTMAX-4 | 61 - SIGRTMAX-3 | 62 - SIGRTMAX-2|
| 63 - SIGRTMAX-1 | 64 - SIGRTMAX |

## Translating Signal to Name/Number

If you have the **number** of the signal, but you want the **name**, you can use
`kill -l` to list the name.  
```bash
kill -l 2
#       ^ the number of the signal you want the name of
# Output: INT
```

This will not print the `SIG` prefix. Here, the signal `2` is the `SIGINT` signal,
but only `INT` is printed.  

---

Alternatively, if you know the **name** of the signal and want to know the **number**
that it represents, you can do the same thing:

```bash
kill -l SIGINT
#            ^ The name of the signal you want the number for
# Output: 2
```

## Use Cases and Examples for `trap`

### Script Cleanup  
1. Cleanup on script exit:  
To clean up files used in the script when 
the `EXIT` signal (0) is encountered, usually
once the script is finished running:  
```bash  
trap "rm -f /tmp/tmpfile; echo 'Cleanup performed';" EXIT  
```
  
### Handling Interruptions  
2. Handling Script Interruptions:  
If you want to handle user interruptions (like `CTRL-C`), 
you can use `trap` on `SIGINT`:  
```bash  
trap "echo 'Script interrupted.'; exit 1" SIGINT  
```

### Handling Errors  
3. Handling Errors  
Error handling in bash can be done with `trap`.  
Use the `trap` command on the `ERR` signal:  
```bash  
trap 'echo "An error has occurred. Exiting script..."; exit 1' ERR  
```

### Debugging
4. Debugging Scripts or One-liners
`trap` can also be used for debugging.  
The `DEBUG` signal is encountered every 
time a command is executed in the script.  
```bash  
trap 'echo "Command executed on line $LINENO"' DEBUG  
```

## Check if a trap is set on a signal  
To see if a trap is set on a signal, use the `-p` (print trap) option.  
```bash  
trap -p SIGINT  
# or simply
trap
```
Using trap with no options does the same thing.  


To reset the signal to its untrapped, normal state, use
a hyphen `-` and the name of the trapped signal:  
```bash  
trap - SIGINT  
trap -p SIGINT  # Should not print anything  
```

## Managing Signals Inside Scripts (Handler Functions / Callback Functions)  
The `action` can be a bash/shell function, to be used as a callback for a trapped signal.  
```bash  
#!/bin/bash  
 
# Set callback for multiple signals  
trap graceful_shutdown SIGINT SIGQUIT SIGTERM  
 
graceful_shutdown() {
  echo -e "\nRemoving temporary file:" $temp_file  
  rm -rf "$temp_file"  
  exit  
}
 
temp_file=$(mktemp -p /tmp tmp.XXXXXXXXXX)  
echo "Created temp file:" $temp_file  
counter=0  
while true  
do 
  echo "Loop number:" $((++counter))  
  sleep 1  
done  
```





## Resetting Traps and Signal Actions to Default  
To reset the `trap` set on a signal, just call it again,
this time with no action, or a dash `-` where the action would go.  
```bash  
# Reset EXIT to default behavior  
trap EXIT  
trap - EXIT  
```




## Additional Notes on `trap`

* Multiple Traps  
    * You can set multiple `trap` commands for different signals in the same script.  
* Disabling a Trap  
    * To disable a trap, use an empty string as the action.  
        * For example, trap "" SIGINT will ignore Ctrl+C.  
* Scope  
    * trap commands affect the current shell and its child processes.  
    * They do not affect the parent shell or other scripts not sourced by the current script.  
```bash  
trap "" SIGINT   # Ignore C-c (^C). This is not the same as resetting.  
```

## Functions Inheriting Traps

There exist two shell options that you can enable to allow shell functions to inherit
traps.  

1. `-E` / `errtrace`
   ```bash
   set -E
   # or
   set -o errtrace
   ```

2. `-T` / `functrace`
   ```bash
   set -T
   # or
   set -o functrace
   ```

The `errtrace` shell option forces traps on the `ERR` signal to be inherited by shell
functions.  

Likewise, the `functrace` shell option forces traps on both the `DEBUG` and `RETURN`
signals to be inherited by shell functions.  


For example:
```bash
trap 'printf "Failed.\n"; exit 1' ERR
fail() {
    false
}
fail  # Won't trigger the trap
```
The `fail` function call will return an unnsuccessful result.  
If you call this function without `set -E`, it will not trigger the trap.  


So if we did the same thing with `set -E`, we'll get the intended behavior.  
```bash
trap 'printf "Failed.\n"; exit 1' ERR
set -E
fail() {
    false
}
fail  # Now the trap will be triggered
```

---

So use these options if you want your traps to behave in the same way when calling
shell functions as they do when invoking regular commands.  


## Resources  

* `man bash`
- `help set`
- `help trap`
* <https://www.howtogeek.com/814925/linux-signals-bash/>  
