
# Customizing Your Terminal  

## Table of Contents
* [Customizing Your Terminal](#customizing-your-terminal) 
* [Colors](#colors) 
* [Customizing Your Prompt](#customizing-your-prompt) 
    * [Modify the PS1 Environment Variable](#modify-the-ps1-environment-variable) 
    * [Modifying the PS2 Environment Variable](#modifying-the-ps2-environment-variable) 


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
available for use in `PS1`:  

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


### Modifying the PS2 Environment Variable  

`PS2` is the environment variable that controls what the next-line prompt looks like.  

For example when running:  
```bash  
user@server $ command "argument" \
> "another argument"  
> "The > is the ${PS2} environment variable"  
```
In this instance, `PS2="> "`.  


