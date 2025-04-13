
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


### Scanning Open Ports on a System
Using `nmap` by itself (`nmap <target>`) will scan the most common 1000 ports.  
Nmap can scan single ports, port ranges, and all ports.  

- Scan all ports (`-p-`): 
  ```bash
  nmap -p- example.com
  ```

- Scan the most common 100 ports (fast scan):
  ```bash
  nmap -F example.com
  ```

- Scan a single port:
  ```bash
  nmap -p 80 example.com
  ```
  Shows the port number, the protocol (TCP or UDP), the state, and the service
  related to that port.  

- Scan multiple ports by separating with commas:
  ```bash
  nmap -p 80,8080,22 example.com
  ```

- Scan a range of ports:
  ```bash
  nmap -p 80-8080 example.com
  ```
  This will scan all ports from `80` to `8080` (8k ports).  
  You can also combine this with commas to specify multiple ranges.  
  ```bash
  nmap -p 80-8080,22,33-43
  ```


An example:
```bash
nmap -p- -T4 --open -Pn -vvv 10.10.11.174 -oN output.txt
```
* `-T4`: Sets the "timing template" to 4 for faster execution.
* `--open`: Only show open (or possibly open) ports
* `-Pn`: No ping. Skips nmap discovery stage. 
* `-vvv`: Level 3 verbosity.  
* `-oN`: Normal output, outputs to file (`output.txt`).




