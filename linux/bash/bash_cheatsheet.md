

# Linux Command Cheatsheet  

## Table of Contents
* [CLI Tools to Become Familiar With](#cli-tools-to-become-familiar-with) 
* [Tools to Check Out for Networking/Admin](#tools-to-check-out-for-networkingadmin) 
* [CDPATH](#cdpath) 
* [Miscellaneous Useful Commands](#miscellaneous-useful-commands) 
* [Check which version of linux is running](#check-which-version-of-linux-is-running) 
* [Hiding Text when Getting User Input with `read`](#hiding-text-when-getting-user-input-with-read) 
* [SCP](#scp) 
    * [SCP Commands](#scp-commands) 
    * [SCP Options](#scp-options) 
* [Duplicating File Descriptors](#duplicating-file-descriptors) 
    * [Redirect Stderr to Stdout](#redirect-stderr-to-stdout) 
* [Check how much memory is being used](#check-how-much-memory-is-being-used) 
* [Check CPU usage](#check-cpu-usage) 
* [Check which processes are executing on the processor](#check-which-processes-are-executing-on-the-processor) 
* [Check network usage and load of the system](#check-network-usage-and-load-of-the-system) 
* [Check Running Processes](#check-running-processes) 
* [Give a user full sudo access](#give-a-user-full-sudo-access) 
    * [Rule of Least Privilege](#rule-of-least-privilege) 
* [Expansion via Indirection](#expansion-via-indirection) 
    * [Using Indirection with Arrays (Lists) and Associative Arrays (Dictionaries)](#using-indirection-with-arrays-lists-and-associative-arrays-dictionaries) 
* [Using Grep](#using-grep) 
    * [Alternation (matching any one of multiple expressions)](#alternation-matching-any-one-of-multiple-expressions) 
* [Using tput](#using-tput) 
    * [`tput` Examples](#tput-examples) 
* [Control Sequences](#control-sequences) 
* [Heredocs in Linux](#heredocs-in-linux) 
    * [Basic Principles of Here Documents](#basic-principles-of-here-documents) 
    * [Example](#example) 
* [Check which sudo commands a user has access to](#check-which-sudo-commands-a-user-has-access-to) 
* [Replacing All Occurrences of a String in Multiple Files](#replacing-all-occurrences-of-a-string-in-multiple-files) 
* [Finding Files](#finding-files) 
    * [The `find` Command](#the-find-command) 
    * [Testing Files with `find`](#testing-files-with-find) 
    * [Testing Timestamps of Files with `find`](#testing-timestamps-of-files-with-find) 
* [The Three Timestamps Explained](#the-three-timestamps-explained) 
    * [`find` Options](#find-options) 
    * [Global Options](#global-options) 
* [Run a Script when Any User Logs Into the System](#run-a-script-when-any-user-logs-into-the-system) 
* [Important Linux Commands](#important-linux-commands) 
    * [User and Group Management](#user-and-group-management) 
    * [Network Configuration and Monitoring](#network-configuration-and-monitoring) 
    * [Process Management](#process-management) 
    * [Package Management](#package-management) 
    * [System Information](#system-information) 
        * ["others"](#others) 
* [Get or Increase the Limit of Open Files](#get-or-increase-the-limit-of-open-files) 
* [Recursively Get or Search Files](#recursively-get-or-search-files) 
* [Using Netcat](#using-netcat) 
    * [Listening on Ports](#listening-on-ports) 
    * [Transferring Files](#transferring-files) 
    * [Timezone change](#timezone-change) 
* [Colored output for `less`](#colored-output-for-less) 
* [Using `xargs` to Transform Input into Arguments](#using-xargs-to-transform-input-into-arguments) 
* [Numeric Calculations & Random Numbers](#numeric-calculations--random-numbers) 
* [Get the Directory of a Script](#get-the-directory-of-a-script) 
* [Search Terms for Bash Man Page](#search-terms-for-bash-man-page) 
* [Definitions](#definitions) 
* [Terminal Colors](#terminal-colors) 
    * [256-colors](#256-colors) 
* [SSH Logs and Processes](#ssh-logs-and-processes) 
* [Cron, Cronjobs & Crontabs](#cron-cronjobs--crontabs) 
* [File and Directory Permissions](#file-and-directory-permissions) 
* [Disable Shellcheck From Within Shell Scripts](#disable-shellcheck-from-within-shell-scripts) 
* [Check if an argument is empty](#check-if-an-argument-is-empty) 
* [Check if a File Exists or is Larger Than 0 Bytes](#check-if-a-file-exists-or-is-larger-than-0-bytes) 
* [Get Command Locations, Binaries, and Aliases](#get-command-locations-binaries-and-aliases) 
* [Using `find`](#using-find) 
    * [Exclude files using `find`](#exclude-files-using-find) 
* [Getting Help With Commands](#getting-help-with-commands) 
* [Trapping Errors](#trapping-errors) 
* [Source Relative Files](#source-relative-files) 
* [Changing the system's hostname](#changing-the-systems-hostname) 
* [Stream Manipulation w/ `awk`, `grep`, and `sed`](#stream-manipulation-w-awk-grep-and-sed) 
* [Compare Files](#compare-files) 
* [Loops](#loops) 
* [Getting Options and Arguments](#getting-options-and-arguments) 
* [Options](#options) 
* [Glob Options](#glob-options) 
* [Functions & Scripts](#functions--scripts) 
* [Returning Values](#returning-values) 
* [Raising Errors](#raising-errors) 
* [Special Arguments/Parameters](#special-argumentsparameters) 
* [Arrays in Bash](#arrays-in-bash) 
* [List-like Arrays & String Manipulation/Slicing](#list-like-arrays--string-manipulationslicing) 
* [Dictionaries (Associative Arrays)](#dictionaries-associative-arrays) 
* [Process Substitution in Bash](#process-substitution-in-bash) 
    * [Overview](#overview) 
    * [Syntax](#syntax) 
    * [How It Works](#how-it-works) 
    * [Examples](#examples) 
* [Process Substitution](#process-substitution) 
* [Transforming Strings with `tr`](#transforming-strings-with-tr) 
    * [Arguments](#arguments) 
    * [Character Classes](#character-classes) 
* [All Bash Conditional Flags](#all-bash-conditional-flags) 
        * [Arithmetic Operators](#arithmetic-operators) 
* [Interpreter Order of Operations](#interpreter-order-of-operations) 
* [Parameter Expansion (Slicing/Substitution)](#parameter-expansion-slicingsubstitution) 
    * [Slicing](#slicing) 
    * [Substitution](#substitution) 
    * [Substrings](#substrings) 
    * [Getting the Length of a String/Variable](#getting-the-length-of-a-stringvariable) 
* [PS1, PS2, PS3, and PS4 Special Environment Variables](#ps1-ps2-ps3-and-ps4-special-environment-variables) 
    * [PS1](#ps1) 
    * [PS2: Secondary Prompt String](#ps2-secondary-prompt-string) 
    * [PS3: Prompt String for select](#ps3-prompt-string-for-select) 
    * [PS4: Debug Prompt String](#ps4-debug-prompt-string) 
* [Get bits: Zero, random or random 0/1](#get-bits-zero-random-or-random-01) 
* [SysAdmin Relevant - Firewall and Network commands](#sysadmin-relevant---firewall-and-network-commands) 
* [Redirecting Standard Output AND Standard Error](#redirecting-standard-output-and-standard-error) 
* [Getting IP and Network Information](#getting-ip-and-network-information) 
    * [Show routing information](#show-routing-information) 
    * [Show network interfaces](#show-network-interfaces) 
    * [Show IP Address of the current machine](#show-ip-address-of-the-current-machine) 
* [Get the Full Path of the Current Script](#get-the-full-path-of-the-current-script) 
* [rmdir](#rmdir) 
* [BASH_REMATCH](#bash_rematch) 


## CLI Tools to Become Familiar With  
* xclip  
* npv/nvp # sound clips, pulse audio  
* ESXi  
* Ncdu  
* pandoc  
* ffmpeg  
* tar  
* parallel (GNU Parallel)  
* awk  
* sed  
* top  


## Tools to Check Out for Networking/Admin:  
* `pfsense` - A tool for authentication  
* `ss -ntulp` - system information  
* `OpenSCAP` - benchmarking tool  
* `nmap` - maps the server if you don't have permissions  
    * Good for external mapping without permissions  
* `ss` or `netstat` are internal with elevated permissions for viewing  
    * Used locally with elevated permissions, it's better than `nmap`?  

## CDPATH  

`CDPATH`: The search path for the `cd` command.  
This is a colon-separated list of directories.  
The shell looks for destination directories for `cd` using this list.  
 
Example:  
```bash
export CDPATH='.:~:/usr'
```

* Once the `CDPATH` is set, the `cd` command will search only in the directories
  present in the `CDPATH` variable.  
* More details at [The Unix School](https://www.theunixschool.com/2012/04/what-is-cdpath.html)  



## Miscellaneous Useful Commands  
cht.sh - cheat sheet website for curling anything  

* `xxd` - hex dumping / reversing hex dumps  
* `ncal` - View a command-line calendar  
* `ps aux | grep ssh` - List all processes containing "ssh" in their names.  
* `who` - List of users currently logged in, along with their usernames, terminal devices, 
          login times, and IP addresses (`pts` means SSH sessions)  
* `w` - Similar to `who`, with more details (load avg, system uptime)  
* `free -h` - Get amount of memory being used, and how much is free  
* `inotify` - Monitoring filesystem events  
    * `inotify-tools` extends the capabilities of this 

---  

## Check which version of linux is running  
The command to check which version of Linux is running:  
```bash  
# Check linux version  
cat /etc/*release  
```
To check which version of kernel is running:  
```bash  
# Check kernel version  
uname -r  
```

---

## Hiding Text when Getting User Input with `read`
Hide user input while they're typing:
```bash
read -r -s -p "Enter your password: " PASSWORD
```
* `-s`: Stops keyboard input from being printed to the terminal (silent).  
* `-r`: Stops backslashes (`\`) from escaping anything.  
* `-p "prompt"`: The prompt. 

This will act like sudo password input.
No text will be output to the terminal while the user is typing.


To output a `*` for each character the user types:
```bash
unset password;
while IFS= read -r -s -n1 pass; do
  if [[ -z $pass ]]; then
     echo
     break
  else
     echo -n '*'
     password+=$pass
  fi
done
```
* `-n1`: Returns the `read` after every 1 character instead of waiting for a newline (Enter).  



---

## SCP
Usage: `scp <options> source_path destination_path`  

### SCP Commands
```bash
# copying a file to the remote system using scp command
$ scp file user@host:/path/to/file                        
# copying a file from the remote system using scp command
$ scp user@host:/path/to/file /local/path/to/file         
 
# copying multiple files using scp command
$ scp file1 file2 user@host:/path/to/directory            
# Copying an entire directory with scp command
$ scp -r /path/to/directory user@host:/path/to/directory  
```

### SCP Options
```bash
-r      # transfer directory 
-v      # see the transfer details
-C      # copy files with compression
-l 800  # limit bandwith with 800
-p      # preserving the original attributes of the copied files
-P      # connection port
-q      # hidden the output
```

---  

## Duplicating File Descriptors  
You can redirect file descritors to other file descriptors.  
This effectively combines two file descriptors into one.  

* The redirection operator  
  ```bash  
  [n]<&word  
  ```
  is used to duplicate input file descriptors.  
    * If `word` expands to one or more digits, the file descriptor denoted by `n`
      is made to be a copy of that file descriptor.  
    * If the digits in word do not specify a file descriptor open for 
      input, a redirection error occurs.  
    * If word evaluates to `-`, file descriptor `n` is closed.  
    * If `n` is not specified, the standard input (file descriptor `0`) is used.  

* The operator  
  ```bash  
  [n]>&word  
  ```
  is used similarly to duplicate output file descriptors.  
    * This effectively "attaches" file descriptor `n` to the file or device 
      specified by `word`.  
    * If `n` is not specified, the standard output (file descriptor `1`) is used.  
    * If the digits in `word` do not specify a file descriptor open for  
      output, a redirection error occurs.  
    * If word evaluates to `-`, file descriptor `n` is closed.  
    * As a special case, if `n` is omitted, and word does not expand to one or more 
      digits or `-`, the standard output and standard error are redirected  
      as described previously.  

### Redirect Stderr to Stdout  
```bash  
cat file 2>&1  
```
This command redirects the standard error (`stderr`) to the standard output (`stdout`).  


---  


## Check how much memory is being used  
To check RAM usage:  
```bash  
var=$(free -h | grep Mem | awk '{print $3}')  # This is how much RAM is being used  
# Or, simply:  
vmstat 1 5  
```
To check swap usage:  
```bash  
free -h | grep Swap | awk '{print $3}'  # How much swap is being used  
```


---  


## Check CPU usage  
To check how much CPU power is being used:  
```bash  
# Checking CPU usage  
mpstat 1 5  
```

---  

## Check which processes are executing on the processor  
Check CPU usage for each process:  
```bash  
# Check process cpu usage  
pidstat 1 5  
```

---  

## Check network usage and load of the system  
Check the network usage of the system, and check the load of the system:  
```bash  
sar -n DEV 1 5  
```

Check TCP packets and errors:  
```bash  
sar -n TCP,ETCP 1 5  
```

---  

## Check Running Processes  
See what processes are running on the system:  
```bash  
ps -ef  
```
* `-e`: Show every process on the system  
* `-f`: Show full command lines (full-format listing)  
    * Causes the command arguments to be printed.  
    * `-F` is Extra-full-format.  

---  

## Give a user full sudo access  
You can add them directly to the `/etc/sudoers` file.  
Or, you can add them to their own files in `/etc/sudoers.d/`
```bash  
usermod -G 
```
* **NOTE:** in the `/etc/sudoers` file, lines starting with one hash `#` are **NOT COMMENTS.** 
Those lines are **NOT** ignored (see `man sudoers(5)`).  
The lines need to have two `##` in order to be comments  

### Rule of Least Privilege  
* The "rule of least privilege" is to give only the minimum access needed to a user.  
    * Also called the "principle of least privilege."  

```bash  
cat /etc/sudoers  
```

---  

## Expansion via Indirection  
In Bash, the `!` character is used to expand a variable name to its value.  
This is known as "expansion via indirection."  

```bash  
VARIABLE_NAME="world"  
greeting="VARIABLE_NAME"  
 
echo ${!greeting} 
# outputs: world  
```
So `greeting` holds a string, which is the name of the 
variable (`VARIABLE_NAME`) that holds the value (`world`).  

### Using Indirection with Arrays (Lists) and Associative Arrays (Dictionaries)  

This can be used on arrays (lists) and associative arrays (dictionaries) as to  
access the keys or values of all elements:  
* Indirection with arrays (lists):  
    * Using indirection on a list will return the indices of all elements in the list.  
    * ```bash  
      FRUITS=('Apple' 'Banana' 'Orange') && echo ${!FRUITS[@]}  
      # outputs: Keys of all elements, space-separated 
      0 1 2
      ```

* Indirection with associative arrays (dictionaries):  
    * Using indirection on a dictionary will return the keys of each 
      element in the dictionary.  
    * ```bash  
      declare -A sounds  
      sounds[dog]="bark"  
      sounds[cow]="moo"  
      sounds[bird]="tweet"  
      sounds[wolf]="howl"  
      echo "${!sounds[@]}"  
      # outputs: All keys in the dictionary  
      ```

---  
 

## Using Grep  
See [grep](../tools/grep.md).  
* Print lines that match patterns.  
The greps:  
```bash  
grep  
egrep  
fgrep  
rgrep 
```
* `grep` uses "basic regex" by default.  
* `grep -E` enables "extended regex."  
    * Basic vs Extended Regular Expressions:  
        * In basic regular expressions the meta-characters 
          `?`, `+`, `{`, `|`, `(`, and `)` lose their special meaning. 
        * You need to escape them to get the functionality:  
          `\?`, `\+`, `\{`, `\|`, `\(`, and `\)`.  
### Alternation (matching any one of multiple expressions)  
Two regular expressions can be joined by the "infix" operator,  `|;`.  
The resulting regular expression matches any string matching either alternate expression.  


---  

## Using tput  
Using `tput`, you can to get terminal information or manipulate the terminal.  
i.e., `tput` can get or set various terminal capabilities.  

### `tput` Examples  
* Get the number of columns for the current terminal instance  
    * ```bash  
      tput cols  
      ```
* Clear the screen and send the sequence to move the cursor to 
  row 0, column 0 (the upper left corner of the screen).  
    * ```bash  
      tput clear  
      tput cup 0 0  
      ```
* Send the sequence to move the cursor to row 23, column 4.  
    * ```bash  
      tput cup 23 4  
* Set the shell variables bold, to begin `stand-out mode` sequence,
  and offbold, to end `stand-out mode` sequence, for the current terminal.  
    * ```bash  
      bold=`tput smso` offbold=`tput rmso`
      ```
    * `smso` - set mode stand-out (bold)  
    * `rmso` - remove mode stand-out (bold)  


---  


## Control Sequences  
Also known as "escape codes" or "escape sequences."  
| Control Sequence | Produces              |
|------------------|-----------------------|
|       `\n`       |    newline            |
|       `\l`       |    line-feed          |
|       `\r`       |    return             |
|       `\t`       |    tab                |
|       `\b`       |    backspace          |
|       `\f`       |    form-feed          |
|       `\s`       |    space              |
|  `\E` and `\e`   | escape character      |
|      `^x`        |`control-x` (`x`=char) |


---  


## Heredocs in Linux  
See `./tools/heredocs.md`
### Basic Principles of Here Documents  
You can use here documents on the command line and in scripts.  
Heredocs can shove standard input(`stdin`) into a command  
from within a script.  
```bash  
COMMAND << limit_string  
data  
variables  
text  
limit_string  
```

* `COMMAND`: This can be any Linux command that accepts redirected input.  
    * Note, the `echo` command doesn't accept redirected input.  
    * If you need to write to the screen, you can use the `cat` command, which does.  
* `<<`: The redirection operator.  
* `limit_string`: This is a label.  
    * It can be whatever you like as long as it doesn't appear 
      in the list of data you're redirecting into the command.  
    * It is used to mark the end of the text, data, and variables list.  
* Data List: A list of data to be fed to the command.  
    * It can contain commands, text, and variables.  
    * The contents of the data list are fed into the command one  
      line at a time until the `limit_string` is encountered.  

### Example  
```bash  
#!/bin/bash  
cat << "_end_of_text"  
Your user name is: $(whoami)  
Your current working directory is: $PWD  
Your Bash version is: $BASH_VERSION  
_end_of_text  
```
The output of the `whoami` cmd will be printed, since it  
was run in a subshell.  


---  

## Check which sudo commands a user has access to  
Check which sudo commands are available to the current user:  
```bash  
sudo -l  
```

Check which sudo commands are availabe for a different user:  
```bash  
sudo -l -U user  
```

---  
## Replacing All Occurrences of a String in Multiple Files  
`grep -rl "oldstring" *.txt | xargs sed -i 's/oldstring/newstring/g'` - Replace a string in multiple files  
* `grep -r`ecursively, `-l`ist files that have a match  
* `sed` changes file `-i`n-place  

---  

## Finding Files  
* `tree -I '.git'` - Tree view of current directory and subdirectories.  
    * -I(gnore) the `.git` directory.  
* `ls -I '.git'` - List current directory.  
    * -I(gnore) the `.git` directory.  
* `ls -I '.git' **/*.md` - List all markdown in current directory and subdirectories.  
    * -I(gnore) the `.git` directory.  

### The `find` Command  
The king: `find`. Has 5 "main" arguments.  
`-H`, `-L`, `-P`, `-D` and `-O` must appear before the first path name if used.  
You can specify the type of regex used with `-regextype` (`find -regextype help`)  


### Testing Files with `find`
There are a ton of tests available to `find`.  
```bash  
find -name "*.md" -not -path "./directory/*"    # Find .md files not in `directory`
find -name "*.md" \! -path "./directory/*"      # Same as above  
 
find . -type d -o -name '*.txt'                 # Find any .txt files or directories  
 
find . -type f -a -name '*.py'                  # Find files ending with .py  
find . -type f -name '*.py'                     # Same as above (-a is optional)  
```


### Testing Timestamps of Files with `find`
For testing the timestamps on files:  
* `-daystart`: Measure times from the  beginning of today rather than from 24 hours ago.  
(for `-amin`, `-atime`, `-cmin`, `-ctime`, `-mmin`, and `-mtime`)  

|   **Option**  |  **Timestamp Tested**              |
|---------------|------------------------------------|
|   `-amin  ±n` |   Access Time in Minutes           | 
|   `-atime ±n` |   Access Time in Days              | 
|   `-cmin  ±n` |   Status Change Time in Minutes    | 
|   `-ctime ±n` |   Status Change Time in Days       |
|   `-mmin  ±n` |   Modification Time in Minutes     | 
|   `-mtime ±n` |   Modification time in Days        |  

* `±`: Plus or Minus - `n` can be positive or negative.  
    * `-amin +5`: Finds files accessed **MORE** than `5` minutes ago.  
    * `-amin -5`: Finds files accessed **LESS** than `5` minutes ago.  
    * `-amin 5`: Finds files accessed **EXACTLY** `5` minutes ago.  

* `stat {file}` will show all three of `{file}`'s timestamps.  
## The Three Timestamps Explained  
* Access Time (`atime`):  
    * This timestamp is updated when the contents of a file are read by any command or application.  
* Modification Time (`mtime`):  
    * This timestamp is updated when the file's content is modified.  
    * If you edit a file and save changes, its modification time is updated.  
    * It does not change when the file's metadata (like permissions or ownership) are changed.  
* Change Time (`ctime`):  
    * Often confused with the modification time, the change time is updated when the  
      file's **metadata** *or* **content** is changed.  
    * This includes changes to the file's **permissions,** **ownership,** and **content.**  
    * It's important to note that `ctime` is not the creation time of the file.  
        * Unix and traditional Linux filesystems do not store the creation time of a file.  

* `stat {file}` will show all three of `{file}`'s timestamps.  
* Modification Time: `ls -lt` will list files with their modification times.  
* Access Time: Use `ls --time=atime -lt` to list files with access times.  
* Change Time: Use `ls --time=ctime -lt` to list files with change times.  
 
### `find` Options  
### Global Options  
* `-depth`: Process each directory's contents before the directory itself.  
    * `-d`: POSIX-compliant `-depth`
    * The `-delete` action also implies `-depth`.  
* `-ignore_readdir_race`: `find` won't give an error message when it fails to `stat` a file.  
    * `-noignore_readdir_race`: Turns off the effect of `-ignore_readdir_race`.  
* `-maxdepth levels`: Descend at most `levels` levels of directories below the starting points.  
* `-mindepth levels`: Don't apply any tests or actions at levels less than `levels`.  
* `-mount`: Don't descend directories on other filesystems.  
    * An alternate name for `-xdev`, for compatibility with some other versions of `find`.  
* `-noleaf`: Don't optimize by assuming that directories contain 2 fewer subdirectories than their hard link count (`.` and `..`).  
    * This option is needed when searching filesystems that don't follow the Unix 
      directory-link convention, like CD-ROM or MS-DOS filesystems or AFS volume mount points.  
* `-path pattern`: File name matches shell pattern `pattern`.  
    * The metacharacters do not treat  `/'  or  `.' specially; so, for example,
    ```bash  
    find . -path "./sr*sc"  
    ```
    will print an entry for a directory called `./src/misc`.  

* `-follow`: Deprecated - use `-L` instead  
* `-help` / `--help`: help.  



## Run a Script when Any User Logs Into the System  
To run a script automatically when ANY user logs in, 
add it to the `/etc/profile` file, or add it as a 
shell (`.sh`) script in the `/etc/profile.d/` directory.  
* `/etc/profile` is a POSIX shell script.  
```bash  
# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))  
# Add anything here to be run at 
printf "%s: %s" "$DATE" "$USER" >> /home/kolkhis/userlogs.log  
# This will timestamp the current user in userlogs.log  
```

* `/etc/profile.d/` is a directory containing `.sh` scripts.  
  Add a script here and it will be run when any user logs in.  
```bash  
#!/bin/sh  
printf "%s: %s" "$DATE" "$USER" >> /home/kolkhis/userlogs.log  
```

## Important Linux Commands  
### User and Group Management  
```bash  
passwd      # Change user password  
useradd     # Create user accounts  
userdel     # Delete user accounts  
usermod     # Modify user accounts  
groupadd    # Create user group  
groupdel    # Delete user group  
groups      # Get user groups  
id          # Get user ID information  
```

### Network Configuration and Monitoring  
```bash  
ifconfig  
ip  
ping  
netstat  
ss  
traceroute  
ssh  
nc  
```
### Process Management  
```bash  
ps  
top  
kill  
killall  
pstree  
htop  
```
### Package Management  
```bash  
apt-get  
apt  
yum  
dnf  
rpm  
dpkg  
snap  
zyper  
```

### System Information  
```bash  
uname   # Get system info (OS/kernel type by default)  
df      # Get filesystem information  
du      # Get disk usage  
free    # Get RAM/swapfile information  
lscpu   # Get CPI information  
lshw    # Get all system information  
lsblk   # Get information about block devices (storage devices) as a tree
fdisk -l # Get more detailed information about block devices 
ulimit  # Get current settings about current system limits & more  
mount   # List mounted filesystems, or mount a filesystem
```

#### "others"  
```bash  
mdir  
gedit  
```


## Get or Increase the Limit of Open Files  
There are soft limits and hard limits:  
* Soft limits are the currently enforced limits  
* Hard limits are the max value that can't be passed by setting the soft limit.  
Getting the current max file limit:  
```bash  
ulimit -a  
```
Set Open Files limit for the current shell:  
```bash  
ulimit -n 2048  # Set to 2048 for the current shell  
```
Note that this only sets it for the current shell and doesn't persist.  
To make it persist, you can either add the above command to `.bashrc`, 
or try:  
```bash  
someUser hard nofile 2048  
su - someUser  
```
By default, these limits are usually in `/etc/security/limits.conf`,  
and the default limits can be set there.  


## Recursively Get or Search Files  
To add a filename on each line, either `ls -1` or `find` can be used.  
I don't think there's a way to recursively search with `ls` without  
`set -o globstar` enabled.  
Get all markdown files in pwd and all subdirectories:  
```bash  
ls -1 **/*.md  # with `set -o globstar` enabled  
find . -type f -name '*.md' # 
```

## Using Netcat  
Netcat is often referred to as the "Swiss army knife" of networking tools.  
It can function as a simple client and server for TCP or UDP connections.  
### Listening on Ports 
* `nc -l 2389`: Launches netcat to listen for incoming 
  connections on port 2389  
### Transferring Files  
* `netcat` can be used to transfer files between two 
  computers by setting up one as a listener and another as a sender.  


### Timezone change  
* Get timezone for system:  
    * `timedatectl`
* Find your timezone:  
    * `timedatectl list-timezones`
* Change timezone for system:  
    * `timedatectl set-timezone America/New_York`


## Colored output for `less`
Kinda janky, and only displays in red, but red is easier to read.  
```bash  
man bash | grep --color=always -e '.*' | less -R  
```



## Using `xargs` to Transform Input into Arguments  
`xargs`: transform standard input (stdin) into arguments.  
```bash  
find . -name d | echo  # won't print anything because it doesn't take stdin as args  
find . -name d | xargs echo  # Will print the output of the `find` command.  
```

## Numeric Calculations & Random Numbers  
Numeric calculations can be done in a subshell in parentheses.  
```bas  
$((a + 200))      # Add 200 to $a  
$(($RANDOM%200))  # Random number 0..199  
declare -i count  # Declare as type integer 
count+=1          # Increment  
```

## Get the Directory of a Script  
```bash  
dir=${0%/*}
```

## Search Terms for Bash Man Page  
`man bash`  
* /pathname expansion  
* /pattern matching  
* /coprocesses (`coproc`)  
* /redirection  


## Definitions  
The following definitions are used throughout the `bash` man page.  
* `blank`: A space or tab.  
* `word`: A sequence of characters considered as a single unit by the shell.  
          Also known as a token.  
* `name`: A word consisting only of alphanumeric characters and underscores, and  beginning  with  
          an alphabetic character or an underscore.  Also referred to as an identifier.  
* `metacharacter`: 
    A character that, when unquoted, separates words.  One of the following:  
    ```bash  
    |  & ; ( ) < > space tab newline  
    ```
* `control operator`: 
    A token that performs a control function.  It is one of the following symbols:  
    ```bash 
    || & && ; ;; ;& ;;& ( ) | |& <newline>  
    ```



## Terminal Colors  

### 256-colors  
38; indicates "foreground"  
5; indicates "256-color"  
```bash  
SYNTAX="\e[38;5;${COLOR_CODE}m"  
# or, if used in your prompt customization:  
SYNTAX="\[\e[38;5;${COLOR_CODE}m\]"  
0-7: Standard colors  
8-15: Bright colors  
16-231: 6x6x6 RGB cube  
232-255: Grayscale  
```

## SSH Logs and Processes  
`journalctl -u ssh` - See SSH login attempts  
You can see the fingerprint of the SSH key is included in the logs. Failed login attempts will appear  
like this:  
```bash  
Mar 30 17:10:35 web0 sshd[5561]: Connection closed by authenticating user ubuntu 10.103.160.144 port  
38860 [preauth]  
```
`ps aux | grep ssh` - List all processes containing "ssh" in their names.  
For remote SSH sessions, you will see entries with "pts" in the terminal device column,
indicating that those are pseudo-terminals used for SSH connections.   
"tty" indicates a non-SSH connection.  
These pseudo-terminals allow you to interact with the remote machine as if you were sitting at the physical console.  


## Cron, Cronjobs & Crontabs  
1. **Open Crontab Configuration**  
Open the crontab configuration file with:  
```bash  
crontab -e  
```

2. **Define a Cron Job**  
A cron job is defined by a line in the crontab, which has the following format:  
```bash  
* * * * * command_to_be_executed  
```
* The five asterisks represent:  
    1. Minute (0-59)  
    1. Hour (0-23)  
    1. Day of the month (1-31)  
    1. Month (1-12)  
    1. Day of the week (0-7, where both 0 and 7 are Sunday)  
For example, to run a Python script every day at 3:30 PM:  
```bash  
30 15 * * * python3 /path/to/the_script.py  
```
Or, instead of the 5-asterisks method, special strings can be used  
* Common Special Strings:  
    * `@reboot`: Run once at startup.  
    * `@yearly` or `@annually`: Run once a year, equivalent to `0 0 1 1 *`.  
    * `@monthly`: Run once a month, equivalent to `0 0 1 * *`.  
    * `@weekly`: Run once a week, equivalent to `0 0 * * 0`.  
    * `@daily` or `@midnight`: Run once a day, equivalent to `0 0 * * *`.  
    * `@hourly`: Run once an hour, equivalent to `0 * * * *`.  



## File and Directory Permissions  
The permissions are listed in the following order (left to right):  
1. Owner  
2. Group  
3. Other (any other user not in group)  
-rw-r--r--  
```bash  
##own grp oth  
-|---|---|---  
```
`chmod` to change permissions.  
`chown` to change file owner.  


## Disable Shellcheck From Within Shell Scripts  

To disable shellcheck, use this comment:  

```bash  
# shellcheck disable=SC2059  
```

## Check if an argument is empty  
The `-z` conditional flag checks if the string is empty.  
The `-n` conditional flag checks that the string is not empty.  
```bash  
if [[ -z "$1" ]]; then  
    echo "The first position argument is an empty string."  
elif [[ -n "$1" ]]; then  
    echo "The first position argument is NOT an empty string."  
```
* `-n`: Argument is present 
* `-z`: Argument not present  

## Check if a File Exists or is Larger Than 0 Bytes  
* `-f`: Checks if file exists.  
* `-d`: Checks if directory exists.  
* `-s`: This checks if the file exists, AND is larger than 0 bytes.  
```bash  
# Check if file exists and source it  
[ -s ~/.bash_aliases ] && \. ~/.bash_aliases  
```


## Get Command Locations, Binaries, and Aliases  
* `find` - Finds a file.  
* `which` - Shows which binary the command uses.  
* `file` - Determine the file type.  
* `type` - Builtin. Displays information about the command type.  
* `whereis` - Finds the binary, source code, and man pages for a command.  

## Using `find` 
### Exclude files using `find`
Basic Exclusion Syntax  
```bash  
find /path/to/search -type d -name 'directory_to_exclude' -prune -o -print  
```
* `-type d`: specifies that you're looking for directories.  
* `-name '.git'`: specifies the name of the directory you want to exclude.  
* `-prune`: tells find to prune (skip) the directory when it's encountered.  
* `-o`: is the **OR** operator.  
* `-print`: specifies that any other files or directories that **don't** match the exclusion criteria should be printed.  

To print everything in the current directory and all 
subdirectories **EXCEPT** the contents of `.git`:  
```bash  
# Exclude '.git' from find:  
find . -type d -name '.git' -prune -o -print  
```


## Getting Help With Commands  
* `whatis <cmd>` - Display one-line man page descriptions  
* `man -f <cmd>` - Displays all man pages available for `<cmd>`(same as `whatis`)  
* `man -k <cmd>` (same as `apropos <cmd>`) - Searches the short descriptions and man page names for the `<cmd>`
* `man 8 <cmd>` will open chapter 8's `<cmd>` man page.  
* `command -V <cmd>` will inspect the `<cmd>`


## Trapping Errors  
You can trap errors with the `trap` command.  
```bash  
trap 'echo Error at about $LINENO' ERR  
# or  
traperr() {
    echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"  
}
set -o errtrace  
trap traperr ERR  
```

## Source Relative Files  
```bash  
source "${0%/*}/../share/foo.sh"  
```

## Changing the system's hostname  
`hostnamectl hostname <new_hostname>`
`hostname -I` will display the current SSH IP (along with some other stuff)  


## Stream Manipulation w/ `awk`, `grep`, and `sed`
Print all lines matching a pattern in a file:  
```bash  
awk '[pattern] {print $0}' [filename]  
grep -E '[pattern]' [filename]  
sed  
```


## Compare Files  

`cmp` - Compare two files byte by byte  
`diff` - Compare two files line by line  
`comm` - Compare two sorted files line by line  
`sort` - Sort a file line by line, write to stdout  

- `sort -k 4`: Sort by column (column 4 here).  
```bash
ps aux | sort -k 4
ps -eo lstart,cmd,pid,ppid
```


## Loops  

```bash  
# Basic for loop  
for i in /etc/rc.*; do  
  echo "$i"  
done  

# C-like for loop  
for ((i = 0 ; i < 100 ; i++)); do  
  echo "$i"  
done  

# Ranges  
for i in {1..5}; do  
    echo "Welcome $i"  
done  

# With step size  
for i in {5..50..5}; do  
    echo "Welcome $i"  
done  

# Loop over lines from a file in bash  
while read -r line; do  
  echo "$line"  
done < file.txt  # Reading from `file.txt`

# Loop over lines from a command 
while read -r line; do  
  echo "$line"  
done < <(find . -maxdepth 1 -name '*.txt')  # All .txt files in current dir  

# Forever (Infinite Loop)  
while true; do  
    echo "This will run forever."  
done  
```

## Getting Options and Arguments  
Argument parsing can be done manually:
```bash  
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
    case $1 in  
      -V | --version)  
        echo "$version";  
        exit;  
        ;;  
      -s | --string )  
        shift; 
        string=$1;  
        ;;  
      -f | --flag )  
        flag=1;  
        ;;  
    esac;  
    shift;  
done  
if [[ "$1" == '--' ]]; then  
    shift;  
fi  
```
Or, you can use `getopt`/`getopts`.  


## Options  
```bash  
set -o noclobber  # Avoid overlay files (echo "hi" > foo)  
set -o errexit    # Used to exit upon error, avoiding cascading errors  
set -o pipefail   # Unveils hidden failures  
set -o nounset    # Exposes unset variables  
```

## Glob Options  
```bash  
shopt -s nullglob    # Non-matching globs are removed  ('*.foo' => '')  
shopt -s failglob    # Non-matching globs throw errors  
shopt -s nocaseglob  # Case insensitive globs  
shopt -s dotglob     # Wildcards match dotfiles ("*.sh" => ".foo.sh")  
shopt -s globstar    # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')  
```


## Functions & Scripts  
Functions are the only way to change the state of the existing shell (e.g., using `cd` to change  
directory)  
Scripts cannot do this.  

## Returning Values  
To return values in bash/sh, just echo or printf them. 
```bash  
myfunc() {
    local myresult='some value'  
    echo "$myresult"  
}
result=$(myfunc)  
```
## Raising Errors  
Do not use the `return` keyword for normal function value returns.  
`return` raises errors.  
```bash  
myfunc() {
  return 1  
}

if myfunc; then  
  echo "success"  
else  
  echo "failure"  
fi  
```




## Special Arguments/Parameters  
Full list [here](https://web.archive.org/web/20230318164746/https://wiki.bash-hackers.org/syntax/shellvars#special_parameters_and_shell_variables)  
* `${PIPESTATUS[n]}`: return value of piped commands (array)  
* `$#`: Number of arguments  
* `$*`: All positional arguments (as a single word)  
* `$@`: All positional arguments (as separate strings)  
* `$1`: First argument  
* `$_`: Last argument of the previous command  
* `$?`: Exit code/Return code of the last command  
* `$0`: The name of the shell or the shell script (filename). Set by the shell itself. (`argv[0]`)  
* `$$`: The process ID (PID) of the shell. In an explicit subshell it expands to the PID of the current "main shell", not the subshell. This is different from $BASHPID!  
* `$!`: The process ID (PID) of the most recently executed background pipeline (like started with command &)  
* `$-`: Current option flags set by the shell itself, on invocation, or using the set builtin command. It's just a set of characters.  
In a code block for easier reading:  
```bash  
${PIPESTATUS[n]}    # return value of piped commands (array)  
$#    # Number of arguments  
$*    # All positional arguments (as a single word)  
$@    # All positional arguments (as separate strings)  
$1    # First argument  
$_    # Last argument of the previous command  
$0    # The name of the shell or the shell script (filename). Set by the shell itself. (`argv[0]`)  
$$    # The process ID (PID) of the shell. In an explicit subshell it expands to the PID of the current "main shell", not the subshell. This is different from $BASHPID!  
$!    # The process ID (PID) of the most recently executed background pipeline (like started with command &)  
$-    # Current option flags set by the shell itself, on invocation, or using the set builtin command. It's just a set of characters.  
```



## Arrays in Bash  

## List-like Arrays & String Manipulation/Slicing  
```bash  
Fruits=('Apple' 'Banana' 'Orange')  
Fruits[0]="Apple"  
Fruits[1]="Banana"  
Fruits[2]="Orange"  
echo "${Fruits[0]}"           # Element #0  
echo "${Fruits[-1]}"          # Last element  
echo "${Fruits[@]}"           # All elements, space-separated  
echo "${#Fruits[@]}"          # Number of elements  
echo "${#Fruits}"             # String length of the 1st element  
echo "${#Fruits[3]}"          # String length of the Nth element  
echo "${Fruits[@]:3:2}"       # Range (from position 3, length 2)  
echo "${!Fruits[@]}"          # Keys of all elements, space-separated  

Fruits=("${Fruits[@]}" "Watermelon")    # Push  
Fruits+=('Watermelon')                  # Also Push  
Fruits=( "${Fruits[@]/Ap*/}" )          # Remove by regex (pattern?) match  
unset Fruits[2]                         # Remove one item  
Fruits=("${Fruits[@]}")                 # Duplicate  
Fruits=("${Fruits[@]}" "${Veggies[@]}") # Concatenate  
lines=(`cat "logfile"`)                 # Read from file  

for i in "${arrayName[@]}"; do          # Iterating over an array  
  echo "$i"  
done  
```


## Dictionaries (Associative Arrays)  
```bash  
declare -A sounds  
# Declares sound as a Dictionary object (aka associative array).  
 
sounds[dog]="bark"  
sounds[cow]="moo"  
sounds[bird]="tweet"  
sounds[wolf]="howl"  
 
# Working with dictionaries  
echo "${sounds[dog]}" # Access an element of a dictionary  
echo "${sounds[@]}"   # Get all values of a dictionary  
echo "${!sounds[@]}"  # Get all keys of a dictionary  
echo "${#sounds[@]}"  # Get number of elements of a dictionary  
unset sounds[dog]     # Delete an element of a dictionary  
 
# Iterate over values of a dictionary  
for val in "${sounds[@]}"; do  
  echo "$val"  
done  
 
# Iterate over keys of a dictionary 
for key in "${!sounds[@]}"; do  
  echo "$key"  
done  
```


## Process Substitution in Bash  
See [process substitution](./process_substitution.md)  

Process substitution is for treating command outputs as files.  
 
This is useful for using commands in place of files 
for commands that only accept files.  

* Note: Process substitution is not POSIX-compliant.  
    It's promarily supported in Bash and Zsh.  
### Overview  

* Process substitution is used to treat the output of a process  
  as a filename, which can then be passed to other commands.  
* This feature is available in Bash and other shells that support it, like Zsh.  

### Syntax  

* **`<(list)`**: This form is used when you want to treat the output of `list` as an input file. For example, `cat <(ls)` will execute `ls` and then `cat` the output as if it were a file.  
* **`>(list)`**: This form is for treating the input to the process as an output file. For example, `echo "Hello" > >(cat)` will pass "Hello" to `cat` as its input.  

### How It Works  

* Bash replaces each `>(list)` and `<(list)` with a filename.  
    * This filename points to a FIFO (named pipe), or a file 
      in `/dev/fd` that is connected to standard input (stdin) or  
      output of the `list` process.  
* The `list` process is executed asynchronously, meaning the 
  main command and `list` can run at the same time.  

### Examples  

1. **Comparing Two Dynamic Sets of Data**  
    ```bash  
    diff <(ls dir1) <(ls dir2)  
    ```
    This command compares the output of `ls` in two different directories.  

## Process Substitution  
`man bash; /Process Substitution`
* **Note**: Process substitution is not POSIX-compliant.  
Process substitution allows a process's input or output to  
be referred to using a filename.  
 
It takes the form of `<(list)` or `>(list)`.  
The process `list` is run asynchronously,
and its input or output appears as a filename.  
 
This filename is passed as an argument to the current command  
as the result of the expansion.  
 
If the `>(list)` form is used, writing to the file will 
provide input for `list`.  
 
If the `<(list)` form is used, the file passed as an argument  
should be read to obtain the output of `list`.  
 
* Process substitution is supported on systems that support  
  named pipes (FIFOs) or the `/dev/fd` method of naming open files.  
 


## Transforming Strings with `tr`
Transform strings  
### Arguments  
* `-c`  Operations apply to characters not in the given set  
* `-d`  Delete characters  
* `-s`  Replaces repeated characters with single occurrence  
* `-t`  Truncates  
### Character Classes  
* `[:upper:]`   All upper case letters  
* `[:lower:]`   All lower case letters  
* `[:digit:]`   All digits  
* `[:space:]`   All whitespace  
* `[:alpha:]`   All letters  
* `[:alnum:]`   All letters and digits  
```bash  
echo "Welcome To This Wonderful Shell" | tr '[:lower:]' '[:upper:]'  
#=> WELCOME TO THIS WONDERFUL SHELL  
```

## All Bash Conditional Flags  
See `./conditionals_in_bash.md`  
* -a file  
    * True if file exists.  
    * Check if file exists.  
* -b file  
    * True if file exists and is a block special file.  
    * Check if file exists and is a block special file.  
* -c file  
    * True if file exists and is a character special file.  
    * Check if file exists and file is a character special file.  
* -d file  
    * True if file exists and is a directory.  
    * Check if directory exists.  
* -e file  
    * True if file exists.  
    * Check if file exists.  
* -f file  
    * True if file exists and file is a regular file.  
* -g file  
    * True if file exists and is set-group-id.  
* -h file  
    * True if file exists and is a symbolic link.  
    * Check if file exists and file is a symlink. 
* -k file  
    * True if file exists and its ``sticky'' bit is set.  
    * Check if file exists and has sticky bit set. 

* -p file  
    * True if file exists and is a named pipe (FIFO).  
    * Check if file exists and is a named pipe. 
* -r file  
    * True if file exists and is readable.  
    * Check if file exists and is readable. 
* -s file  
    * True if file exists and has a size greater than zero.  
    * Check if file exists and is not empty. 
* -t fd   
    * True if file descriptor fd is open and refers to a terminal.  
* -u file  
    * True if file exists and its set-user-id bit is set.  
* -w file  
    * True if file exists and is writable.  
* -x file  
    * True if file exists and is executable.  
* -G file  
    * True if file exists and is owned by the effective group id.  
* -L file  
    * True if file exists and is a symbolic link.  
* -N file  
    * True if file exists and has been modified since it was last read.  
* -O file  
    * True if file exists and is owned by the effective user id.  
* -S file  
    * True if file exists and is a socket.  
* file1 -ef file2
    * True if file1 and file2 refer to the same device and inode numbers.  

* file1 -nt file2
    * True if file1 is newer (according to modification date) than file2, or if file1  exists  and file2 does not.  
* file1 -ot file2
    * True if file1 is older than file2, or if file2 exists and file1 does not.  
* -o optname  
    * True if the shell option optname is enabled. 
    * See the list of options under the description of the `-o` option to the set builtin below.  
* -v varname  
    * True if the shell variable varname is set (has been assigned a value).  
* -R varname  
    * True if the shell variable varname is set and is a name reference.  
* -z string  
    * True if the length of string is zero.  
   string  
* -n string  
    * True if the length of string is non-zero.  
* string1 == string2
    * string1 = string2
    * True if the strings are equal.  
    * = should be used with the test command for POSIX-compliance. 
    * When  used  with  the [[ command, this performs pattern matching as 
      described in (Compound Commands).  
* string1 != string2
    * True if the strings are not equal.  
* string1 < string2
    * True if string1 sorts before string2 lexicographically.  
* string1 > string2
    * True if string1 sorts after string2 lexicographically.  

#### Arithmetic Operators:  
* `-eq`: (`==`) Is equal to   
* `-ne`: (`!=`) Not equal to   
* `-lt`: (`<`) Less Than   
* `-le`: (`<=`) Less than or equal to 
* `-gt`: (`>`) Greater than  
* `-ge`: (`>=`) Greater than or equal to  



## Interpreter Order of Operations  
1. Command is executed  
1. Results in a simple command and an optional list of args:  
    1. If the command has no slashes, it looks for a shell function of that name.  
    1. If no shell function is found, the shell searches for a builtin.  
    1. No slashes, shell function, or builtin, shell searches for a binary in `$PATH`
        * Bash uses a hash table to remember full pathnames of binaries.  
        * Full search only happens if command isn't found in the hash table.  
    1. If nothing is found, shell seraches for `command_not_found_handle` function.  


## Parameter Expansion (Slicing/Substitution)  
Replace strings and variables in place with parameter expansion.  
### Slicing  
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

### Substitution  
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

### Substrings  
```bash  
${foo:0:3}      # Substring (position, length)  
${foo:(-3):3}   # Substring from the right  
```

### Getting the Length of a String/Variable  
```bash  
${#foo}        # Length of $foo  
```

## PS1, PS2, PS3, and PS4 Special Environment Variables  
### PS1  
The PS1 environment variable is used to customize the terminal prompt.  

What it does: This is the main shell prompt that you see.  
It's highly customizable and can include variables, escape sequences, and functions.  
Example: `export PS1="\u@\h:\w\$ " `
See `./customizing_terminal.md`

### PS2: Secondary Prompt String  
What it does: This is the prompt displayed when a command is not finished.  
For example, if you type echo "hello and don't close the quote, you'll see this prompt.  
Example: `export PS2="> "`


### PS3: Prompt String for select  
What it does: This is the prompt used in shell scripts for the select loop, which is used to generate menus.  
Example: `export PS3="Please make a choice: "`

### PS4: Debug Prompt String  
What it does: This is displayed when debugging a script.  
It's prepended to each line of output when using set -x for debugging.  
Example: `export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '`


## Get bits: Zero, random or random 0/1  

* `/dev/zero` : returns zero  
* `/dev/random` : returns random number  
* `/dev/urandom` : returns random 0 or 1  


## SysAdmin Relevant - Firewall and Network commands  

* `service` - Run a System V init script  
* `ufw` - Firewall stuff  
* `iptables` - Admin took for packet filtering and NAT  
* `whereis` - Find binary, source, and man page for a command.  


## Redirecting Standard Output AND Standard Error  
Redirect first, then do `2>&1`.  
The order of redirections is significant:  
```bash  
# GOOD  
ls > dirlist 2>&1  # Do it this way!
```
directs both standard output and standard error to the file `dirlist`, while the command  
```bash  
# BAD  
ls 2>&1 > dirlist  # Don't do it this way!
```
directs  only  the  standard output to file `dirlist`, because the standard error was duplicated  
from the standard output before the standard output was redirected to `dirlist`.  

* tl;dr: 
    * Tell `stdout` where to go first (`ls > /dev/null`)  
    * Then attach `stderr` to `stdout` (`2>&1`)  
        * You're telling `stderr`(`2`) to follow(`>&`) `stdout`(`1`).  
        * Now `2` AND(`>&`) `1` are going to `/dev/null`
    * Then you have `ls > /dev/null 2>&1`


## Getting IP and Network Information
### Show routing information
```bash
ip route
# Can be shortened down to:
ip r  # Show routing table 
```
The output should look like this:
```plaintext
default via 192.168.0.1 dev enp0s31f6 proto dhcp src 192.168.0.11 metric 100 
192.168.0.0/24 dev enp0s31f6 proto kernel scope link src 192.168.0.11 metric 100 
192.168.0.1 dev enp0s31f6 proto dhcp scope link src 192.168.0.11 metric 100 
```

### Show network interfaces
```bash
ip address
# Can be shortened:
ip addr
ip a  # Show all network interfaces and their IP addresses
```
The output should look like this:
```plaintext
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether d8:9e:f3:75:55:ce brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.11/24 metric 100 brd 192.168.0.255 scope global dynamic enp0s31f6
       valid_lft 555740sec preferred_lft 555740sec
    inet6 2606:9400:93a0:a4b0::4/128 scope global dynamic noprefixroute 
       valid_lft 15653948sec preferred_lft 533948sec
    inet6 fd00:6477:7da1:5da2:da9e:f3ff:fe75:55ce/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 535426sec preferred_lft 401569sec
    inet6 2606:9400:93a0:a4b0:da9e:f3ff:fe75:55ce/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 15724789sec preferred_lft 604789sec
    inet6 fe80::da9e:f3ff:fe75:55ce/64 scope link 
       valid_lft forever preferred_lft forever
```
Here the network interfaces are listed in the order they were created.  
The network interfaces here are `lo` and `enp0s31f6`.  

### Show IP Address of the current machine
```bash
hostname -I  # Show IP address
```
The output should look like this:
```bash
192.168.0.11 2606:9400:93a0:a4b0::4 fd00:6477:7da1:5da2:da9e:f3ff:fe75:55ce 2606:9400:93a0:a4b0:da9e:f3ff:fe75:55ce 
```
The first address is the IPv4 address of the current machine on the local network.  
The second address is the IPv6 address of the current machine on the local network.  



## Get the Full Path of the Current Script

You can use this inside a script to get the directory that the script is inside:
```bash
script_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
```
This method works for `source`d scripts.  
Use this if you're not running this script directly.  

---

To get the whole path, including the filename, just use `realpath`:
```bash
script_dir=$(realpath $0)
```
If you want to trim the filename from this, you can use parameter expansion.  
```bash
${script_dir%/*}
```
This method does **not** work for sourced scripts.  
The `$0` argument changes to reflect the script calling it.  

## rmdir
The `rmdir` command deletes a directory *only* if the directory is empty.  
This is safer than `rm -r`, because it will not delete directories that still contain files.  
```bash
# Delete the `delete` directory
rmdir ~/dir/to/delete
# Delete all of the parent directories too (as long as they're empty)
rmdir -p ~/dirs/to/delete
```
* `-p`: Delete each parent directory as well.  
* `-v`: Output every directory that is processed.  

## BASH_REMATCH
The `BASH_REMATCH` variable can be used inside scripts that utilize regular
expressions.  

This is an array in which Bash stores any regex matches made with the `=~` operator.  
```bash
if [[ $SOMEVAR =~ \w+ ]]; then
    echo "${BASH_REMATCH[0]}"
fi
```

The `BASH_REMATCH` Array:
- After a successful regex match, Bash stores the results in an array named `BASH_REMATCH`.
- `BASH_REMATCH[0]` contains the entire substring that matched the regex.
    - This is the only element that is set without capture groups.  
- `BASH_REMATCH[1]`, `BASH_REMATCH[2]`, etc. contain the captured submatches from
  parenthesized groups in the order they appear.
- `BASH_REMATCH` is overwritten after each regex match.
- If there are no parentheses (capture groups), only the full match (`BASH_REMATCH[0]`) is stored.
- Bash uses Extended Regular Expressions (ERE) by default, so you generally don’t
  need to escape metacharacters as you would in Basic Regular Expressions (BREs).

- The regex operator (`=~`) only returns the first match.
    * Bash doesn't have a built-in mechanism for global matching like some other languages.


### Bash Regex Examples with `BASH_REMATCH`
```bash
#!/bin/bash
# Example 1: Basic Regex Match with a Single Capture Group
# This example matches the word "World" in the string and captures it.
input_string="Hello, World!"
if [[ $input_string =~ (World) ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"    # Entire substring that matched (i.e., "World")
    echo "Captured group 1: ${BASH_REMATCH[1]}"  # Content of the first capture group
fi

echo "-------------------------------------------"

# ---------------------------------------------------------------------------
# Example 2: Regex Match with Multiple Capture Groups
#
# This example extracts a username and an ID number from a formatted string.
input_string2="User: alice, ID: 007"
if [[ $input_string2 =~ User:\ ([a-zA-Z]+),\ ID:\ ([0-9]+) ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"  # Entire matched portion ("User: alice, ID: 007")
    echo "Username: ${BASH_REMATCH[1]}"    # First capture group (letters for the username)
    echo "User ID: ${BASH_REMATCH[2]}"     # Second capture group (digits for the ID)
fi

echo "-------------------------------------------"

# ---------------------------------------------------------------------------
# Example 3: Iterating Over Multiple Matches in a String
#
# Bash’s regex matching with BASH_REMATCH only captures the first match.
# To process all words in a string, you can use a loop that repeatedly extracts the first match.
text="one two three"
while [[ $text =~ ([^[:space:]]+) ]]; do
    echo "Found word: ${BASH_REMATCH[1]}"  # Captures a single word (non-space characters)

    # Remove the matched word and any following space from the text.
    text=${text#*"${BASH_REMATCH[1]}"}     # Remove the part up to and including the matched word
    text=${text#" "}                       # Remove leading space (if present)
done
```

## Why Not to Use `#!/usr/bin/env bash`
Using `/usr/bin/env bash` in the shebang line is common, especially for people who
use MacOS. MacOS uses `zsh` as its primary shell, and it only has Bash v3 on the 
system. Bash v5 can be installed via `homebrew` but it won't live at
`/bin/bash` by default. So this can be useful if your scripts run on multiple
systems, and you don't know where `bash` is installed.  

The argument that `/usr/bin/env bash` is portable is only the case on Mac systems,
and possibly virtual environments (e.g., Python scripts use `/usr/bin/env python3` to 
use virtual environments - `venv`).  

If you're in a controlled environment (servers, embedded systems, initramfs), it's
better to hardcode `/bin/bash` than to use `/usr/bin/env bash`.  
Here's why *not* to use `/usr/bin/env bash`:

- `PATH` Manipulation: `env` makes your script susceptible to `PATH` injection attacks.  
    - If someone runs your script in an environment with a modified `$PATH`, `env`
      will gram the first `bash` it finds.  
      This can be:
      - A malicious or broken `bash` binary. 
      - A different (incorrect) version of bash.

- SUID/SGID scripts can be way more dangerous.  
    - Since `env` relies on a *user-controlled* `$PATH`, this opens up privilege 
      escalation attacks if a malicious user puts a fake `bash` earlier in the `PATH`.  
    - Though, most modern systems disable SUID shell scripts because they're
      inherently unsafe. But, this is still important to know.  
- Boot/recovery environments: In `initramfs`/recovery shells/minimal containers/single-user mode:
    - `/usr/bin/env` may not exist.
    - Even if it exists, `bash` might not be in `$PATH`.  

- Performance overhead: 
    - Calling `/usr/bin/env` introduces an extra fork & `exec` (a tiny bit more
      memory/CPU usage).  
        - First it runs `/usr/bin/env`
        - Then `env` searches `$PATH`
        - Then it runs `bash`
    - This is negligible for short scripts but can matter for many scripts or tight
      loops.

- Non-portable on some systems. Some systems might:
    - Not have `/usr/bin/env`
    - Have `env` in a differnt location (`/bin/env` on some weird unix systems)

- Problems passing arguments to bash. Some edge cases:
    - If you need to pass arguments to the interpreter, the `env` method doesn't
      allow it cleanly.  
      ```bash
      #!/usr/bin/env bash -e
      ```
      This will fail.  
      `env` treats `bash -e` as a single argument and will not pass `-e` properly.  
    - You can not safely use `env` if your shebang line needs options/flags.  

- Breakage in chrooted/minimal environments.
    - If you run a script inside a chroot, container, or jailed environment:
        - `/usr/bin/env` may not exist.
        - You might only have `/bin/bash` and no `env` binary.  

- Harder to debug. When something breaks, `env` adds an extra layer of abstraction.  
    - Now you have to debug not only your script but also which `bash` was actually
      called. 
    - If you're debugging, the hardcoded path is clearer and more predictable.  

- Not POSIX compliant. `/usr/bin/env` is not POSIX-mandated.  
    - If you're writing scripts for POSIX systems (AIX, Solaris, old Unix, embedded
      systems, BusyBox environments), they might not have `/usr/bin/env` (maybe `/bin/env`).

---

The consensus:
- If the script is personal, portable, and user-level, `/usr/bin/env bash` is fine.  
- If it's production, automation, infrastruture, root-owned, or in a secure
  environment use `/bin/bash`. 


