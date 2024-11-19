
## Linux Cheatsheet

Also see [the linux sysadmin cheatsheet](./sysadmin_command_cheatsheet.md).  

## Table of Contents
* [Linux Cheatsheet](#linux-cheatsheet) 
* [General Information about the System](#general-information-about-the-system) 
    * [User and Group Management](#user-and-group-management) 
    * [Permissions and Ownership](#permissions-and-ownership) 
    * [Package Management](#package-management) 
        * [For **Debian-based systems** (like Ubuntu)](#for-debian-based-systems-like-ubuntu) 
        * [For **Red Hat-based systems** (like CentOS, Fedora)](#for-red-hat-based-systems-like-centos-fedora) 
    * [Process Management](#process-management) 
    * [System Monitoring and Logging](#system-monitoring-and-logging) 
    * [Network Management](#network-management) 
    * [Disk and Filesystem Management](#disk-and-filesystem-management) 
    * [Archive and Compression](#archive-and-compression) 
    * [Task Automation and Scheduling](#task-automation-and-scheduling) 
* [Disk and System Information](#disk-and-system-information) 
    * [vmstat](#vmstat) 
    * [Check which version of linux is running](#check-which-version-of-linux-is-running) 
    * [nproc](#nproc) 
    * [Get System Information](#get-system-information) 
* [Disk Information](#disk-information) 
* [Logging and Monitoring](#logging-and-monitoring) 
* [Limiting resources](#limiting-resources) 


## General Information about the System
Use `lshw` to list the hardware on the system
```bash
lshw  # List the hardware on the system
lscpu # List the CPU information
uname -a  # Get information about the system (kernel, version, hostname, etc)
who  # Shows who is logged into the system
w    # More detailed version of 'who'
last # Show the last users to log into the system (prints in reverse)
cat /etc/*release  # Get information about the operating system
cat /proc/cmdline  # Get the kernel command line arguments (boot parameters, boot image)
ethtool  # Show info on the network interfaces
ip a     # Show info on the network interfaces
ip r     # Show the routing table (shows network gateway)
```



### User and Group Management
```bash
useradd username  # Add a new user
usermod -aG groupname username  # Add user to a supplementary group
userdel username  # Delete a user account
passwd username  # Set or change password for a user
groupadd groupname  # Add a new group
groupdel groupname  # Delete a group
id username  # Display user and group IDs
whoami  # Display your current username
su - username  # Switch to another user account
sudo command  # Run command as superuser (or another user)
```

### Permissions and Ownership
```bash
ls -l filename  # View file permissions
chmod 644 file  # Change permissions (owner=read/write, group=read, others=read)
chown user:group file  # Change owner and group of a file
chgrp groupname file  # Change the group ownership of a file
umask 022  # Set default file permissions for new files
```

### Package Management
#### For **Debian-based systems** (like Ubuntu):
```bash
apt update  # Update package lists
apt upgrade  # Upgrade all packages
apt install package  # Install a package
apt remove package  # Remove a package
dpkg -i package.deb  # Install a .deb package manually
```

#### For **Red Hat-based systems** (like CentOS, Fedora):
```bash
dnf update  # Update packages
dnf install package  # Install a package
dnf remove package  # Remove a package
rpm -ivh package.rpm  # Install an .rpm package manually
```

### Process Management
```bash
ps aux     # View all processes
top        # Interactive process viewer
htop       # Enhanced interactive process viewer (often pre-installed)
kill PID   # Kill a process by PID
killall processname  # Kill all instances of a process by name
pkill -u username  # Kill all processes from a specific user
nice -n 10 command  # Start a command with a priority (lower values = higher priority)
renice -n 10 -p PID  # Change the priority of an existing process
```

### System Monitoring and Logging
```bash
dmesg | less  # View boot and kernel-related messages
journalctl    # Query the systemd journal logs
tail -f /var/log/syslog  # Follow system logs in real-time
uptime        # Show how long the system has been running
vmstat 5      # Display memory, CPU, and I/O statistics every 5 seconds
iostat 5      # Display disk I/O statistics every 5 seconds
```

### Network Management
```bash
ping hostname_or_IP  # Test connectivity to another host
nslookup hostname  # Query DNS for a host
traceroute hostname  # Trace the route packets take to reach a host
netstat -tuln  # Show open ports and connections
ss -tuln       # Similar to netstat; show listening sockets and ports
iptables -L    # View firewall rules
firewalld-cmd --list-all  # View firewalld rules (CentOS/RedHat)
curl url       # Transfer data from or to a server
wget url       # Download files from the internet
scp file user@remote:/path  # Securely copy files to a remote system
```

### Disk and Filesystem Management
```bash
fdisk -l       # List partition tables
mkfs.ext4 /dev/sdX1  # Create an ext4 filesystem on a partition
mount /dev/sdX1 /mnt  # Mount a filesystem
umount /mnt     # Unmount a filesystem
lsblk           # List all available block devices
blkid           # Show block device attributes (UUIDs, labels, etc)
df -h           # Display disk usage (human-readable)
du -sh /dir     # Show disk usage of a directory
fsck /dev/sdX1  # Check and repair a filesystem
```

### Archive and Compression
```bash
tar -cvf archive.tar /dir  # Create a .tar archive
tar -xvf archive.tar       # Extract a .tar archive
gzip file                  # Compress a file with gzip
gunzip file.gz             # Decompress a .gz file
zip -r archive.zip /dir    # Create a .zip archive
unzip archive.zip          # Extract a .zip archive
```

### Task Automation and Scheduling
```bash
crontab -e  # Edit the crontab file for scheduled tasks
crontab -l  # List all crontab jobs for current user
systemctl enable service  # Enable a service to start on boot
systemctl disable service # Disable a service from starting on boot
```


## Disk and System Information

### vmstat
`vmstat` is a command that shows you the status of the virtual memory and CPU usage of your system.

### Check which version of linux is running
The command to check which version of Linux is running:
```bash
cat /etc/*release
```
To check which version of kernel is running:
```bash
uname -r
```

To see how the system booted, and what kernel parameters were passed
when the system was started:
```bash
cat /proc/cmdline
```

### nproc
The `nproc` command shows the number of processors that the system has access to.  
A machine with a 4-core CPU will have 4 processors.  


### Getting Resource Usage Information
#### Processes
```bash
ps -ef                  # Check what processes are running on the system (Shows their PIDs and PPIDs)
ps -ef | awk '{print $1}' | sort | uniq -c  # Show all unique users running processes  
ps aux                  # Different notation, shows all processes (also memory and cpu usage of them)
pidstat 1 5             # Show process resource CPU Usage.  Check which processes are executing on the processor
pidstat --human 1 5     # Human-readable format.  
```
The different between `ps -ef` and `ps aux`:  
* `ps -ef` shows the PPIDs of processes (parent process ID), `ps aux` doesn't.  
    * This is `System V` style.  
* `ps aux` shows CPU and Memory usage of processes, `ps -ef` doesn't.  
    * This is `BSD` style.  

ps aux vs ps -ef

#### Kernel
```bash
uname -a            # Check kernel/OS  
uname -r            # Check kernel version
cat /proc/cmdline   # Get info on how the system was started
```

#### Uptime
```bash
uptime              # Check how long system has been up
w                   # Show uptime and all the users currently logged into the system.  
who                 # a less detailed version of ``
```

#### Memory, CPU, Disk, and Network Usage

* `vmstat 1 5` : Check virtual memory usage (1 second intervals for 5 seconds)
* `mpstat 1 5` : Check overall CPU usage
* `iostat -xz 1 5` : More CPU and Disk usages
* `sar -n DEV 1 5`: Check network usage and load of system
* `ethtool enp1s0`: Check link to `enp1s0`, or any other network connection

#### Software Packages

* `dpkg -l | wc -l` : Get number of packages in `dpkg`
* `dpkg -l | grep -i ssh`: Get packages with `ssh` in their names
* `rpm -qa | wc -l`: Get the number of packages on Red-Hat-adjacent systems (rpm)


## Disk and Device Information

* `dmidecode`: Get extensive info on hardware components.  

* `fdisk -l | grep -i vd`: Check physical disk(s) and their partitions.  
    * Physical disks will be `vd{a,b,c..}` or `sd{a,b,c..}`  
        * `Disk /dev/vda:`  
        * `Disk /dev/sda:`  
    * Disk partitions will be `vd{a,b,c..}{1,2,3..}` or `sd{a,b,c..}{1,2,3..}`  
        * `/dev/vda1`  
        * `/dev/sda1`  

* `lsblk`: Show storage devices (block devices) in a tree.  
* `blkid`: Show block device attributes (UUIDs, labels, etc.)
    * `blkid /dev/vda1`  
    * `blkid /dev/sda2`  

* `df -h`: Filesystem usage  

* `mount`: lists mounted devices (with no arguments), or mounts a filesystem.  

* `df -h / | grep -v Size | awk '{print $2}'`  
* `df -h / ` will show the `/` root directory in df  
* `grep -v Size` will remove the Size column  
* `awk '{print $2}'` will print 2nd column  

* `df -i`: Show inode usage


## Logging and Monitoring

* `iostat -d 1 5` : Monitors disks  



If you can ping localhost, you're listening all the way through your NIC

Killercoda lab on setting up telemetry/logging:
[here](https://killercoda.com/het-tanis/course/Linux-Labs/102-monitoring-linux-logs)  

Uses:
* Grafana - for displaying data nicely  
* Promtail - pushes logs into the Loki server  
* Loki - API driven log aggregator  


## Limiting resources

* `ulimit [-HS] -a`
* `ulimit [-HS] [-bcdefiklmnpqrstuvxPRT [limit]]`
Provides control over the resources available to the shell and to
processes started by it, on systems that allow such control.  
* `man bash; /ulimit \[-HS`

---


