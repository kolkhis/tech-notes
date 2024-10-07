# Miscellaneous Linux Notes  



## Table of Contents
* [Tools](#tools) 
    * [Cybersecurity Tools to Check Out](#cybersecurity-tools-to-check-out) 
    * [Other Tools to Check Out](#other-tools-to-check-out) 
* [Preserving Environment Variables when using `sudo`](#preserving-environment-variables-when-using-sudo) 
* [Testing Filesystems with Write Tests and Read Tests](#testing-filesystems-with-write-tests-and-read-tests) 
* [Preserving Positional Line Numbers in Text](#preserving-positional-line-numbers-in-text) 
* [MTU and Using Ping without Fragmentation](#mtu-and-using-ping-without-fragmentation) 
* [Finding the default network interface](#finding-the-default-network-interface) 
* [Checking Active Connections](#checking-active-connections) 
* [Adding Users Through /etc/passwd](#adding-users-through-etcpasswd) 
    * [Add a new line for the user](#add-a-new-line-for-the-user) 
* [Playing Games on Linux](#playing-games-on-linux) 
* [Update to Newer Versions of Packages and Commands](#update-to-newer-versions-of-packages-and-commands) 
* [Specify a Certain Version of a Package](#specify-a-certain-version-of-a-package) 
* [Builtin Colon (`:`) Command](#builtin-colon--command) 
* [Find > ls](#find--ls) 
* [SCP](#scp) 
    * [SCP Commands](#scp-commands) 
    * [SCP Options](#scp-options) 
* [Getting the Current System's Kernel Version](#getting-the-current-systems-kernel-version) 
* [sudoers and sudoing](#sudoers-and-sudoing) 
* [Encrypt a file with Vi](#encrypt-a-file-with-vi) 
* [Run a script when any user logs in.](#run-a-script-when-any-user-logs-in) 
* [Run a script as another user](#run-a-script-as-another-user) 
* [Show the PID of the shell you're running in](#show-the-pid-of-the-shell-youre-running-in) 
* [List all aliases, make an alias, and remove an alias. Make it persistent.](#list-all-aliases-make-an-alias-and-remove-an-alias-make-it-persistent) 
* [`for` Loops](#for-loops) 
    * [Create 200 files named `file<number>` skipping every even number 001-199](#create-200-files-named-filenumber-skipping-every-even-number-001-199) 
        * [Using `seq`,](#using-seq) 
        * [Using Brace Expansion (Parameter Expansion)](#using-brace-expansion-parameter-expansion) 
        * [Using and C-style For-Loops](#using-and-c-style-for-loops) 
* [Set a variable of one data point](#set-a-variable-of-one-data-point) 
* [Run a command repeatedly, displaying output and errors](#run-a-command-repeatedly-displaying-output-and-errors) 
* [Make your system count to 100](#make-your-system-count-to-100) 
* [Loop over an array/list from the command line](#loop-over-an-arraylist-from-the-command-line) 
* [Loop over an array/list in a file](#loop-over-an-arraylist-in-a-file) 
* [Test a variable against an expected (known) value](#test-a-variable-against-an-expected-known-value) 
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
    * [Swap Memory](#swap-memory) 
* [Connect to another server](#connect-to-another-server) 
* [List Users on a System](#list-users-on-a-system) 
* [Hard Links vs Symbolic Links](#hard-links-vs-symbolic-links) 
    * [Hard Links and File Deletion](#hard-links-and-file-deletion) 
* [Different Colors for `less` Output](#different-colors-for-less-output) 
    * [Termcap String Capabilities](#termcap-string-capabilities) 
    * [Other Options for `less`](#other-options-for-less) 




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


## Preserving Environment Variables when using `sudo`
Make sudo see variables from the current environment.  
 
When using `sudo`, you can preserve environment variables from the current environment with the `-E` flag.  
```bash  
┎ kolkhis@homelab:~  
┖ $ export testvar=smth  
┎ kolkhis@homelab:~  
┖ $ sudo bash -c 'echo $testvar'  
 
┎ kolkhis@homelab:~  
┖ $ sudo -E bash -c 'echo $testvar'  
smth  
```



A command for programatically checking servers (prod-k8s in this example):  
```bash  
for server in `cat /etc/hosts | grep -i prod-k8s | awk '{print $NF}'`; do echo "I am checking $server"; ssh $server 'uptime; uname -r'; done  
```

## Testing Filesystems with Write Tests and Read Tests 
With bash you can use a `for` loop with the notation `{1..10}` to loop through 1  
and 10.  
For POSIX compliance, use `seq` for the loop.  

* Write test:  
  ```bash  
  for i in {1..10}; do time dd if=/dev/zero of=/space/testfile_$i bs=1024k count=1000 | tee -a /tmp/speedtest1.basiclvm  
  ```

* Read tests:  
  ```bash  
  for i in seq 1 10; do time dd if=/space/testfile_$i of=/dev/null; done  
  ```

* Cleanup:  
  ```bash  
  for i in seq 1 10; do rm -rf /space/testfile_$i; done  
  ```




## Preserving Positional Line Numbers in Text  
Use `nl` to preserve line numbers.  
```bash  
cat somefile | nl | grep "search for this"  
```
This will preserve the line numbers in the output.  
You can also use the `grep -n` option.  
```bash  
cat somefile | grep -n "search for this"  
```


## MTU and Using Ping without Fragmentation  
```bash  
ping -M do <target>  
```
This `-M do` makes sure the packet does not get fragmented.  
* `ping`: The basic `ping` command is used to test the connectivity between two devices 
  on a network by sending ICMP echo request packets to the target and measuring the 
  time it takes to receive an echo reply (response). 
* `-M`: This option sets the path MTU discovery mode, which controls how the `ping` 
  command deals with IP fragmentation.  


MTU stands for **Maximum Transmission Unit**, which is the largest size of a packet 
that can be sent over a network link *without fragmentation*.  
* The MTU for a network interface can be found using `ifconfig` or `ip`:  
  ```bash  
  ifconfig  
  ip addr  
  # or  
  ip a  
  ```
  These commands list all the network interfaces, their statuses, and other info.  
  The network interface will usually be named something like `eth0`, `en0`, `enp0`, etc  
    * `ifconfig` may not be installed by default on modern Linux distributions.  


## Finding the default network interface  
To specifically find the interface being used for outbound traffic (like connecting 
to the internet), you can check the default route:  
```bash  
ip route  
# or  
ip r  
```
The name will be something like `enp0s31f6`, or something like `eth1` on older systems.  
* `en`: Indicates that it's an ethernet connection.  
* `p0s31f6`: This is the info on the ethernet port and bus being used.  


## Checking Active Connections  
You can use `netstat` or `ss` to check active network connections, as well as which 
network interface is being used.  
```bash  
netstat -i  
ss -i  
```



## Adding Users Through /etc/passwd  
See [manually adding user accounts in linux](./manually_adding_user_accounts.md).  

### Add a new line for the user:  
Each line in the `/etc/passwd` file represents a user account.  
The format of each line in `/etc/passwd` is as follows:  
```bash  
username:password:UID:GID:GECOS:home_directory:shell  
```
* `username`: The username for the new user.  
* `password`: The encrypted password for the user (you can leave this field empty to disable password login).  
* `UID`: The user ID for the new user.  
* `GID`: The primary group ID for the new user.  
* `GECOS`: Additional information about the user (such as full name or description).  
* `home_directory`: The home directory for the new user.  
* `shell`: The login shell for the new user.  

---  

* Add the new user by editing /etc/passwd:  
  ```bash  
  sudo vi /etc/passwd  
  # then add:  
  user:password:UID:GID:GECOS:/home/newuser:/bin/bash  
  ```
    * `sudo` is required for writing to this file.  
    * Save and close the file after adding the user information.  
    * The shell needs to be the path to the actual binary for the shell.  

* Create the user's home directory: If you specified a home directory for the new 
  user, you need to manually create it using the `mkdir` command.  
    * ```bash  
      sudo mkdir /home/newuser  
      ```

* Set permissions for the home directory: After creating the home directory, you may 
  need to set the appropriate permissions to allow the new user to access it.  
    * ```bash  
      sudo chown newuser:newuser /home/newuser  
      ```

* Set the user's password (if applicable): If you left the password field empty in 
  the `/etc/passwd` file, you may need to set a password for the new user using the 
  `passwd` command.  
    * ```bash  
      sudo passwd newuser  
      ```
    
* Test the new user account: After completing those steps, you can test the new 
  user account by logging in with the username and password (if applicable) and 
  verifying that the user has access to the home directory.  



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

### Swap Memory  
Swap memory is writing down to a block device. It's like a paging file. 
In a modern Linux system, you want RAM to be used and not SWAP.  


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





## Hard Links vs Symbolic Links  
Symbolic links (sometimes called soft links or symlinks) and hard links are both 
pointers to a memory address where a file is stored. 
They both allow you to access a file.  
 
The main difference is that hard links are not deleted when the original file is 
deleted. Symbolic links break when this happens.  
 
Hard links cannot exist across file system boundaries. A symbolic link can.  
Hard links will only work within the same block device. 

Hard links point to the block of memory itself, whereas a symlink points to the file path.  

* Hard Links:  
    * Points to the same inode (file content).  
    * Cannot link to directories.  
    * Still works even if the original file is deleted. 
    * Can't span across different filesystems.  
        * This means you can't hard link a file on another block device. 

* Symlinks (Symbolic Links):  
    * Points to the file path.  
    * Can link to directories.  
    * Breaks if the original file is deleted or moved.  
    * Can span across different filesystems.  

### Hard Links and File Deletion  
When you delete a file in Linux, it's not actually deleted. 

The inode (index node) pointer to that file is deleted. The file is still there on the disk.  
 
You'd need to manually overwrite/stripe over the data to remove it.  
Without manually overwriting the data, forensic tools would be able to recover the data.  
 
This is why hard links can exist when the original file is deleted. They're still  
pointing to a valid block of memory on the disk.  

If both the original file and hard link are deleted, the data will still be there on  
the disk, but it will never be recovered through normal means. There are forensic 
tools that exist that can read the disk and recover the data.  

* An inode (index node) is a metadata structure that stores information about files 
  and directories, like ownership, permissions, and pointers to the file's data blocks.  
* Inodes do **not** store filenames. Those are managed by directory structures.  
* Every file has an inode. Hard links share inodes, while symbolic links do not.  



## Different Colors for `less` Output  
`LESS_TERMCAP_**`: Allows you to specify colors for different parts of terminal output.  
You need to use the `less -R` option to enable this.  
TODO: Experiment with using the formats `"[10m"` and `$'\e[10m'`
```bash  
export LESS='-R'  
export LESS_TERMCAP_md=$'\e[33m'  # Start Bold  
export LESS_TERMCAP_mb=$'\e[4m'   # Start Blinking  
export LESS_TERMCAP_us=$'\e[10m'  # Start Underline 
export LESS_TERMCAP_so=$'\e[11m'  # Start Standout  
export LESS_TERMCAP_me=""         # End all modes  
export LESS_TERMCAP_se=""         # End Standout  
export LESS_TERMCAP_ue=""         # End underline  
```


### Termcap String Capabilities  
##### `man://termcap 259`
Termcap stands for "Terminal Capability".  
It's a database used by Terminal Control Libraries (e.g., `ncurses`) to manage colors 
and other terminal features.  

Some of the modes that you can use to colorize output:  
* `me`: End all "modes" (like `so`, `us`, `mb`, `md`, and `mr`)  
* `so`: Start standout mode  
* `md`: Start bold mode  
* `us`: Start underlining  
* `mb`: Start blinking  
* `ue`: End underlining  
* `se`: End standout mode  
* `mr`: Start reverse mode  
* `mh`: Start half bright mode  






### Other Options for `less`
```bash  
export LESS="-FXR"  
```
* `-F` causes less to automatically exit if the entire file can be displayed on the first screen.  
* `-X` stops `less` from clearing the screen when it exits.   
    * Disables sending the termcap initialization and deinitialization strings to the terminal.  
    * The initialization string is sent when `less` starts. This causes the terminal  
      to be cleared.  The deinitialization string does the same thing.  


