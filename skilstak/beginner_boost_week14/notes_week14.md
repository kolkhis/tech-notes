
# Beginner Boost Week 14


### Finding Files and Vulnerabilities Like a Hacker

#### Commands
* `ls`
* `lsof`
* `find`
* `file`
* `chmod`
    * What are Bases? Binary, Octal, Hexadecimal, Base64
* `type`
* `ln`
* `command`
* `which`


### `ls`
* Lists current or given folder's files (all visible files by default)
* When dealing with files under a certain threshold of bytesize, they will be stored in the inode table.
    * This means that breaking up files into smaller files is not a bad idea.
* -h adds human readable formatting for filesizes with -l. (powers of 1024, because it's base2)
* Every file has 3 timestamps associated with it.
    * atime, mtime, ctime
        * more info: `man find`
    * a = last access time
    * c = change time (permissions)
    * m = last modified time (content)

### `find`
* atime, mtime, ctime
    * a = last access time
    * c = creation time
    * m = last modified time
        * The `touch` command will update this timestamp (or create a new file)
    * more info: `man find`


### `touch`
* Updates timestamp if file exists. Creates file if it doesn't exist.
* We go into /etc/ and want to create a new file (called motd), but don't have write permissions.
    * File is made but can't be saved. `:w /tmp/backupfile`
* `touch motd` - permission denied
* `sudo su` - enter password
* `touch /etc/motd`



### `chmod`
* chmod +x hello - adds executable permission for all users/group



### Permissions
* rwx = read/write/execute
    * read / report
    * write
    * execute / explore
* -rw-rw-r-- 1 kolkhis kolkhis
*   ^ perms     ^user   ^group
    * 3 middle permissions apply to group
        * Can be used to blacklist people from files
    * Last 3 perms apply to ALL users
    * The `1` shows how many occurrences/refs there are to this memory space (if there are hard links to this file)
* First char: 
    * d = directory
    * l = link: shows a link that points somewhere. Symlinks are always full permissions. The file itself has its own permissions.
    * c = Special devices that are "not real files", but settings
        * Could `cat` a new setting into this filetype to change a setting. A lot of files in /dev/ have this setting.


### `type <cmd>`
* Shows what type of command it is
* `type ls` - Will list what a command is (if it's an alias)

### `file <file>`
* Shows what type of file it is ("it" being the argument given)
* ` file `which lynx`` - same as `file $(which lynx)`

### `which <cmd/executable>`
* will show where the executable is for given `cmd`/`executable`

### `lsof`
* Lists all open files on the system, and which processes are using those files.

### `ln [-s] <file>`
* Creates a link to a given file.
* By default, creates a "hard link." This means they are the same exact file.
    * Essentially a pointer. Does not really occupy additional space.
    * Two separate files that refer to the exact same memory space.
    * Literally hard links that refer to the same thing. Removing one will not delete the other.
    * Deleting the associated file will NOT break the symlink.
    * Can NOT have a hard link point to a file on another disk.
    * You can rename the file and the hard link will persist.
    * There is a finite limit of Hard Links (512)
* `-s` makes this a symbolic link
    * Is not a pointer.
    * Deleting the associated file will break the symlink.
    * Is itself a file, it has its own size, modification time, etc.
    * Can have a symlink point to a file on another disk.
    * No limit to the amount of symlinks
* `ln "$PWD/file.md" /tmp/blah`
    * Creates a symlink (with full filepath) for current file to /tmp/blah



### `command`
* `command -v <cmd/executable>` - Tell if a command is a command/executable on the system.
* Returns success if the argument can be used as a command.
    * `which` is preffered to check if a binary exists.
* Builtin (not an executable)
    * There is no `man` page for builtins. Must use `help command`


### `test -n`
* `test -n "$cmd"` - Checks if "$cmd" has anything in it. Will use original binary.

You can take advantage of a misconfigured path by inserting a custom script with the same name,
and pass it along to make it act like the original (trojan)
Social engineering - hijack your own `sudo` and get admin to login as root



### Script
touch hello
echo "echo hello" > hello
bash hello
bash < hello

#### Shebang line:
`#!/usr/bin/bash` - Will run this program with the file as stdin 
    * `-x` will give debug info


* To use a command without alias, use `\cmd`


termdown - python program that will create an on-screen ASCII-art timer that counts down.



## Bash is an Interpreter.
Takes bash code/script and converts into syscalls
Sends the binary code into the kernel to execute
All languages are "compiled", but not all languages are pre-compiled.
Less efficient than compiled code.


## New Standard for Finding Interpreter
`#!/usr/bin/env bash`
Will run whatever program if it exists in PATH.
Is on every *nix system
`#!/usr/bin/env python3`
Also works
* Disadvantage:
    - Looks for bash within environment
    - Less secure than /usr/bin/bash, because another bash could be injected to a higher-priority $PATH 




## Go
Can compile Go code for a specific Operating Systems:
    * `GOOS=windows go build higo.go`

Oro/Mato, Sheo, Hornet 2, NKG, then the final bet can be for PV and AbsRad


Raids from:

WhoKnowzYo

