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
trap "rm -f ./tmpfile && printf \"Trap triggered!\" " SIGINT SIGTERM EXIT ERR
```
This will remove the file `./tmpfile` when the user presses Ctrl+C, Ctrl+D, or exits the script.  
 


## Linux Signals Used with `trap`
```bash  
trap -l  
```
The above command **`-l`ists** all signals that Linux uses.  

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

## Bash-specific Signals for Scripting and Error Handling  

* ### `ERR`  

This pseudo-signal is trapped whenever a command in the script  
returns a non-zero exit status (indicating failure).  
It allows you to execute a specific action, like cleanup or logging,
when an error occurs in the script.  

* ### `DEBUG`  

This is used to execute a command before every statement in a script or function.  
It's particularly useful for debugging purposes,
as it can provide detailed insight into the flow of execution.  

* ### `EXIT`  

This pseudo-signal is trapped when the script exits,
either normally or through an unhandled signal.  
It's commonly used for cleanup actions that should occur 
regardless of how the script terminates.  

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

## Getting a Signal from a Number
```bash
kill -l 11
#       ^ the number of the signal you want the name of
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

## Sources  

* `man bash`
* [HowToGeek](https://www.howtogeek.com/814925/linux-signals-bash/)  

