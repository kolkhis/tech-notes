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

### `/etc/profile` and `~/.bash_logout` (system-wide `.bashrc`)
The `/etc/profile` file is loaded on every single instance of bash, whether it's a
login/interactive shell or not.  
It's basically a system-wide `.bashrc` file.  

If `/etc/profile` exists, it will read/execute this first, before any other config files.  
Then bash will look for `~/.bash_profile`, `~/.bash_login`, and `~/.profile`.  
The first one of these found will be read/executed, and the rest will be ignored.  

The `~/.bash_logout` file will be read/executed every time a shell exits (with the
`exit` builtin), whether it's a login/interactive shell or non-interactive shell.  

---

So the order in which bash loads config files:
* Non-interactive
    - `/etc/profile` (always)
    - First one found (in this order):
        - `~/.bash_profile`
        - `~/.bash_login`
        - `~/.profile`
    - `~/.bash_logout` when the shell `exit`s.  

* Interactive shell
    - `/etc/profile` (always)
    - `/etc/bash.bashrc` (always)
    - First one found (in this order):
        - `~/.bash_profile`
        - `~/.bash_login`
        - `~/.profile`
    - `~/.bashrc`
    - `~/.bash_logout` when the shell `exit`s.  





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

Each line in this file is a rule specifying who is allowed to do sudo stuff on the
system.  

Add a rule for a user in this file in the format:
```bash
# username host=(user:group) commands
username ALL=(ALL:ALL) ALL
```
* `username`: The username of the user that the rule will apply to.  
* `ALL=`: Defines where the rule applies.
    * `ALL` means it applies to any host (for multi-host environments).  
* `(ALL:ALL) ALL`:
    * The first `ALL` refers to the user list.
        * This means the user can run commands as any user.  
    * The second `ALL` refers to the group list.  
        * This means the user can run commands as any group.  
    * The third `ALL` represents the commands the user can run with sudo.  
        * `ALL` means they can run any command with sudo.  
        * This can be a comma separated list of specific commands.  

Add a rule for a group the same way, except prepend a `%` to the name (without a space).  
```bash
%groupname ALL=(ALL:ALL) ALL
```



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
Specific packages can be excluded in`/etc/yum.conf` or `/etc/dnf/dnf.conf`.  

### `/var/log/dnf.log` (or `/var/log/yum.log`) (RedHat)
Logs package installation and updates.  



## Files in `/proc`

The purpose of each of these Files in `/proc`:
```bash
# System Hardware and Memory
/proc/fb # Framebuffer device (graphics display)
/proc/dma  # Active Direct Memory access (DMA) channels used by device
/proc/iomem  # Memory map of devices and system memory regions. Use for debugging memory-mapped devices
/proc/ioports # List of I/O ports used by system devices (serial ports, PCI devices, etc)
/proc/meminfo  # Detailed info on memory usage (incl. free, total, cached memory)
/proc/mtrr     # Memory Type Range Registers (MTRRs) used for CPU cache optimizations
/proc/vmallocinfo   # Details about memory allocated via `vmalloc()`. Helps with debugging memory usage.  
/proc/pagetypeinfo  # Memory allocation and fragmentation details at the page level
/proc/buddyinfo   # Memory fragmentation and allocation by the buddy system allocator
/proc/zoneinfo    # Detailed memory stats for each NUMA zone (RAM region)
/proc/kpagecount  # Number of references (users) for each physical memory page
/proc/kpageflags  # Flags associated with each memory page (e.g., free, allocated, swap)
/proc/kpagecgroup # Cgroup related memory usage stats for each apge


# CPU and Performance Monitoring
/proc/cpuinfo    # Detailed CPU information, including model, cores, cache size, and flags.
/proc/loadavg    # System load averages over 1, 5, and 15 minutes, plus running processes.
/proc/stat       # Overall system statistics, including CPU usage, interrupts, and context switches.
/proc/vmstat     # Virtual memory statistics (page faults, swap usage, I/O operations).
/proc/schedstat  # Scheduler statistics for CPU task scheduling performance.


# Storage & Swap
/proc/swaps       # Information about active swap spaces.
/proc/diskstats   # Statistics for each disk device (reads, writes, I/O time, etc.).
/proc/partitions  # Information about detected partitions.


# Kernel & System Information
/proc/modules           # List of currently loaded kernel modules (drivers).
/proc/version           # Kernel version, build date, and compiler used.
/proc/version_signature # More detailed kernel version information (used by some distros).
/proc/cmdline           # Kernel boot parameters (passed by bootloader).
/proc/kcore             # A virtual file representing the entire system memory (use with gdb for kernel debugging).
/proc/filesystems   # List of supported filesystems in the kernel.
/proc/execdomains   # Execution domain support (for different binary formats).
/proc/sysrq-trigger # Allows manually triggering a SysRq key function (e.g., force kernel panic, reboot).
/proc/bootconfig    # Kernel boot configuration settings.


# Security & Encryption
/proc/crypto     # List of available cryptographic ciphers supported by the kernel.
/proc/keys       # Shows currently loaded kernel keys (used in authentication, encryption).
/proc/key-users  # Statistics about kernel key usage per user.


# Process & Locking Mechanisms
/proc/locks          # Active file locks on the system (used by flock and advisory locking).
/proc/softirqs       # Soft interrupt statistics (used in networking, disk I/O).
/proc/interrupts     # Statistics on hardware interrupts, including CPU usage per IRQ.
/proc/timer_list     # List of active kernel timers (for debugging time-based operations).


# System Services & Containers
/proc/cgroups    # Lists active cgroups (control groups for resource management).
/proc/mdstat     # Status of RAID arrays managed by mdadm.


# Logging & Debugging
/proc/kmsg       # Kernel log messages (similar to dmesg).
/proc/consoles   # Active console devices (e.g., tty, serial console).
/proc/kallsyms   # Kernel symbols table (used for debugging, similar to System.map).


# Miscellaneous
/proc/misc       # Miscellaneous character devices.
/proc/uptime     # System uptime (first value) and idle time (second value).
```

## Other
* `/etc/services`: Shows all the default ports for different services.  
* `/etc/protocols`: Shows the different types of internet protocols.  




