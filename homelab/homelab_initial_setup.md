# Homelab Initial Setup Notes
Just notes documenting my initial setup process for my homelab.  

This file is just kind of a stream-of-consciousness dump where I wrote down issues
and solutions I tried.  

Read at your own peril.  

## Table of Contents
* [My Hardware](#my-hardware) 
* [Initial System Setup (Installation)](#initial-system-setup-installation) 
* [Set up a New User](#set-up-a-new-user) 
* [Setting up Storage for the Homelab](#setting-up-storage-for-the-homelab) 
* [Package Setup](#package-setup) 
    * [Setting up LVM](#setting-up-lvm) 
    * [Replacing the Old Disk and Partitioning the New Ones](#replacing-the-old-disk-and-partitioning-the-new-ones) 
* [Use Web UI to Create Directory and Upload ISOs](#use-web-ui-to-create-directory-and-upload-isos) 
* [Creating the First VM](#creating-the-first-vm) 
* [Moving to ZFS](#moving-to-zfs) 
* [Setting up Monitoring](#setting-up-monitoring) 
* [Troubleshooting Write-ups](#troubleshooting-write-ups) 
    * [Troubleshooting Logical Volume Management (LVM) Commands](#troubleshooting-logical-volume-management-lvm-commands) 
    * [Troubleshooting the Disk - Creating the Logical Volume](#troubleshooting-the-disk---creating-the-logical-volume) 
    * [Troubleshooting Installation](#troubleshooting-installation) 
    * [Installation Troubleshooting Steps Taken](#installation-troubleshooting-steps-taken) 
        * [Reconfiguing BIOS (UEFI)](#reconfiguing-bios-uefi) 
        * [Re-scanning for Drives](#re-scanning-for-drives) 
        * [Updating Firmware](#updating-firmware) 
        * [Hardware RAID Controller Device settings](#hardware-raid-controller-device-settings) 
* [Initial Setup Troubleshooting TL;DR](#initial-setup-troubleshooting-tldr) 
* [Removing a VM that is Pointing to a Nonexistent Storage](#removing-a-vm-that-is-pointing-to-a-nonexistent-storage) 
* [Misc](#misc) 


## My Hardware
Machine: Dell PowerEdge R730
* Specs:
    * Memory:
        * 32GB RAM (DDR4 RDIMM)
    * CPU:
        * Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz (two of these)
        * 12 cores per socket (24 cores), 2 threads per core (48 threads)
        * x86_64 Architecture 


## Initial System Setup (Installation)
Create bootable media (flash drive) with Proxmox VE.

* Boot system - Insert flash drive into system and power on.
* Press F11 during initial setup to enter the Boot Manager.  
* Select "One Shot UEFI Boot"
* Select the bootable media containing Proxmox VE
* Select "Proxmox VE (Terminal UI)"
    * This is where I ran into an error (see [troubleshooting installation](#troubleshooting-installation)). 
    * Under "Advanced options" there is a "Proxmox VE (Terminal UI, Debug Mode)"
      option. It will drop you into a shell after each step in the installation, and you 
      can run commands to troubleshoot if you're having issues.  


---

System setup highlights:

* Choose disk: Choose the disk you want to install Proxmox VE on.
    * This will be your boot drive.  
* Set password: The password you'll use for root user access to the system.  
* Set hostname: needs to be a Fully Qualified Domain Name (FQDN)
    * An FQDN needs to look like a bit like a URL, with a host name and a domain name: 
        * `hostname.domainname`
        * Mine: `home-pve.lab`
    * The Proxmox installer should automatically detect and populate the rest of the network
      configuration for you.  


Once you hit "Install", it should install Proxmox VE and then reboot.  

---

Log into the system.

## Set up a New User


Doing everything as `root` could be dangerous, and is considered a bad practice by a
lot of people.  

Following the "Rule of Least Privilege", it's best to have a user account in 
the `sudo` group, instead of doing everything as `root`.  

We also don't want to SSH into any box as `root`, so I'll create a new user.  


```bash
useradd -m kolkhis
usermod -aG sudo kolkhis
```
* `useradd -m`: Make the user's home directory.
* `usermod -aG`: `-a`ppend `-G`roup. This adds the user to the `sudo` group without 
  affecting other group memeberships.  

or just:
```bash
useradd -m -G sudo kolkhis
```
* `-m`: Create home directory.
* `-G`: Add the user to the specified group(s).  

---

If you forgot to specify `-m` when creating the user, you'll have to create a home 
directory for him.
```bash
mkdir -p /home/kolkhis
cp -r /etc/skel/. /home/kolkhis
chown -R kolkhis:kolkhis /home/kolkhis
chmod 700 /home/kolkhis
```
* `mkdir -p`: Create the directory (including `-p`arent directories if needed)
* `cp -r /etc/skel/. /home/kolkhis`: Copy default user files to the new user's home dir.  
* `chown -R kolkhis:kolkhis /home/kolkhis`: Change the ownership of the new user's
  dir to the user `kolkhis` and the group `kolkhis`.  
* `chmod 700 /home/kolkhis`: Change the permissions of the new user's home dir to
  full permissions for the user and no persmissions for the group and others.  

---

Then, as `root`, set a password for the user:
```bash
passwd kolkhis
```

---


## Setting up Storage for the Homelab
I had a bit of trouble deciding how to go about setting up storage.  
I want it to be accessible from the network, and easy to manage.  
I looked at Ceph for this, but initial setup seems like a steep learning curve.  

So, I'm going to start with LVM to get things up and running.
I may migrate to Ceph down the road when everything else is set up and stable.  

I already created a partition earlier using `gdisk`, so I'll turn that into a single
logical volume using the `ext4` filesystem.  
```bash
# For pvs/pvdisplay, vgs/vgdisplay, lvs/lvdisplay
sudo apt install liblinux-lvm-perl
```



## Package Setup

Proxmox uses Debian as its base OS.  
Version: `Debian GNU/Linux 12 (bookworm)`  

Normal Debian is a pretty minimal operating system, and doesn't ship with a lot of 
the tools we use regularly. So, we need to install them.  
Debian-based distributions use `apt` for package management.  

`sudo` was not on the system by default, so I had to install it.
```bash
apt-get install sudo
```
I also wanted some tools to check on the system:
```bash
sudo apt-get install sysstat
```

---

### Setting up LVM

I couldn't find some LVM commands (`lvs`, `lvdisplay`, etc.), so I had to go and [find out where the commands were](#troubleshooting-logical-volume-management-lvm).  

After doing that, I provisioned the entire partition I made on the 800GB SSD as a single logical volume for
storage.  
```bash
pvcreate /dev/sdb1
vgcreate vg1 /dev/sdb1
lvcreate vg1 -n storage -l 100%FREE 
```
I got an error here and had to [troubleshoot the disk](#troubleshooting-logical-volume-management-lvm)


### Replacing the Old Disk and Partitioning the New Ones
Using `smartctl`, I discovered that the disk had seen 7 years of active use (61,436 hours, 2559.83 days)... I'm pretty sure I need to replace it.  
2554 days + 16 hours

---

I replaced the 800GB SSD.
I replaced it with a 512GB, and added an additional 3rd SSD, also 512GB.  
```bash
sdb                  8:16   0 476.9G  0 disk
sdc                  8:32   0 476.9G  0 disk

Disk /dev/sdb: 476.94 GiB, 512110190592 bytes, 1000215216 sectors
Disk model: FIKWOT FX812 512
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/sdc: 476.94 GiB, 512110190592 bytes, 1000215216 sectors
Disk model: FIKWOT FX815 512
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```
I will turn these into Logical Volumes, and provision 100GB for ISOs and the rest will be for provisioning VMs/containers.  

---


---

I decided to try using the Web UI provided by Proxmox to provision these disks. 
I did a test run of doing this with one of the 512GB disks for storing ISOs.
It created a **partition** that used the entire capacity of the disk, `/dev/sdb1`, and mounted it on `/mnt/pve/iso_storage`.
Now, seeing as I have two 512GB SSDs, and 512GB seems like overkill for ISO storage, I am going to create a 100GB partition on one drive (`/dev/sdb`) for ISO storage, and see if I can provision the rest for VMs.  
I'm unable to use the Web UI to provision Logical Volumes, so I'm going to create partitions instead. 

```bash
sudo gdisk /dev/sdb
o  # Create new partition table
n  # Create new partition
p  # Make it the primary partition
# Use defaults for everything except "Last sector", set to +100G
w  # Write changes
```
Then I created another partition using the rest of the disk, and made the second disk one partition using the whole disk.  

I created a Volume Group named `VMs`, through the Proxmox Web UI, using the second partition of the `/dev/sdb` disk.
Strangely, this volume group is not visible using `lsblk`.  

## Use Web UI to Create Directory and Upload ISOs
I used the Proxmox Web UI to provision the 100GB partition for ISO images.
```yaml
Datacenter > homepve > Disks > Directory > Create: Directory
Select '/dev/sdb1', 'ext4', Name: "ISO_Storage"
```
This creates the directory `/mnt/pve/ISO_Storage` and populates it with the necessary files that Proxmox
needs

Upload ISOs to the new directory 
```yaml
Datacenter > home-pve > ISO_Storage > ISO Images > Upload
```
The images that are uploaded are stored in:
```bash
/mnt/pve/ISO_Storage/template/iso/ 
```
I uploaded several ISO images to this.  


## Creating the First VM

After the ISOs are uploaded, click "Create VM" at the top right.  
It will take you through a setup process.  
You'll select the ISO storage you set up, and select the ISO from there.  
Under "Disks", select the Volume Group `VMs` (or whatever you named it) and give it some disk space. Be generous but don't exceed the disk size, and leave space for other VMs.  

Under CPU you can assign the number of cores to use. My PowerEdge R730 has 24 cores x 2 threads each (48), I decided to assign 4 cores. 
I assigned 4GB of RAM (4096).  
The rest, defaults.

I decided to use Ubuntu Server 22.04.01 LTS.  
Use the "Console" in the Web UI to go through installation of the guest OS.  

* Consideration: I found out after the fact that VMs running on `ext4` filesystems do not support snapshots 

---

## Moving to ZFS
I wanted support for VM snapshots, so I'm thinking I'll go for ZFS.  
I'll [move to ceph later](~/scratch/migration_to_ceph.md) when I get more nodes.  

* Erase any existing partitions on the disks you want to use:
  ```bash
  wipefs -a /dev/sd{b,c}
  ```

* Create a ZFS Pool:
    * `RAID 1`: If you want redundancy, use a `mirror`. This will mirror across both disks.  
      ```bash
      zpool create <poolname> mirror /dev/sdb /deb/sdc
      ```
    * `RAID 0`: If you want performance, use striping. This is the default, so just don't use `mirror`.  
      ```bash
      zpool create <poolname> /deb/sdb /dev/sdc
      ```
      I'm going to use a `RAID 0` setup for now, and name my pool `vmdata`.  
      ```bash
      zpool create vmdata /dev/sdb/ /dev/sdc
      ```

Creating a ZFS pool created some interesting partitions in `lsblk`:
```bash
sdb                  8:16   0 476.9G  0 disk
├─sdb1               8:17   0 476.9G  0 part
└─sdb9               8:25   0     8M  0 part
sdc                  8:32   0 476.9G  0 disk
├─sdc1               8:33   0 476.9G  0 part
└─sdc9               8:41   0     8M  0 part
```


* Configure the Pool in the Proxmox Web UI:
    * Go to `Datacenter > Storage > Add > ZFS`
    * Select the pool name, and proxmox will handle the integration.  


* Using snapshots:
    * Create manual snapshots with:
      ```bash
      zfs snapshot poolname/dataset@snapshot-name
      ```
    * Or, enable automatic scheduled snapshots using `zfs-auto-snapshot`.  


* You can add compression if you want, to save space. Maybe not great for my
  hardware, but ZFS supports it.
    * ZFS supports "transparent compression" for better performance and space efficiency.  
      ```bash
      zfs set compression=on poolname
      ```

---

I switched the Ubuntu Server VM over to the new ZFS storage.  

That's the end of the system setup portion of this.  

## Setting up Monitoring

See [monitoring setup](../linux/monitoring/monitoring_tools.md)

---




## Troubleshooting Write-ups
### Troubleshooting Logical Volume Management (LVM) Commands

When trying to create a new logical volume from the second disk, I ran into a 
problem where I did not have the `pvs`/`pvdisplay`, `vgs`/`vgdisplay`, or 
`lvs`/`lvdisplay` commands on the system.

With a quick `apt search lvdisplay` I find the package:
```plaintext
`liblinux-lvm-perl/stable 0.17-4 all`
    Perl module to access LVM status information
 Linux::LVM parses the output from vgdisplay, pvdisplay, and lvdisplay and
 makes it available as a Perl hash.
```
After installing `liblinux-lvm-perl` on my homelab I did not have access to the commands `pvs`/`pvdisplay`, `vgs`/`vgdisplay`, or `lvs`/`lvdisplay`.

Looking at the ProLUG lab environment:
```bash
dnf whatprovides pvs
```
Shows the package:
```plaintext
lvm2-9:2.03.23-2.el9.x86_64 : Userland logical volume management tools
```

I'll try installing the `lvm2` package:
```plaintext
kolkhis@home-pve:~/scratch$ sudo apt install lvm2
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
lvm2 is already the newest version (2.03.16-2).
0 upgraded, 0 newly installed, 0 to remove and 77 not upgraded.
```
The package is already installed.  

I search for the binary itself. It must be on the system somewhere since
I have the package installed.  
```bash
sudo find / -name pvs 2>/dev/null
# Output:
# /usr/sbin/pvs
# /usr/share/bash-completion/completions/pvs
```
So, the commands are there, but not in the path.
I'll add `/usr/sbin` to my `$PATH` environment variable in `~/.bashrc`.  
```bash
export PATH="$PATH:/usr/sbin"
```


---

### Troubleshooting the Disk - Creating the Logical Volume 
After finding the executables, I tried to create the logical volume again, but 
got an error when running `lvcreate`:
```plaintext
kolkhis@home-pve:~/scratch$ sudo lvcreate vg1 -n storage -l 100%FREE
[sudo] password for kolkhis:
Interrupted initialization of logical volume vg1/storage at position 0 and size 4096.
Aborting. Failed to wipe start of new LV.
Error writing device /dev/sdb1 at 7168 length 1024.
WARNING: bcache_invalidate: block (0, 0) still dirty.
Failed to write metadata to /dev/sdb1.
Failed to write VG vg1.
Manual intervention may be required to remove abandoned LV(s) before retrying.
```
After this happened the device no longer showed up in `lsblk` or `fdisk -l`.  
The light on the disk's caddy was blinking, so I reaseated the disk and it was recognized again.  

---

I decided to try to recreate the LV:
```bash
sudo lvremove vg1  # Removes LVs that are using vg1
sudo lvcreate vg1 -n storage -l 100%FREE  # try creating again
```
Same error.

After some research I decided to wipe the disk to make sure all signatures and 
metadata, like LVM/RAID/filesystem data, was removed.  

Clear the signatures using `wipefs`:  
```bash
sudo wipefs -a /dev/sdb1
# Output:
# /dev/sdb1: 8 bytes were erased at offset 0x00000218 (LVM2_member): 4c 56 4d 32 20 30 30 31
```

Zero out the start of the partition with `dd`:  
```bash
# Zero out the first 100MB of the disk
sudo dd if=/dev/zero of=/dev/sdb1 bs=1M count=100
```

I tried to remake everything.  
```bash
# I reinitialized it as a physical volume
sudo pvremove /dev/sdb1
sudo pvcreate /dev/sdb1
# I remade the volume group too, in case it was corrupted by earlier attempts:
sudo vgremove vg1
sudo vgcreate vg1 /dev/sdb1
# Then attempted to remake the LV
sudo lvcreate -l 100%FREE -n storage vg1
```
Same issue.  

Though, with `lvs`, the logical volume is listed. 
When using `lvdisplay` I get the following output:
```bash
  --- Logical volume ---
  LV Path                /dev/vg1/storage
  LV Name                storage
  VG Name                vg1
  LV UUID                oIGNGn-uerx-YrAi-giDl-xTtf-1beQ-V7IWzc
  LV Write Access        read/write
  LV Creation host, time home-pve.lab, 2024-11-19 08:59:35 -0500
  LV Status              NOT available
  LV Size                745.21 GiB
  Current LE             190774
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
```

* `LV Status` is `NOT available`. 

The logical volume storage is visible in the output of `lvs` with the expected 
size after the disk reseat, it does indicate that `lvcreate` partially 
succeeded... but the recurring errors and need to reseat the disk are serious 
red flags.

I manually activated the LV with `lvchange`
```bash
lvchange -ay vg1/storage
```
This changed the output of `lvdisplay` to show `LV Status` as `available`.  

I'll now try to format and mount the logical volume. 
```bash
# sudo mkfs.ext4 /dev/mapper/vg1-storage
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done
Creating filesystem with 195352576 4k blocks and 48840704 inodes
Filesystem UUID: d7ae3783-8b2a-4778-80b7-fda888e85e13
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000
Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
```
Got an error at the end, and had to reseat the disk for it to be recognized by the system again.  


As per ChatGPT's advice, I'm going to try to use the `smartctl` tool to check for signs of hardware failure.  
Using `smartctl`, I discovered that the disk had seen 7 years of active use (61,436 hours, 2559.83 days)... I'm pretty sure I need to replace it.  
2554 days + 16 hours





### Troubleshooting Installation
First Error: 
`The installer could not find any supported hard disks.` 

??? info "Spoiler Alert (Fix)"

    Fix: Boot into BIOS (F11 on startup), go to "Device Settings".  
    There is an option in the BIOS in the "Device Settings", under the "Hardware 
    RAID Controller", that says "Convert to Non-RAID Disk". 

    This must be done for each disk.  

I have an 800GB SSD in drive bay 0.  

I hit "OK" and was dropped into a bash shell on the Proxmox VE system.
I need to check out the disks:

```plaintext
root@proxmox:/# lsblk
loop0
loop1
sda - mounted /cdrom
- sda1
- sda2
- sda3
- sda4
sr0 
(partial output, can't copy/paste it here)
root@proxmox:/# fdisk -l
124000 cylinders, 24 heads, 20 sectors/track, 61440000 sectors
Units: sectors of 1 * 512 = 512 bytes

Device  Boot  StartCHS      EndCHS      StartLBA EndLBA  Sectors Size  Id Type
/dev/sda1     0,0,2         1014,23,20  1        2716387 2726387 1331M ee EFI GPT
```

The `sda` disk is the flash drive with the bootable media.  
I'm not seeing any drive close to 800GB, so that means my SSD is not being detected
by the system.  


I have another SSD I can test, a 240GB SATA drive. I will set that up in a caddy and
install it (the drive bays on the machine are hot-swappable, so I should be able to
do this without rebooting the system).  

---

### Installation Troubleshooting Steps Taken

#### Reconfiguing BIOS (UEFI)

I wound up switching up some ~BIOS~ UEFI settings.
The "Embedded SATA" setting was set to "RAID Mode", I tried both "AHCI" and "ATA",
and both produced the same error.  
It's currently sitting in AHCI mode right now.

After switching to AHCI mode, I added a second disk (the aforementioned 240GB SATA SSD), and that one was not recognized either.

---

#### Re-scanning for Drives 
Using the Proxmox shell, I'll re-scan for drives with this nifty command I found:
```bash
echo "- - -" | sudo tee /sys/class/scsi_host/host*/scan

```

This did not change the output of either `lsblk` or `fdisk -l`

---

#### Updating Firmware
In boot, press F10 to get to the Lifecycle Controller.
Go down to Firmware Update, and go to the Update firmware link.  
Select HTTPS for the update method, this will search for firmware from Dell.  

#### Hardware RAID Controller Device settings
Under "device settings" (after hitting F2 for system setup at boot), I checked the "disk settings" and finally found signs of life for the two SSDs I have in the system. It seems they were configured for RAID. This does make sense considering they as used devices that were formerly used in enterprise environments.  
There are some options here for operations to perform on the disks:

* `blink` 
* `unblink` 
* `clear`

I'm trying `clear` on both of the SSDs. 
Then I'll reboot and see if the disks are then recognized by the system when trying to install Proxmox.  

This did not help.

---

There was also an option I overlooked in the "Device Settings", under the Hardware RAID Controller, that says "Convert to Non-RAID Disk". 
I did this for both the disks currently in the system. 
Rebooting into the Proxmox VE installer...

---

The installer now boots correctly and recognizes the disks. 
However, when I select "Install Proxmox VE (Terminal UI)" using the 800GB SSD, it fails 
on the step `creating LV`, at 3%, with the error:
```error
unable to create swap
```
I tried doing this 2 times, and the 800GB SSD stopped being recognized by the system after the second time. 

I boot into the proxmox shell using  "Install Proxmox VE (Terminal UI, Debug Mode)" in the installer. 
I now see the 240GB disk in `lsblk` and `fdisk -l` as `/dev/sda`.
The 800 GB disk is not being detected.
Since I have access to this disk right now, I'm going to try and format it using the tools offered by the Proxmox shell.
The 240GB disk does not contain a partition table, and I assume the 800 GB disk is the same, since I followed the same exact steps for each of these drives.
I'm wondering if the reason this is failing is because the drives don't already have partition tables on them.  
I want to put a GPT partition table on it (since MBR is deprecated), so I'll use `gdisk` to do that

```bash
gdisk /dev/sda
o  # Create a new empty GPT partition table
n  # Create a new partition
p  # Make it the primary partition
# Use defaults
w  # Write changes (otherwise they won't be applied)
```

I went on with the installation from here.
It got past the "Creating LV" step, and it's chugging along nicely. 
The installation was successful on the 240GB SSD.  


I still need to figure out what to do about the 800 GB disk.
I now know I need to create a partition table on it.
After reseating the disk, I was able to see it using `lsblk`. 

It still had some data on it from trying to install proxmox. I deleted the partition using `gdisk`, created a GPT partition table on the disk, and a partition, using `gdisk` with the same commands as before.  

I tried to install Proxmox VE again on the 800GB disk, it got past the 3% error, but it failed at around 89%: `failure: unable to initialize physical volume /dev/sda3`
I decided to keep the 240GB SSD installation and use the 800GB SSD for storage.  




## Initial Setup Troubleshooting TL;DR:
I have 2 disks in the system. A 240GB SSD in Bay 0 and an 800GB SSD in bay 1.  
The disks were not being recognized by the system. When trying to run the proxmox installer from USB, I kept getting the error `The installer couldn't find any supported hard disks.`

I hit `OK` and was dropped into a bash shell on the Proxmox VE system. Cool! I have a shell to use for troubleshooting.  
I went into the BIOS, changed the Embedded SATA controller to AHCI mode from RAID mode. Still nothing.  
After a lot of hair pulling, I finally found some signs of disk life in the Hardware RAID Controller's device settings, under "Physical Disk Management".

The disks were configured as RAID disks for the Hardware RAID Controller. 
I went to the hardware RAID controller under Device Settings, went to "Physical Disk Management", and converted the disks to "Non-RAID" disks.

The Proxmox Installer was now able to see the disks.  
Then when trying to install Proxmox VE on the 800GB disk, it failed at "Creating LV" (3%) with the error: `unable to create swap volume`

After failing to install twice with this error, I entered the Proxmox shell and tried to format the 800 GB disk. But it was not visible with `lsblk`/`fdisk -l`. Neither of the disks were.  

I read somewhere that RAID configuration could be problematic with disks, so I cleared the RAID controller's configuration.  
I rebooted after doing this.

This time I ran the installer in Debug Mode.  
Booting into the proxmox shell, I was able to see the 240 GB SSD in `lsblk` and `fdisk -l` as `/dev/sda`.
I decided to install the Proxmox VE on the 240 GB SSD.
It did not have a partition table. I thought this may be why it's acting up, so I created one using `gdisk` (for GPT partition table, since MBR is only for older systems). 
I also created a partition on the disk while in `gdisk`.  
I continued the installation after doing that and it worked.  


After I booted into Proxmox, I was able to see the 800 GB SSD in `fdisk -l`/`lsblk`. I formatted it the same way I formatted the other one.

Then I tried installing again on the 800GB drive. It failed with a different error: 
`Unable to initialize physical volume /dev/sda3`

F#$! it. I can still use it for storage on the system, so I will keep the 240 drive as my boot drive.

I did a small write-up (a summary of all the notes I took while troubleshooting), if anyone is interested


## Removing a VM that is Pointing to a Nonexistent Storage
When I switched to ZFS from paritions/lvm, I neglected to destroy the VM I had set
up using that volume group, named `VMs`.  

I checked `/etc/pve/storage.conf`, no reference to VMs. 
I checked `/etc/pve/qemu-server/100.conf`, and there were references to `VMs` in
there. I deleted them and saved.  

```bash
sudo vim /etc/pve/qemu-server/100.conf
# delete any reference to the VMs volume group
sudo systemctl restart pvedaemon.service pveproxy.service pvestatd.service
```
That solved the issue, I was able to remove the VM after that.  

I could have tried pointing it at the new ZFS pool, but I wanted to start fresh
anyway.  

---



## Misc
Restarting services after changing hostname:
```bash
sudo systemctl restart pvedaemon pveproxy pvestatd
```



