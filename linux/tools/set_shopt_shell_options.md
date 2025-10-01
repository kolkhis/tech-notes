# Shell Options

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

Some shell options have shorthands that can be used (e.g., `set -e` instead of
`set -o errexit`).  

* `set -e`: Exit immediately if a command exits with a non-zero status.
    - Same as `set -o errexit`
* `set -u`: Treat unset variables as an error when substituting.
    - Same as `set -o nounset`
* `set -o pipefail`: If any command in a pipeline fails, the whole pipeline fails.  
    - Failure in this case is any non-zero exit status.  
* `set -x`: Print commands and their arguments as they are executed.
    - Usually used for debugging purposes.  
* `set -o vi`: Use vi keybindings for regular command-line interactions.  

### `set` Uses

* `set -e`: Useful in scripts where you want to ensure that errors stop the script.
* `set -u`: Good for debugging uninitialized variables.
* `set -x`: Helpful for debugging scripts.


## `shopt`

The shopt built-in allows you to change additional shell optional behavior. It's more flexible than set in some ways.

### `shopt` Options and Arguments

* `shopt -s option`: Enables (`-s`ets) an option.
* `shopt -u option`: Disables (`-u`nsets) an option.
* `shopt -q`: Quiet mode. Nothing is output.
    - Can be used to check if an option is set. It will return zero if all
      options are set, and non-zero if there are any that are unset.  

### `shopt` Uses

* `shopt -s nullglob`: Useful when you want patterns that could match filenames
                       to expand to an empty string when no filenames match.
* `shopt -s dotglob`: Useful when you want patterns to include files that start with a dot (.).



## Non-Exhaustive List of Shell Options

### Shell options for `set`

* `-e`, `errexit`: Exit on error.
* `-f`, `noglob`: Disable filename expansion.
* `-H`, `histexpand`: Enable `!` style history substitution.
* `-u`, `nounset`: Treat unset variables as an error.
* `-x`, `xtrace`: Debug mode.
- `-o`: Specify a named option.  

Run `help set` for a full list.  

### Shell options for `shopt` 

* `cdspell`: Autocorrects minor spelling errors in a cd command.
* `checkhash`: Checks that commands found in hash tables exist.
* `cmdhist`: Save multi-line commands in the history as a single line.
* `dotglob`: Includes dot files in pathname expansion.
* `extglob`: Enables extended pattern matching.
* `nullglob`: Allows patterns to return a null string if no match is found.

Check `man bash` for a full list under the `SHELL BUILTIN COMMANDS` section.  




