
# Beginner Boost Week 18  

## Procedural Programming  

Procedural Programming  
Follows a top-down approach.  
How does procedural programmiong differ from other forms of programming?  

1. Modularity  
1. Control Flow  
1. Data and Logic Separation  
1. Limited Code Reusability: Not OOP - no classes etc.  



-----------------------------------------------------------------------------------------  

## Difference Between a Procedure and a Function  

What is the difference between a function and a procedure?  
Buth are types of subroutines or subprograms in computer programming, but they have some key  
differences.  

#### Procedure  
Procedures can have zero or more input or output arguments, but they do not produce a result that  
can be used further in an expression.  
Typically used to perform actions or manipulate data within a program.  
Example: A procedure that displays a message on the screen but does not return anything.  

#### Function  
Takes things in, puts things out. 
Alwyas returns a value.  
Example: A function that calculates the sum of two numbers and returns the reult.  

> "A true function does not look at anything outside of itself" - Rob 2023

#### tl;dr:  
A procedure does not return anything. A function does have a return.  


* In Python, a script is itself a procedure.  
* In every single thing that turns into an executable, each has a procedure or function in it.  

-----------------------------------------------------------------------------------------  


## FIRST PROCEDURE  

* Make a program that says hello.  
* It should use the first argument as the name.  


The following is itself a procedure:  
```bash  
#!/bin/sh  

date  
echo Hello there  
```


This is also a "procedure", but it is called a function.  
```bash  
#!/bin/sh  

# file: ./greet  

# if using bash, you can use `function main()`. This is not POSIX-compliant.  
main() {
    date  # Easy way to timestamp  
    echo Hello 'arg1:' "$1" 'arg2:' "$2"  
}

main "$@"  # This will pass in any command line arguments into `main()`

```


## Parameters  
The `$@` passes the exact same arguments that were passed to the program, in the same way. Keeps the arguments separate.  
The `$*` combines all of the arguments into a single string. Each arg is separated by a space in the string.  

"$@" = "$1" "$2" "$3" # etc..  
"$*" = "$1 $2 $3" # etc.. 

```bash  

main "$@" # greet 
```
`greet "Kol" "khis"`  
will output:   
`Hello arg1: Kol arg2: khis`  

```bash  
main "$*" # greet  
```
`greet "Kol" "khis"`  
will output:   
`Hello arg1: Kol khis arg2: ''`  

After bash runs something, it'll be hashed. If removed and `type <program_name>` says it is hashed,
it can be fixed with `exec bash -l`.  
* `exec` is the preferred way to hand off the current shell to another process.  
* `exec bash -l` - The `-l` makes bash act like a login shell.  
* This will reload shell as if you had just logged in (for .bash* reloads)  

### Hashed Files  
`man 1 hash`  
`man 3 hash`  
To rehash a file, it can me done with `hash -r`.  
Or force shell to not remember hashed executables.  


#### Shell/Bash is not the language to write large projects in.  
It's not good at writing enterprise software.  


## Return Values  

Every program has return value.  
- Anything that runs as an action, command, function, etc., has a return value.  

Anything that runs from the command line returns `0` (success) or `<non-zero>` (not success).  
That value is stored in a special variable: `$?`
The `$?` variable will alwyas contain the exit code of the LAST COMMAND that was run.  

A lot of times `$?` will check a command that calls another command, so that needs to be taken into  
account. Shellcheck will point out these situations.  


#### Bash booleans are the POLAR OPPOSITE of most other languages  
In Bash, `false=1`, and `true=0`,
whereas in most other programming languages, `false=0` and `true=1`

##### Other lanauges where true=0 and false=1  
* SQL  
* Perl  





## Keep your script portable  
Do not put dependencies in your shell scripts!  
If you have dependencies, make it a compiled Go program.  
If your script is more than 100 lines long, write it in a different language.  

#### NOTE: Parentheses are not used when calling functions in bash.  
Example:  
```bash  
rfcdate() {
    date --rfc-3339 seconds  
}

rfcdate  
```
Attempting to call this function with `rfcdate()` will result in an error.  

-----------------------------------------------------------------------------------------  

## How to Re-run script whenever it is changed  

#### Using entr  
The `entr` program will rerun a program each time the given file is changed.  
```bash  
entr bash -c "clear; ./my_script" <<< my_script  
```
<<< means: Take this single line and send it to stdin as if it was a file  

#### Using `watch`
Another option is `watch`. This will (by default) run the given command every 2 seconds.  
It will clear the screen for each iteration, so there's no need to put a `clear;` in.  
```bash  
watch "./my_script"  
```
`man watch`

#### Infinite Loop (use the above options instead, if available.)  
A noob option is to use a loop (poor man's `watch`).  
```bash  
while true; do ./my_script; sleep 1; done  
```
This will run the script every second. 
If you do this, REMEMBER TO USE `sleep`!!!!!!!!  

-----------------------------------------------------------------------------------------  




## Send an entire file to `shfmt` from within Vim  

Hit `gg` to go to the top of the file, at the first line, and use the command:  
```viml  
:.,$! shfmt  
```
This will send the current line (`.`) until the end of the file.  
`:h :range!`

Another option is to visually select the whole file and do:  
```viml 
:'<,'>!shfmt %  
```

### Configuring `shfmt`
You can create a configuration file named `.editorconfig` in the root directory of the project, or  
a global `.editorconfig` placed in `~` or `~/.config/`

-----------------------------------------------------------------------------------------  

### `help` vs `man`
If you can't find a man page for a command, try `help <cmd>`. This will be available for shell builtins.  
`help` takes apart the man page for `bash`, and just shows the section for that one command.  
This will only be availble to builtins. (`man builtins` for more information on builtins.)  

```bash  
man command  
> no manual entry for command  
help command  
[displays the 'command' section in the bash man page]  
```
#### `command` vs `type` vs `which`
`which <cmd>` returns the binary that is used when `<cmd>` is executed.  
`type <cmd>` returns a detailed string of the binary `<cmd>` uses, OR the alias if `<cmd>` is aliased.  
`command -v <cmd>` will show which executable is being used for `<cmd>`, or it will show the alias if `<cmd>` is aliased.  
`command -V <cmd>` will output the same thing as `type`

## How to Use a Program Instead of Alias  
If a command is aliased, you can use the original un-aliased version of a command with a backslash.  
alias clear="echo HA no clear for you!"  
`\clear`
^ This will run clear even though it is aliased.  

-----------------------------------------------------------------------------------------  

## Key Takeaways:  

#### Bash booleans are the POLAR OPPOSITE of most other languages  
In Bash, `false=1`, and `true=0`, whereas in most other programming languages, `false=0` and `true=1`

Lanuages that use this convention:  
* Bash  
* SQL (some dialects. modern dbs have dedicated Boolean datatypes.)  


## Related  
[Google Shell Coding Style Guide](https://google.github.io/styleguide/shellguide.html)  
Program called "watch"  
Procedural Programming vs. Functional Programming vs. Object-oriented Programming  
Google Shell Coding Style Guidelines / Shell Style Guide  


## Questions to Ask  

> "The sooner that you learn to separate your code into functions and procedures, and NEVER MIX THE TWO, the better you will be."  
* What do you mean by never mixing the two? Are you saying that one program should not contain both functions and procedures? Like if I'm writing a program that has functions, I shouldn't also make procedures?  


