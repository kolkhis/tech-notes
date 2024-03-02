# Miscellaneous Linux Notes

## Table of Contents
* [Miscellaneous Linux Notes](#miscellaneous-linux-notes) 
* [Tools](#tools) 
    * [Cybersecurity Tools to Check Out](#cybersecurity-tools-to-check-out) 
    * [Other Tools to Check Out](#other-tools-to-check-out) 
* [Playing Games on Linux](#playing-games-on-linux) 
* [Update to Newer Versions of Packages and Commands](#update-to-newer-versions-of-packages-and-commands) 
* [Specify a Certain Version of a Package](#specify-a-certain-version-of-a-package) 
* [Builtin Colon (`:`) Command](#builtin-colon-()-command) 
* [Find > ls](#find->-ls) 
* [SCP](#scp) 
    * [SCP Commands](#scp-commands) 
    * [SCP Options](#scp-options) 
* [Kernel Version](#kernel-version) 
* [sudoers and sudoing](#sudoers-and-sudoing) 
* [Encrypt a file with Vi](#encrypt-a-file-with-vi) 
* [Run a script when any user logs in.](#run-a-script-when-any-user-logs-in.) 
* [Run a script as another user](#run-a-script-as-another-user) 
* [Show the PID of the shell you're running in](#show-the-pid-of-the-shell-you're-running-in) 
* [List all aliases, make an alias, and remove an alias. Make it persistent.](#list-all-aliases-make-an-alias-and-remove-an-alias.-make-it-persistent.) 
* [`for` Loops](#for-loops) 
    * [Create 200 files named `file<number>` skipping every even number 001-199](#create-200-files-named-file<number>-skipping-every-even-number-001-199) 
        * [Using `seq`,](#using-seq) 
        * [Using Brace Expansion (Parameter Expansion)](#using-brace-expansion-(parameter-expansion)) 
        * [Using and C-style For-Loops](#using-and-c-style-for-loops) 
* [Set a variable of one data point](#set-a-variable-of-one-data-point) 
* [Run a command repeatedly, displaying output and errors](#run-a-command-repeatedly-displaying-output-and-errors) 
* [Make your system count to 100](#make-your-system-count-to-100) 
* [Loop over an array/list from the command line](#loop-over-an-array/list-from-the-command-line) 
* [Loop over an array/list in a file](#loop-over-an-array/list-in-a-file) 
* [Test a variable against an expected (known) value](#test-a-variable-against-an-expected-(known)-value) 
* [Get the headers from a HTTP request](#get-the-headers-from-a-http-request) 
* [List the number of CPUs](#list-the-number-of-cpus) 
* [CPU Commands](#cpu-commands) 
    * [Find the manufacturer of the CPU](#find-the-manufacturer-of-the-cpu) 
    * [Find the architecture of the CPU chip](#find-the-architecture-of-the-cpu-chip) 
    * [Check the CPU speed in MHz](#check-the-cpu-speed-in-mhz) 
* [Check if this system is physical or virtual](#check-if-this-system-is-physical-or-virtual) 
* [RAM Commands](#ram-commands) 
    * [Check how much RAM we have](#check-how-much-ram-we-have) 
    * [Check how much RAM we are using](#check-how-much-ram-we-are-using) 
* [Connect to another server](#connect-to-another-server) 
* [GREP_COLORS](#grep_colors) 



Terminology:
* RCA = Root Cause Analysis

## Tools
### Cybersecurity Tools to Check Out  
* `pfsense` - A tool for authentication  
* `OpenSCAP` - benchmarking tool  
* `nmap`  
    * `nmap` maps the server if you don't have permissions  
        * good for external mapping without permissions  
* `ss` or `netstat` are internal with elevated permissions for viewing  
    * Used locally with elevated permissions, it's better than `nmap`?  
    * `ss -ntulp`
* `sleuthkit` - File and filesystem analysis/forensics toolkit.

### Other Tools to Check Out
* `parallel` (GNU Parallel) - Shell tool for executing jobs in parallel using one or more machines.
    * A job is typically a inslge command or small script that has to be run
      for each line in the input.
    * Typical input is a list of either files, hosts, users, or tables.
* KeePassXC - Password manager or safe. Locked with one master key or key-disk.  
* traefik - HTTP reverse proxy and load balancer that makes deploying microservices easy.  
* vault - Product data management (PDM) tool. Integrates with CAD systems. Autodesk product.  
* Ncat - What's the difference between `netcat` and `Ncat`?  
* sleuthkit - File and filesystem analysis/forensics toolkit.
* ranger - a console file manager (vi hotkeys)
* btop - Customizable TUI Resource monitor. See the [github](https://github.com/aristocratos/btop) page
    * See [example btop.conf](https://github.com/aristocratos/btop?tab=readme-ov-file#configurability)
    * Goes in `$XDG_CONFIG_HOME/btop/btop.conf` or `$HOME/.config/btop/btop.conf`

A command for programatically checking servers (prod-k8s in this example):  
```bash  
for server in `cat /etc/hosts | grep -i prod-k8s | awk '{print $NF}'`; do echo "I am checking $server"; ssh $server 'uptime; uname -r'; done  
```

## Playing Games on Linux
Use Proton - a version of WINE made specifically for gaming.

## Update to Newer Versions of Packages and Commands
```bash
sudo update-alternatives --config java
sudo update-alternatives --config javac

```

## Specify a Certain Version of a Package
```bash
sudo apt install <package>=<version>
```
Just append the version number to the package name with an equals `=` sign.
Example:
```bash
sudo apt install mysql-server=8.0.22
```



## Builtin Colon (`:`) Command
* `: [arguments]`
    * No effect; the command does nothing beyond expanding arguments 
      and performing any specified redirections. 
    * The return status is zero (which evaluates to `true` in bash/sh).  

## Find > ls  
Use `find` instead of `ls` to better handle non-alphanumeric filenames.  

## SCP
Usage: `scp <options> source_path destination_path`  

### SCP Commands
```bash
# copying a file to the remote system using scp command
scp file user@host:/path/to/file                        
# copying a file from the remote system using scp command
scp user@host:/path/to/file /local/path/to/file         
 
# copying multiple files using scp command
scp file1 file2 user@host:/path/to/directory            
# Copying an entire directory with scp command
scp -r /path/to/directory user@host:/path/to/directory  
```

### SCP Options

| Option   |  Description
|-|-
| `-r`     |  Transfer directory 
| `-v`     |  See the transfer details
| `-C`     |  Copy files with compression
| `-l 800` |  Limit bandwith with 800
| `-p`     |  Preserving the original attributes of the copied files
| `-P`     |  Connection port
| `-q`     |  Hidden the output




## Getting the Current System's Kernel Version  
Get Kernel version  
``` bash  
ls /boot  
dmesg | head  
uname -a  
```

## sudoers and sudoing
* List of sudoers or sudo users is found in `/etc/sudoers`
* `sudoers` uses per-user timestamp files for credential caching.  
* Once a user has been authenticated (by running `sudo [cmd]` and entering password),
  a record is written.
    * The record contains: 
        * The user-ID that was used to authenticate
        * The terminal session ID
        * The start time of the session leader (or parent process)
        * A time stamp (using a monotonic clock if one is available)
* The authenticated user can sudo without a password for 15 minutes,
  unless overridden by the `timestamp_timeout` option.


## Encrypt a file with Vi  
Vi/vim only.
```vim 
:X  
```
By default, uses Blowfish2.  
 
It's said to be extremely insecure, and was removed by
Neovim due to implementation flaws and vulnerability.  
 
Use GPG instead.  


## Run a script when any user logs in.  
* To run a script automatically when ANY user logs in, 
    add it to the `/etc/profile` file, or add it as a 
    shell (`.sh`) script in the `/etc/profile.d` directory.  
    * `/etc/profile` is a POSIX shell script.  
    ```bash  
    # /etc/profile: system-wide .profile file for the Bourne shell (sh(1))  
    # Add anything here to be run at 
    printf "%s: %s" "$DATE" "$USER" >> /home/kolkhis/userlogs.log  
    # This will timestamp the current user in userlogs.log  
    ```
    * `/etc/profile.d/` id a directory containing `.sh` scripts.  
    Add a script here and it will be run when any user logs in.  
    ```bash  
    #!/bin/sh  
    printf "%s: %s" "$DATE" "$USER" >> /home/kolkhis/userlogs.log  
    ```

## Run a script as another user  
```bash  
su -c '/home/otheruser/script' otheruser  
# runs `script` as 'otheruser'  
su -c '/home/otheruser/script'  
# runs 'script' as root if no username is provided  
```


## Show the PID of the shell you're running in  
```bash  
echo $$  
```


## List all aliases, make an alias, and remove an alias. Make it persistent.  
```bash  
alias -p         # or just `alias`. Print list of aliases  
alias c="clear"  # Creates the alias  
unalias c        # Removes the alias  
echo 'alias c="clear"' >> ~/.bash_aliases  # Makes it persistent.  
```


## `for` Loops 
### Create 200 files named `file<number>` skipping every even number 001-199  

#### Using `seq`,
```bash
# Using `seq`
for i in $(seq 1 2 200); do  
    touch file${i}
done  
```

#### Using Brace Expansion (Parameter Expansion)
```bash  
# Bash 4 Exclusive: Brace expansion  
for i in {1..200..2}; do  
    touch file${i}
done  
```

#### Using and C-style For-Loops 
```bash
# C-style loop  
for (( i=0; i<200; i+2 )); do  
    touch file${i}
done  
```

## Set a variable of one data point  
```bash  
VAR=somevalue
VAR="somevalue"
VAR="$(echo somevalue)"
```

## Run a command repeatedly, displaying output and errors  
* By using `watch`, you can execute a program periodically,
  showing output fullscreen  
```bash  
watch -n 2 uptime  
```
Using the -n, --interval *seconds* option, you can specify how often  
the program is run.  

* Using `entr` - This only runs a command when a given file changes.  
```bash  
entr bash -c "clear; echo date '\nFile has changed.';" < <(file.sh)  
```
Every time the `file.sh` file changes, `entr` will run bash, with the commands `clear;`, and  
`echo date '\nFile has changed.'`.  
It was fed the file via stdin with "Process Substitution" (`< <(file.sh)`).  
Using `entr -c` will eliminate the need for the `clear;` command.  

## Make your system count to 100  
This can either be done with a C-style loop, the `seq` command, or "brace expansion."  
Respectively:  
```bash  
for (( i=0; i<=100; i++)); do  
    echo $i  
done  
seq 100  
echo {1..100}
```


## Loop over an array/list from the command line  
```bash  
list=$(find . -name *.py); # Predefining a list. Can do this inline too.  
# Looping over the array itself  
list=$(find . -name *.py); for n in "${list[@]}"; do printf "Current item: %s\n" "$n"; done; 
# Using the length (#)  
list=$(find . -name *.py); for n in ${#list}; do  echo $list[$n]; done  
```

## Loop over an array/list in a file  
```bash  
while read -r linevar; do
    echo "Current item:"; echo $linevar;
done <file  
```

or:
```bash  
while read -r file; do
    echo "Current item:"; 
    echo $file;
done < <(find . -name *.py)
```

or:
```bash
declare -a FILES
read -r -d '' -a FILES < <(find . -name *.py)
for file in "${FILES[@]}"; do
    printf "Current item: %s\n" "$file";
done
```



## Test a variable against an expected (known) value  
```bash  
if [[ "$var" == "known value" ]]; then  
    echo "$var is known value"  
fi  
```


## Get the headers from a HTTP request  
```bash  
curl -i hostname.com/:port  
```

## List the number of CPUs  
CPU info is stored in `/proc/cpuinfo`
```bash  
cat /proc/cpuinfo | grep cores  
```
There is also a utility command, `lscpu`.  
This displays all the information you'd want about your system's CPU.  
```bash  
lscpu | grep "CPU(s)"  
```
## CPU Commands
### Find the manufacturer of the CPU  
```bash  
lscpu | grep "Vendor ID"  
```


### Find the architecture of the CPU chip  
```bash  
lscpu | grep "Architecture"  
```

### Check the CPU speed in MHz  
```bash  
lscpu | grep "MHz"  
```

## Check if this system is physical or virtual  
```bash
dmidecode -s system-manufacturer
```
* If it's a phyical system, you'll see the manufacturer (e.g., `Dell Inc.`).  
* If it's a virtual system, you'll see some sort of virtualization:
    * `QEMU`
    * `innotek Gmbh` (VirtualBox)

```bash
dmidecode
```
* `dmidecode` is for dumping a computer's `DMI` (`SMBIOS`) table contents in a 
  human-readable format.
    * `SMBIOS` stands for "System Management BIOS", while 
    * `DMI` stands for "Desktop Management Interface."
* This table contains a description of the system's hardware components,
  and other useful pieces of information such as serial numbers and BIOS revision.

## RAM Commands
### Check how much RAM we have  
Use the `free` command to see RAM statistics.  
```bash  
free -h  
free -h | awk '{print $2}' | sed -E 's/^used/total memory/'  
free -h | awk '{printf $2}' | sed -E 's/^used/total memory/'  
```
Since the first column does not have a header, `awk '{print $2}'` will show  
the `total` column, but the header is `used`.  
So, passing it through `sed` can fix that.  

* The `free` field shows unused memory (MemFree and SwapFree in /proc/meminfo)
    * ```bash
        cat /proc/meminfo | grep -E "MemFree|SwapFree"
        ```

### Check how much RAM we are using  
Using `free -h`, just like checking total RAM.  
```bash  
free -h | awk '{print $3}' | sed -E 's/^free/\nRAM in Use/'  
```

## Connect to another server  
```bash  
nc -dz  
nmap -sS  
```


## List Users on a System
1. To list all the user accounts on the system, you can run the command:
```bash
cat /etc/passwd | awk '{ print($1) }'
# or to see the users with shell access
cat /etc/passwd | grep 'bash'
 
cat /etc/passwd | awk -F: '{ print($1) }' | grep -v "nologin"
```

2. You can also list all the users on a system with `cut`:
```bash
cut -d: -f1 /etc/passwd
```
* `-d:` sets the delimiter to `:`
* `-f1` tells `cut` to print the first field (the username)

3. You can also achieve this with `compgen -u`
```bash
compgen -u | column
```
* This command outputs possible completions depending on the options.  






