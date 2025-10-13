# Linux Tips and Tricks

## Talk by Vladimir Levijev (ka dimir)
### Oct 13 2025


### first shells
UNIX shell
Bourne shell / sh
csh
ksh
zsh
bash -- combines featers of sh and csh

## Bash Config files

Global config files:
- RedHat; /etc/bashrc
- Debian: /etc/bash.bashrc

HISTCONTROL: var to set ignores
HISTSIZE/HISTFILE

```bash
ls -ltr # sort by access time
cl="find . -name '.#*'
```
^S ^Q: Control output that's written to screen (XON/XOFF)
- ^S (XOFF): "Stop output"
- ^Q (XON): "Stop output"
- Disable behavior by setting `stty -ixon`

Utility for changing the user's shell:  
```bash
chsh
```

```bash
cat /etc/timezones
readlink /etc/localtime
timedatectl
```

pwd variables to store directories:
- `$OLDPWD`
- `$PWD`

env var glitch (defin session var for specific cmd)
```bash
user=john echo "$user"
```

`locate`:
plocate mlocate/ `updatedb`

- `ls -d`: List directory itself

umask subtracts permissions from the default permission that are created.  

### File Attributes
`lsattr` - list attributes of a file. 22 atribues availble. `i` cannot be
modified
- 
```bash
chattr +i /etc/passwd # set the "immutable" attribute on file
chattr -e /etc/passwd # remove the attribute
```
attributes:
- i: immutabe
- a: append-only
- A: no atime updates: Read does not change ATIEM
- c: compressed
- s: secure deletion: wiped securely when deleted (the bits will be zeroed)


Check support for attributes:
```bash
tune2fs -l /dev/sda3 | grep 'Filesystem features'
```

---



## Misc.
Estonia produced skype, Transferwise (wise) and bolt
first nation to offer internet voting.  

OS systems provie service to users, incl file management, process mgsmg, etc. -- called a shell

### without os
access sata controller
sending cmds
handling dma or pio transfers
waiting for status
reading the data
no FS support


### Movies about linux
The Code (2001)
Revolution OS (classic)

### Zabbix
100% Open Source
First 0.1 was gpl2 then moved to AGplv3
- agentbased and agentless monitoring
- provides automation / auto-discovery
- Visualization
- Zabbix Cloud now a thing
