

# Linux Commands for network information  

## Scenario  
You are a new system administrator at a company. You've been tasked with finding out information about a set of servers that has very little to no documentation on it.  
Check network information.  

## Main Commands  
`ss`
`lsof`
`ip`
`grep`
`awk`
`sed`

## Part one: Network information  
Put the name of your network interface into a file called `/root/interface`.  
Put the ip address of your network interface into a file called `/root/primary-ip`.  
Write the default route out to a file called `/root/default`.  

1. Check your ip address  
```bash  
ip addr 
```

2. What is the name of your interface?  
```bash  
ip addr | grep enp | grep mtu | awk '{print $2}' | sed 's/://'  
```

3. Put that value in a file `/root/interface`.  
```bash  
ip addr | grep enp | grep mtu | awk '{print $2}' | sed 's/://' > /root/interface  
```
There are other ways to do this, but this will do it with one command.  


4. What is the ip of your interface?  
```bash  
ip addr | grep enp | grep inet | awk '{print $2}' 
```

5. Put that value in a file `/root/primary-ip`.  
```bash  
ip addr | grep enp | grep inet | awk '{print $2}' > /root/primary-ip  
```

6. Let's pull the default route for your system  
```bash  
ip route  
```

7. What is the default route for your system? Write this out to `/root/default`
```bash  
ip route | grep -i default | awk '{print $3}' > /root/default  
```

8. Ping the default gateway 3 times and verify that you get a response back  
```bash  
ping -c3 `ip route | grep -i default | awk '{print $3}'`
```

---  

## Part two: Ports  
## Check Open Ports on the System  

Can you find `sshd` and `containerd` listening on your system?  
If you can, write yes into the file `/root/ports`.  

1. Check what ports are open on your system.  
```bash  
ss -ntulp  
```
This will show all the open ports, their process, and their PIDs.  
```bash  
ss -ntulp | grep -E 'sshd|containerd'  
```
This will only show the ports that match the regex (`sshd` or `containerd`).  
* Another way to look at the ports/processes for `sshd` and `containerd` is to use:  
  ```bash  
  lsof -i :22  # Show all the processes listening on port 22 (sshd)  
  ```

2. Echo "yes" if you can see `sshd` and `containerd` listening on your system.  
```bash  
echo "yes" > /root/ports  
```

3. Connect to port 22. 
```bash  
timeout 3 nc 127.0.0.1 22
```
* `timeout` is a command that will kill the process after a certain amount of time.  
  In this case, it will disconnect `nc` after 3 seconds.  

4. Let's stop `containerd`, and verify that the process is no longer running.  
```bash  
systemctl status containerd  # Show the status of containerd (running)  
systemctl stop containerd    # Stop the containerd service  
ss -ntulp | grep containerd  # Verify that containerd is no longer running  
```

---  

## Part Three: Network Traffic  
## Check the Network Traffic on your System  
Look at the throughput to your interfaces.  
Create a file `/root/ubuntu.pcap` with 200 packets that can be read by wireshark later. 
* *We don't look at it in the lab. We just create it*  

1. Check network throughput to your system for 20 seconds.  
```bash  
ifstat 2 10  # Run ifstat every 2 seconds, 10 times  
```
Note that there's very little traffic (in terms of size) on your system.  

2. Do a tcpdump to inspect the actual traffic into your system.  
   Capture 1000 packets against your `enp1s0` interface.  
```bash  
tcpdump -ni enp1s0 -s 0 -c 1000  # -w /root/ubuntu.pcap  # -w will write to file
```

3. Generate a `.pcap` file that can be used by wireshark to inspect traffic.  
    (We don't have wireshark on this system)  
```bash
for i in $(seq 1 5); do ping -c 10 www.google.com & done; tcpdump -ni enp1s0 -s0 -c 200 -w $(hostname).pcap
```

4. Verify the size and creation of the file.
```bash
ls -lh /root/ubuntu.pcap
```



