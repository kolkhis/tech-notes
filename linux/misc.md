## Check out:  
* `pfsense` - A tool for authentication  
* `ss -ntulp`
* `OpenSCAP` - benchmarking tool  
* `nmap`  
    * `nmap` maps the server if you don't have permissions  
        * good for external mapping without permissions  
* `ss` or `netstat` are internal with elevated permissions for viewing  
    * Used locally with elevated permissions, it's better than `nmap`?  

A command for programatically checking servers (prod-k8s in this example):  
```bash  
for server in `cat /etc/hosts | grep -i prod-k8s | awk '{print $NF}'`; do echo "I am checking $server"; ssh $server 'uptime; uname -r'; done  
```

## Playing Games on Linux
Use Proton - a version of WINE made specifically for gaming.


## Builtin 
* `: [arguments]`
    * No effect; the command does nothing beyond expanding arguments 
    and performing any specified redirections.  The return status is zero.  

## Find > ls  
Use `find` instead of `ls` to better handle non-alphanumeric filenames.  


## Kernel Version  
Get Kernel version  
``` bash  
ls /boot  
dmesg | head  
uname -a  
```

## sudoers and sudoing
* List of sudoers or sudo users is found in `/etc/sudoers`
* sudoers uses per-user timestamp files for credential caching.  
* Once a user has been authenticated (by running `sudo [cmd]` and entering password),
  a record is written containing the user-ID that was used to authenticate, the
  terminal session ID, the start time of the session leader (or parent process) and
  a time stamp (using a monotonic clock if one is available).
* The authenticated user can sudo without a password for 15 minutes,
  unless overridden by the `timestamp_timeout` option.


## Encrypt a file with Vi  
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


## Create ~200 files named `file<number>` skipping every even number 001-199  
```bash  
# C-style loop  
for (( i=0; i<200; i+2 )); do  
    touch file${i}
done  
# Using `seq`
for i in $(seq 1 2 200); do  
    touch file${i}
done  
# Bash 4 Exclusive: Brace expansion  
for i in {1..200..2}; do  
    touch file${i}
done  
```


## Set a variable of one data point  
```bash  
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


## Loop over a list from the command line  
```bash  
list=$(find . -name *.py); # Predefining a list. Can do this inline too.  
# Looping over the array itself  
list=$(find . -name *.py); for n in "${list[@]}"; do echo "Current item:"; echo "$n"; done; 
# Using the length (#)  
list=$(find . -name *.py); for n in ${#list}; do  echo $list[$n]; done  
```

## Loop over a list from a file  
```bash  
while read -r linevar; do echo "Current item:"; echo $linevar; done <file  
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

## Find the manufacturer of the CPU  
```bash  
lscpu | grep "Vendor ID"  
```


## Find the architecture of this chip  
```bash  
lscpu | grep "Architecture"  
```

## Tell the speed in MHz  
```bash  
lscpu | grep "MHz"  
```

## Tell me if this system is physical or virtual  
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


## Tell me how much RAM we have  
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

## Tell me how much RAM we are using  
Using `free -h`, just like checking total RAM.  
```bash  
free -h | awk '{print $3}' | sed -E 's/^free/\nRAM in Use/'  
```

## Connect to another server  
```bash  
nc -dz  
nmap -sS  
```

## GREP_COLORS  
* Note: `-v` matches NON-MATCHING lines.  

  Specifies the colors and other attributes used to highlight various parts of `grep` output.  
  Its value is a colon-separated list of capabilities that defaults to:  
  ```bash  
  # Default:  
  GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36' 
  ```
  with  the  `rv` and `ne` boolean capabilities unset / omitted (false).  

  Supported capabilities are as follows:  

* `sl=`:  
    * Color for matching lines.  
    * SGR substring for whole selected lines.  
        * (i.e., matching lines when `-v` option is omitted, or non-matching lines when `-v` is specified).  
    * If the boolean (`rv`) capability and the `-v` option are both specified,
       it applies to context matching lines instead. 
    * The default is empty (i.e., the terminal's default color pair).  

* `cx=`:  
    * Color for the context (lines where there's a match, but not the match itself)  
    * SGR substring for whole context lines (i.e., non-matching lines when the `-v`
      option is omitted, or matching lines when `-v` is specified).  
    * If the boolean (`rv`) capability and the `-v` option are both specified: 
        * it applies to selected non-matching lines instead. 
    * The default is empty (i.e., the terminal's default color pair).  

* `rv`:  
    * Invert match and context colors.  
    * Boolean value that reverses (swaps) the meanings of the `sl=` and `cx=` capabilities when  
       the  `-v` option is specified.  
    * The default is false (i.e., the capability is omitted).  

* `mt=01;31`:  
    * Color for matching txt in any matching line.  
    * SGR substring for matching non-empty text in any matching line 
        * (i.e., a selected line when  the `-v` command-line option is omitted,
          or a context line when `-v` is specified).  
    * Setting this is equivalent to setting both `ms=` and `mc=` at once  to  the  same  value.  
    * The default is a bold red text foreground over the current line background.  

* `ms=01;31`:  
    * Color for matches in a selected line. 
    * SGR substring for matching non-empty text in a selected line. 
        * (This is only used when the `-v` command-line option is omitted.)  
    * The effect of the `sl=` (or `cx=` if `rv`) capability remains active when this kicks in.  
    * The default is a bold red text foreground over the current line background.  

* `mc=01;31`:  
    * Color for matching text in a context line  
    * SGR substring for matching non-empty text in a context line.  
    * (This is only used when the `-v` command-line option is specified.)  
    * The effect of the `cx=` (or `sl=` if `rv`) capability remains active when this kicks in.  
    * The default is a bold red text foreground over the current line background.  

* `fn=35`:  
    * Color for filenames before any text  
    * SGR substring for file names prefixing any content line.  
    * The default is a magenta text foreground over the terminal's default background.  

* `ln=32`:  
    * Color for line numbers in any line  
    * SGR substring for line numbers prefixing any content line.  
    * The default is a green text foreground over the terminal's default background.  

* `bn=32`:  
    * Color for byte offsets before any line  
    * SGR substring for byte offsets prefixing any content line.  
    * The default is a green text foreground over the terminal's default background.  

* `se=36`:  
    * Color for separators between selected lines. 
        * `:` = selected lines  
        * `-` = context lines  
        * `--` = adjacent context lines  
    * SGR substring for separators that are inserted between 
        * selected line fields (`:`),
        * between context line fields, (`-`), and 
        * between groups of adjacent lines when nonzero context is specified (`--`). 
    * The default is a cyan text foreground over the terminal's default background.  

* `ne`:  
    * Boolean value. Disables Erase in Line (`EL`).  
    * Prevents clearing to the end of line using Erase in Line (`EL`) to  
      Right (`\33[K`) each time a colorized item ends.  
        * This is needed on terminals on which `EL` is not supported.  
    * It is otherwise useful on terminals for which the  
      `back_color_erase` (`bce`) boolean terminfo capability does not apply, when the chosen  
      highlight colors do not affect the background, or when EL is too slow or causes too  
      much flicker.  
    * The default is false (unset) (i.e., the capability is omitted).  

  Boolean capabilities (`ne` and `rv`) have no `=...` part. 
  They are unset (`false`) by default, and become `true` if they're set.  

 See the Select Graphic Rendition (`SGR`) section in the documentation of the text terminal  
 that is used for permitted values and their meaning as character attributes. 

 These substring values are integers in decimal representation and can be concatenated with  
 semicolons. 


```bash  
GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36' 
```
* Common values to concatenate include 
    * 1 for bold.  
    * 4 for underline.  
    * 5 for blink.  
    * 7 for inverse.  
    * 39 for default foreground color.  
    * 30 to 37 for foreground colors.  
    * 90 to 97 for 16-color mode foreground colors.  
    * 38;5;0 to 38;5;255 for 88-color and 256-color modes foreground colors.  
    * 48;5;0 to 48;5;255 for 88-color and 256-color modes background colors.  
    * 49 for default background color.  
    * 40 to 47 for background colors.  
    * 100 to 107 for 16-color mode background colors.  

`grep` takes care of assembling the result into a complete SGR sequence (`\33[...m`).  




* `cx=`: context  
    * Color for the context (lines where there's a match, but not the match itself)  
    * The default is empty (i.e., the terminal's default color pair).  

* `rv`: reverse  
    * Boolean value. Invert match and context colors. 
    * Default false, true if set.  

* `mt=01;31`: matching text  
    * Color for matching txt in any matching line.  
    * Setting this is the same as setting `ms=` and `mc=` at once to the same value.  
    * The default is a bold red text foreground over the current line background.  

* `ms=01;31`: matching selected  
    * Color for matches in a selected line. 
    * The effect of the `sl=` (or `cx=` if `rv`) remains active when this kicks in.  
    * The default is a bold red text foreground over the current line background.  

* `sl=`: 
    * Color for whole matching lines.  
    * The default is empty (i.e., the terminal's default color pair).  

* `mc=01;31`: matching context  
    * Color for matching text in a context line  
    * The effect of the `cx=` (or `sl=` if `rv`) capability remains active when this kicks in.  
    * The default is a bold red text foreground over the current line background.  

* `fn=35`: file names  
    * Color for filenames that come at the beginning of any line  
    * The default is a magenta text foreground over the terminal's default background.  

* `ln=32`: line numbers  
    * Color for line numbers in any line  
    * The default is a green text foreground over the terminal's default background.  

* `bn=32`:  
    * Color for byte offsets before any line  
    * The default is a green text foreground over the terminal's default background.  

* `se=36`:  
    * Color for separators between selected lines. 
        * `:` = selected lines  
        * `-` = context lines  
        * `--` = adjacent context lines  
    * The default is a cyan text foreground over the terminal's default background.  

* `ne`:  
    * Boolean value. Disables Erase in Line (`EL`).  
    * Prevents clearing to the end of line using Erase in Line (`EL`) to  
      Right (`\33[K`) each time a colorized item ends.  
    * The default is false (unset). True if set.  

