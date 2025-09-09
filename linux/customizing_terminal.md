# Customizing Your Terminal  



## Config Files
The main file to edit to customize the terminal is `~/.bashrc`.  
This will be run on every interactive login shell (for the specific user).  


If you want to customize a certain thing for all users, there are some global files
you can edit.  

### `~/.bashrc`
This is the runtime configuration file for bash, and it will be executed every time a
new interactive shell is loaded.  
Put any valid bash/sh code in here and it will be executed when bash starts interactively.  

### `/etc/profile` and `~/.bash_logout` (system-wide `.bashrc`)
The `/etc/profile` file is loaded on every single instance of bash, whether it's a
login/interactive shell or not.  
It's basically a system-wide `.bashrc` file.  

If `/etc/profile` exists, it will read/execute this first, before any other config files.  
Then bash will look for `~/.bash_profile`, `~/.bash_login`, and `~/.profile`.  
The first one of these found will be read/executed, and the rest will be ignored.  

The `~/.bash_logout` file will be read/executed every time a shell exits (with the
`exit` builtin), whether it's a login/interactive shell or non-interactive shell.  

---

### Config File Load Order

The order in which bash loads config files:

* Non-interactive
    - `/etc/profile` (always)
    - First one found (in this order):
        - `~/.bash_profile`
        - `~/.bash_login`
        - `~/.profile`
    - `~/.bash_logout` when the shell `exit`s.  

* Interactive shell (e.g., a login shell)
    - `/etc/profile` (always)
    - `/etc/bash.bashrc` (always)
    - First one found (in this order):
        - `~/.bash_profile`
        - `~/.bash_login`
        - `~/.profile`
    - `~/.bashrc`
    - `~/.bash_logout` when the shell `exit`s.  

The `/etc/profile` file is **always** evaluated, regardless of whether a shell
is interactive or not.  

## Colors

See [ANSI escape sequences](./ansi_control_sequences.md) for more details.  

* `30 - 37` : 8-color foreground colors.
* `40 - 47` : 8-color background colors.
* `38;5;0 - 255` : 88/256-color foreground colors.  
* `48;5;0 - 255` : 88/256-color background colors.  


## Customizing Your Prompt
### Modify the PS1 Environment Variable  

`PS1` is the environment variable that controls what the terminal prompt looks like.  

Here is a list of 
[special escape sequences](https://www.computerhope.com/unix/ubash.htm#prompting)  
available for use in `PS1`.  

These can also be found in `man://bash`, `/^\s*PROMPTING`.

|  Escape Sequence  |   What it Represents      
|-------------------|---------------------------  
|  `\a`          |   ASCII bell character (audio bell/visual bell on some terminals) 
|  `\d`          |   Date in "Weekday Month Date" format (e.g., "Tue May 26") 
|  `\D{format}`  |   Custom date format, using strftime format specifiers. 
|  `\e`          |   ASCII escape character 
|  `\h`          |   Hostname up to the first `.` 
|  `\H`          |   Full hostname 
|  `\j`          |   Number of jobs currently managed by the shell 
|  `\l`          |   Basename of the shell’s terminal device name 
|  `\n`          |   Newline 
|  `\r`          |   Carriage return 
|  `\s`          |   Name of the shell (e.g., "Bash") 
|  `\t`          |   Current time in 24-hour HH:MM:SS format 
|  `\T`          |   Current time in 12-hour HH:MM:SS format 
|  `\@`          |   Current time in 12-hour am/pm format 
|  `\A`          |   Current time in 24-hour HH:MM format 
|  `\u`          |   Username of the current user 
|  `\v`          |   Version of Bash (e.g., 4.4.19) 
|  `\V`          |   Version of Bash + patch level (e.g., 4.4.19.1) 
|  `\w`          |   Current working directory (full path) 
|  `\W`          |   Basename of the current working directory 
|  `\!`          |   History number of this command 
|  `\#`          |   Command number of this command (counts each command) 
|  `\$`          |   If the current user's UID is 0 (root user), a `#`, otherwise a `$` 
|  `\nnn`        |   Character represented by the octal value nnn 
|  `\[`          |   Marks the start of a sequence of non-printing characters (colors, etc) 
|  `\]`          |   Marks the end of a sequence of non-printing characters 

Any ANSI color control sequences need to be wrapped in `\[` and `\]`:  
```bash  
export PS1="\[\e[38;5;20m\]\u:\h \$ \[\e[0m\]"  
            #256-color ANSI         # Reset  
```
See [ANSI control sequences](./ansi_control_sequences.md) for adding colors.

* `\w` (The current working directory), uses the value of the `PROMPT_DIRTRIM`
  variable.
    - If set, it will use this number as the number of trailing directories to keep.  

### Modifying the PS2 Environment Variable  

`PS2` is the environment variable that controls what the next-line prompt looks like.  

For example when running:  

```bash  
user@server $ command "argument" \
> "another argument"  
> "The > is the ${PS2} environment variable"  
```

In this instance, `PS2="> "`.  

If your `PS2` variable was set to `~> `, it would show those characters on newlines
within commands:
```bash  
user@server $ command "argument" \
~> "another argument"  
~> "The > is the ${PS2} environment variable"  
```




