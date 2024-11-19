# Bash Commands for Disk Management and Monitoring

Also see [the sysadmin cheatsheet](../sysadmin_command_cheatsheet.md).  


## Table of Contents
* [Commands for Disk/Hardware Management and Monitoring](#commands-for-diskhardware-management-and-monitoring) 
    * [`lsblk`](#lsblk) 
    * [`fdisk`](#fdisk) 
    * [`mount`](#mount) 
    * [`blkid`](#blkid) 
    * [`df`](#df) 
* [System Information](#system-information) 
* [Logging](#logging) 
* [Scriptable Way to Partition Disks with `fdisk`/`gdisk`](#scriptable-way-to-partition-disks-with-fdiskgdisk) 
* [Wipe Existing Data on a Disk or Parition](#wipe-existing-data-on-a-disk-or-parition) 
* [Testing a Disk for Errors using `smartctl`](#testing-a-disk-for-errors-using-smartctl) 


 

## Commands for Disk/Hardware Management and Monitoring
```bash
uname -a            # Check OS version
uname -r            # Check kernel version
uptime              # Check how long system has been up
cat /proc/cmdline   # Get info on how the system was started
vmstat 1 5          # Check virtual memory usage (1 second intervals for 5 seconds)
mpstat 1 5          # Check overall CPU usage
ps -ef              # Check what processes are running on the system
ps -ef | awk '{print $1}' | sort | uniq -c
pidstat 1 5         # Check which processes are executing on the processor
iostat -xz 1 5      # More CPU and Disk usages
sar -n DEV 1 5      # Check network usage and load of system
dmidecode           # Get system information
ethtool enp1s0      # Check link to `enp1s0`, or any other network connection

fdisk -l            # List partition tables
mkfs.ext4 /dev/sdX1 # Create an ext4 filesystem on a partition
mount /dev/sdX1 /mnt  # Mount a filesystem
umount /mnt         # Unmount a filesystem
lsblk               # List all available block devices
df -h               # Display disk usage (human-readable)
du -sh /dir         # Show disk usage of a directory
fsck /dev/sdX1      # Check and repair a filesystem
```
The `1 5` after the command means to run the command every 1 second, 5 times.  



### `lsblk`
`lsblk` lists all block devices and partitions, including logical volumes, in a tree.  
Shows the size, type of drive, and where it is mounted.  
```bash
lsblk
lsblk
```

### `fdisk`
`fdisk` It can also be used to create, delete, and modify partitions.  
```bash
fdisk /dev/sda
```

It can be used to view information about block devices and partitions by using `-l`.  
```bash
fdisk -l            # List all block devices and partitions
fdisk -l /dev/sda   # Show info on /dev/sda
fdisk -l | grep -i vd: Check physical disk(s)
```
Disks will end in a letter, starting with `a`.  
Partitions will end in a number, starting with `1`.  

* Disk:
    * `Disk /dev/vda:`
* Partition:
    * `/dev/vda1`

### `mount`
`mount` can be used to view filesystems on the system.  
```bash
mount               # List all mounted filesystems
mount | grep vda1   # Show the mount point for /dev/vda1
```
It can also be used to mount a filesystem.  
```bash
mount /dev/sda1 /mnt/disk1
```
This mounts the disk partition `/dev/sda1` to `/mnt/disk1`.  

### `blkid`
`blkid` shows the filesystem type and UUID of a block device.  
Shows all block devices if no disks are specified.  
```bash
blkid           # List all block devices' UUIDs, filesystem types, etc.
blkid /dev/vda1 # Show only the info for /dev/vda1 
```

### `df`
`df` shows disk usage.
You can specify a directory to show the usage of that directory.  
```bash
df -i # Inodes
df -h # Filesystem usage in human-readable format
```

To see the total size of a filesystem, you can use `df` on the directory where it is mounted.  
```bash
# Show the total size of the filesystem mounted on the root directory
df -h / | grep -v Size | awk '{print $2}' 
```
* `df -h /` Show the disk filesystem space usage in the `/` root directory.  
* `grep -v Size` will remove the line containing the word `Size`
* `awk '{print $2}'` will print 2nd column


## System Information  
```bash  
uname   # Get system info (OS/kernel type by default)  
df      # Get filesystem information  
du      # Get disk usage  
free    # Get RAM/swapfile information  
lscpu   # Get CPI information  
lshw    # Get all system information  
lsblk   # Get information about block devices (storage devices) as a tree
fdisk -l # Get more detailed information about block devices 
ulimit  # Get current settings about current system limits & more  
mount   # List mounted filesystems, or mount a filesystem
```

Use `dmidecode` to get very detailed information about the hardware on your system.  
```bash  
dmidecode
# Check if this system is physical or virtual  
dmidecode -s system-manufacturer  
```

## Logging
https://killercoda.com/het-tanis/course/Linux-Labs/102-monitoring-linux-logs
Grafana
Promtail pushes logs into the Loki server
Loki - API driven log aggregator



## Scriptable Way to Partition Disks with `fdisk`/`gdisk`
Send input to `fdisk` (or `gdisk`) without entering the interactive prompt by using a
pipe to send input to the program.  
```bash
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/sda
```
1. `echo -e "o\nn\np\n1\n\n\nw"`: This line is sending a series of commands
    to `fdisk` as follows:
    * `o`: Delete all partitions and create a new empty DOS partition table.
    * `n`: Add a new partition.
    * `p`: Makes the new partition primary.
    * `1`: Specifies it as partition number 1.
    * The three blank lines (`\n`) give the default start and end values, i.e., use the entire disk.
    * `w`: Writes the changes and exits fdisk .
    * `\n`: Each `\n` is a linebreak, same as pressing Enter in the interactive prompt.  

2. `|` : Pipe. It takes the output from the previous command (`echo`) and sends it as input to the next command (`fdisk`).

3. `fdisk /dev/sda`
    * `fdisk` is a command line utility used to create and manipulate disk partition tables.
    * `/dev/sda` specifies the first hard disk.

* This command will delete all partitions on the first hard disk and create a new primary partition that uses the whole disk.


## Wipe Existing Data on a Disk or Parition
You can use `dd` to wipe a disk by overwriting the disk.  
```bash
sudo dd if=/dev/zero of=/dev/sdb1 bs=1M count=100
```
This can wipe a disk or wipe a partition.  
Adjust the count to roughly match the size of the disk or partition you want to wipe.  


## Testing a Disk for Errors using `smartctl`
`smartctl` is a command line utility that can be used to test a disk for errors.  
```bash
smartctl -a /dev/sda            # Show all SMART info about the disk
smartctl -t short /dev/sda      # Start a quick test (~2 minutes, runs in background)
smartctl -l selftest /dev/sda   # View test results
 
smartctl -t long /dev/sda       # Run a full test (takes a long time)
smartctl -l selftest /dev/sda   # View test results 
```

