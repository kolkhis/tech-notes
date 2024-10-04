

# Run Processes in the Background  



## Table of Contents
* [Background Processes with `&`](#background-processes-with-) 
* [Directing Output of Background Processes](#directing-output-of-background-processes) 
* [Backgrounding Subshells and Subshell Commands](#backgrounding-subshells-and-subshell-commands) 
    * [Using `&` with Subshells (Inside vs. Outside)](#using--with-subshells-inside-vs-outside) 
    * [`&` Inside the Subshell `(command &)`](#-inside-the-subshell-command-) 
        * [Scope of Background Process](#scope-of-background-process) 
        * [Subshell Environment](#subshell-environment) 
        * [Immediate Return](#immediate-return) 
    * [`&` Outside the Subshell `(command) &`](#-outside-the-subshell-command-) 
        * [Entire Subshell in Background](#entire-subshell-in-background) 
        * [Parent Script Continuation](#parent-script-continuation) 
        * [Subshell Benefits](#subshell-benefits) 
* [Using `nohup`](#using-nohup) 


## Background Processes with `&`
 
You can background any process by appending `&` to the end.  
Using `&` to background a process:
```bash  
ping 127.0.0.1 &  
```
This will direct `stdout` to the current shell, but the process will  
run in the background.

This is useful if you want to run a process in the current  
shell but also free it up to run other commands.  
 
To stop the process, you can use `fg` to bring it back to the 
foreground, then `^C` will stop it.
 
Alternatively, use `ps` to find its `PID` (Process ID), then use `kill <PID>`

## Directing Output of Background Processes
##### See the [bash hacker's redirection guide](https://web.archive.org/web/20230315225157/https://wiki.bash-hackers.org/howto/redirection_tutorial).  
If you don't want to see the output of a background process 
in your current shell, you can redirect it:
```bash
{ some_command & } > /dev/null 2>&1
```
* This redirects both `stdout` and `stderr` to `/dev/null` (trash can).  
* It's used in a command group to allow the `&` syntax to be used.  

```bash
mkfifo /tmp/temp_pipe
{ some_command & } > /tmp/temp_pipe 2>&1
```
* This redirects the output to a named pipe, which can be read by another process.  


## Backgrounding Subshells and Subshell Commands
You can background subshells, or commands within subshells, the same way
as other processes with `&`.
 
### Using `&` with Subshells (Inside vs. Outside) 

* Inside `(command &)`: Only puts the commands within the subshell in the background.
* Outside `(command) &`: Puts the entire subshell in the background.  
 
Both approaches effectively run the commands in the background.  
 
The placement of `&` inside or outside the subshell can influence
how the background process is managed, and its relationship to the
parent shell.  
The distinction primarily affects how you think about the process grouping and management.  
 
In terms of readability and understanding:
* Placing `&` inside might suggest only the command is meant to run in the background.
* Placing it outside clearly indicates the entire set of 
  operations (the subshell) is intended to be backgrounded.


### `&` Inside the Subshell `(command &)`
 
#### Scope of Background Process
* When you place `&` inside the parentheses, it puts only the commands
  within the subshell in the background.  
* This is particularly useful if you want to group several commands
  together and run that group in the background.

#### Subshell Environment
* The commands inside the parentheses are executed in a subshell.
    * This means they have a separate execution environment from the parent shell.  
* Variables modified in the subshell do not affect the parent shell.

#### Immediate Return
* The parent script does not wait for the subshell to complete; it
  immediately continues to the next line of the script.


### `&` Outside the Subshell `(command) &`
 
#### Entire Subshell in Background
* Placing `&` outside the parentheses puts the entire subshell in the background.  
* This is similar to the above in practice but emphasizes that the subshell
  itself is being backgrounded.

#### Parent Script Continuation
* Similar to the above, the parent script continues execution without
  waiting for the background process to complete.

#### Subshell Benefits
* You still benefit from the isolated environment of the 
  subshell, where commands executed inside do not directly
  modify the environment of the parent shell.


---

## Using `nohup`

* `nohup` - run a command immune to hangups, with output to a non-tty  

This means that it will ignore the hangup signal, and will run in the background.  

If the program that you want background is a script, you can use  
the `nohup` command to run it in the background.  




