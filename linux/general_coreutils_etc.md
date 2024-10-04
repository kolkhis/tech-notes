

## Table of Contents
* [Packages to install when I have Linux on desktop:](#packages-to-install-when-i-have-linux-on-desktop) 
    * [Core utils to remember](#core-utils-to-remember) 
* [Timezone change](#timezone-change) 
    * [Tmux vs Screen](#tmux-vs-screen) 
        * [Multiple user session:](#multiple-user-session) 
    * [Cool Vim Tips/Tricks](#cool-vim-tipstricks) 


* Terminal
    * builtin?
    * Ghostty (hopefully)
* Terminal multiplexer
    * tmux
    * screen
* Window Manager
    * Awesome WM (Window Manager) 
    * i3wm



`man` sections:
| Section | Description
|-|-
| `1` | Executable programs or shell commands
| `2` | System calls (C functions provided by the kernel)
| `3` | Library calls (functions within program libraries)
| `4` | Special files (usually found in /dev)
| `5` | File formats and conventions eg /etc/passwd
| `6` | Games
| `7` | Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7)
| `8` | System administration commands (usually only for root)
| `9` | Kernel routines [Non standard]

* Running `man 8 ls` will look in section 8 for `ls`
* `man -f ls` will give the available sections/pages for `ls`.
   
### Core utils to remember
<details>
<summary>Commands</summary>

* `printf`
* `cat`
* `read`
* `grep`
* `tr`
* `echo`
* `sed`
* `awk`
* `ps`

</details>

## Timezone change
* Get timezone for system:
    * `timedatectl`
* Find your timezone:
    * `timedatectl list-timezones`
* Change it:
    * `timedatectl set-timezone America/New_York`


### Tmux vs Screen
#### Multiple user session:
* Both have multi-user support
* Screen allows users to share a session *and* be in different windows.
    * screen -r sessionowner/[pid.tty.host]
* Tmux session allows users to share a session, but switching windows switches for both users.

* Attach to existing session in tmux:
    * `tmux attach -t [session_name]`
    * Where `[session_name]` is the target session from `tmux ls`

* Attach to an existing `screen` session:
    * `screen -r` or `screen -R [session_name]`




### Cool Vim Tips/Tricks

Registers:
* `"tyy` <- yank line to register t  
* `@t` <- play register as macro  

Macros:
* `q[char]` <- start recording a macro in the [char] register. q again to stop recording.  
* `@[char]` <- play the macro  

Vim Filters:
* `:.![cmd]` <- use the current line as stdin for `[cmd]`, stdout on current line  
* `:%! [cmd]` <- use the entire file as stdin for `[cmd]`, stdout on current line
* Pressing `!!` in normal mode will automatically start a filter command
  for the current line (`:.!`)

`<C-o>p` <- quickly pastes register while in insert mode  
:h i_ctrl-o 



