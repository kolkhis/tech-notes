

# Using `trap` for Error Handling, Debugging, & Other Behavior

Syntax:
```bash
trap [action] [signal(s)]
```

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


All Signals have numeric representations along with the "symbolic names" given to them:
* `SIGHUP (1)`: Hangup detected on controlling terminal or death of controlling process.  
* `SIGINT (2)`: Interrupt from keyboard (Ctrl+C).  
* `SIGQUIT (3)`: Quit from keyboard.  
* `SIGILL (4)`: Illegal Instruction.  
* `SIGABRT (6)`: Abort signal from abort system call.  
* `SIGFPE (8)`: Floating-point exception.  
* `SIGKILL (9)`: Kill signal.  
* `SIGSEGV (11)`: Invalid memory reference.  
* `SIGPIPE (13)`: Broken pipe: write to pipe with no readers.  
* `SIGALRM (14)`: Timer signal from alarm system call.  
* `SIGTERM (15)`: Termination signal.  
* `SIGUSR1 (10) and SIGUSR2 (12)`: User-defined signals.  

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


## Use Cases and Examples for `trap`
1. Cleanup on Script Exit
To clean up files used in the script when 
the `EXIT` signal (0) is encountered:
```bash
trap "rm -f /tmp/tmpfile; echo 'Cleanup performed';" EXIT
```
  
2. Handling Interruptions
If you want to handle user interruptions (like `CTRL-C`), 
you can use `trap` on `SIGINT`:
```bash
trap "echo 'Script interrupted.'; exit 1" SIGINT
```

3. Handling Errors
Error handling in bash can be done with `trap`.  
Use the `trap` command on the `ERR` signal:
```bash
trap 'echo "An error has occurred. Exiting script..."; exit 1' ERR
```

4. Debugging
`trap` can also be used for debugging.  
The `DEBUG` signal is encountered every 
time a command is executed in the script.
```bash
trap 'echo "Command executed on line $LINENO"' DEBUG
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

## Resetting Traps and Signal Actions to Default
To reset the `trap` set on a signal, just call it again,
this time with no action, or a dash `-` where the action would go.
```bash
# Reset EXIT to default behavior
trap EXIT
trap - EXIT
```

