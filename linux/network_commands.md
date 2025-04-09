

# Network Commands on Linux


A list of useful network commands and how to use them.


## Table of Contents
* [Commands](#commands) 
    * [`ip`](#ip) 
    * [`ifconfig`](#ifconfig) 
    * [`route`](#route) 
    * [`netstat`](#netstat) 
    * [`ss`](#ss) 
    * [`ping`](#ping) 
    * [`traceroute`](#traceroute) 
    * [`mtr`](#mtr) 
    * [`nc` (`netcat`)](#nc-netcat) 
    * [`curl`](#curl) 
    * [`wget`](#wget) 
    * [`dig`](#dig) 
    * [`nslookup`](#nslookup) 
    * [`nsupdate`](#nsupdate) 
    * [`host`](#host) 
* [Choosing Which Tool to Use](#choosing-which-tool-to-use) 



## Commands

### `tcpdump`
Use tcpdump to dump all the packets that are coming through a network interface.  
Capture all packets on an interface.
```bash
tcpdump -i eth0
tcpdump -i enp0s31f6
```



### `ip`
Replaces `ifconfig`, `route`, `netstat`, and more.
It's a versatile command for network interface and routing configurations.
```bash
ip addr show    # List all interfaces and their IP addresses
ip route show   # Display routing table
```


### `ifconfig`
##### Deprecated in favor of [`ip`](#ip).
Used for configuring network interfaces.
```bash
ifconfig -a # List all interfaces and their status
```


### `route`
##### Deprecated in favor of [`ip route`](#ip).
Used to view and manipulate the IP routing table.
```bash
route -n # Display the routing table
```


### `netstat`
##### Considered deprecated in favor of [`ss`](#ss).
Shows network status, listening ports, and routing tables.
```bash
netstat -tulnp # Show listening TCP and UDP ports with process IDs
```


### `ss`
Replaces `netstat`.
Used to display various network socket statistics.
```bash
ss -tulnp # List listening TCP and UDP ports
```


### `ping`
Sends `ICMP ECHO_REQUEST` packets to network hosts.
```bash
ping -c 4 google.com # Ping google.com 4 times
```


### `traceroute`
Prints the route packets take to a network host.
```bash
traceroute google.com
```


### `mtr`
Combines the functionality of `traceroute` and `ping`. It provides continuous traceroute and ping statistics.
```bash
mtr google.com
```


### `nc` (`netcat`)
Swiss army knife for TCP/IP.
Used for reading/writing across network connections using TCP or UDP.
```bash
nc -l 1234          # Listen on port 1234
nc example.com 1234 # Connect to example.com on port 1234
```


### `curl`
Tool to transfer data from or to a server. Supports various protocols.
```bash
curl https://example.com
curl -o ~/downloaded_file.txt https://example.com/file.txt # Download file.txt

# Silently download file.txt
curl -s -o ~/downloaded_file.txt https://example.com/file.txt 

# Silently download file.txt, and be silent if it fails
curl -sf -o ~/downloaded_file.txt https://example.com/file.txt 

# Follow redirects (like if the file has moved), and be silent even when it fails
curl -sfL -o ~/downloaded_file.txt https://example.com/file.txt 

# Follow redirects (like if the file has moved), fail silently but output error messages if it fails
curl -sfSL -o ~/downloaded_file.txt https://example.com/file.txt 
```


### `wget`
Similar to `curl`, used to download files from the web.
```bash
wget https://example.com/file.txt  # Download file.txt
wget -O remote_file.txt https://example.com/file.txt # save the file to remote_file.txt
```


### `dig`
DNS lookup utility.
```bash
dig @8.8.8.8 example.com +short
```


### `nslookup`
Query Internet domain name servers.
`dig` is more powerful, but `nslookup` is widely used for quick queries.
```bash
nslookup example.com
```


### `nsupdate`
Used for dynamically updating DNS records.
Useful for DDNS (Dynamic DNS) services.
```bash
# Usage requires a properly configured environment and key.
nsupdate -v update.txt
```


### `host`
DNS lookup utility, simpler than `dig`.
```bash
host example.com
```


### `iperf3`
Network speed testing tool.  
One machine (server) needs to be ready to receive packets, while another machine (client) sends packets.  
Default port used is `5201`.  
Default packet type is TCP. Use `-u` for UDP.  
```bash
# Start an iperf3 server
iperf3 -s
# or
iperf3 --server
iperf3 -c 192.168.4.11 -u -n 20G
```

* `-P`: Allow parallel streams.  

## Choosing Which Tool to Use

* For modern systems, prefer using `ip` over `ifconfig` and `route`,
  and `ss` over `netstat` for updated functionalities.
    * Replacement for `ifconfig` is `ip addr`
    * Replacement for `netstat` is `ss`.  
    * Replacement for `netstat -i`: `ip -s link`.
    * Replacement for `netstat -g` is `ip maddr`.

* DNS Troubleshooting: Use `dig`, `host`, and `nslookup` for diagnosing DNS 
  issues.  
    * `dig` is more detailed, while `host` and `nslookup` are more straightforward for 
      quick lookups.

* Network Testing: `ping`, `traceroute`, and `mtr` are essential for testing network 
  reachability and path.  
    * `mtr` provides a more detailed path analysis over time.

* Data Transfer and Testing: `curl` and `wget` are indispensable for downloading 
  files or exploring HTTP APIs.  
    * `netcat` is invaluable for more low-level TCP/UDP network testing or transferring data.


## Files

### `cat /etc/resolv.conf`
This file contains the DNS rules for the system.  
This is symlinked to `/run/systemd/resolve/stub-resolv.conf` on some systems.  
You shouldn't edit this file directly.  

Using `resolvectl status` will display details about the uplink DNS servers that
are currently in use.  

### `/etc/nsswitch.conf`
- <https://www.man7.org/linux/man-pages/man5/nsswitch.conf.5.html>

Contains the configuration for the Name Switch Service.  

This file is responsible for determining the order in which
sources are used to resolve names and look up information, such as:
- Hostname resolution
- User and group information (`passwd`, `group`)
- Authentication mechanisms
- Network service entries, etc.  

The Name Switch Service specifies the order in which name service databases are 
queried for certain information, like user accounts and hostnames.

It allows the system to determine where to look for this information: local files, 
DNS (Domain Name System), or network services like NIS and LDAP.

- The first column in this file is the database name.  
* The next columns specify service specifications.
- `files`, `db`, `systemd`, `sss`, `nis`
- Optional actions to perform if a result is obtained from the previous service.

---

Example from a rocky linux box:
```ini
passwd:     files sss systemd
group:      files sss systemd
netgroup:   sss files
automount:  sss files
services:   sss files
```
Each entry follows the same kind of procedure:
- `passwd:   files sss systemd`
    - `files` Says to look in `/etc/passwd` for user account info first
    - `sss`: Then query the SSSD (System Security Services Daemon), typically used with LDAP or FreeIPA
    - `systemd`: Finally check the systemd user database (for runtime or transient user accounts)

