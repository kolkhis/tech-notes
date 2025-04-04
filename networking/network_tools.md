

# Networking CLI Tools


## Linux

## Basic Tools
* [ping](#ping)
* [traceroute](#traceroute)
* [nslookup](#nslookup)
* [dig](#dig)
* [netstat](#netstat)
* [ifconfig](#ifconfig)
* [ip](#ip)
* [nmap](#nmap)
* [tcpdump](#tcpdump)
* [wget/curl](#wget/curl)
* [ssh](#ssh)
* [telnet](#telnet)
* [mtr](#mtr)

---

### `cat /etc/resolv.conf`
This file contains the DNS rules for the system.  
This is symlinked to `/run/systemd/resolve/stub-resolv.conf` on some systems.  
You shouldn't edit this file directly.  

Using `resolvectl status` will display details about the uplink DNS servers that
are currently in use.  


### `ping`
Sends ICMP ECHO_REQUEST packets to network hosts.  
It's commonly used to check if a host is reachable across an IP network.  
#### `ping` Example:
```bash
ping google.com
```
This command sends packets to google.com and prints the response times.  


### `traceroute` (tracert on Windows)
Shows the route packets take to reach a network host.  
It can identify the path and measure transit delays of packets across an IP network.  
#### `traceroute` Example:
```bash
traceroute google.com
```
This command traces the path from your machine to google.com.  


### `nslookup`
Queries the Domain Name System to obtain domain or IP address mapping.  
It's useful for finding out information about domain names and their corresponding IP addresses.  
#### `nslookup` Example:
```bash
nslookup example.com
```
This command retrieves DNS records for example.com.  


### `dig`
Similar to nslookup, but provides more detailed information.  
It's a tool for querying DNS name servers.  
#### `dig` Example:
```bash
dig @8.8.8.8 google.com
```
This command queries the Google DNS server for records related to google.com.  

```bash
dig google.com A +short
```
* This retrieves the `A` records for `google.com`.
* `+short`: This flag makes `dig` only output the IP addresses.  


### `netstat`
Deprecated in favor of `ss`.  
Displays network connections, routing tables, interface statistics, masquerade connections, and multicast memberships.  
#### `netstat` Example:
```bash
netstat -tuln
```
This command lists all TCP and UDP listening ports along with their addresses and port numbers.  


### `ifconfig`
Deprecated in favor of the `ip` command.  
Configures network interfaces.  
It can display information about the current network interface configuration or set up an interface.  
#### `ifconfig` Example:
```bash
ifconfig eth0
```
This command shows information for eth0 network interface.  


### `ip`
This utility is used to show and manipulate routing, devices, policy routing, and tunnels.  
ip has largely replaced ifconfig.  
#### `ip` Example:
```bash
ip addr show
```
This command displays addresses and properties assigned to all network interfaces.  
To show a more brief output:
```bash
ip -br addr
```
To see the default gateway (interface):
```bash
ip route
# or
ip r
```


### `ethtool`
`ethtool` is used to query or control network driver and hardware settings.  

### `nmap`
Network exploration tool and security scanner.  
It's used to discover hosts and services on a computer network, thus building a "map" of the network.  
#### `nmap` Example:
```bash
nmap -p 22,80,443 192.168.1.1
```
This command scans ports 22, 80, and 443 on the host 192.168.1.1.  

#### Scan a Range of IP addresses with nmap
You can use nmap to map a network.  
Mapping a network with nmap can look something like this:
```bash
nmap -sP 192.168.200.100-254  # Scan only 100-254
nmap -sP 192.168.200.0/24  # Scan the whole range 1-254
```
The `-sP` (or `-sn`) option does not use a port scan. This only checks if the hosts are responding.  
Say that command specified that three hosts were responding.  
Run an aggressive scan on those three hosts:
```bash
nmap -A 192.168.200.101-103
```
This will perform an aggressive scan.
Nmap will show what ports are open and guess what is running on those ports, and what OS the 
host is likely running based on nmap's best guess.  


### `tcpdump`
A network traffic analyzer or sniffer.  
It captures packets off a network interface and interprets them for you.  
#### `tcpdump` Example:
```bash
tcpdump -i eth0 port 80
```
This captures all traffic on the eth0 interface to or from port 80.  


### `wget`/`curl`
Command-line utilities for downloading files from the web.  
curl is also capable of uploading data and supports a wide variety of protocols.  
#### Example with `curl`:
```bash
curl -o example.html http://example.com
```
This downloads the webpage from example.com and saves it as example.html.  


### `ssh`
Secure Shell is a protocol used to securely log onto remote systems.  
It's the command-line tool for accessing remote machines.  
#### `ssh` Example:
```bash
ssh user@192.168.1.10
```
This command logs you into the remote machine with IP 192.168.1.10 as user.  


### `telnet`
A network protocol used on the Internet or local area networks to provide
 a bidirectional interactive text-oriented communication facility using a virtual terminal connection.  
Not secure compared to SSH but useful for troubleshooting.  
#### `telnet` Example:
```bash
telnet example.com 80
```
This connects to example.com on port 80, often to test web server connectivity.  


### `mtr`
Combines the functionality of traceroute and ping into one diagnostic tool.  
It displays the route and measures each hop's transit delays.  
#### `mtr` Example:
```bash
mtr google.com
```
Shows the path and network latency to google.com with real-time updates.  
Each of these tools has multiple flags and options you can use to refine
 your commands according to your specific needs.  


### Exercises
* Use `ping` to check the connectivity to a local and remote server.  
* Use `traceroute` to see the path taken to an external website.  
* Run `nslookup` to find out the authoritative DNS servers for a domain.  
* Explore `nmap` by scanning your local network for open ports.  
* Capture HTTP traffic with `tcpdump`.  


Many of these tools can be misused for probing networks without permission, which could be illegal and unethical.  
Always have proper authorization before scanning networks and hosts.  


#### Questions
How can you use nmap to scan for a specific service running on a range of IP addresses?
* You can scan for a specific service with nmap by specifying the service's port number and a CIDR notation to denote the IP range (a subnet).  
* For example, if you want to scan for SSH servers running on the IP range 192.168.1.0/24,
  you could use:  
  ```bash
  nmap -p 22 192.168.1.0/24  
  ```
  This command will only scan port 22 (the default port for SSH) on all IP addresses 
  from 192.168.1.0 to 192.168.1.255  

