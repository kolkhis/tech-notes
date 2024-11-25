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
* [MEF (Metro Ethernet Framework)](#mef-metro-ethernet-framework) 
* [Finding Environment Variables](#finding-environment-variables) 
* [Important Linux Commands for Sysadmins](#important-linux-commands-for-sysadmins) 
    * [Getting general information about the system](#getting-general-information-about-the-system) 
    * [Package Management commands](#package-management-commands) 
        * [For **Debian-based systems** (like Ubuntu)](#for-debian-based-systems-like-ubuntu) 
        * [For **Red Hat-based systems** (like CentOS, Fedora)](#for-red-hat-based-systems-like-centos-fedora) 
    * [Process Management Commands](#process-management-commands) 
    * [System Monitoring and Logging Commands](#system-monitoring-and-logging-commands) 
    * [Network Management Commands](#network-management-commands) 
* [Network Firewalls vs. WAFs](#network-firewalls-vs-wafs) 
* [Bash Parameter Transformation](#bash-parameter-transformation) 
    * [Parameter Transformation Operators](#parameter-transformation-operators) 
    * [Multiple Parameter Transformation Operators](#multiple-parameter-transformation-operators) 
    * [Parameter Transformation Examples](#parameter-transformation-examples) 
* [Checking the Operating System with the `OSTYPE` Variable](#checking-the-operating-system-with-the-ostype-variable) 
* [Patching Linux Systems](#patching-linux-systems) 
    * [Updating Linux Boxes in Enterprise Environments](#updating-linux-boxes-in-enterprise-environments) 
    * [System Update Strategy](#system-update-strategy) 
    * [Scheduling System Updates](#scheduling-system-updates) 
    * [Automating System Updates](#automating-system-updates) 
    * [System Patching Compliance and Security](#system-patching-compliance-and-security) 
    * [Testing System Updates](#testing-system-updates) 
    * [Updating Linux Boxes, tl;dr](#updating-linux-boxes-tldr) 


## Tools  
### Cybersecurity Tools to Check Out  
* `pfsense` - A tool for authentication  
* `fail2ban` - Ban IPs that fail to login too many times  
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


## The Three "Main" Families of Linux  
There are three major families of Linux distributions:  
* Red Hat  
* SUSE  
* Debian  

### Red Hat Family Systems (incl CentOS, Fedora, Rocky Linux)  
Red Hat Enterprise Linux (RHEL) heads up the Red Hat family.  

* The basic version of CentOS is virutally identical to RHEL.  
    * CentOS is a close clone of RHEL, and has been a part of Red Hat since 2014.  
* Fedora is an upstream testing platform for RHEL.  
* Supports multiple hardware platforms.  
* Uses `dnf`, an RPM-based package manager to manage packages.  
* RHEL is a popular distro for enterprises that host their own systems.  


### SUSE Family Systems (incl openSUSE)  
SUSE (SUSE Linux Enterprise Server, or SLES) and openSUSE are very close to each  
other, just like RHEL/CentOS/Fedora.  

* SLES (SUSE Linux Enterprise Server) is upstream for openSUSE.  
* Uses `zypper`, an RPM-based package manager to manage packages. 
* Includes `YaST` (Yet Another Setup Tool) for system administration.  
* SLES is widely used in retail and other sectors.  



### Debian Family Systems (incl Ubuntu and Linux Mint)  

Debian provides the largest and most complete software repo to its users of any other  
Linux distribution.  
 
* Ubuntu tries to provide a compromise of long term stability and ease of use.  
* The Debian family is upstream for several other distros (including Ubuntu).  
    * Ubuntu is upstream for Linux Mint and other distros.  
* Uses `apt`, a DPKG-based package manager to manage packages.  
* Ubuntu is widely used for cloud deployments.  





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

You can use `LESS_TERMCAP_**` to add colors to `less` output in the terminal (where  
`**` are two letters that indicate a mode).  
Some of the modes that you can use to colorize output:  
* `so`: Start standout mode  
* `se`: End standout mode  
* `us`: Start underlining  
* `ue`: End underlining  
* `md`: Start bold mode  
* `mb`: Start blinking  
* `mr`: Start reverse mode  
* `mh`: Start half bright mode  
* `me`: End all "modes" (like `so`, `ue`, `us`, `mb`, `md`, and `mr`)  
E.g.:  
```bash  
export LESS="-FXR"  # Add default options for less  
export LESS_TERMCAP_mb="[35m" # magenta  
export LESS_TERMCAP_md="[33m" # yellow  
export LESS_TERMCAP_me=""      # "0m"  
export LESS_TERMCAP_se=""      # "0m"  
```





### Other Options for `less`
```bash  
export LESS="-FXR"  
```
* `-F` causes less to automatically exit if the entire file can be displayed on the first screen.  
* `-X` stops `less` from clearing the screen when it exits.   
    * Disables sending the termcap initialization and deinitialization strings to the terminal.  
    * The initialization string is sent when `less` starts. This causes the terminal  
      to be cleared.  The deinitialization string does the same thing.  



## MEF (Metro Ethernet Framework)  
MEF is a protocol that allows you to connect multiple Ethernet devices to a 
single Ethernet port.  


## Finding Environment Variables  
Print out environment variables line-by-line:  
```bash  
env  
printenv  
```
These two commands will output the same variables.  


## Important Linux Commands for Sysadmins  
### Getting general information about the system  
Use `lshw` to list the hardware on the system  
```bash  
lshw  # List the hardware on the system  
lscpu # List the CPU information  
uname -a  # Get information about the system (kernel, version, hostname, etc)  
who  # Shows who is logged into the system  
w    # More detailed version of 'who'  
last # Show the last users to log into the system (prints in reverse)  
cat /etc/*release  # Get information about the operating system  
cat /proc/cmdline  # Get the kernel command line arguments (boot parameters, boot image)  
ethtool  # Show info on the network interfaces  
ip a     # Show info on the network interfaces  
ip r     # Show the routing table (shows network gateway)  
lsblk    # List the block devices on the system (disk info)  
blkid    # Show the UUIDs of the block devices (or a specific block device)  
ps       # Show running processes on the system  
pstree   # Show the processes running in a tree  
df -h    # Show disk usage (-h is human-readable)  
free -h  # Show memory usage  
du -sh /dir  # Show the disk usage of a specific directory  
```

### Package Management commands  
#### For **Debian-based systems** (like Ubuntu):  
```bash  
apt update  # Update package lists  
apt upgrade  # Upgrade all packages  
apt install package  # Install a package  
apt remove package  # Remove a package  
dpkg -i package.deb  # Install a .deb package manually  
dpkg -r package  # Remove a package  
dpkg -l  # List all installed packages  
```

#### For **Red Hat-based systems** (like CentOS, Fedora):  
```bash  
yum update  # Update packages  
yum install package  # Install a package  
yum remove package  # Remove a package  
rpm -ivh package.rpm  # Install an .rpm package manually  
rpm -qa  # List all installed packages  
```



### Process Management Commands  
```bash  
ps aux     # View all processes  
top        # Interactive process viewer  
htop       # Enhanced interactive process viewer (often pre-installed)  
kill PID   # Kill a process by PID  
killall processname  # Kill all instances of a process by name  
pkill -u username  # Kill all processes from a specific user  
nice -n 10 command  # Start a command with a priority (lower values = higher priority)  
renice -n 10 -p PID  # Change the priority of an existing process  
```

### System Monitoring and Logging Commands  
```bash  
dmesg | less  # View boot and kernel-related messages  
journalctl    # Query the systemd journal logs  
tail -f /var/log/syslog  # Follow system logs in real-time  
uptime        # Show how long the system has been running  
vmstat 5      # Display memory, CPU, and I/O statistics every 5 seconds  
iostat 5      # Display disk I/O statistics every 5 seconds  
```

### Network Management Commands  
```bash  
ping hostname_or_IP  # Test connectivity to another host  
nslookup hostname  # Query DNS for a host  
traceroute hostname  # Trace the route packets take to reach a host  
netstat -tuln  # Show open ports and connections  
ss -tuln       # Similar to netstat; show listening sockets and ports  
iptables -L    # View firewall rules  
firewalld-cmd --list-all  # View firewalld rules (CentOS/RedHat)  
curl url       # Transfer data from or to a server  
wget url       # Download files from the internet  
scp file user@remote:/path  # Securely copy files to a remote system  
```

## Network Firewalls vs. WAFs  
A WAF and a standard firewall are both firewalls, but they function in different ways.  
A standard firewall acts like a gatekeeper.  
Standard firewalls are designed to permit or deny access to networks.  
On the other hand, a WAF generally focuses on threats aimed at HTTP/HTTPS and other areas of the application, as you mentioned in your post.  
Additionally, WAFs run on different algorithms such as anomaly detection, signature-based, and heuristic algorithms.  
Therefore, it is best to place a standard firewall as the first layer of security and then place a WAF in front of the application servers in the DMZ zone.  

## Bash Parameter Expansion (Slicing/Substitution)  

Not to be confused with [parameter transformation](#bash-parameter-transformation).  
This does technically transform variables, but it serves a different purpose.  

Replace strings and variables in place with parameter expansion.  

### Slicing with Parameter Expansion
```bash  
name="John"  
echo "${name}"  
echo "${name/J/j}"    #=> "john" (substitution)  
echo "${name:0:2}"    #=> "Jo" (slicing)  
echo "${name::2}"     #=> "Jo" (slicing)  
echo "${name::-1}"    #=> "Joh" (slicing)  
echo "${name:(-1)}"   #=> "n" (slicing from right)  
echo "${name:(-2):1}" #=> "h" (slicing from right)  
echo "${food:-Cake}"  #=> $food or "Cake"  
length=2
echo "${name:0:length}"  #=> "Jo"  
# Cutting out the suffix  
str="/path/to/foo.cpp"  
echo "${str%.cpp}"    # /path/to/foo  
echo "${str%.cpp}.o"  # /path/to/foo.o  
echo "${str%/*}"      # /path/to  
# Cutting out the prefix  
echo "${str##*.}"     # cpp (extension)  
echo "${str##*/}"     # foo.cpp (basepath)  
# Cutting out the path, leaving the filename  
echo "${str#*/}"      # path/to/foo.cpp  
echo "${str##*/}"     # foo.cpp  

echo "${str/foo/bar}" # /path/to/bar.cpp  

str="Hello world"  
echo "${str:6:5}"   # "world"  
echo "${str: -5:5}"  # "world"  
```

### Substitution with Parameter Expansion
```bash  
${foo%suffix}   Remove suffix  
${foo#prefix}   Remove prefix  
${foo%%suffix}  Remove long suffix  
${foo/%suffix}  Remove long suffix  
${foo##prefix}  Remove long prefix  
${foo/#prefix}  Remove long prefix  
${foo/from/to}  Replace first match  
${foo//from/to}     Replace all  
${foo/%from/to}     Replace suffix  
${foo/#from/to}     Replace prefix  

src="/path/to/foo.cpp"  
base=${src##*/}   #=> "foo.cpp" (basepath)  
dir=${src%$base}  #=> "/path/to/" (dirpath)  
```

### Substrings with Parameter Expansion
```bash  
${foo:0:3}      # Substring (position, length)  
${foo:(-3):3}   # Substring from the right  
```

### Getting the Length of a String/Variable with Parameter Expansion  
```bash  
${#foo}        # Length of $foo  
```


## Bash Parameter Transformation  
`man://bash 1500`
Parameter transformation is a way to perform a transformation on a parameter before it is used.  
Syntax:  
```bash  
${parameter@operator}
```
Each operator is a single letter  

### Parameter Transformation Operators  
* `U`: Converts all lowercase letters in the value to uppercase.  
* `u`: Capitalizes only the first letter of the value.  
* `L`: Converts all uppercase letters in the value to lowercase.  
* `Q`: Quotes the value, making it safe to reuse as input.  
* `E`: Expands escape sequences in the value (like `$'...'` syntax).  
* `P`: Expands the value as a prompt string.  
* `A`: Generates an assignment statement to recreate the variable with its attributes.  
* `K`: Produces a quoted version of the value, displaying arrays as key-value pairs.  
* `a`: Returns the variable's attribute flags (like `readonly`, `exported`).  


### Multiple Parameter Transformation Operators  
You can use parameter transformation on multiple positional parameters or arguments  
at once by using `@` or `*`.  

When you use `${@}` or `${*}`, Bash treats each positional 
parameter (e.g., command-line arguments) one by one, applying the 
transformation to each.  
The output is a list with each item transformed according to the specified operator.  

If you use `${array[@]}` or `${array[*]}`, Bash applies the transformation to each element of the array, one by one. The result is also a list with each array item transformed individually.  

The final transformed output might go through word splitting (separating by spaces) 
and pathname expansion (turning wildcard characters like `*` into matching filenames) 
if enabled, so the result could expand further into multiple words or paths.  

Typically `*` will combine the parameters into one string, whereas `@` will split the  
parameters into an array.  

| Syntax       | Description           | Example Output (for `hello world bash`)   |
|--------------|-------------------------------------------------|--------------------  
| `${@^}` | Capitalizes each parameter                            | `Hello World Bash`
| `${*^}` | Capitalizes only the first letter of the combined string | `Hello world bash`
| `${@^^}`| Uppercases each parameter completely                  | `HELLO WORLD BASH`
| `${*^^}`| Uppercases the entire combined string                 | `HELLO WORLD BASH`
| `${@,}` | Lowercases the first character of each parameter      | `hello world bash`
| `${*,}` | Lowercases only the first character of the combined string | `hello world bash`
| `${@Q}` | Quotes each parameter individually                    | `'hello' 'world' 'bash'`
| `${*Q}` | Quotes the entire combined string                     | `'hello world bash'`

### Parameter Transformation Examples  

Parameter transformation on variables, arrays, and associative arrays:  
```bash  
# Example variable for demonstration  
var="hello world"  
array_var=("one" "two" "three")  
declare -A assoc_array_var=([key1]="value1" [key2]="value2")  

# U: Convert all lowercase letters to uppercase  
echo "${var@U}"        # Output: HELLO WORLD  

# u: Capitalize only the first letter  
echo "${var@u}"        # Output: Hello world  

# L: Convert all uppercase letters to lowercase  
var="HELLO WORLD"  
echo "${var@L}"        # Output: hello world  

# Q: Quote the value, safe for reuse as input  
echo "${var@Q}"        # Output: 'HELLO WORLD' (or "HELLO WORLD" depending on context)  

# E: Expand escape sequences (e.g., newline, tab)  
esc_var=$'hello\nworld'  
echo "${esc_var@E}"    # Output: hello  
                       #         world  

# P: Expand as a prompt string (useful for prompt formatting)  
PS1="[\u@\h \W]\$ "    # Set the prompt  
echo "${PS1@P}"        # Output: [user@host directory]$  

# A: Generate an assignment statement that recreates the variable  
echo "${var@A}"        # Output: declare -- var="HELLO WORLD"  

# K: Quoted version of the value, with arrays as key-value pairs  
echo "${array_var@K}"          # Output: 'one' 'two' 'three'  
echo "${assoc_array_var@K}"    # Output: [key1]="value1" [key2]="value2"  

# a: Display attributes of the variable (flags)  
declare -r readonly_var="test"  
echo "${readonly_var@a}"       # Output: r (indicates readonly)  
```

Examples of using parameter transformation with positional parameters and arrays  
using the `^` and `@` operators:  
```bash  
# Positional parameters example  
set -- "hello" "world"  
echo "${@^}"   # Each positional parameter capitalized: "Hello World"  

# Array example  
array=("one" "two" "three")  
echo "${array[@]^}"   # Capitalize each array element: "One Two Three"  

# Word splitting and pathname expansion example  
files=("file1.txt" "*.sh")  
echo "${files[@]^}"   # Expands "*.sh" to match any shell scripts in the directory  
```

## Handling Empty and Undefined Variables in Bash
The walrus operator `:=` is available in bash using the syntax:
```bash
"${foo:=default_value}"
```
This will only set `foo` if `foo` is either:
* Unset (variable doesn't exist yet)
* Empty (variable exists but has no value)

If `foo` is set to a value, then the `:=` operator will do nothing, and the value of
`foo` is returned. 

### Bash Walrus Examples
#### Assigning a Default Value
```bash
unset VAR
echo "${VAR:=default}"  # Output: default
echo "VAR"              # Output: default
```

A more practical example:
```bash
FILENAME="${1:=default_file.txt}"
echo "Processing ${FILENAME}"
```
This either take `$1` (the first argument) as the `FILENAME`, or if `$1` is empty, not set,
or doesn't exist, it will use `default_file.txt` as the value instead.  


#### Leaving a non-null value unchanged
```bash
VAR="Hello"
echo "${VAR:=default}"  # Output: Hello
echo "VAR"              # Output: Hello (does not change)
```

#### Handling an Empty Variable
```bash
VAR=""
echo "${VAR:=default}"  # Output: default
echo "VAR"              # Output: default (value is updated)
```



## Checking the Operating System with the `OSTYPE` Variable  
Use `OSTYPE` instead of `uname` for checking the operating system. 
* This is an environment variable. On Ubuntu Server (or any Linux distro), it will have the value `linux-gnu`.  
* This saves you from making an external call to the shell (with `uname`).  


## Patching Linux Systems  
How you go about patching/updating systems in Linux depends on if the node is  
stateful or stateless. 
* A stateful node retains its state, data, and specific configurations across session  
  and reboots.  
* A stateless node is ephemeral. This means that it does not retain state, data, or  
  configurations across sessions.  
    * Stateless nodes are easier to scale and redeploy with updated versions.  

### Updating Linux Boxes in Enterprise Environments  

* Stateful nodes need to be patched.  
    * This is because stateful nodes retain data and specific configurations that persist across reboots.  
* Updating and patching these nodes ensures security vulnerabilities are fixed and that software is up to date while maintaining the state and data.  
* Patching is crucial here since these nodes can’t simply be replaced without data loss or complex migration.  

* Stateless nodes typically aren’t patched directly.  
* Stateless nodes don’t retain data or configuration once they’re restarted or terminated; they’re often part of horizontally scaled environments (like microservices or containerized applications).  
* Instead of patching, stateless nodes are redeployed with a new image that includes all updates and patches.  
* This approach allows for easy replacement and minimizes downtime.  

---  

### System Update Strategy  
* Rolling Updates: For services that require high availability, rolling updates allow nodes to be updated in a staggered manner.  
    * This minimizes downtime by ensuring that some nodes remain available while others are updated.  
* Blue-Green Deployment: For stateless applications, a blue-green deployment can be used.  
    * Deploy the updated image to a “blue” environment while the “green” environment continues serving traffic.  
    * Once validated, switch all traffic to the blue environment.  
* Canary Releases: Deploy updates to a small subset of nodes initially to monitor for issues before rolling out to the full environment.  

### Scheduling System Updates  
* Non-Peak Hours: Schedule updates during off-peak hours to reduce the impact on end-users.  
* Maintenance Windows: Use designated maintenance windows approved by stakeholders to ensure updates do not interfere with critical operations.  

### Automating System Updates  
* Use configuration management tools like Ansible, Chef, or Puppet to automate patching and updating of stateful nodes.  
* For stateless nodes, use CI/CD pipelines to automate the creation and deployment of new images with the latest updates.  

### System Patching Compliance and Security:  
* Compliance: Regular updates are often required to maintain compliance with security standards (e.g., PCI-DSS, HIPAA).  
    * Ensure systems are patched according to these standards.  
* Vulnerability Management: Use tools like OpenSCAP or Lynis for vulnerability scanning to ensure updates address all known vulnerabilities.  
* Audit Logs: Keep detailed logs of updates and patches applied to ensure traceability and accountability for changes in the environment.  

### Testing System Updates:  
* Always test updates in a staging environment that mirrors production.  
    * This is to ensure compatibility and identify potential issues before applying them in production.  
* Have a rollback plan.  
    * For each update, have a rollback plan in case of failures, especially for stateful systems where data integrity is critical.  

### Updating Linux Boxes, tl;dr  
* Stateful nodes require patching due to their persistent state and data.  
* Stateless nodes are usually replaced with updated images, avoiding direct patching.  
* Automate and schedule updates to minimize impact and maintain consistency.  
* Ensure testing, compliance, and logging to meet enterprise standards and maintain system reliability.  



## Clear Cache, Memory, and Swap Space on Linux  

tl;dr:  
```bash  
echo 1 > /proc/sys/vm/drop_caches  # Clears only the PageCache. Frees memory used for caching file data. 
echo 2 > /proc/sys/vm/drop_caches  # Clears dentries and inodes. Releases memory used for filesystem metadata. 
echo 3 > /proc/sys/vm/drop_caches  # Clears all three types of caches.  
sync && echo 1 > /proc/sys/vm/drop_caches  # Clears Buffer Cache and PageCache 
swapoff -a && swapon -a  # Clear swap space (turn it off and on again)
```

---  

### Clearing PageCache and inode/dentry Caches 
Clearing cache, memory, and swap space on Linux is done with a special file:  
`/proc/sys/vm/drop_caches`

The `drop_caches` file is used to clean cache without killing any applications.  

This file is used by `echo`ing a number between `1` and `3` into the file.  
* Clear PageCache only:  
  ```bash  
  sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'  
  ```
    * The PageCache is the in-memory cache for storing file contents that are read from the disk.  
    * This speeds up file access by caching disk data in RAM.  
* Clear dentries and inodes:  
  ```bash  
  sudo sh -c 'echo 2 > /proc/sys/vm/drop_caches'  
  ```
    * The dentry (directory entry) cache is the directory-related metadata stored in  
      memory.  
        * This is used for navigating the system quickly without repeatedly  
          scanning the disk.  
    * The inode (index node) cache is the metadata for files and directories.  
        * This is used to quickly locate files and access metadata without scanning  
          the disk.  
* Clear all 3 (PageCache, dentries, and inodes):  
  ```bash  
  sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'  
  ```
    * This frees up memory but potentially impacting performance until caches are rebuilt.  

These commands do not delete data from the disk. These only release cached data 
that's kept in RAM to free up memory.  

### Clear Buffer Cache  

To clear the buffer cache, use `sync` before clearing the PageCache.  
```bash  
sudo sync && echo 1 > /proc/sys/vm/drop_caches  
```
This is both clears the PageCache and the buffer cache.  
* `sync`: Flushes the filesystem buffers to disk.  
    * It synchronizes cached writes to the disk.  



### Clearing Swap Space  
Swap space is a part of the HDD (or SSD) that is used as summplemetary RAM.  
Swap is FAR slower than RAM, so it's not a great practice to use a ton of it.  

To clear swap space, use `swapoff` and `swapon`:  
```bash  
sudo swapoff -a  
sudo swapon -a   
```

* `swapoff`: Disables swapping on a given device.  
    * `-a`: Disables swapping on all swap devices and files.  
* `swapon`: Used to specify devices to be used for paging and swapping.  
    * `-a`: All devices marked with `swap` in the `/etc/fstab` file will be enabled.  

Clearing swap space will not free up RAM.  
It only frees up space used for swap on the disk.  


### Buffer Cache vs PageCache  
* PageCache: Used to cache the contents of files on the disk into memory.  
    * Makes file access and R/W operations faster by storing the actual contents of a file in memory.  
    * When a process reads from a file, the data is loaded into the PageCache first,
      then all subsequent reads can pull directly from memory rather than needing to  
      access the disk.  
    * When a process requests data from a file, the system checks if it's already in  
      the PageCache (if it is, it's called a "cache hit").  
    * If it's a cache hit, it serves the data from memory.  

* Buffer Cache: Used to cache raw block data that is read from, or written to, the disk.  
    * Primarily used for I/O operations on the block level.  
    * Serves as temporary storage for data that is read from, or written to, disk sectors.  
    * Stores disk block and sector data, including low-level metadata about  
      filesystem structures, which the kernel needs to manage disk operations (superblocks, 
      inodes, dentries).  
    * Helps with filesystem metadata and block-level operations. Optimizes the  
      performance of low-level disk I/O operations by minimizing direct reads and  
      writes to disk.  


## OPNsense
OPNsense is an open-source firewall and routing software.  
It's based on FreeBSD and designed to provide advanced networking features while
still being easy to use and highly customizabale.  

Widely used for both home and enterprise networks.  

Easy, free, secure, and flexible.  

---

OPNsense is commonly used for:
* Home network firewalls
* Enterprise gateway firewalls
* VPN servers
* Content filtering
* Load balancing

---

Some of the features of OPNsense:
* Firewall and security:
    * Uses `pfSense`'s `pf` (packet fileter) for robust and efficient packet filtering.  
    * Supports statful packet inspection; tracks the state of connections and applies
      rules accordingly.  
    * Supports VPNs; Includes options for setting up OpenVPN, IPsec, and WireGuard VPNs.  
* Has a web-based interface:
    * The entire configuration is managed through a web interface.  
    * Provides graphs, dashboards, and real-time monitoring of system and network activity/performance.  
* Advanced routing options:
    * Supports static and dynamic routing protocols.  
        * OSFP, BGP, OSPF, RIP, RIPng, IS-IS, EIGRP, PIM, and HSRP.
    * Can function as a gateway for complex network setups.  
* Plugins and extensibility:
    * OPNsense includes a plugin system that allows for third-party software
      extensions to be installed and managed.  
        * Intrusion Detection/Prevention (IDS/IPS) with tools like Suricata
        * Proxy server for content filtering anc caching.  
        * Dynamic DNS support.  
    * You can extend functionality to meet enterprise-grade needs or specific home
      network needs.  
* Hardware compatibility
    * Runs on x86 hardware, making it compatible with many devices, including
      embedded systems.  
    * Available as an image for VMs.  

## Creating a Partition Table on a Disk using `parted`
`parted` is a command-line utility for partitioning disks.  

Example disk: `/dev/sdb`
```bash
parted /dev/sdb
# Now we're in the interactive prompt for parted

# Create the partition tabel
mklabel gpt
# Or, for older MBR systems:
mklabel msdos
 
# Create a partition using 100% of the disk
mkpart primary 0% 100%
 
# Verify the partition
print
 
# Quit parted
quit
```
* `mkpart primary 0% 100%`
    * `mkpart`: Make partition. Creates a new partition on the disk.  
    * `primary`: Specify the type of partition.   
    * `0%`: Start point. Starts at the beginning of the disk.  
    * `100%`: End point. Ends at the end of the disk.  


## Scriptable Way to Partition Disks with `fdisk`/`gdisk`
Send input to `fdisk` (or `gdisk`) without entering the interactive prompt by using a
pipe to send input to the program.  
```bash
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/sda
```
1. `echo -e "o\nn\np\n1\n\n\nw"`: This line is sending a series of commands
    to `fdisk` as follows:
    * `o`: Delete all partitions and create a new empty DOS partition table.
    * `n`: Add a new partition.
    * `p`: Makes the new partition primary.
    * `1`: Specifies it as partition number 1.
    * The three blank lines (`\n`) give the default start and end values, i.e., use the entire disk.
    * `w`: Writes the changes and exits fdisk .
    * `\n`: Each `\n` is a linebreak, same as pressing Enter in the interactive prompt.  

2. `|` : Pipe. It takes the output from the previous command (`echo`) and sends it as input to the next command (`fdisk`).

3. `fdisk /dev/sda`
    * `fdisk` is a command line utility used to create and manipulate disk partition tables.
    * `/dev/sda` specifies the first hard disk.

* This command will delete all partitions on the first hard disk and create a new primary partition that uses the whole disk.

## Wipe Existing Data on a Disk or Parition
You can use `dd` to wipe a disk by overwriting the disk.  
```bash
sudo dd if=/dev/zero of=/dev/sdb1 bs=1M count=100
```
This can wipe a disk or wipe a partition.  
Adjust the count to roughly match the size of the disk or partition you want to wipe.  


## Testing a Disk for Errors using `smartctl`
`smartctl` is a command line utility that can be used to test a disk for errors.  
```bash
smartctl -a /dev/sda            # Show all SMART info about the disk
smartctl -t short /dev/sda      # Start a quick test (~2 minutes, runs in background)
smartctl -l selftest /dev/sda   # View test results
 
smartctl -t long /dev/sda       # Run a full test (takes a long time)
smartctl -l selftest /dev/sda   # View test results 
```



## Special Files to Get Bits: Zero, Random or Random 0/1
* `/dev/zero` : returns zero
* `/dev/random` : returns random
* `/dev/urandom` : returns random 0 or 1


## Setting up ClamAV Antivirus
###### [source](https://killercoda.com/het-tanis/course/Linux-Labs/105-install-antivirus)
ClamAV is an open-source antivirus engine for detecting trojans, viruses, malware, and other malicious threats.
It is mostly used on Linux and Unix systems.  

ClamAV is in the `apt` package repository, for Debian-based systems.  
```bash
sudo apt update 
sudo apt install clamav clamav-daemon
```
* `clamav`: The main ClamAV package.
* `clamav-daemon`: The ClamAV daemon.  

To manually update the database, stop `clamav-freshclam` and run `freshclam`.  
```bash
sudo systemctl status clamav-freshclam
sudo systemctl stop clamav-freshclam
freshclam
sudo systemctl start clamav-freshclam --now
```

Run a scan against a directory, and time it:
```bash
time clamscan -i -r --log=/var/log/clamav/clamav.log /home/
```
* `-i`/`--infected`: Only show infected files.  
* `--remove`: Automatically remove infected files.  
* `-r`/`--recursive`: Recursively scan directories.  

### Automate Scans 
Set up a script to run scans daily.  
```bash
#!/bin/bash
# Set your logfiles
DAILYLOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log";
LOGFILE="/var/log/clamav/clamav.log";

# Scan the entire system from root
clamscan -ri / &> "$LOGFILE"

# Copying to daily log file for history tracking
cp $LOGFILE $DAILYLOGFILE

# Gather Metrics to use later
scanDirectories=`tail -20 $DAILYLOGFILE | grep -i directories | awk '{print $NF}'`
scanFiles=`tail -20 $DAILYLOGFILE | grep -i "scanned files" | awk '{print $NF}'`
infectedFiles=`tail -20 $DAILYLOGFILE | grep -i infected | awk '{print $NF}'`
runTimeSeconds=`tail -20 $DAILYLOGFILE | grep -i time | awk '{print $2}' | awk -F. '{print $1}'`

# Report out what metrics you have
echo "Directories: $scanDirectories Files: $scanFiles Infected: $infectedFiles Time: $runTimeSeconds"
 
exit 0
```
To run the script daily:
* Copy the script into `/etc/cron.daily/`
* Set it to run in the `crontab` (cron table)
  ```bash
  crontab -e
  # Then add the line:
  0 1 * * * root /path/to/script
  ```

## Format Drives and Create Partitions
Format drives and create disk partitions using `gdisk`.  
```bash
sudo gdisk /dev/sdX
o  # Create a new empty GPT partition table
n  # Create a new partition
p  # Make it the primary partition
# Use defaults
w  # Write changes (otherwise they won't be applied)
```
If you want to create a partition of a specific size, then when it prompts for the
`Last sector`, you can specify a specific size, like `+100G` for a 100GB partition.  



