# RHCSA Tasks

This page contains some tasks that may be required in the RHCSA exam.  

## Reset Root Password
Knowing how to reset the password of the `root` user is **super** important for syadmins.  

Boot in recovery mode.
```bash
reboot
```
Then when we get into GRUB, select the kernel, and press ++e++.  

Go down to the line that starts with `linux`.  
Go to the end of the line and type in `rd.break`.  

Hit ++ctrl+x++. Then you'll be booted into emergency mode.

Then run the commands:
```bash
mount -o remount,rw /sysroot/
chroot /sysroot
```
This will bring the root filesystem back online. 

Now, change the password itself.
```bash
passwd
```
Change the password to **the one that you're given**.  
Don't just pick one. You usually need to set the password to a specific value.

Then, run:
```bash
touch /.autorelabel
```
This is primarily for SELinux. It will ensure that SELinux applies labels the way that it's supposed to.  

Exit the chrooted environment. 
```bash
exit
```
Reboot the system.  
```bash
reboot
```

Now try logging in with the password that you set.  

## Enable Persistent Storage for Journald
One of the RHCSA exam objectives is:

> "Preserve system journals"

The process here is fairly straightforward.  
```bash
journalctl --no-pager | grep -i '/log/journal' | tail
```

In these logs, you'll see the location for the Runtime Journal:  
```plaintext
Oct 01 10:53:08 localhost systemd-journald[271]: Runtime Journal (/run/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 73M, 65M free.
Oct 01 10:53:14 rhel systemd-journald[662]: Runtime Journal (/run/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 73M, 65M free.
Oct 01 10:53:14 rhel systemd-journald[662]: Runtime Journal (/run/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 73M, 65M free.
```

We can see that the journal is logging to the `/run/log/journal/` directory, which
does not persist across reboots.  

To set it up to be persistent, edit `/etc/systemd/journald.conf`.  

!!! note 

    If the file does not exist, create it.  
    ```bash
    sudo touch /etc/systemd/journald.conf
    ```

Add a line under the `[Journal]` section:
```ini
[Journal]
Storage=persistent
```

Then create the directory:
```bash
mkdir /var/log/journal
```

Then restart `journald`:
```bash
systemctl restart systemd-journald
```

If you're on RHEL9+, you'll need to flush the log data stored in
`/run/log/journal/` into `/var/log/journal/`.  
```bash
journalctl --flush
```

Now check the logs again, in the same way:
```bash
journalctl --no-pager | grep -i '/log/journal' | tail
```
Now we should see:
```plaintext
Oct 01 11:01:28 rhel systemd-journald[3696]: Runtime Journal (/run/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 73M, 65M free.
Oct 01 11:01:51 rhel systemd-journald[3696]: Time spent on flushing to /var/log/journal/6a521d735b0a43b6a5443c89f42a3570 is 72.686ms for 2184 entries.
Oct 01 11:01:51 rhel systemd-journald[3696]: System Journal (/var/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 2.7G, 2.7G free.
```
We can see the previous logging to `/run/log/journal`, then we see our
`--flush` command being logged, and finally we see our `/var/log/journal`
directory being written to.  

These journal databases will now persist across reboots.  

Reboot the machine to verify.  

```bash
reboot
```

Check the journal with `-b -1` to check the previous boot.  
```bash
journalctl -b -1
```

---


## Managing Basic Networking

An entire section in the RHCSA exam objectives is "Manage basic networking".  

NetworkManager in RHEL systems is a dynamic network control and configuration
daemon. It's used to keep network devices and connections up and active when
they're available.  

There are two main tools used to configure NetworkManager.  

1. `nmcli`: Command-line tool
    - `man nmcli`
    - `man nmcli-examples`
2. `nmtui`: TUI tool (nicer UX)

The more powerful choice is `nmcli`.  


### Configure Static IP Addresses

There are a few main objectives in this part.  

1. Identify which interface to configure
2. Create/modify a NetworkManager connection profile for that interface.  

check interfaces.  
```bash
ip a
```
Identify the interface to configure (e.g., `ens18`).  

Check NM profiles.  
```bash
nmcli con show
```
See if we have a profile that already matches the network interface (e.g., `ens18`).  

!!! note

    The name of the profile should not be confused with the name of the interface.  
    The name of the NM profile is named **after** the interface.  

The connection profile is located in `/etc/NetworkManager/system-connections`
```bash
ls /etc/NetworkManager/system-connections/
# ens18.nmconncection
```

!!! warning "Deprecated Config Directory"

    The `/etc/sysconfig/network-scripts` directory that used to be used to
    configure NetworkManager is deprecated in RHEL 9+.  

Follow the address configuration instructions from the cloud provider.  

#### Using NMTUI
```bash
sudo nmtui
# > select connection
# > Edit connection
# > Switch from "Automatic" to "Manual" and enter all details
```
After setting up with `nmtui`, run:
```bash
nmcli con reload
systemctl restart NetworkManager
```

Check the IP address again:
```bash
ip a
```
See if your new IP is correctly configured.  

#### Using NMCLI

To just use the `nmcli` tool to configure the static IP, start with a clean
slate. Delete the current profile that corresponds to the network interface
you're configuring.  
```bash
nmcli con del ens18  # Delete the current profile for the `ens18` interface
systemctl restart NetworkManager
```
Now check the `man nmcli-examples` page.  

Example 11 shows how to add an ethernet connection profile with a manaual IP
config.  
```bash
nmcli con add type ethernet con-name MyNet ifname ens18 \
    ip4 142.202.190.187/26 \
    gw4 142.202.190.129    \
    ipv4.dns "8.8.8.8 8.8.4.4" \
    ip6 2600:c05:2010:50:184::1/64 \
    gw6 2600:c05:2010:50:1 \
    ipv6.dns "2001:4860:4860::8888 2001:4870:4860::8844"
```

Now reload the configuration, and check that it worked.
```bash
nmcli con show
nmcli con reload
systemctl restart NetworkManager
ip a
curl example.org
```

### Configure Hostname Resolution

There's a framework on many Unix systems called NSS (Name Service Switch).

This framework is responsible for figuring out what source/service should be
used to resolve names, and in what order.  

The config file for NSS is `/etc/nsswitch.conf`.  

The default order on RHEL 10:
```bash
# Generated by authselect
# Do not modify this file manually, use authselect instead. Any user changes will be overwritten.
# You can stop authselect from managing your configuration by calling 'authselect opt-out'.
# See authselect(8) for more details.

# In order of likelihood of use to accelerate lookup.
passwd:     files systemd
shadow:     files
group:      files [SUCCESS=merge] systemd
hosts:      files  dns myhostname
services:   files
netgroup:   files
automount:  files

aliases:    files
ethers:     files
gshadow:    files
networks:   files dns
protocols:  files
publickey:  files
rpc:        files
```

The objective is to configure **hostname** resolution. So, the line we want to
configure here is the one that specifies **`hosts`**.  

The current order for `hosts` name resolution:

1. `files`: `/etc/hosts`
2. `dns`: `/etc/resolv.conf`
3. `myhostname`: The `nss-myhostname` plugin. Provides hostname resolution for
   the locally configured system hostname.  
    - Resolves the system's own hostname, as well as `localhost` and other
      special names.  

!!! note "The order matters!"

    The order in which these services are queried are the order in which they
    appear in the `nsswitch.conf` file.  
    So here, hostname resolution first goes through `/etc/hosts`, then
    `/etc/resolv.conf`, then finally the `nss-myhostname` plugin. The next
    source will only be queried if no match is found.  


#### `/etc/hosts` (files)
Check `/etc/hosts` (the first source).  
```bash
vi /etc/hosts
```
The file should look something like this:
```bash
# Loopback entries; do not change.
# For historical reasons, localhost precedes localhost.localdomain:
127.0.0.1   rhel localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
# See hosts(5) for proper format and other examples:
# 192.168.1.10 foo.example.org foo
# 192.168.1.13 bar.example.org bar
```
Here, the local host's hostname is `rhel`.  

Here is where you can configure how hostnames resolve.  

For example, you could make the `example.org` hostname always resolve to the IP
address `1.2.3.4`, or make `blah` refer to the localhost, by adding the lines:
```bash
1.2.3.4    example.org
blah       127.0.0.1
```

The address goes on the left, the hostname goes on the right.  

We can then `ping example.org` and it will ping `1.2.3.4`.  

---

#### Changing the Order

We can change the order in which we resolve hostnames by editing the
`nsswitch.conf` file.  

If we change this line:
```bash
hosts:      files  dns myhostname
```
We can make `dns` the first service we check for hostname resolution.  

```bash
hosts:      dns files  dns myhostname
```

Now, even if we had that `example.org` entry in `/etc/hosts`, the DNS will find
the real `example.org` on the internet and ping that instead.  

But, if we still have that `blah` entry, DNS won't be able to resolve it, so
`/etc/hosts` will be queried.  

### Changing DNS Settings

The `/etc/resolv.conf` is where programs find the IP address for the DNS
server.  

!!! note "Making DNS changes persistent"

    The RHCSA is about persistence -- this file is not modified directly, it's
    generated by NetworkManager. If we were to modify this file, it would not
    be persistent, as it would be re-generated by NetworkManager when the service
    starts/restarts.  


