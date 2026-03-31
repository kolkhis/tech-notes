# Linux From Scratch (LFS)


## What is LFS?

- [Linux From Scratch](https://www.linuxfromscratch.org/)

Linux From Scratch (LFS) is a project that provides instructions for building 
your own custom Linux operating system directly from source code.

It is designed for Linux users who want to gain a deeper understanding of the
inner workings of the operating system.  

---

These notes will document building my own Linux operating system by using LFS
as a base. The OS will use common enterprise technologies (e.g., systemd)
rather than more obscure tools. I made this choice to gain a deeper
understanding of the OS components used in enterprise environments.  


## Starting Out

LFS follows Linux standards as closely as possible.

The standards followed: 

- [POSIX.1-2008](https://pubs.opengroup.org/onlinepubs/9699919799/)
    - The POSIX specification.  
- [Filesystem Hierarchy Standard (FHS) Version 3.0](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
    - The filesystem structure.  
- [Linux Standard Base (LSB) Version 5.0 (2015)](https://refspecs.linuxfoundation.org/lsb.shtml)
    - The LSB consists of several separate specifications:
        - Core
        - Desktop
        - Runtime Languages
        - Imaging

The core packages that are included in a system built to the LFS standard are
listed [here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/prologue/package-choices.html)
along with explanations on why they were included.  

### Chapter Overview
For chapters 1-4:
- Anything done as the root user after Section 2.4 must have the `LFS` environment variable set FOR THE ROOT USER.

- The `LFS` variable must be set at all times, and the `umask` needs to be set to `0022`.

For chapters 5-6:

- The partition should be at `/mnt/lfs` and always be mounted.  

- Chapters 5 and 6 must be done as the `lfs` user system account.  
    - Create the `lfs` user and group.  
    - Use `su - lfs` for each task in these chapters.  

For chapters 7-10:
- `/mnt/lfs` should be mounted.  

## Setting up the Build Environment

The LFS project is built within a pre-existing Linux system.  
A disk partition is made for the LFS filesyste and that's where the new OS is
going to be built.  

The list of dependencies for builting an LFS system can be found 
[here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/hostreqs.html). 

They provide a shell script on that page that checks for the dependencies on
the host system and ensures they're on the correct versions.  

My host system used for building is Ubuntu Server 22.04.3, using the default 
LVM installation.

### Adding a New Virtual Disk

Step one is to create a partition on which to build the LFS system.  

With an LVM installation on a VM, there are two options.  

1. Add a second virtual disk.  
2. Shrink and create space for another partition in LVM.  

I'm going to opt for adding a second virtual disk to the VM in Proxmox.  

From the Proxmox Web UI, go to the VM, select the Hardware tab, and add a new 
hard disk.
Choose your storage pool (default is fine if there are no others set up).  

My current disk for build is listed as `/dev/sdb` in the system.  
This will be the dedicated LFS disk referred to for the rest of the build in 
this document.  

--- 

### Paritioning The Disk

- Book Source: [Chapter 2.4](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/creatingpartition.html)  

There are several partitions **required** for a Linux system:

- The root partition `/`
- The swap partition 
- The EFI boot parition
- The GRUB BIOS partition (optional but needed for BIOS/Legacy boot and Secure Boot)

The disk partitioning can be automated via `sfdisk`.  

Define sizes for the partitions needed via an `sfdisk` script:
```bash
# Partition table type
label: gpt
unit: sectors
first-lba: 2048

# BIOS boot partition
# This `type` specifies a BIOS Boot Partition
size=1M, type=21686148-6449-6E6D-744E-6574626F6F74, name="BIOS_Boot"

# 1. /boot (EFI System Partition) - 1GB
# type=U is the shortcut for EFI System
size=1G, type=U, name="EFI_System"

# 2. Swap - 4GB
# type=S is the shortcut for Linux Swap
size=4G, type=S, name="Linux_Swap"

# 3. / (Root) - Remainder of disk
# type=L is the shortcut for Linux Filesystem
type=L, name="Linux_Root"
```

Save that script into a file, then pass the file via stdin to `sfdisk`:
```bash
sudo sfdisk /dev/sdb < ./sfdisk_disk_layout
```

Check the disk:
```bash
sudo fdisk -l /dev/sdb
```

The output should look like:
```txt
Device        Start      End  Sectors Size Type
/dev/sdb1      2048     4095     2048   1M unknown
/dev/sdb2      4096  2101247  2097152   1G EFI System
/dev/sdb3   2101248 10489855  8388608   4G Linux swap
/dev/sdb4  10489856 67108830 56618975  27G Linux filesystem
```

- `/dev/sdb1` is our BIOS boot partition.  
- `/dev/sdb2` is our EFI system partition.  
- `/dev/sdb3` is our SWAP partition.  
- `/dev/sdb4` is our root filesystem partition.  

### Formatting Partitions with Filesystems

- Book Source: [Chapter 2.5](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/creatingfilesystem.html)

Now we can format these partitions.  

- The BIOS boot partition (/dev/sdb1) requires no filesystem.    
- EFI system partition requires FAT32
- SWAP partition requires SWAP
- Rootfs requires EXT4

```bash
mkfs.vfat -F32 /dev/sdb2
mkswap /dev/sdb3
mkfs.ext4 /dev/sdb4
```

Disk should look like this:
```txt
kolkhis@lfs-builder:~$ lsblk -f /dev/sdb
NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sdb
├─sdb1
├─sdb2 vfat   FAT32       08D0-FC00
├─sdb3 swap   1           e81488ff-eb87-4fdf-bcbc-c6bc2b335a91
└─sdb4 ext4   1.0         ea99de3f-5513-4338-8e88-878a51dade4c
```

### LFS Variable/Umask

- Book Source: [Chapter 2.6](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/aboutlfs.html)

LFS requires a `$LFS` variable to be set to the desired mountpoint for the LFS
partition.    

The umask also needs to be set to `022`. 

```bash
export LFS="/mnt/lfs"
sudo umask 022
```

### Mounting the Partition

- Book Source: [Chapter 2.7](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/mounting.html)

Mount the root filesystem partition (`/dev/sdb4`).  
```bash
mkdir -pv "$LFS"
mount -v -t ext4 /dev/sdb4 "$LFS"
chown root:root "$LFS"
chmod 755 "$LFS"
```

If we are using a swap partition, ensure that it is enabled using the `swapon` command:
```bash
sudo swapon /dev/sdb3
sudo swapon
#NAME      TYPE      SIZE USED PRIO
#/swap.img file        3G   0B   -2
#/dev/sdb3 partition   4G   0B   -3
```

## Packages

- Book Source: [Chapter 3.1](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/introduction.html)

The `$LFS/sources` directory will be used to store the packages and their
sources.  

It's recommended to make this writable and "sticky" (only the owner can delete
files inside).  
```bash
mkdir "$LFS/sources"
chmod 1755 "$LFS/sources"
```

The packages can be fetched individually or from a curated list specifically
for LFS.  

A full list, line-by-line, can be found
[here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list-systemd).  

Use `wget` to fetch all tarballs and patches.  
```bash
curl -O https://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list-systemd
wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources
```





<!-- - Add GPT disk partition table: -->
<!--   ```bash -->
<!--   sudo gdisk /dev/sdb -->
<!--   # n -->
<!--   # Enter (defaults are fine) -->
<!--   # w -->
<!--   ``` -->

<!-- - Format the partition: -->
<!--   ```bash -->
<!--   sudo mkfs.ext4 /dev/sdb1 --> 
<!--   ``` -->

<!-- - Add a mount point: -->
<!--   ```bash -->
<!--   sudo mkdir /mnt/lfs -->
<!--   ``` -->

<!-- - Grab the UUID for persistent mounting (`blkid` or `lsblk -f`): -->
<!--   ```bash -->
<!--   sudo blkid /dev/sdb1 -->
<!--   # /dev/sdb1: UUID="aa9db16e-7a70-4694-9f25-4930f82b29d5" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="Linux filesystem" PARTUUID="9ebbd1f2-1695-4ef2-9c29-4483c3664d9c" -->
<!--   ``` -->

<!-- - Add to `/etc/fstab`: -->
<!--   ```bash -->
<!--   UUID=aa9db16e-7a70-4694-9f25-4930f82b29d5 /mnt/lfs ext4 defaults 0 0 -->
<!--   ``` -->

<!-- - Mount the partition from the `fstab` file: -->
<!--   ```bash -->
<!--   sudo mount -a -->
<!--   ``` -->




## Resources

- Basic Resources: <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter01/resources.html>
- FAQs: <https://www.linuxfromscratch.org/faq/>
- <https://systemd-by-example.com/>


