
# Beginner Boost Week 19


## Shell Conditionals
Shell is notoriously bad at keeping you safe from injection attacks.
* Shell conditionals allow for the use of parameter expansion.
* Parameter expansions are a common attack vector for shell injections.


## Bash Conditionals
DO NOT USE SINGLE BRACKETS IN BASH!!!
* Double brackets do not perform parameter expansions. This keeps it "immune" from injection attacks,
  since parameter expansions are not possible within the double brackets.
* Double brackets shut down a lot of the ways that injection attacks can happen using Bash.



### `if`/`elif`/`else` Statements
Conditionals in Shell use single brackets for conditionals.
POSIX:
```sh
if [ condition ]; then
    echo some stuff
elif [ other_condition ]; then
    echo other stuff
else 
    echo something else
fi
```

Conditional in Bash use double brackets for conditionals.
Bash:
```bash
if [[ condition ]]; then
    echo some stuff
elif [[ other_condition ]]; then
    echo other stuff
else 
    echo something else
fi
```

### Switch/Case
In shell/Go/C there is a "switch/case" conditional.
```sh
case $name in 
    "Lancelot") echo "Hello Lancelot";;
    "Robin")
        echo "Hello Robin";;
    "Arthur")
        echo "hello there arthur";
        echo "How ya doin";
        echo "Third line";;
    *)
        echo "I don't know your name"
```




## Getting User Input With `read`

You can get user input from stdin from a program called `read`
You should always use `read -r`. This prevents escape sequences.
```sh
read -r name
echo "You entered $name"
```

`read` is a shell builtin, use `help` to get info on it.
`help read`
`man read` will open the C standard library man file for `read`, `man(2)`
`man -f read` shows that this is the only page for `read`.

You can also make this non-interactive by redirecting from STDIN:
```sh
./bridgekeeper <<< Lancelot
```
The `read` command will take that text (Lancelot) as the input.


#### Don't make scripts interactive.
You may want to make scripts non-interactive by default.
It is generally a bad idea to make scripts interactive. 
They block the scripts waiting for user input.

General rule: DON'T BLOCK.
This means, DON'T PROMPT.


### Debugging Shell/Bash Code With `set -x`
`set -x` steps through the shell interpreter for a program and prints everything to STDOUT. This is
ideal for debugging. Near the top of your script, just put `set -x` and the interpreter steps will
be printed out.







### POSIX v BASH / `test` and `[` 
Shell uses commands, bash uses builtins.
Other flavors of shell do have some builtins as well.

`which test`
```bash
file /usr/bin/test
file `which test`
```

There is actually a file called `[`
```bash
which [
file `which [`
```
Owned by root, anyone can run it. It is a shell builtin.
```bash
type [
```

`sh` is just a symlink to `dash`, a POSIX-like shell.
```bash
file `which sh`
```

You can switch to `dash` by running `/bin/sh`
```sh
ls -l `which [`
ls -l `which test`
```
The `test` and `[` are NOT USED IN BASH. Unless you explicitly call `/usr/bin/[` or `/usr/bin/[`
They are ACTUAL commands. The `]` is actually an argument to the `[` command. This is why you need a
space before the closing bracket.

`test` - Used to check file types and compare values.


## Terminal Color
`termcolors` will print out the ANSII escape sequences (not a default program, custom script).
By saving the ANSII escape sequences to variables, they can be put in strings to change the colors
of the text.


### Disabling Shellcheck For a Script
To disable shellcheck, use this comment at the top of the file, below the shebang line:
```sh
# shellcheck disable=SC2059
```

### printf vs echo
`echo` will not use escapes by default. A newline is printed at the end.
`printf` will do escapes by default. No newline is printed at the end.



## Related
Tabs are "officially" the way to use shell.

Subprocess: a process that is running under the management of the parent program.

`apt-get` is not deprecated: It is to be used in scripts, whereas `apt` is for the end-user.

#### Ask GPT:
What are:
builtins
subprocesses
subshells
All of the differences between `echo` and `printf`

