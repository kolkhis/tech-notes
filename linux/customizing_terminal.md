
# Customizing Your Terminal



## Modify the PS1 Environment Variable

`PS1` is the environment variable that controls what the terminal prompt looks like.  

Here is a list of 
[special escape sequences](https://www.computerhope.com/unix/ubash.htm#prompting)
available for use in `PS1`:  

|  Escape Sequence  |   What it Represents      |
|-------------------|---------------------------|
|  `\a`          |   ASCII bell character (can hear a bell/see a visual bell on some terminals) |
|  `\d`          |   Date in "Weekday Month Date" format (e.g., "Tue May 26") |
|  `\D{format}`  |   Custom date format, using strftime format specifiers. |
|  `\e`          |   ASCII escape character |
|  `\h`          |   Hostname up to the first . |
|  `\H`          |   Full hostname |
|  `\j`          |   Number of jobs currently managed by the shell |
|  `\l`          |   Basename of the shell’s terminal device name |
|  `\n`          |   Newline |
|  `\r`          |   Carriage return |
|  `\s`          |   Name of the shell (e.g., "Bash") |
|  `\t`          |   Current time in 24-hour HH:MM:SS format |
|  `\T`          |   Current time in 12-hour HH:MM:SS format |
|  `\@`          |   Current time in 12-hour am/pm format |
|  `\A`          |   Current time in 24-hour HH:MM format |
|  `\u`          |   Username of the current user |
|  `\v`          |   Version of Bash (e.g., 4.4.19) |
|  `\V`          |   Version of Bash + patch level (e.g., 4.4.19.1) |
|  `\w`          |   Current working directory (full path) |
|  `\W`          |   Basename of the current working directory |
|  `\!`          |   History number of this command |
|  `\#`          |   Command number of this command (counts each command) |
|  `\$`          |   If the effective UID is 0 (root user), a #, otherwise a $ |
|  `\nnn`        |   Character represented by the octal value nnn |
|  `\[`          |   Marks the start of a sequence of non-printing characters (useful for embedding control sequences) |
|  `\]`          |   Marks the end of a sequence of non-printing characters |

Any ANSI color control sequences need to be wrapped in `\[` and `\]`:
```bash
export PS1="\[\e[38;5;20m\]\u:\h \$ \[\e[0m\]"
            #256-color ANSI         # Reset
```

## Modifying the PS2 Environment Variable

`PS2` is the environment variable that controls what the next-line prompt looks like.  

For example when running:
```bash
user@server ~ $ command "argument" \
> "another argument"
> "The > is the ${PS2} environment variable"
```
In this instance, `PS2="> "`.  


