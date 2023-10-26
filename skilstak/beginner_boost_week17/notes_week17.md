
# 2023 Beginner Boost - Week 17


## Basic Programming

Specifically, procedural programming
We'll use POSIX shell and bash as our first programming language (as odd as that sounds).

> This is basically because when learning how to use bash and the command line, you're already
> programming.


`entr bash -c './hello' <<< ./hello `
`entr bash -c shellcheck ./hello <<< ./hello`
This runs:
    bash -c './hello'

`entr bash -c "clear; shellcheck ./hello; echo Output:; ./hello" <<< ./hello`

Every time the file changes

delimiter: The character that's separating things
field: The stuff that's being separated

##### AWESOME TIP
> Putting a space at the front of a command on the command line will make it not show up in your
> history.

##### Adding SSH remote to a Git repo
```sh
git init
git remote add origin git@github.com:kolkhis/<repo-name>.git
```

##### POSIX shell shebang
`#!/bin/sh`

##### bash shell shebang
`#!/bin/bash`



#### Carriage Return / Line Feed
Carriage Return moves the char back to the beginning of line.
Line Feed creates a new line and moves to it.

Most programming languages only use a Line Feed (\n)
Linux systems only use Line Feed, while Windows uses Carriage Return + Line Feed


Using `printf` will recognize escape sequences (no \n at EOF.)
Using `echo -e` will force it to recognize escape sequences



### Arguments / Variables

Environment variables (or system variables) are variables that are shared among all scripts.
    - Environment variables are the Core way of passing specific customizations of Containers/Cloud Apps

`env` - Shows your environment variables

`echo $USER`
`echo $PWD`

`printf "Hello %s! \n %s" "$USER" "How are you?"`

Local varibles: varibles defined from within the script
Environment varibles: variables pulled from `env`
Argument variables: variables pulled from space-delimited arguments passed in on the CLI


#### QUOTE YOUR VARIABLES
If you don't quote your variables, they are subject to injection attacks.

#### Injection:
Pulling environment variables in a script without using quotes is risky.
The variables could be reassigned by someone:

```sh
export USER="; echo 'someone else';"
```

This is called a "shell injection attack."


### Passing Data and Variables Into a Script From Outside

`man bash`
`/parameters`

Multiple ways to pass data into a program/script:

1. Environment variables
2. Arguments/parameters
3. Reading from stdin (standard input)
4. Open a file and read it
5. Load it from a web page


Parameters are generally the settings in which you want to operate
Sometimes used synonymously with the arguments passed in

Parameters are placeholders, arguments are what go into the parameters.


Positional parameters
These are pulled from the space-delimited arguments passed in on the command line.
They can be accessed with `$1`, `$2`, etc

Any positional parameters greater than 9 require braces: `"${11}"`

#### Standard for getting named variables

The standard for named variables is by using brackets:
```sh
user="Myself"
printf "Hello ${user}!"
```




























Special Parameters
   The shell treats several parameters specially.  These parameters may only be referenced; assignment to them is not allowed.
   *      Expands to the positional parameters, starting from one.  When the expansion is not within double quotes, each positional parameter expands to a separate word.  In contexts where it is per‐
          formed, those words are subject to further word splitting and pathname expansion.  When the expansion occurs within double quotes, it expands to a single word with the value of each parame‐
          ter  separated  by  the first character of the IFS special variable.  That is, "$*" is equivalent to "$1c$2c...", where c is the first character of the value of the IFS variable.  If IFS is
          unset, the parameters are separated by spaces.  If IFS is null, the parameters are joined without intervening separators.
   @      Expands to the positional parameters, starting from one.  In contexts where word splitting is performed, this expands each positional parameter to a separate  word;  if  not  within  double
          quotes,  these  words  are  subject to word splitting.  In contexts where word splitting is not performed, this expands to a single word with each positional parameter separated by a space.
          When the expansion occurs within double quotes, each parameter expands to a separate word.  That is, "$@" is equivalent to "$1" "$2" ...  If the  double-quoted  expansion  occurs  within  a
          word, the expansion of the first parameter is joined with the beginning part of the original word, and the expansion of the last parameter is joined with the last part of the original word.
          When there are no positional parameters, "$@" and $@ expand to nothing (i.e., they are removed).
   #      Expands to the number of positional parameters in decimal.
   ?      Expands to the exit status of the most recently executed foreground pipeline.
   -      Expands to the current option flags as specified upon invocation, by the set builtin command, or those set by the shell itself (such as the -i option).
   $      Expands to the process ID of the shell.  In a () subshell, it expands to the process ID of the current shell, not the subshell.
   !      Expands to the process ID of the job most recently placed into the background, whether executed as an asynchronous command or using the bg builtin (see JOB CONTROL below).
   0      Expands to the name of the shell or shell script.  This is set at shell initialization.  If bash is invoked with a file of commands, $0 is set to the name of that file.  If bash is  started
          with  the -c option, then $0 is set to the first argument after the string to be executed, if one is present.  Otherwise, it is set to the filename used to invoke bash, as given by argument
          zero.























### Talking about weekly coding sessions

* Python
    - configuration management
    - data focused apps
    - AI model creation

* HTML/CSS/Javascript
    - Static site generator


### Job Security
Operations, cloud native, security: No downturn in the job market.



## USE THIS OFTEN:
`type <file/cmd>`

`type` is preferred over `which`:
`which <file/cmd>`



