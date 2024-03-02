

# Subnetting  

Subnetting is the process of dividing a single network into smaller network segments,
or subnets.  
This is essential for efficient IP address management and improving network performance.  


## Table of Contents
* [Subnetting](#subnetting) 
* [About IPv4 Addresses](#about-ipv4-addresses) 
* [Network Classes](#network-classes) 
* [Subnet Mask](#subnet-mask) 
* [Binary](#binary) 
    * [States of Nature](#states-of-nature) 
* [Determining Network Class via Binary](#determining-network-class-via-binary) 
    * [Converting an IPv4 Address to Binary](#converting-an-ipv4-address-to-binary) 
* [Network Bits](#network-bits) 
* [CIDR: Classless Inter-Domain Routing](#cidr:-classless-inter-domain-routing) 
    * [VLSM: Variable-Length Subnet Masking](#vlsm:-variable-length-subnet-masking) 
* [The IP:  192.168.1.0](#the-ip:--192.168.1.0) 
* [The IP now with network bits: 192.168.1.0/24](#the-ip-now-with-network-bits:-192.168.1.0/24) 
    * [The host numbers `0` and `255` are reserved](#the-host-numbers-`0`-and-`255`-are-reserved:) 
* [Subnetting Formulas and Definitions (for reference)](#subnetting-formulas-and-definitions-(for-reference):) 
    * [Formula for the Number of Hosts](#formula-for-the-number-of-hosts) 
    * [Forumla for the Number of Subnets](#forumla-for-the-number-of-subnets) 
    * [Formula for the Subnet Mask](#formula-for-the-subnet-mask) 
    * [Checking for the Right Number of Bits](#checking-for-the-right-number-of-bits) 
    * [Network and Broadcast Addresses](#network-and-broadcast-addresses) 
* [In the cloud](#in-the-cloud) 
* [What You Should Know About CIDR for Networking Proficiency](#what-you-should-know-about-cidr-for-networking-proficiency) 
    * [Understanding Subnetting](#understanding-subnetting) 
    * [IP Address Planning](#ip-address-planning) 
    * [Routing Protocols and CIDR](#routing-protocols-and-cidr) 
    * [Practical Application](#practical-application) 
    * [IPv6 and CIDR](#ipv6-and-cidr) 
    * [Network Tools](#network-tools) 
* [Practical Subnetting Example](#practical-subnetting-example) 



## About IPv4 Addresses
An IPv4 address is 32 bits long. These are divided into two parts:
1. Network bits.  
2. Host bits.  

## Network Classes  

First we determine what class the network is.  

Class A IP addresses have the first bit of the first octet set to `0`.  
* Range: `0.0.0.0` to `127.255.255.255`  
* Network Bits: `8`  

Class B IP addresses have the first two bits of the first octet set to `10`.  
* Range: `128.0.0.0` to `191.255.255.255`  
* Network Bits: `16` 

Class C IP addresses have the first three bits of the first octet set to `110`.  
* Range: `192.0.0.0` to `223.255.255.255`  
* Network Bits: `24` 


|  Class   | Network Bits |     Range   | First Bit(s) of the First Octet  |
|----------|--------------|-------------| ----|
| Class A  |      8       |   0 - 127   | 0   |
| Class B  |     16       | 128 - 191   | 10  |
| Class C  |     24       | 192 - 223   | 110 |


##### Class D and E: Class D addresses are used for multicast groups and Class E addresses are reserved for experimental purposes. They are not typically used for general networking.  


## Subnet Mask  
* A subnet mask is used to determine which portion of an IP address refers  
  to the network, and which part refers to hosts.  
* In [CIDR](#-CIDR:-Classless-Inter-Domain-Routing) notation, the subnet mask is 
  denoted by a suffix (like `/24`), indicating the number of bits allocated for the 
  network portion, which is the first number in the IPv4 address.  
    * For each 8 network bits an IP has, one of the numbers is reserved for the  
      network.  

For example, in `192.168.1.0/24`, only the last number can be used for hosts.  
* The first number (`192` the first 8 network bits) is reserved for the network.  
* The second number (`168` the next 8 network bits) is reserved for the network.  
* The third number (`1` the next 8 network bits) is reserved for the network.  
* At the fourth number (`0`), all 24 network bits are accounted for, so  
  that number can be used for hosts (1-254).  

More complex subnets can be made by "borrowing bits" from the network portion of 
the IP.  
Those can be calculated by converting the decimal number to binary.  

---  

## Binary  

A base2 (binary) number has 2 states of nature (0-1)  
A base10 number has 10 states of nature (0-9)  

To covert other numbers to base10, go from right to left, starting from 0.  
The right-most number will be exponent  

### States of Nature  

Based on the number of bits, the amount of available numbers changes.  


|Number of Bits |  States of Nature |
|---------------|-------------------|
|       1       |          2        |
|       2       |          4        |
|       3       |          8        |
|       4       |         16        |
|       5       |         32        |
|       6       |         64        |
|       7       |        128        |
|       8       |        256        |
|       9       |        512        |
|      10       |       1024        |
|      11       |       2048        |
|      12       |       4096        |
|      13       |       8192        |
|      14       |      16384        |
|      15       |      32768        |
|      16       |      65536        |


## Determining Network Class via Binary  

### Converting an IPv4 Address to Binary  
Each set in the IPv4 address is usually displayed as base10.  
To convert it into binary, we would need to exponent 2 (number of binary states), 8 times. 
In binary, 8 bits represent 256 states of nature. We'd cut that in half for each step.  
For each of the bits for each number (8), we'd multiply it like so:  

| **Exponent:** |  2⁷  |  2⁶  |  2⁵  |  2⁴   |  2³  |  2²|  2¹  |  2⁰   |
|---------------|------|------|------|-------|------|----|------|-------|
|  **States:**  |128's | 64's | 32's |  16's |  8's | 4's | 2's |  1's  |

For each number in the IP (up to the host numbers):  
* if a 128 goes into it, subtract 128 and add that bit (1)  
* if a 64 goes into it, subtract 64 and add that bit (1)  
* Do the same for 32, 16, 8, 4, 2, and 1  

|  Type  |   First Set  |   Second Set  |   Third Set  |  Fourth Set  |
|--------|--------------|---------------|--------------|--------------|
| base10 |      192     |      168      |       1      |       0      |
| base2  |  `________`. |  `________`.  |  `________`. |  `HHHHHHHH`. |

```
192  - 128  =  64    :  1  (128 goes into 192: TRUE)  
64   -  64  =  0     :  1  ( 64 goes into the remainder: TRUE)  
0    -  32  =  0     :  0  ( 32 goes into the remainder: FALSE)  
0    -  16  =  0     :  0  ( 16 goes into the remainder: FALSE)  
0    -   8  =  0     :  0  ( 16 goes into the remainder: FALSE)  
0    -   4  =  0     :  0  ( 4  goes into the remainder: FALSE)  
0    -   2  =  0     :  0  ( 2  goes into the remainder: FALSE)  
0    -   1  =  0     :  0  ( 1  goes into the remainder: FALSE)  
```
So the first set will look like:  

|  Type  |   First Set  |   Second Set  |   Third Set  |  Fourth Set  |
|--------|--------------|---------------|--------------|--------------|
| base10 |      192     |      168      |       1      |       0      |
| base2  |  `11000000`. |  `________`.  |  `________`. |  `HHHHHHHH`. |



Or we can use our exponent table (the number is 192):  
| **Exponent:** |  2⁷  |  2⁶  |  2⁵  |  2⁴   |  2³  |  2²|  2¹  |  2⁰   |
|---------------|------|------|------|-------|------|----|------|-------|
|  **States:**  |128's | 64's | 32's |  16's |  8's | 4's | 2's |  1's  |
| **Bit Repr:** |  _   |  _   |  _   |   _   |  _   |  _  |  _  |   _   |

1. Start with the highest bit value (128, or 2727) and see if it fits into 192.  
   Since 128 is less than 192, it fits, so you set the first bit to 1.  
   Then subtract 128 from 192, leaving 64.  

| **Exponent**  |  2⁷ (128)     |  2⁶ (64)    |  2⁵ (32)  | 2⁴ (16) |  2³ (8) |  2² (4) |  2¹ (2) |  2⁰ (1)
|---------------|---------------|-------------|-----------|---------|---------|---------|---------|---------
| **Result**    |192 - 128 = 64 |             |           |         |         |         |         |
| **Bits**      |  1            |     _       |    _      |    _    |    _    |    _    |    _    |    _

2. Next, check if 64 (2626) fits into the remainder (64). It does, so set the second 
   bit to 1. Subtract 64 from 64, leaving 0.  

| **Exponent**  |  2⁷ (128) |  2⁶ (64)    |  2⁵ (32)  | 2⁴ (16) |  2³ (8) |  2² (4) |  2¹ (2) | 2⁰ (1)
|---------------|-----------|-------------|-----------|---------|---------|---------|---------|---
|  **Result**   |           | 64 - 64 = 0 |           |         |         |         |         |   |
|  **Bits**     | 1         |   1         |     _     |    _    |    _    |    _    |    _    | _ |

3. Since the remainder is now 0, all remaining bits are set to 0. 
   So for the first octet of bits we have `11000000`.  

That leaves us with this:  
|  Type  |   First Set  |   Second Set  |   Third Set  |  Fourth Set  |
|--------|--------------|---------------|--------------|--------------|
| base10 |      192     |      168      |       1      |       0      |
| base2  |  `11000000`. |  `________`.  |  `________`. |  `HHHHHHHH`. |

---  

There are two identifying factors for the IP's class:  
* The first number falls inside the range of `192` to `223`.  
  This identifies it as a Class C IP Address.  
* The first three bits in the first octet are `110`.  
  This also identifies it as a Class C IP Address.  

Our network is Class C, so it has 24 network bits.  


## Network Bits  


This is the table from [network classes](#network-classes)  

|  Class   | Network Bits |     Range   | First Bit(s) of the First Octet  |
|----------|--------------|-------------| ----|
| Class A  |      8       |   0 - 127   | 0   |
| Class B  |     16       | 128 - 191   | 10  |
| Class C  |     24       | 192 - 223   | 110 |

The lower the number of network bits, the more HOST bits are available.  
 
Each of the network bits refer to one of the bits in the binary 
representation of the IP.  

For instance, if we have a "Class A" IP with 8 network bits, the network 
bits are reserved for the first "set" (the first binary octet).  
For the IP `127.0.0.0`:  
|  Type  |   First Set  |   Second Set  |   Third Set  |  Fourth Set  |
|--------|--------------|---------------|--------------|--------------|
| base10 |      127     |       0       |       0      |       0      |
|Network |  `NNNNNNNN`. |  `HHHHHHHH`.  |  `HHHHHHHH`. |  `HHHHHHHH`. |
| base2  |  `01111111`. |  `________`.  |  `________`. |  `________`. |

The `N`s represent the bits reserved for the network.  
The rest (`H`) are available hosts.  
The first bit is set to `0`, so we know it is a Class A IP address.  

---  

However, if we have a "Class B" IP with 16 network bits, the network  
will reserve the first two octets:  
For the IP `191.0.0.0`:  
|  Type  |   First Set  |   Second Set  |   Third Set  |  Fourth Set  |
|--------|--------------|---------------|--------------|--------------|
| base10 |      191     |       0       |       0      |       0      |
|Network |  `NNNNNNNN`. |  `NNNNNNNN`.  |  `HHHHHHHH`. |  `HHHHHHHH`. |
| base2  |  `10111111`. |  `________`.  |  `________`. |  `________`. |
The first two bits are `10`, so we know it's a Class B IP address.  



## CIDR: Classless Inter-Domain Routing  
* CIDR uses a notation that includes the IP address followed by a slash,
  and then the number of bits in the subnet mask.  
* In CIDR notation, `/24` or `/30` indicate the number of bits used 
  for the network portion of the address. This number is called the  
  "Subnet Mask"  

For example, `192.168.1.0/24` indicates that the first 24 bits of the IP 
address are used for network identification, and the remaining bits are 
for host identification.  

### VLSM: Variable-Length Subnet Masking  
CIDR uses VLSM, which means the subnet mask length can vary (it's a variable).  
This allows networks to be divided into subnetworks of different sizes,
making address allocation more flexible.  


## The IP:  192.168.1.0  

In these notes, "each number" will refer to `192`, `168`, and `1`.   
The last number (`0`) doesn't matter - those will be the hosts available on the subnets.  
Each number is represented by an octet of binary bits (8 bits).  

## The IP now with network bits: 192.168.1.0/24  

`192.168.1.0/24`  
* The `/24` means there are 24 network bits (Class C)  
    * This is referred to as the "CIDR" (Classless Inter-Domain Routing) notation.  

|  Type  |   First Set  |   Second Set  |   Third Set  |  Fourth Set  |
|--------|--------------|---------------|--------------|--------------|
| base10 |      192     |      168      |       1      |       0      |
|Network |  `NNNNNNNN`. |  `NNNNNNNN`.  |  `NNNNNNNN`. |  `HHHHHHHH`. |
| base2  |  `11000000`. |  `________`.  |  `________`. |  `________`. |

Where:  
* `N` = Network Bits  
* `H` = Host Bits  

In the binary representation (`base2`):  
* The first three sets ("First Set", "Second Set", "Third Set") each consist of  
  8 bits (or "octets"), making up 24 bits in total, dedicated to the network 
  portion (`/24`).  

* The "Fourth Set" represents the host portion, which consists of 8 bits, allowing  
  for 256 different states (0 to 255).  

In this instance:  
* `192.168.1.0` refers to the network address.  
* `192.168.1.255` would be the broadcast address.  
* `192.168.1.1` through `192.168.1.254` are valid host addresses.  

### The host numbers `0` and `255` are reserved: 
* `0` is reserved for the Network  
* `255` is reserved for the Broadcast  
```
192.168.1.0       = The network itself  
192.168.1.255     = The broadcast  
192.168.1.{1,254} = available as hosts  
```
So we have 1-254 available as hosts.  


---  

1. Split it in half by adding ("borrowing") a bit 

`192.168.1.0/25`  
* 1-127 is the first subnet  
* 128-254 is the second subnet  


1. Split it in half again by borrowing another bit:  

`192.168.1.0/26`  
The subnets for this network are now:  
* 1-63
* 64-127  
* 128-191  
* 192-254  


1. Split it in half yet again by adding another bit (now 1/8th of the original size)  

`192.168.1.0/27`  
The subnets for the network now:  
* 0-31  
* 32-63
* 64-95  
* 96-127  
* 128-159  
* 160-191  
* 192-223
* 224-255  

000  
001  
010  
011  
100  
101  
110  
111  





Just count in 32s (bottom to top)  
224- 
192-  
160-  
128  
96  
64  
32
0  


## Subnetting Formulas and Definitions (for reference):  

### Formula for the Number of Hosts  

To determine the number of hosts in a subnet, use the formula:  
```bash  
2^(32 - subnet_mask) - 2
```
For example, in a `/24` subnet (a subnet with 24 network bits), there  
are `2^(32 - 24) - 2 = 254` usable host addresses.  
```bash  
2^(32 - 24) - 2 = 254  
```

* This formula calculates the number of usable hosts in a subnet.  
* `H` represents the number of bits used for the host portion of the subnet.  
* The `-2` accounts for two addresses in every subnet that cannot be assigned to  
  hosts:  
    * the network address (all host bits are 0)  
    * the broadcast address (all host bits are 1)  


### Forumla for the Number of Subnets  
* Subnets = `2^S`
    * This is used to calculate the number of subnets created when you subnet an existing network.  
    * `S` is the number of bits borrowed from the host part to create more networks.  

### Formula for the Subnet Mask  
* Masking: N=1's | S=1's | H = 0's  
    * This represents the structure of a subnet mask.  
        * The network (N) portions are represented by 1s  
        * The subnet  (S) portions are represented by 1s  
        * The host (H) portion is represented by 0s  

### Checking for the Right Number of Bits 
```bash  
(( NETWORK_BITS + SUBNET_BITS + HOST_BITS = 32 ))  
```
* `N+S+H = 32`
    * This equation is specific to IPv4 addressing.  
        * `N` is the number of network bits  
        * `S` is the number of subnet bits  
        * `H` is the number of host bits  
    * Since IPv4 addresses are 32 bits in total, the sum of network, subnet, and host bits must equal 32.  
        * The 32 represents the four binary bit octets that make up the IP.  

### Network and Broadcast Addresses  
* `N = all H = 0`
    * This represents the network address of a subnet. All host bits (H) are set to 0.  
* `B = all H = 1`
    * This represents the broadcast address of a subnet. All host bits (H) are set to 1.  

What do these formulas represent? They are related to subnetting. 


Subnetting Terms:  
* CIDR - Classless Inter-Domain Routing  
* VLSM - Variable-Length Subnet Masking  

Routing Protocols:  
* OSPF - Open Shortest Path First  
* BGP  - Border Gateway Protocol  



## In the cloud  
You can not go any lower than 16 network bits on AWS (possibly other VPCs too)  
10.100.0.0/16 <- 




## What You Should Know About CIDR for Networking Proficiency  

### Understanding Subnetting  

Proficiency in CIDR involves a strong grasp of subnetting concepts,
including how to divide networks into subnets,
calculate the number of available hosts,
and understand the implications for network design and routing.  


Subnetting is the process of dividing a single network into smaller  
network segments, or subnets.  
This is essential for efficient IP address management and improving  
network performance.  

* Subnet Mask  
    * A subnet mask is used to determine which portion of an IP address refers to 
      the network and which part refers to hosts. 
    * In CIDR, the subnet mask is denoted by a suffix (like `/24`), indicating  
      the number of bits allocated for the network portion.  
* Host Calculation  
    * To determine the number of hosts in a subnet, use the formula `2^(32 - subnet mask) - 2`
        * For example, in a `/24` subnet, there are `2^(32 - 24) - 2 = 254` usable host addresses.  
* Subnet Sizes  
    * Understand how changing the subnet mask affects the size of a network.  
        * A smaller subnet mask (like /23) results in fewer network bits 
          and more host bits, thus a larger number of hosts.  
* Practice  
    * Regularly practice subnetting exercises to become proficient in:  
        * calculating network and broadcast addresses  
        * calculating the number of hosts  
        * subnet division  



### IP Address Planning  
IP Address Planning is the skill of planning and allocating IP addresses 
efficiently for different sized networks, considering future growth and  
network segmentation.  

Efficient IP address planning is critical for network scalability and management.  

* Assessing Needs  
    * Assess the needs of the network,
      including:  
        * The number of required hosts  
        * Network segments (subnets)  
        * Potential future growth  
* Allocating Addresses  
    * Allocate IP addresses based on the size of the network.   
    * Use smaller subnets for networks with fewer hosts to conserve IP addresses.  
* Addressing Schemes  
    * Develop a logical addressing scheme that simplifies management and allows  
      for easy expansion.  
    * Group similar devices or departments into the same subnet when possible.  



### Routing Protocols and CIDR  
Understanding how modern routing protocols (like OSPF, BGP) interact with CIDR,
including the concepts of route summarization and supernetting.  

Modern routing protocols leverage CIDR for efficient routing.  

* Route Summarization  
    * This involves combining multiple subnets into a single advertisement  
      to reduce the size of routing tables.  
        * For example, `192.168.0.0/24` and `192.168.1.0/24` can be summarized 
          as `192.168.0.0/23`.  
* Protocol Understanding  
    * Familiarize yourself with protocols like OSPF (Open Shortest Path First),
      and BGP (Border Gateway Protocol), and how they use CIDR for route 
      advertisement and path selection.  

OSPF (Open Shortest Path First)  
BGP (Border Gateway Protocol)  



### Practical Application  
Practice with real-world scenarios, including setting up network environments with various subnet sizes,
configuring routers, and understanding the impact on routing tables.  

Hands-on experience is vital.  

* Network Setup  
    * Set up different network scenarios using subnetting.  
    * Implement these in lab environments or simulations.  
* Troubleshooting  
    * Practice troubleshooting common network issues related to subnetting,
      such as IP conflicts or routing problems.  


### IPv6 and CIDR  
Familiarity with CIDR in the context of IPv6, as IPv6 becomes more prevalent 
and requires a different approach due to its larger address space.  

IPv6 uses CIDR as well, but with a much larger address space.  

* Address Structure  
    * Understand the structure of IPv6 addresses and how they differ from IPv4.  
* Subnetting in IPv6  
    * Learn how subnetting works in IPv6, where the subnet size is typically /64, but can vary.  


### Network Tools  
Proficiency in using network tools for CIDR calculations, subnetting,
and addressing. This includes both command-line tools and software applications.  

Use tools to simplify CIDR-related tasks.  

* CIDR Calculators  
    * Tools like subnet calculators can automate subnetting tasks.  
* Command-Line Tools  
    * Get comfortable with command-line tools like `ipcalc` or 
      `ifconfig/ip` for subnet calculations and network configuration.  




## Practical Subnetting Example  

Imagine you have the network `192.168.1.0/24` and you need to create 4 subnets.  
This network has 8 host bits (`/24` means 24 network bits, so `32 - 24 = 8` host bits).  

1. Borrow 2 bits for subnetting (2^2 = 4 subnets).  
2. The new subnet mask becomes `/26` (24 original network bits + 2 borrowed bits).  
3. This gives you four subnets: `192.168.1.0/26`, `192.168.1.64/26`, `192.168.1.128/26`,
   and `192.168.1.192/26`.  

Each subnet now has 6 bits left for hosts (`2^6 - 2 = 62` usable addresses per subnet).  





