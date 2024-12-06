
# `nmap`

`nmap` is a tool for network exploration and security auditing.  
It can be used to scan systems and networks for open ports and services.  


## Using `nmap`

### Single Target Scanning
Scan a single target system for open ports and services.  
```bash
nmap 192.168.1.1  # Example address
```
To use iPv6, use `-6`:
```bash
nmap -6 192.168.1.1
```
To do an aggressive scan, use `-A`:
```bash
nmap -A 192.168.1.1
```

### Scan a specific port:
Specify a port to scan with `-source-port` (or `-g`)
```bash
nmap -source-port [port] [target]
nmap -g [port] [target]
```

### Saving Output to a File
You can save `nmap` output to files in multiple formats. 

`-oN`, `-oX`, `-oS`, `-oG <file>`: Output scan in normal, XML, `s|<rIpt kIddi3`, and 
Grepable format, respectively, to the given filename.
```bash
nmap -oN output.txt 192.168.1.1  # output in normal format
nmap -oX output.txt 192.168.1.1  # output in XML format
nmap -oS output.txt 192.168.1.1  # output in s|<rIpt kIddi3 format
nmap -oG output.txt 192.168.1.1  # output in greppable format
```


### Multiple Target Scanning
`nmap` can scan multiple targets at once.  
You can do this by globbing, reading from a file, or scanning an entire subnet.  

#### Scanning with a Glob
The `*` wildcard is supported by `nmap`.  
```bash
nmap 192.168.1.*
```
This will scan all systems in the `192.168.1.[0-255]` range

#### Scan from a List of Targets
You can read a list of IP addresses from a file and run a scan against all of them.  
```bash
nmap -iL targets.txt
```

### OS Detection
`nmap` can guess the OS of a system simply by the ports and services that are open.  
```bash
nmap -O --osscan-guess 192.168.1.1
```
* `-O`: Enable OS detection
* `--osscan-limit`: Limit OS detection to promising targets
* `--osscan-guess`: Guess OS more aggressively





