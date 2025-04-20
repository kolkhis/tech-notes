# Programmable Bash Completion

You can extend the default bash autocompletion (or tab completion) in Bash.

## Writing a Completion Script

The process for writing bash completions utilizes `compgen` and `complete` (bash
builtins).
Important variables in this process:
- `COMP_WORDS`
- `COMP_CWORD`


```bash
_my_tool_completions() {
    local cur
    local prev
    local words
    local cword
    _init_completion -n = || return
    case "${prev}" in
        mytool)
            printf "The base command 'mytool'"
            COMPREPLY=( $(compgen -W "start stop status restart help" -- "$cur") )
            return
            ;;
        --mode)
            COMPREPLY=( $(compgen -W "verbose quiet debug" -- "$cur") )
            return
            ;;
    esac

    case "${cur}" in
        -*)
            COMPREPLY=( $(compgen -W "--help --version --mode" -- "$cur") )
            return
            ;;
    esac
}

# then register it as the completion function for 'mytool'
complete -F _my_tool_completions mytool

# then source this script to have it take effect
```
Test it by sourcing the file and trying completions with the command.  
Make it permanent by putting it in a file in `/etc/bash_completion.d` (or source it
in `.bashrc`).  

- `_init_completion`: Sets up common variables to use when writing a completion function.  
    - `-n =`: Don't split completion on `=` (like when you do `--option=value`)
    - When called it populates the variables:
        - `cur`: The word currently being typed (the partial input that's already there)
        - `prev`: The previous word.
        - `words`: All the words in the command line so far.
        - `cword`: The index of the current word.  

- `compgen -W "start stop status" -- "$cur"`: 
    - `-W`: Generates completion options based on the words given (a space-delimited list of possible completions).    
    - `-- "$cur"`: The partial input the user typed so far. This filters results.  

- `COMPREPLY`: An array of results to show
    - Use this to return suggestions.  


### Using `compgen`
Depending on the flags given to `compgen`, you can specify what it looks for when
offering completions.  

- `-W "list of words"`: Generate completions from the space-delimited list of words given as a single string.  
- `-f`: Use filenames for completions.
- `-d`: Use directory names for completions.
- `-A command`: Use all available command names in `PATH` for completions.  
- `-A function`: Use all defined shell function names for completions.  
- `-A alias`: Use all the aliase names currently set for completions.  

Some examples:
```bash
compgen -f -- "$cur"  # Complete filenames
compgen -d -- "$cur"  # Complete directories
compgen -A function -- "$cur"   # Complete shell functions
compgen -A command -- "$cur"    # Complete commands in PATH
```

### Using `complete`
You use `complete` to specify what should be used for completions for a given
command.  

- `complete -F func_name mycmd`: Use the function `func_name` to generate completions 
  for `mycmd`.  
- `complete -C command mycmd`: Use the command `command` to generate completions for `mycmd`.  
    - This is usually used for binary programs, not shell functions.  
- `complete -W wordlist mycmd`: Use the `wordlist` (static list of words) for completions.  
- `complete -A action mycmd`: Specifies a completion "action."   
  The `action` can be:
    - `command`: Command names from the `PATH`.  
    - `file`: File names.  
    - `directory`: Directory names.  
    - `user`: Usernames from `/etc/passwd`.  
    - `host`: Hostnames from `/etc/hosts`.  
    - `group`: Group names from `/etc/groups`.  
    - See full list at [actions supported by `complete -A`](#actions-supported-with-complete-a).  

- `complete ... mycmd -P prefix`: Add a prefix to every possible completion.  
   Used with other options.
  ```bash
  complete -W "prod dev stage" -P "--env=" mycmd 
  ```

- `complete ... mycmd -S suffix`: Add a suffix to every possible completion. 
   Used with other options.  
  ```bash
  complete -W "backup deploy" -S ".sh" mycmd 
  ```

You can use `-P` and `-S` together, too:
```bash
complete -W "alpha beta gamma" -P "--mode=" -S ";" mycmd
```
With this example, tab-completing `mycmd --mode=` gives:
* `--mode=alpha;`
* `--mode=beta;`
* `--mode=gamma;`



### Using `_init_completion`
This is a helper function that defines some variables that are used in generating
completions.  

* `_init_completion -n =`: Don't split completion on `=` (like when you do `--option=value`)

When `_init_completion` is called, it populates the variables:
- `cur`: The word currently being typed (the partial input that's already there)
- `prev`: The previous word.
- `words`: All the words in the command line so far.
- `cword`: The index of the current word.  
- An example: 
  ```bash
  mytool deploy --env pr[TAB]
  # cur="pr"
  # prev="--env"
  # words=(mytool deploy --env pr)
  # cword=3
  ```
  These are set automatically *only* with `_init_completion`.  

---

### Manual Variable Assignments (no `_init_completion`)
If you **don't** want to use `_init_completion`, there are other ways to do get the
values you need in order to produce completions.  

Without using `_init_completion`, these variables are made available by the shell:  
* `COMP_WORDS`: An array of all words typed so far.
* `COMP_CWORD`: Index of the word being completed.
* `COMP_LINE`: The full command line as a single string.
* `COMP_POINT`: Cursor position within COMP_LINE.

The `$cur` and `$prev` variables aren't predefined, but you can define them by 
using `COMP_WORDS` with `COMP_CWORD`:
```bash
cur="${COMP_WORDS[COMP_CWORD]}"
prev="${COMP_WORDS[COMP_CWORD-1]}"
```


## Where to put completions

To make bash completions permanent, add them to a file in `/etc/bash_completion.d/`

Or, if you just want the completion available to your user account, add them to your
`.bashrc` or other runtime config files.  

Ex: `/etc/bash_completion.d/some_tool`

---

### Completions for Packages

If you're making a package (`.deb` or otherwise), completions should go
in `/usr/share/bash-completion/completions`.  
This is just a convention. Putting them in `/etc/bash_completion.d` will still work.

The `bash-completion` package itself will never use the `/etc/bash_completion.d`
directory.  


For making Debian packages, you can use `dh_bash-completion` (a debhelper program) to
install completions. 
```bash
man dh_bash-completion
```
File should be `debian/package.bash-completion`.  


## Actions Supported with `complete -A`

* `complete -A alias`: Alias names. 
    - Same as `complete -a`.
* `complete -A arrayvar`: Array variable names.
* `complete -A binding`: Readline key binding names.
* `complete -A builtin`: Names of shell builtins. 
    - Same as `complete -b`.
* `complete -A command`: Command names found in the `$PATH`. 
    - Same as `complete -c`.
* `complete -A directory`: Directory names. 
    - Same as `complete -d`.
* `complete -A disabled`: Names of disabled shell builtins.
* `complete -A enabled`: Names of enabled shell builtins.
* `complete -A export`: Names of `export`ed shell variables. 
    - Same as `complete -e`.
* `complete -A file`: File names. 
    - Same as `complete -f`.
* `complete -A function`: Names of shell functions.
* `complete -A group`: Group names from `/etc/group`. 
    - Same as `complete -g`.
* `complete -A helptopic`: Help topics (supported by the `help` builtin).
* `complete -A hostname`: Hostnames, as taken from the file specified by the HOSTFILE shell variable.
* `complete -A job`: Job names, if job control is active. 
    - Same as `complete -j`.
* `complete -A keyword`: Shell reserved words. 
    - Same as `complete -k`.
* `complete -A running`: Names of running jobs (if job control is active).
* `complete -A service`: Service names. 
    - Same as `complete -s`.
* `complete -A setopt`: Valid arguments for `set -o`.
* `complete -A shopt`: Shell option names for `shopt`.
* `complete -A signal`: Signal names (from `kill -l`).
* `complete -A stopped`: Names of stopped jobs (if job control is active).
* `complete -A user`: User names from `/etc/passwd`. 
    - Same as `complete -u`.
* `complete -A variable`: Names of all shell variables. 
    - Same as `complete -v`.


