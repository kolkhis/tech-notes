# Critical Linux System Files


## Table of Contents
* [System Configuration and User Management](#system-configuration-and-user-management) 
    * [`/etc/passwd`](#etcpasswd) 
    * [`/etc/group`](#etcgroup) 
    * [`/etc/shadow`](#etcshadow) 
    * [`/etc/gshadow`](#etcgshadow) 
    * [`/etc/login.defs`](#etclogindefs) 
    * [`/etc/skel`](#etcskel) 
    * [`/etc/sudoers` and `/etc/sudoers.d/`](#etcsudoers-and-etcsudoersd) 
* [Logs and Auditing](#logs-and-auditing) 
    * [`/var/log/auth.log` (or `/var/log/secure` on RedHat systems)](#varlogauthlog-or-varlogsecure-on-redhat-systems) 
    * [`/etc/audit/auditd.conf`](#etcauditauditdconf) 
    * [`/var/log/audit/audit.log`](#varlogauditauditlog) 
* [System Boot and Initialization Files](#system-boot-and-initialization-files) 
    * [`/etc/fstab`](#etcfstab) 
    * [`/boot/grub2/grub.cfg` (or `/boot/grub/grub.cfg`)](#bootgrub2grubcfg-or-bootgrubgrubcfg) 
    * [`/etc/default/grub`](#etcdefaultgrub) 
    * [`/etc/systemd/system/default.target`](#etcsystemdsystemdefaulttarget) 
* [Networking Files](#networking-files) 
    * [`/etc/hosts`](#etchosts) 
    * [`/etc/resolv.conf`](#etcresolvconf) 
    * [`/etc/hostname`](#etchostname) 
    * [`/etc/network/interfaces` (Debian) or `/etc/sysconfig/network-scripts/ifcfg-*` (RedHat)](#etcnetworkinterfaces-debian-or-etcsysconfignetwork-scriptsifcfg--redhat) 
    * [`/etc/nsswitch.conf`](#etcnsswitchconf) 
* [Services and Processes](#services-and-processes) 
    * [`/etc/ssh/sshd_config`](#etcsshsshdconfig) 
    * [`~/.ssh/authorized_keys`](#sshauthorizedkeys) 
    * [`/etc/pam.d/`](#etcpamd) 
    * [`/etc/security/limits.conf`](#etcsecuritylimitsconf) 
    * [`/etc/selinux/config` (RedHat)](#etcselinuxconfig-redhat) 
    * [`/var/log/faillog`](#varlogfaillog) 
    * [`/var/log/btmp`](#varlogbtmp) 
    * [`/var/log/wtmp`](#varlogwtmp) 
* [Storage and Filesystem Files](#storage-and-filesystem-files) 
    * [`/etc/mtab`](#etcmtab) 
    * [`/proc/mounts`](#procmounts) 
    * [`/etc/mdadm.conf`](#etcmdadmconf) 
    * [`/etc/lvm/lvm.conf`](#etclvmlvmconf) 
    * [`/etc/exports`](#etcexports) 
* [Performance and Monitoring Files](#performance-and-monitoring-files) 
    * [`/proc/cpuinfo`](#proccpuinfo) 
    * [`/proc/meminfo`](#procmeminfo) 
    * [`/proc/loadavg`](#procloadavg) 
    * [`/var/log/dmesg`](#varlogdmesg) 
* [Package Management Files](#package-management-files) 
    * [`/etc/apt/sources.list` (Debian)](#etcaptsourceslist-debian) 
    * [`/etc/yum.repos.d/*.repo` (RedHat)](#etcyumreposdrepo-redhat) 
    * [`/var/log/dnf.log` (or `/var/log/yum.log`) (RedHat)](#varlogdnflog-or-varlogyumlog-redhat) 


## System Configuration and User Management

### `/etc/passwd`
Each line in the `/etc/passwd` file represents a user account.  
The format of each line in `/etc/passwd` is as follows:  
```bash  
username:password:UID:GID:GECOS:home_directory:shell  
```
* `username`: The username for the new user.  
* `password`: The encrypted password for the user. 
    * This is set to `x` if a password exists.  
    * You can leave this field empty to disable password login.  
* `UID`: The user ID for the new user.  
* `GID`: The primary group ID for the new user.  
* `GECOS`: Additional information about the user (such as full name or description).  
* `home_directory`: The home directory for the new user.  
* `shell`: The login shell for the new user.  

### `/etc/group`
Groups are stored in this file as:  
```plaintext  
group_name:password:group_id:group_members  
```
* Just like `/etc/passwd`, the `password` field usually has an `x` (if a password exists).  



### `/etc/shadow`
Stores encrypted password hashes and password aging information.  
Accessible only by privileged users (e.g., `root`).

### `/etc/gshadow`
Stores secure group information, such as group passwords and group administrators.

### `/etc/login.defs`
Contains system-wide settings for user and group creation, password policies, and other login-related configurations.

### `/etc/skel`
Contains default files that are copied to a new user's home directory when it's created.  

### `/etc/sudoers` and `/etc/sudoers.d/`
Config files for managing sudo permissions.  

## Logs and Auditing

### `/var/log/auth.log` (or `/var/log/secure` on RedHat systems)
This file logs authentication attemps, including successful and failed logins and
sudo usage.  

* `/var/log/auth.log` on Debian
* `/var/log/secure` on RedHat



### `/etc/audit/auditd.conf`
Configuration file for the audit daemon (`auditd`), which tracks system events for security purposes.  

### `/var/log/audit/audit.log`
This logs all events monitored by the audit framework, like file access and user
activity.  

## System Boot and Initialization Files

### `/etc/fstab`
The `/etc/fstab` (file system tables) file contains info about the file systems and their mount points.  
It configures filesystems to mount at boot time.  
This can be edited to add a new filesystem mount.  
Every time you mount a file system and want it to be permanently mounted, you need
to add an entry here.

```bash
/dev/mapper/VolGroup-my_lv /space ext4 defaults 0 0
```
Remove the entry (even after unmounting) if you want to disable a mount point from
mounting when the system boots.  

### `/boot/grub2/grub.cfg` (or `/boot/grub/grub.cfg`)
GRUB bootloader config file.  
Contains kernel and boot options.  
* Do **not** edit this firle directly. Use something like `grub-mkconfig` instead.  

### `/etc/default/grub`
This defines the defaule GRUB bootloader settings.
E.g., timeout and kernel parameters.  

### `/etc/systemd/system/default.target`
This specifies the default systemd target (e.g., multi-user or graphical) that the
system boots into.  


## Networking Files

### `/etc/hosts`
Maps hostnames to IP addresses for local IP resolution.  
```bash
127.0.0.1 localhost
192.168.1.10 server1.example.com server1
```
This assigns names to IPs. You can specify more than 1 name per IP.  

### `/etc/resolv.conf`
This configures DNS servers for resolving domain names.  

### `/etc/hostname`
This specifies the system's hostname.  

### `/etc/network/interfaces` (Debian) or `/etc/sysconfig/network-scripts/ifcfg-*` (RedHat)
Configuration files for network interfaces.

### `/etc/nsswitch.conf`
Nameswitch. Defines the order of name resolution (e.g., local files, DNS, NIS).  


## Services and Processes

### `/etc/ssh/sshd_config`
Configures the SSH server, including allowed auth methods and security settings.

### `~/.ssh/authorized_keys`
Lists public keys allowed to log in via SSH for a specific user

### `/etc/pam.d/`
Contains Pluggable Authentication Module (PAM) config files for various services.  

### `/etc/security/limits.conf`
Defines resource limites for users, like maximum open files or CPU usage.  

### `/etc/selinux/config` (RedHat)
Configures SELinux enforcement mode (enforcing, permissive, disabled).  

### `/var/log/faillog`
Tracks failed login attemps.  

### `/var/log/btmp`
Records failed login attempts.
Access with `lastb`
```bash
lastb
```

### `/var/log/wtmp`
Records login and logout events. 
Access with `last`
```bash
last
```

## Storage and Filesystem Files
### `/etc/mtab`
Lists currently mounted filesystems

### `/proc/mounts`
Similar to `/etc/mtab`, but dynamically generated by the kernel.  

### `/etc/mdadm.conf` 
Config file for software RAID (`mdadm`).  

### `/etc/lvm/lvm.conf`
Config file for Logical Volume Management (LVM).  

### `/etc/exports`
Config file for NFS shared directories.  


## Performance and Monitoring Files
### `/proc/cpuinfo`
Provides info about the CPU.  

### `/proc/meminfo`
Provides memory usage statistics.  

### `/proc/loadavg`
Shows system load averages.  

### `/var/log/dmesg`
This is the Kernel ring buffer log file.  
Logs kernel messages.
This is useful for debugging hardware and boot issues.  
```bash
dmesg -l
```

## Package Management Files

### `/etc/apt/sources.list` (Debian)
Package repos for `apt`.  

### `/etc/yum.repos.d/*.repo` (RedHat)
Configuration files for `yum`/`dnf` repositories.  

### `/var/log/dnf.log` (or `/var/log/yum.log`) (RedHat)
Logs package installation and updates.  





