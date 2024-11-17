
# Networking Fundamentals  


## Simple communication model  
1. Sender  
2. Receiver  
3. Message  
4. Medium  
5. Noise  

## Effective communication model has a 6th component  
1. Sender  
2. Receiver  
3. Message  
4. Medium  
5. Noise  
6. Feedback loop  


Within a communication, the message has to be encoded and decoded, by some protocol.  
A protocol can be a language (any set of rules is essentially a language).  

## Some Terminology  
* TX - Sender - Transmission side of the communication  
* RX - Receiver - The receiving part of the communication  
* DCE - Data Circuit Equipment -  Typically Vendor or ISP side of the connection.  
    * Responsible for the clock rate of the serial line  
* DTE - Data Terminal Equipment - Typically your side of the connection to thw WAN  
* AS - Autonomous System - The networking system under one administrator or company control.  
* Demarcation - The point that defines the ending of one AS and the start of another.  
    * Where one responsibility ends and another begins.  
* Metric - Any unit of measurement used to differentiate systems  



# Quick Binary Rundown  
We work in a Decimal number system (base10) in our daily lives.  
But computers work in a Binary number system (base2).  

| 128s |64s | 32s|16s | 8s | 4s | 2s | 1s |
|------|----|----|----|----|----|----|----|
| _    | _  |  _ | _  |  _ | _  | _  |  _ |
| `2⁷` |`2⁶`|`2⁵`|`2⁴`|`2³`|`2²`|`2¹`|`2⁰`|

```
 2⁷ * 2⁶ * 2⁵ * 2⁴ * 2³ * 2² * 2¹ * 2⁰ = (0 to 255)  
```
## Converting an IP to binary  
```
  192.168.1.0/27  

  192
- 128 1 (yes)  
   64  
 - 64 1 (yes)  
The rest are zeroes (no) 

11000000.  

  168  
- 128 1 (yes)  
   40  
 - 64 0 (no)  
 - 32 1 (yes)  
    8  
 - 16 0 (no)  
 -  8 1 (yes)  
The rest are zeroes (no)  
11000000.10101000.  

1 only has a 1, so the last bit is positive (1)  
11000000.10101000.00000001.  
The host bits are all zeroes  
11000000.10101000.00000001.000000000  
```


## OSI Model Basics  
### Layers of the Network  
There are 7 network layers:  

7. Application  
6. Presentation  
5. Session  
4. Transport  
3. Network  
2. Data Link  
1. Physical  

Session - PDUs (Protocol, Data, Unit) How data is presented  
* Port number, TCP/UDP  
Transport - as the Header is applied it's called a segment  
Network - Header Applied. Passes to the data link  
Data Link - Header *and* Trailer applied  
Physical - Encoding (Manchester, return-to-zero, non-return-to-zero)  
(Some people joke that the 8th layer is the user)  

Data flows down on one side, and up on the other side.  







## Side Notes  
Side note: Tor has been compromised for years. The US Gov't controls more than 60% of edge nodes.  

A Reverse Proxy is often called a Load Balancer.  

Listening for traffic:  
Windows: `netstat -ao`

UDP is more efficient than TCP for rapid communications with bits.  
But if you have more to "say", TCP is better.  


### TLS Handshakes  
Asymmetric TLS 1.2 and 1.3 handshakes: 
There's a Public key and Private key. Private is on the server, client gets 
public key from a trusted 3rd party.  
After the "third party trust" (or "introduction", the initial handshake), a symmetric  
key is calculated, and asymmetric keys are no longer used.  

This is the opposite of SSH. With SSH, you have the private key and the server has the 
public key.  


