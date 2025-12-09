# TCP/IP

TCP/IP stands for Transmission Control Protocol / Internet Protocol.  

TCP/IP works in layers.  

- Application Layer: What programs (e.g., browsers) interact with.  
- Transport: TCP lives here along with UDP.  
    - After the program gets the data through the application layer, it
      transmits that data through the Transport Layer using ports.
      Each port can be assigned to a different protocol in the application
      layer so that TCP knows where the data's coming from.  
    - UDP is a bit faster since it doesn't require a handshake.  
    - Once TCP gets the data, it segments it into packets, where they'll
      individually take the quickest route to the endpoint.  
- Internet
- Network




## Subnetting (IPv4)

There are 5 classes of addresses.  

- A - 8 network bits by default (Starts with 0-127.)
- B - 16 network bits by default(Starts with 128-191.)
- C - 24 network bits by default(Starts with 192-223.)
- D - Multicast
- E - Experimental

- Network: 192.168.11.0/24
    - This has 24 network bits  
    - In the subnet **mask**, network bits are set to `1`.  

IP: 
```txt
  32 bits long, source address will be 
IP: 
 M: 1111111.11111111.11111111.00000000
```

- In the broadcast, it's all zeroes in the hosts field, in the network, it's all ones.  
- In the subnet mask, Network bits are 1, subnet bits are 1s (cuz borrowed for the network), host
  bits are 0. Everything inbetween is the host.  

First column has a power of `0`, second has a power of `1`, etc. based on the
base of the number (e.g., base10).  

Starting from the left:

- 2^7: 128s
- 2^6: 64s
- 2^5: 32s
- 2^4: 16s
- 2^3: 8s
- 2^2: 4s
- 2^1: 2s
- 2^0: 1s

Inside an IPv4 packet, the source or destination address is 32 bits.  

Why do we subnet?

We're given a network: 192.168.1.0/24 - 256 total addresses in one giant space.

But... Technically it's 254.  

- 0 is the network.  
- 255 is the broadcast.  

But, if we were to "borrow a bit" from the host bits, which will create a
subnet bit.  

New network: 192.168.1.0/25 - two separate networks (subnets).  
This splits the network in **half**, so we have 0-127, and 128-255.  

But because it's a subnet, each subnet needs the first and last host as the
network and broadcast, leaving 126 hosts for each one.  

If we had a CIDR notation of 27, it would separate the network into 8 subnets.
Each adjacent "subnet bit" effectively cuts the network in half.  

Equation:

- Hosts = 2^H - 2
- N + S + H = 32 

<https://cidr.xyz/>

The CIDR is the Network Bits + Subnet Bits.  

A network mask (in binary) is used to bitwise AND with the IP address (in
binary).  

After doing a bitwise AND using the mask and the IP, we can get the actual
network itself.  

Arp (address resolution protocol) will map the IPv4 address to the MAC address.  
If the device is not within the same network, it would have to go through the
default gateway.  

## DNS
User no longer resolves. What to check?

- Can the box ping its gateway?
- Is resolution set correctly? Is there an internal resolver or 8.8.8.8
  (Google's DNS) or 4.4.4.4 or 1.1.1.1?

DNS operates at port 53 of both TCP and UDP.  

Why know port nums?

- If you block ports for security reasons, you need to know which ports things
  use.  

```bash
less /etc/services
netstat -ao # PowerShell/cmd
```
Memorize: FTP (20, 21), SSH, 23 (Telnet, insecure so unused), HTTP (80), TFTP
(69), domain/DNS (53).  

POP protocols (post office protocols) - 109 and 110.  

NTP (Network Time Protocol), port 123

## ICMP
A ping to www.google.com means that everything worked from end to end.  

- ICMP: Internet Control Message Protocol
    - https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol

- Why do we turn off ICMP echo replies outside our environment?
    - Security. The replies that you get woud allow an attacker to map out what
      is there.  
    - Codes have specific meanings that can tell you why (if) it failed.  

## OSI Model

7. Application  
    - All HTTP(S), DNS, Common devices
    - Proxies, Reverse Proxies (Load Balancers)
    - Firewalls
        - Unified Threat Management (UTM): Multiple layers of security
          appliances that protect the system.  
        - Next Gen Firewalls: Application level firewalls that are aware of
          what the app is doing, can adapt to various apps, users, and devices.
            - E.g., they'd know what a header should look like when passed into
              a backend application.  
        - Web Application Firewall: Tend to be system-aware, designed to
          protect against OWASP top 10.  

6. Presentation
    - Encode/Decode
    - Compress/Decompress
    - Encrypt/Decrypt
    - Things that happen on one end need to happen on the endpoint as well.  

5. Session  
    - Flow Control
        - Windowing
            - Windowing is a mechanism used (mainly by TCP) to control **how much data** 
              can be sent before requiring an acknowledgement. This is a form of
              flow control.  
            - 
    - These directly relate to TCP.  

4. Transport (header applied) -> segment
    - There are two ways to talk here.  
        - TCP: Connection oriented  
            - Threeway handshake - syn, syn/ack, ack  
            - Pass tdata in sequential order.   
            - Breakdown of session - Fin, Fin/Ack  
            - TCP establishes a connection (handshake), transfers data,
        - UDP: Connectionless.  
    - Layer 4 is where TLS lives.  
    - There's a lot more going on in TCP headers than in UDP headers.  

3. Network (header applied) -> packet

    - Routing
        - Path determination
        - Pakcet switching
    - Access Control Lists and their logic
    - IPSec 
    - Layer 3 firewalls  - Packet Internetwork Exchange.  
        - Cisco used to call their firewall the PIX firewall.  
        - Stateful packet inspection (SPI) firewalls v. Stateless packet
          inspection.  
            - Statful: Keeps track of outbound trusted traffic to allow
              response traffic back in.  
            - Stateless: Every packet is evaluated both directions for
              validation according to ACL rules.  
            - ACLs: Standard and Extended
                - Standard: Only look at source IP addr
                - Extended looks at all other stuff (TCP, UDP, source IP,
                  destination IP, port number)  
    - TTL is decremented at every hop.  

2. Data Link (header applied, *and* trailer applied) -> frame 
    - Switching
    - Hardware (physical) addressing
    - ARP - address resolution protocol. How system knows the mapping of local
      hardware IPs to IPs
    - VLANS - 802.1Q

1. Physical 

    - There's no PDU, you're simply encoding bits onto a medium.  
    - Bits can be sent in either analog or digital formats.  
        - Analog is perfect, continuous wave

Headers and trailers are stripped by the RX.  
We always talk across (outside), and up to down (inside).  

When we're talking to another machine,
we always talk to the same layer (e.g., ping will talk from the network layer
to the network layer).  

Mostly working on the bottom 4 layers.  
IPv4 is the adrdressing scheme for the Netowrk layer.  


## VLANs
Subnets happen on layer 3.  
VLANs operate on layer 2.  

Frames are at layer 2, frames are what switches deal with. They only talk over
frames. Routers operate at layer 3, and they sometimes care about everything.  
Switches are commonly referred to as multi-port bridges.  

A switch with a VLAN will have two types of ports, an access port and trunk
port.  

Each VLAN gets a tag. Tagging is applied at the switch interface.  
Each VLAN needs a separate subnet.  
The VLAN itself doesn't care about the networking -- the router is what allows
the frames to talk to each other.  

For two devices on a VLAN to talk to each other, a router needs to get
involved.  

Frame Header happens at the Data Link layer.  

## Misc

- <https://www.redbooks.ibm.com/redbooks/pdfs/gg243376.pdf>  
    - Read up to page 170 for systems engineering stuff  
    - skip ch 5, 6, 7, 8, maybe 9  

- SIP: Session Initiation Protocol - would be a phone call (VOIP) - 200 OK is like a web protocol  
- RTP: Real-Time Transport Protocol  
- UDP: User Datagram Protocol  
- TCP: Transmission Control Protocol  

Bridges are at layer 2, using hardware addressing.  

- Wireshark  

---

Networking tends not to deal with the top 3 layers of the OSI model.  

There's always a sender, receiver, medium, and noise. These 5 will exist in all
network communication.  

- PDU: Protocol Data Units
- TX: Send
- RX: Receive
- DCE: Data Cricuit Equipment
- DTE: Data Terminal Equipment
- AS: Autonomous System
    - What you control and what you don't
- Demarcation: The point that defines the ending of one AS and the start of another.  
- Metric: Any unit of measurement to differentiate systems.  
    - Bits or bytes

4 primary types of addresses

- Layer 7 - DNS addressing: Resolves our addresses
    - Each DNS address needs to be globally unique.  
- Layer 4 - ports
    - Ports exist for both TCP and UDP.  
    - Must be per-device unique (can only be listening on a single port from a
      single other machine).  
- layer 3 IP addressing
    - Can be IPv4 (32 bits, 3.4b addresses) or IPv6 (128 bits, some quintillion numbers)
    - Each needs to be globally unique.  
- layer 2 - MAC addressing
    - Hardware addresses, 48 bits long, burned into the NIC. Expressed in hexadecimal.  
    - A MAC address needs to be locally unique (within the same network).  
    - The first half is the vendor code. Any physical device has its first
      half baked in. This part is randomly generated inside of virtual environments.   
## Look Up

- Switches and routers will shut down their interface commands by defualt. Use
  the `noshut` cmd to reverse this.  

- 802.1Q frame tags

- LAG - Link Aggregation Groups: Aggregate ports for speed
- LACP (protocol)


- Ping
- Frame
- Bridge (switch) listens for frames. It looks at the destination MAC, and make
  a decision. If the destination MAC was in its MAC Address Table, it would
  allow it through, if not, it would drop the frame.  
    - Bridges are always 2 interfaces.  
- Switches are multi-port bridges. Its MAC Address Table is built dynamically,
  so it becomes more aware of all frames
    - The MAC address table is built in RAM. 
    - Convergence is when all the devices in the network see the network the
      same way.  
        - Everything sees the traffic and network the same way.  
        - If network was not converged, 
- Routers are required to allow inter-VLAN communication.  


Internal PKI, TCP is the underlying mechanism of TLS.  

Connection oriented protocol, it's how we do security with communication (TLS).
 
TLS 1.2 and 1.3 are most common now -- SSL is deprecated. TLS 1.2 and 1.3
handshakes are slightly different. "X.509" is the underlying mechanism for all
TLS.  

Secure data at rest with encryption, data in motion with TLS.  
We encrypt data between two endpoints with TLS.  

Ping splits a network, as it only works at layer <LAYER>. If I can not ping it but can get a console access on it,

- DAS - Direct Attached Storage
    - Directly connected to one server (typically only one server), except in
      some cases of HA.  
    - Uses high speed, dedicated cables.  
- NAS - Network Attached Storage
    - Connected over ethernet.  
    - Shares the same connection as other system traffic (e.g., DHCP).  
    - Can be clustered behind a VIP.  
- SAN - Storage Area Network
    - Dedicated network for passing data.  
        - Optimized for data transfer (no ACL, Jumbo Frames)
        - Uses WWNN worldwide node name - instead of MAC for locally unique
          storage.
        - Servers connect with HBA (host bus adapters) instead of NICs (typically).  
    - connected via Fibre channel, iSCSI, or AoE.
    - SAN traffic does not exist in the same realm as other traffic. They have
      their own network.  

- CIDR Calculator: <https://cidr.xyz/>
- Hierarchial Network Model (Cisco): <https://itworkbooks.wordpress.com/2014/12/02/cisco-hierarchical-network-model-core-distribution-access/> 

