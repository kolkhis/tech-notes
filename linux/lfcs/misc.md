# Misc. Notes


## Login Methods
- Local text-mode console: CLI login
- Local graphical-mode console: Login via GUI

- Remote text-mode login: CLI login
    - The OpenSSH daemon (Secure SHell). Uses strong encryption.  
      ```bash
      ssh user@ip
      ```
    - Used to be telnet, but that was highly insecure.  

- Remote graphical-mode login
    - There's no standard for this
    - VNC is a common method for remote GUI logins.  
    - RDP (Remote Desktop Protocol) connections may also be accepted from Windows machines.  

Consoles/terminals are things that allow you to interact with a PC. They're a
place where the PC can show text output and allow command input (CLI).  

After a Linux machine is booted, you can open a virutal terminal by using:
++ctrl+alt+f2++ 

Linux servers often don't have a GUI, but some do.  

```bash
ip a
```

SSH Daemon listens for connection
SSH client connects to the server via the SSH daemon.  


### Local GUI Login
Select the user you want to login to, and enter the password.

### RDP GUI Login

If you're on a Windows machine and you want to view the remote desktop of a
Linux machine, use RDP.  

- ++win++ -> rdp -> Remote Desktop Connection

or

- ++win+r++ -> `mstsc.exe`

The target Linux machine needs to have XRDP installed. 

Put in the remote IP and hit connect. Click yes on the certificate warning,
then log in with username/password.  

### SSH Login
```bash
ssh user@ip
```


## Getting Help

Most commands have a `--help` option.  

Use `--help` as an argument for most commands to get help text.  

```bash
journalctl --help
```
Opens up with a pager. ++q++ to quit the pager.  

Use `man` to view the full manual page for the command.  
```bash
man journalctl
```

Sometimes there's more than one man page for a command.  
```bash
man man
man 1 printf
man 3 printf
```

- Section `1` is for commands.
- Section `3` is for C functions (system calls).  

Use `--help` in the exam before `man`, as `man` usually takes more time.  

`apropos` searches for man pages that contain a word in their short
descriptions.  
`man -k` does the same thing.  
```bash
apropos director
man -k director
```

If the output is `director: nothing appropriate`, then you may need to create
the database that `apropos` uses.  

```bash
sudo mandb
```
Probably don't need to do this on servers that have been up for a while. It's
typically done automatically.  

---

Commands are only in sections 1 and 8.  

```bash
apropos -s 1,8 director
man -k -s 1,8 director
```

This searches for only man pages in 1 and 8.  


