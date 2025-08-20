# Cheatsheet for Sysadmins

## Table of Contents
* [General Information about the System](#general-information-about-the-system) 
* [File and Directory Management](#file-and-directory-management) 
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






## File and Directory Management
```bash
ls -la     # List files and directories in long format, including hidden files
mkdir dir  # Create a new directory
rmdir dir  # Remove an empty directory
rm -rf /dir  # Recursively remove directory and contents (use with caution)
cp src dest  # Copy files and directories
mv src dest  # Move or rename files and directories
touch file  # Create an empty file or update the timestamp
cat file    # Display contents of a file
less file   # View file contents one page at a time
head -n 10 file  # Show first 10 lines of a file
tail -n 10 file  # Show last 10 lines of a file
find /dir -name "filename"  # Search for files and directories
locate filename  # Quickly find location of files (using a pre-built database)
ln -s target linkname  # Create a symbolic (soft) link
```

## User and Group Management
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

## Permissions and Ownership
```bash
ls -l filename  # View file permissions
chmod 644 file  # Change permissions (owner=read/write, group=read, others=read)
chown user:group file  # Change owner and group of a file
chgrp groupname file  # Change the group ownership of a file
umask 022  # Set default file permissions for new files
```

## Package Management
Also see [Package Management](./package_management.md).  

### For **Debian-based systems** (Debian, Ubuntu):
```bash
apt update  # Update package lists
apt upgrade  # Upgrade all packages
apt install package  # Install a package
apt search package  # Search for a package
apt show package  # Show details about a package
apt remove package  # Remove a package
dpkg -i package.deb  # Install a .deb package manually
```

### For **Red Hat-based systems** (RHEL, Rocky, CentOS):
```bash
dnf update  # Update packages
dnf install package  # Install a package
dnf remove package  # Remove a package
dnf whatprovides command  # Show what package provides a command  
rpm -ivh package.rpm  # Install an .rpm package manually
rpm -qa  # List all packages
```

## Process Management
```bash
ps aux      # View all processes
top         # Interactive process viewer
htop        # Enhanced interactive process viewer (often pre-installed)
kill PID    # Kill a process by PID
killall processname  # Kill all instances of a process by name
pkill -u username  # Kill all processes from a specific user
nice -n 10 command  # Start a command with a priority (lower values = higher priority)
renice -n 10 -p PID  # Change the priority of an existing process
pwdx PID    # Show the current working directory of a process
prtstat PID # Show the stats of a process (CPU, mem, etc)
```

## System Monitoring and Logging
```bash
dmesg | less  # View boot and kernel-related messages
journalctl    # Query the systemd journal logs
tail -f /var/log/syslog  # Follow system logs in real-time
uptime        # Show how long the system has been running
vmstat 5      # Display memory, CPU, and I/O statistics every 5 seconds
iostat 5      # Display disk I/O statistics every 5 seconds
```

## Network Management
```bash
ping hostname_or_IP  # Test connectivity to another host
nslookup hostname  # Query DNS for a host
traceroute hostname  # Trace the route packets take to reach a host
ss -tuln       # Show open ports and sockets  
netstat -tuln  # Older version of ss. Shows open ports and connections
iptables -L    # View firewall rules
firewalld-cmd --list-all  # View firewalld rules (CentOS/RedHat)
curl url       # Transfer data from or to a server
wget url       # Download files from the internet
scp file user@remote:/path  # Securely copy files to a remote system
```

## Disk and Filesystem Management
```bash
fdisk -l       # List partition tables
mkfs.ext4 /dev/sdX1   # Create an ext4 filesystem on a partition
mount /dev/sdX1 /mnt  # Mount a filesystem
umount /mnt     # Unmount a filesystem
lsblk           # List all available block devices
df -h           # Display disk usage (human-readable)
du -sh /dir     # Show disk usage of a directory
fsck /dev/sdX1  # Check and repair a filesystem
```

## Archive and Compression
```bash
tar -cvf archive.tar /dir  # Create a .tar archive
tar -xvf archive.tar       # Extract a .tar archive
gzip file                  # Compress a file with gzip
gunzip file.gz             # Decompress a .gz file
zip -r archive.zip /dir    # Create a .zip archive
unzip archive.zip          # Extract a .zip archive
```

## Task Automation and Scheduling
```bash
crontab -e  # Edit the crontab file for scheduled tasks
crontab -l  # List all crontab jobs for current user
systemctl enable service  # Enable a service to start on boot
systemctl disable service # Disable a service from starting on boot
```
