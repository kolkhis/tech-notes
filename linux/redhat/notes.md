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

### Network Modification Objectives

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

---

#### Identifying Interface and NetworkManager Profile

First, two things must be identified. 
1. The active network interface 
2. The active NetworkManager profile for that interface

There are a couple commands that can show this information.  
```bash
ip -br a            # Shows the interfaces 
nmcli device status # Can be shortened to `nmcli d s`
```

The `nmcli` output will be something like:
```plaintext
DEVICE  TYPE      STATE                   CONNECTION
ens18   ethernet  connected               ens18
lo      loopback  connected (externally)  lo
```

The `DEVICE` column shows the network interface name.  

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

---

#### Modifying the NetworkManager Profile
After identifying the interface and NetworkManager profile, modify
the NetworkManager profile with `nmcli`.  

Current network info can be found by inspecting the interface:
```bash
ip -r addr show dev ens18
```

The objectives for the profile's config are as follows.  

- An IP address within the same network as the current configuration, with a host ID of `50`
    - The current config shows the IP as `192.168.4.55`, so we'd need to change it to
      `192.168.4.50` (change the last number to 50, that's the host ID).  

- Netmask: `255.255.255.0`
    - Gives us the entire `192.168.4.0/24` range.  

- Default gateway within the same network, with a host ID of `1`
    - Gateway will be `192.168.4.1`.  

- Configure the system to use the following DNS settings:
    - DNS server: `8.8.8.8`
    - DNS search domain: `example.local`

Modify the existing NetworkManager profile.  
```bash
sudo nmcli connection modify "ens18" \
  ipv4.method manual \
  ipv4.addresses 192.168.4.50/24 \
  ipv4.gateway 192.168.4.1 \
  ipv4.dns 8.8.8.8 \
  ipv4.dns-search example.local \
  connection.autoconnect yes
```

- `connection modify`: Changes a persistent NetworkManager profile.  
- `ipv4.method manual`: Disables DHCP for IPv4 and uses static addressing.  
- `ipv4.address`: Specifies the address and CIDR.  
- `ipv4.gateway`: Configures the default IPv4 gateway.  
- `ipv4.dns 8.8.8.8`: Specifies the DNS resolver.  
- `ipv4.dns-search example.local`: Specifies the DNS search suffix.  
- `connection.autoconnect yes`: Activate the profile automatically during boot.  

`nmcli con modify` updates the persistent connection profile. The
`/etc/resolv.conf` file should never be edited manually when making changes
like this on RedHat systems.  

---

#### Setting The New Hostname

After modifying the profile, we can go to the other objective of changing the
system's hostname.  
```bash
sudo hostnamectl set-hostname rhel-node1.example.com
```
This changes the hostname immediately and persists it across reboots.  

Verify:
```bash
hostnamectl
# or
hostname
```

#### Activate the Modified NetworkManager Profile

Changes to a connection profile don't immediately alter the current active
connection until it's reactivated.  

Reactivate the profile:
```bash
sudo nmcli connection up ens18
```
Here, `ens18` is the profile name. This applies any changes made to the
profile. It may interrupt networking briefly. 

If an SSH session is connected, it'll probably disconnect because the host's IP is changing.  
On the exam, perform this operation from the system console instead of via SSH.
 

An alternative to the previous command:
```bash
sudo nmcli device reapply ens18
```
Reapplying cannot always apply every type of change cleanly. For an address and
gateway change, bringing the connection profile up again is the dependable exam
approach.  

#### Verify the Changes

Check the IP address:
```bash
ip -4 addr show dev ens18
```
Check for `192.168.4.50/24`.  

Check the default gateway:  
```bash
ip route show default
```
Check for `192.168.4.1`.  


Check NetworkManager's applied settings:
```bash
nmcli device show ens18
```
Check those values against the ones required.  

Check the resolver config.  
```bash
cat /etc/resolv.conf
```
The NetworkManager-generated entries should be present:
```plaintext
search example.local
nameserver 8.8.8.8
```

Check the hostname.  
```bash
hostname
```
Check for `rhel-node1.example.com`.  

Test the local gateway.  
```bash
ping -c 3 192.168.4.1
```

### Exam Workflow

The exam workflow will look something like this:
```bash
nmcli device status
ip -4 address show dev ens18
ip route show default
nmcli connection show --active

sudo nmcli connection modify "ens18" \
  ipv4.method manual \
  ipv4.addresses 192.168.4.50/24 \
  ipv4.gateway 192.168.4.1 \
  ipv4.dns 8.8.8.8 \
  ipv4.dns-search example.local \
  connection.autoconnect yes

sudo hostnamectl set-hostname rhel-node1.example.com
sudo nmcli connection up "ens18"

ip -4 address show dev ens18
ip route
nmcli device show ens18
hostnamectl hostname
```
