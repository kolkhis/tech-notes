

# Subnetting

## Binary

A base10 number has 10 states of nature (0-9)  

To covert other numbers to base10, go from right to left, starting from 0.  
The right-most number will be exponent  

## The IP:  192.168.1.0

In these notes, "each number" will refer to `192`, `168`, and `1`.   
The last number (`0`) doesn't matter - those will be the hosts available on the subnets.  
Each number is represented by an octet of binary bits (8 bits).  



## Network Classes

First we determine what class the network is.  

Class A IP addresses have the first bit of the first octet set to 0.
*   0.0.0.0 to 127.255.255.255  
* 8 Network Bits

Class B IP addresses have the first two bits of the first octet set to 10.
* 128.0.0.0 to 191.255.255.255  
* 16 Network Bits

Class C IP addresses have the first three bits of the first octet set to 110.
* 192.0.0.0 to 223.255.255.255  
* 24 Network Bits


|  Class   | Network Bits |     Range       |
|----------|--------------|-----------------|
| Class A  |      8       |   0 - 126 - 0   |
| Class B  |     16       | 128 - 191 - 10  |
| Class C  |     24       | 192 - 223 - 119 |


##### Class D and E: Class D addresses are used for multicast groups and Class E addresses are reserved for experimental purposes. They are not typically used for general networking.



## Determining Network Class via Binary

Each of the bits for each number:
|  2⁷  |  2⁶  |  2⁵  |  2⁴   |  2³  |  2²|  2¹  |  2⁰   |
|------|------|------|-------|------|----|------|-------|
|128's | 64's | 32's |  16's |  8's | 4's | 2's |  1's  |

For each number in the IP (up to the host numbers):
* if a 128 goes into it, subtract 128 and add that bit (1)  
* if a 64 goes into it, subtract 64 and add that bit (1)  
* Do the same for 32, 16, 8, 4, 2, and 1

|  Type  |   First Set  |   Second Set  |   Third Set  |
|--------|--------------|---------------|--------------|
| base10 |      192     |      168      |       1      |
| base2  |  `________`. |  `________`.  |  `________`. |

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

|  Type  |   First Set  |   Second Set  |   Third Set  |
|--------|--------------|---------------|--------------|
| base10 |      192     |      168      |       1      |
| base2  |  `11000000`. |  `________`.  |  `________`. |


The first three bits in the first octet are `110`.  
That means this is a Class C IP Address.  So, it has 24 network bits.


## The IP now with network bits: 192.168.1.0/24

`192.168.1.0/24`  
* The `/24` means there are 24 network bits (Class C)



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
* 192-233
* 243-255

subnetting:




Hosts = 2H - 2
Subnets = 2S
N+S+H = 32
Masking: N=1's | S=1's | H = 0's


N = all H = 0
B = all H = 1

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
