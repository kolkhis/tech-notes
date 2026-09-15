# RHCSA Notes

A collection of notes on RHCSA tasks and tools.  

## NTP (Network Time Protocol) and Chrony


On RHEL10, Chrony is the standard NTP implementation.  
Things to remember for the exam:
- `chrony`: The RPM package name (`dnf install -y chrony`)  
- `chronyd`: The systemd service and daemon name (`systemctl enable --now chronyd`)  
- `chronyc`: The CLI tool used to inspect and control `chronyd`  
- `/etc/chrony.conf`: The main config file for chrony  


A typical RHCSA task might include setting up NTP (Chrony) and configuring it
to use a specific source (e.g., `time.google.com`).  
```bash
dnf install -y chrony
vi /etc/chrony.conf
```
Add or modify an NTP source in this file by using the following syntax.  
```plaintext
server time.google.com iburst
```
The `server` keyword is used to specify a server to use, followed by the
address. Options can be added afterwards, e.g., `iburst`, which will start with
4-8 requests in order to make the first update of the clock sooner.  

After adding the server, start (or restart) the `chronyd` service and check the status.  
```bash
systemctl enable --now chronyd
# or
systemctl restart chronyd
```

Verify that the new time server is being used.  
```bash
chronyc sources -v
```
The `^*` at the beginning of the line indicates the **active synchronization source**.  

The `chronyc tracking` command can also be used to see some additional info.
```bash
chronyc tracking
```

After setting up Chrony, ensure that NTP is enabled at the system level.  
```bash
timedatectl set-ntp true
timedatectl # verify
```

## Network Configuration

Another common RHCSA task is to configure a system's current local network.
Set up a static IPv4 address for it and configure the system's DNS settings.  

RHEL uses NetworkManager for all of this. Two tools are primarily used for
interacting with NM, `nmcli` and `nmtui`.    

As an example, we'll say the following conditions are on a task:

- Configure a static IPv4 address using:
    - An IP address within the same network as the current configuration, with a host ID of `50`
    - Netmask: `255.255.255.0`
    - Default gateway within the same network, with a host ID of `1`

- Configure the system to use the following DNS settings:
    - DNS server: `8.8.8.8`
    - DNS search domain: `example.local`

- Set the system hostname to:
    - `rhel-node1.example.com`


First, the active network interface must be identified.  
There are a couple commands that can show this information.  
```bash
ip -br a
nmcli device status # can be shortened to `nmcli d s`
```

The `nmcli` output will be something like:
```plaintext
DEVICE  TYPE      STATE                   CONNECTION
ens18   ethernet  connected               ens18
lo      loopback  connected (externally)  lo
```
This shows that the `ens18` interace is connected.  
The `CONNECTION` column shows the NetworkManage profile name. Here, it's the
same name as the interface.  

So now we have:
- Interface: `ens18`
- Active NM profile: `ens18`

Now, confirm which interface carries the default route.  
```bash
ip r show default
```
Output will look like:
```plaintext
default via 192.168.4.1 dev ens18 proto dhcp src 192.168.4.55 metric 100
```
This shows that the default route is handled by the `ens18` interface.  


