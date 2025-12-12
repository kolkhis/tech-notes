# TCP

Transmission Control Protocol (TCP) is a protocol for transferring data between
devices.  

It's considered more reliable than User Datagram Protocol (UDP) in that in
requires verification on both ends.  

## Three-Way Handshake

This is a basic rundown of how TCP works.  

TCP operates using a three-way handshake process. It does this by setting flags
in segments sent via layer 4 of the OSI model (the transport layer).  

Say we have a server that we're connecting to and a client that we're using to
connect to it.  

First, the client will send a TCP segment (layer 4, transport) with a SYN flag
set to 1 and chooses an Initial Sequence Number (ISN).  

Then, if the server is listening, it will receive the segment and reply. The
reply will also be a segment that has both the SYN and ACK flags set.  

- The segment acknowledges the client's SYN by setting ACK to the **client's** ISN + 1.  
- The server also chooses and sets the Sequence Number field to its own ISN.  

The client will receive the segment with SYN-ACK set and finally send back a
segment with the ACK flag set.  

- The last ACK flag will be set to the **server's** ISN + 1 (incremented).  



