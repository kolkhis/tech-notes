

# Shell Options & How to Set Them

> `PAGER='less "+/^ *The list of shopt"' man bash`
> Opens the bash man page to the `shopt` options and descriptions.



## `set`

The set built-in command is used to set or unset shell options and positional parameters. You can change a lot of behaviors of the shell using set.


### Options and Arguments
* `set -o option`: Enables an option.
* `set +o option`: Disables an option.
* `set --`: Unsets all positional parameters.
* `set -`: Turns off -v and -x options, among others.
* `set -e`: Exit immediately if a command exits with a non-zero status.
* `set -u`: Treat unset variables as an error when substituting.
* `set -x`: Print commands and their arguments as they are executed.

### Uses
* `set -e`: Useful in scripts where you want to ensure that errors stop the script.
* `set -u`: Good for debugging uninitialized variables.
* `set -x`: Helpful for debugging scripts.



## `shopt`

The shopt built-in allows you to change additional shell optional behavior. It's more flexible than set in some ways.

### Options and Arguments
* `shopt -s option`: Enables an option.
* `shopt -u option`: Disables an option.
* `shopt -p`: Display all settable options.
* `shopt -q`: Quiet mode. Nothing is output.

### Uses
* `shopt -s nullglob`: Useful when you want patterns that could match filenames to expand to an empty string when no filenames match.
* `shopt -s dotglob`: Useful when you want patterns to include files that start with a dot (.).



## Exhaustive List of Shell Options

### For set
* `-e`: Exit on error.
* `-f`: Disable filename expansion.
* `-H`: Enable ! style history substitution.
* `-u`: Treat unset variables as an error.
* `-x`: Debug mode.

### For shopt
* `cdspell`: Autocorrects minor spelling errors in a cd command.
* `checkhash`: Checks that commands found in hash tables exist.
* `cmdhist`: Save multi-line commands in the history as a single line.
* `dotglob`: Includes dot files in pathname expansion.
* `extglob`: Enables extended pattern matching.
* `nullglob`: Allows patterns to return a null string if no match is found.

### Uses for Shell Options
* `set -e`: Use in scripts where you want to catch errors.
* `shopt -s nullglob`: Use in scripts where you want to handle cases where a glob doesn't match any filenames.




