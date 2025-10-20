# Bash Commands for Disk Management and Monitoring

Also see [the sysadmin cheatsheet](../sysadmin_command_cheatsheet.md).  


## Table of Contents
- [Commands for Disk/Hardware Management and Monitoring](#commands-for-diskhardware-management-and-monitoring) 
    - [`lsblk`](#lsblk) 
    - [`fdisk`](#fdisk) 
    - [`mount`](#mount) 
    - [`blkid`](#blkid) 
    - [`df`](#df) 
- [System Information](#system-information) 
- [Logging](#logging) 
- [Scriptable Way to Partition Disks with `fdisk`/`gdisk`](#scriptable-way-to-partition-disks-with-fdiskgdisk) 
- [Wipe Existing Data on a Disk or Parition](#wipe-existing-data-on-a-disk-or-parition) 
- [Testing a Disk for Errors using `smartctl`](#testing-a-disk-for-errors-using-smartctl) 


 

## Disk/Hardware Management and Monitoring
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
lsblk -f            # Same as above but also list UUIDs and FS types
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

- Disk:
    - `Disk /dev/vda:`
- Partition:
    - `/dev/vda1`

### `mount`
Without args, `mount` will dump every file system that's mounted, in the order they were mounted.  
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

---

Syntax for mounting a file system to a directory:  
```bash  
mount -t type /dev/device directory  
```

- `-t`: Optional. Specifies the type of filesystem to be mounted. (e.g., `ext4`, `ntfs`, `zfs`)
    - `mount -t xfs`: Tells `mount` that the `-t`ype of file system is `xfs`.  
    - `ext4` and `xfs` are some of the most common file system formats in the industry.  
    - By default, mount will use `/etc/fstab` if either `device` or `directory` are omitted.
        - The `mount` program does not read the `/etc/fstab` file if both `device` and `directory` are given. 
    - The `/etc/fstab` (file system tables) file contains info about the file systems and 
      their mount points.  
    - `mount` uses this file to determine how to mount certain filesystems automatically,
      when the user doesn't specify exactly how to mount them.  
    - If you want to override mount options from `/etc/fstab`, use the `-o` option:  
      ```bash  
      mount /device/or/directory -o options  
      ```
    - The `mount` options from the command line will be appended to the list of options from `/etc/fstab`.  


Example of making and mounting a file system:  
```bash  
mkfs.ext4 /dev/xvdc1  
mount -t ext4 /dev/xvdc1 /directory  
```
This uses an existing partition (`/dev/xvdc1`), formats it with the `ext4` format,
and mounts it to the directory `/directory`

#### `mount -a`
Using `mount -a` reads all entries in `/etc/fstab` and makes sure everything is
mounted where it should be.  

If you have an entry in `/etc/fstab` but the filesystem isn't mounted, instead of
rebooting you can just use `mount -a`.  

### `umount`
Unmount a file system.  
```bash
umount /  # Unmounts the filesystem that is mounted at / (root)
umount /mnt/disk1  # Unmounts the filesystem that is mounted at /mnt/disk1
```


If a file system has file handles open in it, you can't unmount it.  

- To check if there are any files open in a file system:  
  ```bash  
  du /boot/efi  
  lsof /boot/efi
  ```
  If `du` hangs, there is something is wrong with the file system.  
  `lsof` will list all the file open in the file system.  
- This will force it to unmount (NOT recommended!):  
  ```bash  
  umount -l /boot/efi  
  ```
    - This could potentially leave zombie processes running.  


#### Remounting
You can either use `umount` to unmount and then `mount` to mount, or use `mount -o remount`
```bash
mount -o remount /boot/efi  # Remount the `/boot/efi` file system (the boot partition).  
```

- `mount` reads from `/etc/mtab` when it does this.  
    - Never edit `/etc/mtab` in real-time yourself. 

This example tells the kernel to attach the filesystem found on `/dev/device` (which is the 
given `type`) at the directory `dir`.  


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

- `df -h /` Show the disk filesystem space usage in the `/` root directory.  
- `grep -v Size` will remove the line containing the word `Size`
- `awk '{print $2}'` will print 2nd column


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
    - `o`: Delete all partitions and create a new empty DOS partition table.
    - `n`: Add a new partition.
    - `p`: Makes the new partition primary.
    - `1`: Specifies it as partition number 1.
    - The three blank lines (`\n`) give the default start and end values, i.e., use the entire disk.
    - `w`: Writes the changes and exits fdisk .
    - `\n`: Each `\n` is a linebreak, same as pressing Enter in the interactive prompt.  

2. `|` : Pipe. It takes the output from the previous command (`echo`) and sends it as input to the next command (`fdisk`).

3. `fdisk /dev/sda`
    - `fdisk` is a command line utility used to create and manipulate disk partition tables.
    - `/dev/sda` specifies the first hard disk.

- This command will delete all partitions on the first hard disk and create a new primary partition that uses the whole disk.


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




Weird things about `mount`:  

- The same filesystem can be mounted more than once.  
- In some cases (e.g., network filesystems) the same filesystem can be mounted on the 
  same mountpoint multiple times.  

Example of making and mounting a file system:  
```bash  
mkfs.ext4 /dev/xvdc1  
mount -t ext4 /dev/xvdc1 /directory  
```
This uses an existing partition (`/dev/xvdc1`), formats it with the `ext4` format,
and mounts it to the directory `/directory`


- `umount`: Unmount a file system.  
    - If a file system has file handles open in it, you can't unmount it.  
    - This will force it to unmount (NOT recommended!):  
      ```bash  
      umount -l /boot/efi  
      ```
        - This could potentially leave zombie processes running.  

    - To check if there are any files open in a file system:  
      ```bash  
      du /boot/efi  
      lsof /boot/efi
      ```
      If `du` hangs, there is something is wrong with the file system.  
      `lsof` will list all the file open in the file system.  


- `lsof` - Lists all open files and the processes that are using them.  
  ```bash  
  lsof /proc  
  ```
    - Shows process IDs (PIDs).  
    - You can check the PID of the shell you're in (with `echo $$`) against the
      output of `lsof` to see if you're currently in that file system.  
    - You can check your shell's PID against `lsof /root` to see if you're currently  
      in that file system.  

---

- `journalctl` 
    - Log analysis tools like `journalctl` can be used to quickly triage system issues 
      based on error severity.
      ```bash
      journalctl -p 3 -xb
      ```
        - `-p 3`: Show only logs with the given priority. 
            - In this case, only messages with an error level of 3 or higher (critical errors)
        - `-x`: Add explanatory help texts about the logs from the "message catalog", which provides possible causes or solutions to certain log messages.  
        - `-b`: Show only the latest boot.  

- `mkfs`
    - `mkfs.<Tab>` will show all the different types of file systems you can make using bash completion.  
        - e.g., `mkfs.ext4`, `mkfs.xfs`, etc.
    - This will format a block device with the given type.  
    - All inode pointers on the block device are deleted when formatted with `mkfs`, but 
      the data still remains on the disk. Forensic tools can recover that data.  

- `sar`: Collect, report, or save system activity information.  
- `lsblk`: Lists all mount points that are block devices  
- `blkid`: Locates and prints block device attributes. Shows the TYPE of filesystem.
- `tune2fs`: Shows information about a block device/file system  
  ```bash  
  tune2fs -l /dev/vda1  # -l lists all the information about the file system  
  ```
    - Shows when a file system was created, mounted, etc.  
    - This command can also tune a file system (mount it as root)  
    - Can use `tune2fs` to fix file systems, but not when they're mounted.  

- `dumpe2fs`: Get more verbose information about a file system/block device  
  ```bash  
  dumpe2fs /dev/vda1  
  ```
    - This command has a bunch of repair functions.  
    - This is usually used for very low-level troubleshooting.  



- `mdadm`: Manage MD devices (AKA Linux Software RAID).  
    - This is used to create and manage RAID devices. 
    
- `dd`
- `mttr`

- `fsck` - never run on mounted file systems  
- `df -h`: Show disk space usage (in a `-h`uman readable format)
- `w`: Shows who is logged in on the system.  


- `fdisk`: Disk partitioning tool. 
    - This allows you to view, modify, create, and delete disk partitions  
    - E.g., `fdisk /dev/xvdc`  
        - Any changes made with `fdisk` need to be written with `w` to be saved.  
  - Example: List all `xvd` partitions  
    ```bash  
    fdisk -l | grep -i xvd  
    ```
    This will list all partitions of a particular type (`xvd` in this example).  
    - This can be used with many disk partition table formats: `GPT`, `MBR`, `Sun`, `SGI` and `BSD` partition tables.
        - `GPT` (GUID Partition Table) is part of the UEFI specification. This is the modern replacement for the older `MBR` partitioning system.  
            - GUID: Globally Unique Indentifier  
        - `MBR` (Master Boot Record) was used on older BIOS-based systems.  
        - `Sun` is used on Solaris-based systems or on SPARC architecture.   
        - `SGI` (Silicon Graphics Inc) partition tables are specific to `IRIX`. Used in legacy SGI hardware and systems runnin IRIX.  
        - `BSD` (Berkeley Software Distribution) partition tables are used on BSD-based systems. Sometimes called disklabels.  
    - `fdisk` has other programs in the same family for editing GUID Partition Tables (GPT): 
        - `cgdisk`: Curses-based GPT editor 
        - `gdisk`: Non-curses-based, feature-rich GPT editor
        - `sgdisk`: GPT editor driven via command-line options.

