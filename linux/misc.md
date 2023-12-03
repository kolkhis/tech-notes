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


## Encrypt a file with Vi  
```vim 
:X  
```
By default, uses Rot13.  


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


## Can you set a variable of one data point?  
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

## Can you make your system count to 100?  
This can either be done with a C-style loop, the `seq` command, or "brace expansion."  
Respectively:  
```bash  
for (( i=0; i<=100; i++)); do  
    echo $i  
done  
seq 100  
echo {1..100}
```


## Can you loop over a list from the command line?  
```bash  
list=$(find . -name *.py); # Predefining a list. Can do this inline too.  
# Looping over the array itself  
list=$(find . -name *.py); for n in "${list[@]}"; do echo "Current item:"; echo "$n"; done; 
# Using the length (#)  
list=$(find . -name *.py); for n in ${#list}; do  echo $list[$n]; done  
```

## Can you loop over a list from a file?  
```bash  
while read -r linevar; do echo "Current item:"; echo $linevar; done <file  
```


## Can you test a variable against an expected (known) value?  
```bash  
if [[ "$var" == "known value" ]]; then  
    echo "$var is known value"  
fi  
```


## Can you get the headers from a HTTP request?  
```bash  
curl -i hostname.com/:port  
```

## Can you list the number of CPUs?  
CPU info is stored in `/proc/cpuinfo`
```bash  
cat /proc/cpuinfo | grep cores  
```
There is also a utility command, `lscpu`.  
This displays all the information you'd want about your system's CPU.  
```bash  
lscpu | grep "CPU(s)"  
```

## Can you find the manufacturer of the CPU?  
```bash  
lscpu | grep "Vendor ID"  
```


## Can you find the architecture of this chip?  
```bash  
lscpu | grep "Architecture"  
```

## Can you tell the speed in MHz?  
```bash  
lscpu | grep "MHz"  
```

## Can you tell me if this system is physical or virtual?  
dmidecode?  

## Can you tell me how much RAM we have?  
Use the `free` command to see RAM statistics.  
```bash  
free -h  
free -h | awk '{print $2}' | sed -E 's/^used/total memory/'  
free -h | awk '{printf $2}' | sed -E 's/^used/total memory/'  
```
Since the first column does not have a header, `awk '{print $2}'` will show  
the "total" column, but the header is "used".  
So, passing it through `sed` can fix that.  

## Can you tell me how much RAM we are using?  
Using `free -h`, just like checking total RAM.  
```bash  
free -h | awk '{print $3}' | sed -E 's/^free/\nRAM in Use/'  
```

## How do you connect to another server?  
```bash  
nc -dz  
nmap -sS  
```



