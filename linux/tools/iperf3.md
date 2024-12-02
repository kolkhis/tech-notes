# `iperf3` Network Speed Measurement Tool

The `iperf3` tool is used to measure network speeds via TCP (default) and UDP.  

You need 2 nodes in order to test using `iperf3`.  
One node acts as the server (receiver), and the other acts as the client (sender).  

## Using `iperf3`
You need both a server node and a client node.  

### Server Node
To start `iperf3` on a node in server mode:  
```bash
iperf3 -s
# or
iperf3 --server
```

Then you will use that machine's IP when sending from the client node.  
```bash
hostname -I | awk '{ print $1 }' # if you don't know the IP
```

### Client Node
On the client node, you specify the server node with `-c <ip>`.
```bash
iperf3 -c 192.168.200.101 -n 1G
```
* This tests the speed of the network using TCP packets with `1G` of data.  

```bash
iperf3 -c 192.168.200.101 -n 1G -P 128
```
* This does the same thing, except it uses 128 parallel streams.
    * This is the maximum number of parallel streams you can use in `iperf3`.  

## TCP and UDP
By default `iperf3` will use TCP packets. When `-u` is used, it will use UDP packets.  
The bitrate is limited for UDP. The default is 1 Mbit/sec for UDP. It's unlimited for TCP/SCTP.  


Increasing the bitrate with `-b` better reflects network speeds with UDP.  



