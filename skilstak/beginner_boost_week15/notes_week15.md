
# Beginner Boost Week 15

## Bash Scripting

---

## Posix vs Bash

### Posix
(Portable Operating System Interface)
Posix is a set of standards && guidelines that rose with Unix
Focuses on portability.
POSIX-compliant shell scripts are shell scripts that can be run on ANY Unix system.

### BASH
BASH is not POSIX-compliant by default.
Is licenced with GPL-v3 - Torvals calls "criminal". It's not GPL at all.
    Forces hardware vendors to release open hardware so it can be changed by end-user.
This is the biggest wort for BASH. This is why Apple keeps Bash Version 2, and uses `zsh` (BSD Unix)
    `zsh` is forced on Mac because of the license. It is inferior to BASH in every way (apparently).

zah and bash: License. 
zsh and fish cannot export functions like in BASH.

### Do we write POSIX-compliant or BASH?
#### BASH is not necessarily going to be on every Unix system anymore.

When writing a script, consider the answers to the following questions:
- Is the shell going to be on the Machine?
- Number 1: Is it POSIX-compliant?
- Number 2: How safe is it? (Can it be exchanged with others and be run safely?)
- Number 3: How intuitive/easy is it?
- Number 4: How powerful is it?

BASH is one of the only shells with Regex support.
Double-bracketed conditionals: expansion
    Can be used for injection attacks in Shell code. The #1 vector for attacking shell code.
Multi-threading support.
DASH or ASH is usually the default startup shell for a lot of Linux systems (Ubuntu/Debian family incl)
    BASH is the "interactive" shell.


When writing script, there's a different set of requirements than the interactive shell.
Personal scripts: BASH.
Scripts that will be shared: POSIX-compliant.


### Shellcheck
Lets you make insecure code, and fix it.
EXTREMELY Valuable tool for anyone who writes shell scripts.
This is a safety net. This will point out security errors.
"Tainted" code is anything that doesn't come from inside the script itself (arguments, env vars, etc)
An acceptable naming convention for variables:
* Lowercase variable names for local/internal (non-tainted) variables.
* All-caps variable names for tainted (from outside the script) variables.


## Tripwire Script
We're going to make a minimal version of "Tripwire"
Writing a program
Point it at the top level of the sys
Checks if any of the files have changed
Sends all the changed files to you in a report.

`#!/bin/sh`
^ This is on ALL Linux/Unix systems

`find` has a `-mmin` option that will show which files have changed.
- Almost equivalent to `ls -1`

`find / -name .bashrc 2>/dev/null | tee /tmp/find.out`
^ Will output into file as well as STDOUT


#### Find Examples
`find ~ -name .bashrc 2>/dev/null`
                     *  ^ This redirects STDERR to /dev/null
`find ~ -name .bashrc -ls`
                     * ^ This is make it list like `ls`

`find / -name .bashrc 2>/dev/null | tee /tmp/find.out`
                                  * ^ Will output into file as well as STDOUT so it can be piped further.


Single Quotes don't expand anything inside of it. (prime)
Double quotes do. (double prime)

### Progressive Learning
PWA - Progressive Web Apps
Progressive learning: Learn vi, then vim, then Neovim. Do this with everything.


`find` has a -mmin option that will show which files have changed.
- Similar output to `ls -1`
`chmod u+x tripwire` will add execute only for current user.
`CDPATH` - look it up



## Misc. Notes

#### ORGANIZE YOUR GIT REPOS!

(Perl is portable -- Your Toolkit can be made with Perl for portability)
Gentoo with Busybox: look it up


`/etc/skel`: all new users on the system will get all files in this directory.


If you have the 's' bit on - command has the SUID bit (sticky bit)


`grep -E -v 'container|cache'` # `-v` Will filter out anything that contains 'container' or 'cache'


### Secrets as Environment variables: 
* Set the env var to read from a file for tokens. (or a script that reads from a file)

#### DON'T DO THIS:
--password $(cat password_file) # BAD IDEA
/proc will show all arguments for any program that has been run. Shell will expand the password and save it in /proc/



/dev/shm/ is an ephemeral filesystem (tmpfs under `df` denotes this.) - This means it's only stored in memory
`du -h -s`  
`df -h`  




# Running shellcheck every time a file is changed & written
posix:
`entr bash -c 'clear; shellcheck tripwire' < <(ls tripwire)`

bash:
`entr bash -c 'clear; shellcheck tripwire' <<< tripwire`

