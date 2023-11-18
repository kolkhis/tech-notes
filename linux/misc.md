Get Kernel version
``` bash
ls /boot
dmesg | head
uname -a
```


Encrypt a file with Vi?
```vim 
:X
```


Run a script on any user login?
```bash

```


Show the PID of the shell you're running in?
```bash
echo $$
```


List all aliases, make an alias, and remove an alias? Make it persistent?


Create ~2100 files named `file<number>` skipping every even number 001-199?


Can you set a variable of one data point?
```bash

```

`watch -n 2 uptime`
Can you make your system count to 100?
```bash
seq 100
```


Can you loop over a list from the command line?
```bash
for n in ${#list}; do echo $list[$n]; done
#
#
while read -r linevar; do command1; command2; ...; command n; done < file
```

Can you loop over a list from a file?


Can you test a variable against an expected (known) value?


Can you get the headers from a HTTP request?
```bash
curl -I hostname.com/:port
```

Can you list the number of CPUs?

Can you find the manufacturer of the CPU?

Can you find the architecture of this chip?

Can you tell the speed in MHz?

Can you tell me if this system is physical or virtual?
dmidecode?

Can you tell me how much RAM we have?
free -h

Can you tell me how much RAM we are using?

How do you connect to another server?
nc -dz
nmap -sS



