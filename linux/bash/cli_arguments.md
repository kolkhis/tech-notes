# Parsing Command Line Arguments


## Table of Contents
* [The `shift` Command](#the-shift-command) 
* [Getting CLI Options, Arguments, and Flags](#getting-cli-options-arguments-and-flags) 
* [Flags that take a value](#flags-that-take-a-value) 
* [Using `getopts`](#using-getopts) 
    * [`getopts` Leading Colon vs No Leading Colon](#getopts-leading-colon-vs-no-leading-colon) 
        * [No Leading Colon](#no-leading-colon) 
        * [Leading Colon](#leading-colon) 
        * [`getopts` Example: Unknown Option (`?` case)](#getopts-example-unknown-option--case) 
        * [`getopts` Example: Missing Argument for a Valid Option (`:` case)](#getopts-example-missing-argument-for-a-valid-option--case) 

## The `shift` Command  

Processing CLI arguments is best done using a `switch`/`case` in a `while` loop.  

* The `shift` command will remove the first argument from the list.  
* This will mean the **next** argument is now in `$1`.  
* All the remaining arguments will be shifted from `$n` to `$n-1`.  
    * `$2` becomes `$1`, `$3` becomes `$2`, and so on.  

## Getting CLI Options, Arguments, and Flags  

1. Use a `while` loop to loop over the arguments.  
   ```bash  
       while [[ "$1" ]]; do  
           echo "Code to process the arguments..."  
           # Now move on to the next argument:  
           shift 
       done  
   ```

    * The `shift` command will remove the first argument from the list.  
    * This will mean the **next** argument is now in `$1`.  
    * All the remaining arguments will be shifted from `$n` to `$n-1`.  


2. Use the regex comparison operator `=~` to check if the argument starts with a dash `-`.  
   ```bash  
       while [[ "$1" =~ ^- ]];  do ...; done
   ```

3. Check that the argument isn't `--` on its own.  
   ```bash  
     while [[ "$1" =~ ^- && ! "$1" == "--" ]];  do ...; done
   ```

    * The `--` flag is used to indicate that all the arguments have been given.

4. If it does, use a `switch`/`case` to handle the flag  
   ```bash  
     while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do  
         case $1 in  
             (-v | -version)  
                 printf "%s\n" "$version";  
                 exit 0;
                 ;;  
   ```

5. Use `shift` to pop the argument off the argument list.  
    * This will mean the **next** argument is now in `$1`.  
    * All the remaining arguments will be shifted from `$n` to `$n-1`.  


```bash  
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
    case $1 in  
        -V | --version)  
            echo "$version";  
            exit;  
            ;;  
        -s | --string )  
            shift; 
            string=$1;  
            ;;  
        -v | --verbose-flag )  
            verbose=1;   
            shift;
            ;;  
    esac
done  

if [[ "$1" == '--' ]]; then  
    shift;  # Clean up the argument list 
fi  
```


## Flags that take a value  
If you have a flag that takes a value, use the `shift` command to get the value:  
```bash  
    case $1 in  
        -i | --input-file)  
            shift;  # Pop the -i or --input-file flag out of the argument list  
            INPUT_FILE="$1";  
            shift;  # Now pop the value out of the argument list  
            ;;  
```


## Using `getopts`

The `getopts` command is a Bash Builtin that is used to parse option 
arguments (`help getopts`).  

This is mainly used for short arguments, i.e., `-v`, `-h`, etc..

Every time `getopts` is called, the next option will be put into in the shell 
variable `$name` (defined in the call).

Basic usage:
```bash
while getopts "hvf:" opt; do
    case $opt in
    ...
```

- `"hvf:"`: Specifies valid options. 
    - `-h` and `-v` used as standalone options.
    - `-f filename` (the colon `:` tells `getopts` that it expects an argument)
        - The argument will be stored in the `OPTARG` variable.  



Example:
```bash
while getopts ":hf:v" opt; do
    case "$opt" in
        h) printf "Help requested\n"; exit 0 ;;
        f) filename="$OPTARG" ;;
        v) verbose=true ;;
        \?) printf >&2 "Invalid option: -%s\n" "$OPTARG" ;;
        :) printf >&2 "Option -%s requires an argument.\n" "$OPTARG" ;;
    esac
done
```

- `getopts ":hf:v"`: This means:
    - The leading colon `:` suppresses automatic error messages. With this, you need
      to perform error handling yourself. See [leading colon vs no leading
      colon](#getopts-leading-colon-vs-no-leading-colon)
    - `h`, `f`, and `v` are valid options.  
    - `f` has a colon, meaning it expects an argument.  
        - e.g., `-f filename.txt`
    - `h` and `v` don't have colons, so they're just flags.
- `opt` is the variable that holds the current option letter.
- `OPTARG` is an automatic variable that holds the argument for the option (if it has one).
    - `$OPTARG` will be empty if no argument is given ONLY if the option expects an
      argument.
    - If an argument does not exect a value, `$OPTARG` will hold the name of the
      option (e.g., `-h` will set `$OPTARG` to `h`).

A case switch is used in a `while` loop with `getopts`.  
There are 2 special cases that need to be accounted for:

1. `\?)`: This case catches unknown/invalid options.
    - This will always be triggered whenever invalid options are given, whether you have
      disabled error reporting (leading colon) or not.
2. `:)`: This is only triggered when both:
    - You have disabled error reporting with a leading colon in the optstring (e.g., `":f:h"`)
    - A required argument is missing.
      E.g.,:
      ```bash
      getopts ":f:h" opt
      ./script -f  # Missing filename
      ```
      This will trigger the `:` case.

### `getopts` Leading Colon vs No Leading Colon
Using a leading colon in the `optstring` with `getopts` disables builtin errors.  

This gives you more granular control over what happens when the script is invoked
improperly.  

---

#### No Leading Colon
- Without the leading colon `:`, if an unknown option is 
  passed (not in `optstring`, like `-z`), `getopts` will:
    - Print an error message to `stderr`
    - Set `$opt` to `?`
    - Set `$OPTARG` to the unknown option that was given (`z`)
- If a required **argument** is missing (liked `":f:"` in `optstring`, `./script -f` called 
  but no argument was given), it will:
    - Print an error message to `stderr`
    - Set `$opt` to `?`.  


---

#### Leading Colon
Starting your `optstring` with a colon will suppress default error messages, and it
will disable default error handling for missing arguments.  

```bash
getopts ":hf:v" opt
```
The first colon in this string tells `getopts` to let us handle errors ourselves.

- This requires the addition of a `:)` case, which is hit when a required argument is
  missing.
    - E.g., if `-f` did not have a `filename`, it would hit the `:` case.

When an unknown option is given, `OPTARG` will hold the option letter, and the `opt`
variable will be `?`.

#### `getopts` Example: Unknown Option (`?` case)

---

With a leading colon:
```bash
getopts ":f:h" opt
./script -z
```
This will set the variables as:

- `opt="?"`
- `OPTARG="z"`

So this is handled with the `\?` case:
```bash
case "$opt" in
    \?) 
        printf "Unknown option: -%s\n" "$OPTARG"
        ;;
```

---

Without a leading colon, the behavior is mostly the same.  
It's still handled with the `?` case, but the only difference is it will also print 
an error message.  


#### `getopts` Example: Missing Argument for a Valid Option (`:` case)
---
With a leading colon:
```bash
getopts ":f:h" opt
./script -f
```
This will set the variables as:

- `opt=":"`
- `OPTARG="f"`

So this is handled with the `:` case:
```bash
case "$opt" in
    :)
        printf "Missing argument for -%s\n" "$OPTARG"
        ;;
```

---

Without a leading colon:
```bash
getopts "f:h" opt
./script -f
```

This will set the variables to:

- `opt="?"`
- `OPTARG="f"`
- An error is also printed.

Without a leading colon, this will not call the `:` case.  

---

