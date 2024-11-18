

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


