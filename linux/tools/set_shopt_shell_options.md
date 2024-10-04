

# Shell Options & How to Set Them


## Table of Contents
* [`set`](#set) 
    * [`set` Options and Arguments](#set-options-and-arguments) 
    * [`set` Uses](#set-uses) 
* [`shopt`](#shopt) 
    * [`shopt` Options and Arguments](#shopt-options-and-arguments) 
    * [`shopt` Uses](#shopt-uses) 
* [Exhaustive List of Shell Options](#exhaustive-list-of-shell-options) 
    * [Shell options for `set`:](#shell-options-for-set) 
    * [Shell options for `shopt`](#shell-options-for-shopt) 
    * [Uses for Shell Options](#uses-for-shell-options) 


> `PAGER='less "+/^ *The list of shopt"' man bash`
> Opens the bash man page to the `shopt` options and descriptions.


* `shopt -p`: Display all settable options.


## `set`

The set built-in command is used to set or unset shell options and positional parameters. You can change a lot of behaviors of the shell using set.


### `set` Options and Arguments
* `set -o option`: Enables an option.
* `set +o option`: Disables an option.
* `set --`: Unsets all positional parameters.
* `set -`: Turns off -v and -x options, among others.
* `set -e`: Exit immediately if a command exits with a non-zero status.
* `set -u`: Treat unset variables as an error when substituting.
* `set -x`: Print commands and their arguments as they are executed.

### `set` Uses
* `set -e`: Useful in scripts where you want to ensure that errors stop the script.
* `set -u`: Good for debugging uninitialized variables.
* `set -x`: Helpful for debugging scripts.



## `shopt`

The shopt built-in allows you to change additional shell optional behavior. It's more flexible than set in some ways.

### `shopt` Options and Arguments
* `shopt -s option`: Enables an option.
* `shopt -u option`: Disables an option.
* `shopt -q`: Quiet mode. Nothing is output.

### `shopt` Uses
* `shopt -s nullglob`: Useful when you want patterns that could match filenames
                       to expand to an empty string when no filenames match.
* `shopt -s dotglob`: Useful when you want patterns to include files that start with a dot (.).



## Exhaustive List of Shell Options

### Shell options for `set`:
* `-e`: Exit on error.
* `-f`: Disable filename expansion.
* `-H`: Enable ! style history substitution.
* `-u`: Treat unset variables as an error.
* `-x`: Debug mode.

### Shell options for `shopt` 
* `cdspell`: Autocorrects minor spelling errors in a cd command.
* `checkhash`: Checks that commands found in hash tables exist.
* `cmdhist`: Save multi-line commands in the history as a single line.
* `dotglob`: Includes dot files in pathname expansion.
* `extglob`: Enables extended pattern matching.
* `nullglob`: Allows patterns to return a null string if no match is found.

### Uses for Shell Options
* `set -e`: Use in scripts where you want to catch errors.
* `shopt -s nullglob`: Use in scripts where you want to handle cases where a glob doesn't match any filenames.




