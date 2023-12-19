## Grok Internet Networking  
* Ethernet  
    * Routing  
        * Local Area Network (LAN)  
        * Wide Area Network  (WAN)  
        * Ethernet Address (machine address)  
        * Dynamic Host Control Protocol (DHCP)  
    * Ports  
    * Network Address Translation (NAT)  
* IP  
* TCP/IP  
* UDP  
* Domain Names  
    * Discovery  
        * `whois`
        * <https://shodan.io>  
    * Registrars  
    * localhost 127.0.0.1  
    * Reserved  
    * `/etc/hosts`
* HTTP/HTTPS  
* TLS  
* SSH (Secure Shell)  
    * `~/.ssh/config`
* Beware of legacy: FTP, Telnet, Gopher  

## Common Network Query Commands  
* `dig`, `nslookup`,
* `ifconfig`, `ipconfig`, `ip`, `ss`
* `ping`
* `nmap`



Telnet is essentially SSH without encryption  



## Shodan  

shodan.io <- Shows a bunch of vulnerabilities  


## Bits vs Bytes  
Megabit != Megabyte  
1 byte = 8 bits  
Mbps is megabits per second  


## Ethernet  

Ethernet can be thought of as mail.  
It's happening at the speed of light (literally uses light).  

Information is transferred through packets.  

You put a letter into the envelope (package). 
The envelope has the final destination on it, and a return address.  

This is exactly the same for packets.  

All those letters would be pre-sorted by zip-code 
In a mail room, all the letters would be dropped off at the post  
office (this is the network router).  

## Tools  
## Looking Out (Outbound Traffic) 
* `tracepath` <- Will trace alll the differe "post offices" between the user and the endpoint  
    * (Windows has `pathping`, similar)  
* `traceroute` 
* `mtr` <- My Trace Route (`sudo apt-get install mtr`)  
* `ping` <- sends ICMP packet to target, counts how long it takes  
    * packet sniffers <- LOOK IT UP  

mtr sends out a specific type of packet (ICMP)  

## Looking In (Inbound Traffic)  
* `ss` - `sudo ss -ltp`
* `lsof` was used before netstat  
* `netstat`  (`sudo apt-get install net-tools`)  
    * `netstat -tuna`
    * `netstat -p`
    * `netstst -tpua`
    * `netstat -peanut`
* state:  
    * established = There is an open connection  
    * listen = it's listening, no active connection  

There's a "from address" and a "to address".  
If the from-address is your IP (or any local IP), you're looking at an outbound connection.  

## Finding the Default Ports for Services
Find the default port for telnet: (or anything else)  
```bash
grep telnet /etc/services  
```

### Other Tools
* `nmap` <- 
* `ncat`/`nc`: Make your own servers that do whatever you want if you can get  
                ncat on the system  
* `strace -p`: Sniff the communications of a particular process  
* `ufw status verbose`: Firewall  


## Display all inbound attack vectors  
* `netstat -tua | grep LISTEN`

If you can't answer the question "Why is this running?" maybe you've been hacked (or you 
need to study more).  
Hackers will commonly trojan the `netstat` command to hide themselves.  
Goes in `/proc`.  

`IPP` (Internet Printing Protocol) is one that will be susceptible to hacks.  
This is the protocol used by printers.  

## Hardening  
A big part of hardening is disabling services that don't need to be running.  

This can be also used to find exploits.  
See what stuff is running that they're not keeping track of.  


* `ifconfig`/`ip a` (ipconfig on windows)  



## How a packet travels
A packet will go through many points before it reaches the endpoint  

\_gateway is the first hop  
    This is the router  
then it goes to ISP  
Then it goes to netops.charter (or other packet distribution centers)  
    This is the backbone of internet  


Ethernet address (machine address/ Mac Address) changes as it goes  
link/ether <- Specifies the mac address. They use the same format as ipv6  
This can be changed (lol)  

The IP endpoint does not change  


Every time the packet changes hands, the next hop address gets crossed-out and
a different stamp goes on it.  
This has a direct correlation to TCPIP.  

ipv4 = 32bit  
ipv6 = 128bit  


## DHCP (Dynamic Host Configuration Protocol)
DHCP - When your device comes onto the network it is assigned a dynamic IP.  
* Points at something that might move.  
* Everyone on the LAN sees the packet that is sent when a device connects  
* contains the hardware address  
* NIC card - Network Interface Controller  
* The response comes from someone claiming to be the router.  
    * Keeps track of the traffic on the network for that mac address.  
* Dynamic unless Reserved  

## Common Attack Methods

### Domain Hijacking  

### Ethernet Spoofing  
Spoofing a mac address  

A MITM attack intercepts traffic and forwards it to its destination,
writes all the packets to a log file and brute force attacks the packets offline.  
### Packet Storm  


## Ports  

In french, port means "door".  
A port is a doorway to a *specific service*.  
Responses, the router or service create ephemeral ports - imaginary ports that don't
block incoming traffic.  

### Reserved ports  
* `less /etc/services`

Best way to hide a hack is to listen on a different port, pretending to be something else  
* port 80 (http)  
* port 443 (https) 443/tcp 443/udp  
* port 8080  



## Network Layers  

## 7 Layers of the OSI Model  
* Physical - COAX, Fiber, Wireless, Hubs, Repeaters  
* Data Link - Ethernet, PPP, Switch, Bridge - Header *and* Trailer applied
* Network - Packets - IP, IVMP, IPsec, IGMP - Header applied
* Transport - E2E connections - UDP or TCP/IP
* Session - PDUs (Protocol, Data, Unit) - How data is presented.
* Presentation - How data is presented
* Application 




Transport layer: UDP or TCP/IP  

UDP packet delivery is not guranteed but are being sent en masse.  
TCP/IP packets are required to be received.  

TCP/IP is WAY slower then UDP.  

Each have their purpose.  
For web apps or email, you'd want to use TCP/IP. This way you know that the packet
has been received.  
For games/streaming, you want to use UDP. You're sending a LOT of information, so it's okay if not
every single packet reaches its destination.  





## Reserved IPs  
* 127.\*.\*.\*  
* 192.168.\*.\*  



## Discovery  
* `whois` shows a bunch of information about the associated domain  
    * `whois skilstak.io`  
    * the name servers can also be then used in whois  

* `dig` will show the IPs associated with a name  
    * dig skilstak.io  

* `nslookup`
* `ping google.com`: `ttl`=ping/latency  


## Aliasing Hosts  
Adding an alias to a host (host alias) can be done a couple ways:
* `/etc/hosts` - Edit and add a name to the end of a host if you want an alias.  
    * This is machine-local.  
* Can also add an entry to `.ssh/config`, but this only applies to SSH.  


## Firewall  
Requires 2 connections to the network  
One side, it connects to the home network  
Other side, it connects to the internet  

It just blocks things.  
A firewall is a safe way to control access to your home network.  
Additionally, you can block outgoing stuff too.  

Firewall rules going out are usually very permissive  
If malware is installed on a system, the first thing it'll usually do is "phone home", i.e., ping
the remote host it will be reporting to.  







