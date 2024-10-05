# Logical Volume Management (LVM)

## Table of Contents
* [What is LVM?](#what-is-lvm) 
* [How does LVM work?](#how-does-lvm-work) 
* [Where Logical Volumes are Stored](#where-logical-volumes-are-stored) 
* [LVM Tools Cheatsheet](#lvm-tools-cheatsheet) 
* [LVM, Step by Step](#lvm-step-by-step) 
    * [Raw Disks and Physical Volumes](#raw-disks-and-physical-volumes) 
        * [Checking the Type of a Disk](#checking-the-type-of-a-disk) 
    * [Physical Volumes and Volume Groups](#physical-volumes-and-volume-groups) 
    * [Volume Groups and Logical Volumes](#volume-groups-and-logical-volumes) 
    * [Formatting and Mounting Logical Volumes](#formatting-and-mounting-logical-volumes) 
    * [Implementing RAID on Logical Volumes with mdadm](#implementing-raid-on-logical-volumes-with-mdadm) 
    * [Creating a Logical Volume from Raw Disks](#creating-a-logical-volume-from-raw-disks) 
* [Resizing Logical Volumes](#resizing-logical-volumes) 
* [Tools for Managing Physical Volumes, Volume Groups, and Logical Volumes (PV, VG, LV)](#tools-for-managing-physical-volumes-volume-groups-and-logical-volumes-pv-vg-lv) 
    * [Physical Volume Management](#physical-volume-management) 
    * [Volume Group Management](#volume-group-management) 
    * [Logical Volume Management](#logical-volume-management) 
    * [Other Useful LVM Commands](#other-useful-lvm-commands) 
* [More LVM Actions](#more-lvm-actions) 
    * [Check available free space in a volume group](#check-available-free-space-in-a-volume-group) 
    * [Filesystem resizing](#filesystem-resizing) 
    * [LVM snapshots](#lvm-snapshots) 
    * [LVM Thin Provisioning](#lvm-thin-provisioning) 
* [Reverting a Logical Volume back to Raw Disks](#reverting-a-logical-volume-back-to-raw-disks) 



## What is LVM?
Logical Volume Management (LVM) allows flexible management of disk storage by 
abstracting the physical hardware and creating an easier-to-manage virtual storage layer.

## How does LVM work?

In a nutshell:
1. Raw disks are loaded into LVM as physical volumes.  
2. Those physical volumes are then aggregated into a volume group.  
3. That volume group is then used to create logical volumes.  
4. The logical volume is formatted with `mkfs` and mounted.  

From there, you can use the storage space of any of the physical volumes in the
volume group(s) to add to a logical volume.  


## Where Logical Volumes are Stored
When a logical volume is created, it's stored in `/dev/mapper` as `/dev/mapper/myvg-mylv`.  
A symlink to the LV is also created for convenience when it's created with `lvcreate`.
The symlinks are stored in `/dev/` as `/dev/myvg/mylv`.  


## LVM Tools Cheatsheet
Tools for managing Physical Volumes, Volume Groups, and Logical Volumes (PV, VG, LV):
For more indepth info on these, see [this section](#tools-for-managing-physical-volumes-volume-groups-and-logical-volumes-pv-vg-lv).  

* `pvcreate`: Creates a PV from 8e type partition
* `vgcreate`: Creates VG using PVs
* `lvmdiskscan`: Displays all storage devices
* `vgscan`: Scans all physical devices, searches for VGs
* `pvdata`: Displays debugging information about PV, reads VGDA
* `pvscan`: Scans PVs and displays active
* `pvmove`: Moves data from one PV to another inside one VG
* `vgreduce`: Removes PV from VG
* `pvdisplay`: Displays information about physical volumes
* `vgdisplay`: Displays information about volume groups
* `lvdisplay`: Displays information about logical volumes
* `vgchange`: Activates or deactivates VG
* `vgexport`: Makes VGs unknown to the system, used prior to importing them on a different system
* `vgimport`: Imports VG from a different system
* `vgsplit`: Splits PV from existing VG into new one
* `vgmerge`: Merges two VGs
* `lvcreate`: Creates LV inside VG
  ```bash
  lvcreate vg1 -n space -L 5G # Create a logical volume called space, with 5GB of storage space
  ```
    * `-n`: Name of the LV
    * `-L`: Size of the LV
    * Use `-l +100%FREE` to use all available space in the VG.  
        * `man://lvcreate 558`
    * The `-L` (`--size`) and `-l` (`--extents`) options are alternate methods of specifying size.
* `lvcreate --snapshot`: Creates a snapshot of a LV
  ```bash
  sudo lvcreate --size 1G --snapshot --name my_snapshot /dev/my_volume_group/my_logical_volume
  ```
    * This creates only a 1 gig snapshot of the LV.  
    * For a snapshot, the size can be expressed with `-l` as a percentage of the total 
      size of the origin LV with the suffix `%ORIGIN` (`100%ORIGIN` provides space for the 
      whole origin).

* `lvextend`: Increases the size of LV
* `lvreduce`: Decreases the size of LV



## LVM, Step by Step
LVM starts with turning raw disks into physical volumes. 
Then the physical volumes are aggregated into a volume group.  
The storage space of all the disks in the volume group can then be used by a logical volume.  

### Raw Disks and Physical Volumes

* **Raw disks** are unformatted, unpartitioned disks that are available for use in the LVM setup.
    * **MBR** (BIOS-based operating systems) uses the partition type code `8e` for LVM, while **GPT** (UEFI-based operating systems) uses the `lvm` flag to indicate an LVM partition.

* Before raw disks can be used by LVM, they are initialized as **physical volumes (PV)** using `pvcreate`.  
* `pvcreate` gives permission to LVM to use these raw disks as storage devices.
  ```bash
  sudo pvcreate /dev/sdb /dev/sdc
  ```
  This initializes `/dev/sdb` and `/dev/sdc` as physical volumes.


#### Checking the Type of a Disk
You can check whether a disk is using GPT or MBR by using `lsblk -f`  
```bash
lsblk -f
```
This will have a column called `PTTYPE` (Partition Type). It will show `gpt` for GPT, or `dos` for MBR.  


You can also use the `blkid` command to check the partitioning scheme:
```bash
blkid -p /dev/sda
```
* `-p`: Low-level probing mode.  
The output should indicate either `PTTYPE=gpt` for GPT or `PTTYPE=dos` for MBR.  

---

To check if the disk partitions are the correct type for LVM (`8e` or `lvm`):  

* For either MBR or GPT, you can use `lsblk` or `blkid` to see if partitions are marked for LVM
  ```bash
  lsblk -o NAME,TYPE,FSTYPE,SIZE,UUID,MOUNTPOINT
  blkid /dev/sdX  # Where X is the disk partition
  ```

* To check on MBR (Master Boot Record, used by BIOS-based operating systems):
  ```bash
  fdisk -l /dev/sdX  # Where X is the disk partition
  ```
  There will be a `Type` column that will show `8e` for LVM.  

* To check on GPT (GUID Partition Tables, used by UEFI-based operating systems):
  To check if the disks are the correct type for LVM (`8e`), you can use `fdisk -l`
  ```bash
  parted /dev/sdX  # Where X is the disk partition
  ```
  There will be a `Flags` field that will show `lvm` for LVM.  



### Physical Volumes and Volume Groups
* Once physical volumes are created, they are aggregated (grouped) together into 
  a **volume group (VG)** using `vgcreate`.
    * A volume group is essentially a pool of storage made up of the physical volumes created with `pvcreate`.
    * You can allocate space from this group when creating logical volumes.
    * E.g.:
        ```bash
        sudo vgcreate my_volume_group /dev/sdb /dev/sdc
        ```
        This creates a volume group named `my_volume_group` that includes `/dev/sdb` and `/dev/sdc`.

### Volume Groups and Logical Volumes
* The next step is to create **logical volumes (LV)** from the volume group using `lvcreate`. 
    * Logical volumes act like partitions inside a volume group, but they are much more flexible because you can resize them on the fly and span them across multiple physical volumes.
    * E.g.:
        ```bash
        sudo lvcreate -L 50G -n my_logical_volume my_volume_group
        ```
        This creates a 50GB logical volume named `my_logical_volume` from the `my_volume_group` volume group.


### Formatting and Mounting Logical Volumes
* Once the logical volume is created, you need to format it with a filesystem so it can be used to store data. This is done with `mkfs`.
    * The most common filesystems are `ext4` and `xfs`, though there are others like `btrfs`.
    * E.g.:
        ```bash
        sudo mkfs.ext4 /dev/my_volume_group/my_logical_volume
        ```
        This formats the logical volume with the `ext4` filesystem.

* After formatting, the logical volume is ready to be mounted and used like any other filesystem.
    * E.g.:
        ```bash
        sudo mount /dev/my_volume_group/my_logical_volume /mnt/my_mount_point
        ```
        This mounts the logical volume to `/mnt/my_mount_point`.


### Implementing RAID on Logical Volumes with mdadm

If redundancy or performance is a concern, you can configure RAID (Redundant Array of 
Independent Disks) using a tool like `mdadm` (Multiple Disk Admin). 
RAID and LVM are separate technologies.

* RAID provides redundancy and performance benefits, while LVM provides flexibility in managing storage. You can use them together, but they serve different purposes.
* Example (creating RAID 1 for redundancy):
    ```bash
    sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
    ```
    This creates a RAID 1 array (mirrored) with `/dev/sdb` and `/dev/sdc`.
    Then you can use `md0` as a physical volume in your LVM setup.

### Creating a Logical Volume from Raw Disks
```bash
fdisk -l | grep -i xvd  # See all xvd-type raw disks
vgcreate vg1 /dev/xvdb /dev/xvdc  # Make a volume group called vg1, with the two physical volumes xvdb and xvdc
pvs # Show all physical volumes
vgextend vg1 /dev/xvde  # Add the 3rd physical volume to the volume group
lvcreate vg1 -n space -L 5G # Create a logical volume called space, with 5GB of storage space
lvs
# The logical volume will be stored in /dev/mapper/vg1-space
mkfs.ext4 /dev/mapper/vg1-space 
mount /dev/mapper/vg1-space /space
pvdisplay  # Show more information than pvs
vgdisplay
lvdisplay
```


## Resizing Logical Volumes
One of LVM's best features is the ability to resize logical volumes dynamically.  
You can both extend or reduce the size of a logical volume.  

* To extend a logical volume, use `lvextend` and `resize2fs`:
  ```bash
  sudo lvextend -L +20G /dev/my_volume_group/my_logical_volume
  sudo resize2fs /dev/my_volume_group/my_logical_volume
  ```




---


## Tools for Managing Physical Volumes, Volume Groups, and Logical Volumes (PV, VG, LV):

### Physical Volume Management 

* `pvcreate`: Initializes a physical volume for use by LVM.
  ```bash
  sudo pvcreate /dev/sdb1
  ```
  This creates a physical volume on partition `/dev/sdb1`. 
  The partition should be of the type `8e` on MBR (BIOS-based OSs), or `lvm` on GPT (UEFI-based OSs).

* `pvdisplay`: Displays detailed information about physical volumes.
  ```bash
  sudo pvdisplay /dev/sdb1
  ```

* `pvscan`: Scans all devices for physical volumes and displays active ones.
  ```bash
  sudo pvscan
  ```

* `pvmove`: Moves physical extents (data) from one physical volume to another within the same volume group.  
    * This is useful when you need to migrate data off a failing disk or redistribute storage.
   ```bash
   sudo pvmove /dev/sdb1 /dev/sdc1
   ```

* `vgreduce`: Removes a physical volume from a volume group, but only after its data has been moved or there are no logical volumes on it.
  ```bash
  sudo vgreduce myvg /dev/sdb1
  ```

### Volume Group Management 

* `vgcreate`: Creates a volume group using one or more physical volumes.
  ```bash
  sudo vgcreate myvg /dev/sdb1 /dev/sdc1
  ```

* `vgdisplay`: Displays information about volume groups.
  ```bash
  sudo vgdisplay myvg
  ```

* `vgscan`: Scans all devices for volume groups and displays found VGs.
  ```bash
  sudo vgscan
  ```

* `vgextend`: Adds one or more physical volumes to an existing volume group, increasing its capacity.
  ```bash
  sudo vgextend myvg /dev/sdd1
  ```

* `vgreduce`: Removes a physical volume from a volume group (already covered above).

* `vgchange`: Activates or deactivates volume groups.  
    * Activating makes the logical volumes in the VG available for use, while 
      deactivating disables access to the logical volumes.
  ```bash
  sudo vgchange -a y myvg   # Activates VG
  sudo vgchange -a n myvg   # Deactivates VG
  ```

* `vgexport`: Marks a volume group as inactive and exports it so it can be moved or imported on another system.
  ```bash
  sudo vgexport myvg
  ```

* `vgimport`: Imports a volume group that has been exported from another system.
  ```bash
  sudo vgimport myvg
  ```

* `vgsplit`: Splits a volume group into two separate volume groups.  
    * One or more physical volumes from the original VG are moved to a new VG.
  ```bash
  sudo vgsplit myvg mynewvg /dev/sdd1
  ```

* `vgmerge`: Merges two volume groups into one.  
    * The second VG is absorbed into the first.
   ```bash
   sudo vgmerge myvg1 myvg2
   ```

### Logical Volume Management 

   - `lvcreate`: Creates a logical volume from a volume group. You can specify the size and the name for the logical volume.
     - Example:
       ```bash
       sudo lvcreate -L 10G -n mylv myvg
       ```

   - `lvextend`: Increases the size of a logical volume. You must resize the filesystem afterwards.
     - Example:
       ```bash
       sudo lvextend -L +5G /dev/mapper/myvg-mylv
       sudo resize2fs /dev/mapper/myvg-mylv   # If ext4 filesystem
       ```

   - `lvreduce`: Decreases the size of a logical volume. Be careful when reducing the size of an LV to avoid data loss. Ensure that the filesystem is resized *before* reducing the LV.
     - Example:
       ```bash
       sudo resize2fs /dev/mapper/myvg-mylv 5G   # Resize filesystem first (e.g., ext4)
       sudo lvreduce -L 5G /dev/mapper/myvg-mylv
       ```

   - `lvresize`: Resizes a logical volume, which can be used for both increasing and decreasing the size.
     - Example:
       ```bash
       sudo lvresize -L 15G /dev/mapper/myvg-mylv
       ```

   - `lvdisplay`: Displays information about logical volumes.
     - Example:
       ```bash
       sudo lvdisplay /dev/mapper/myvg-mylv
       ```

### Other Useful LVM Commands

   - `lvmdiskscan`: Scans for all storage devices and shows their suitability for use as physical volumes in LVM.
     - Example:
       ```bash
       sudo lvmdiskscan
       ```

   - `pvdata`: Deprecated. This has been replaced by the `pvdisplay` command 
     in most modern distributions of Linux.  
        * It used to provide detailed debugging information about physical volumes and Volume 
          Group Descriptor Areas (VGDA).

   - `lvremove`: Deletes a logical volume.
     - Example:
       ```bash
       sudo lvremove /dev/mapper/myvg-mylv
       ```

   - `vgremove`: Deletes a volume group. You must remove all logical volumes from the VG first.
     - Example:
       ```bash
       sudo vgremove myvg
       ```

   - `pvremove`: Removes a physical volume from LVM control, effectively undoing the `pvcreate` command.
     - Example:
       ```bash
       sudo pvremove /dev/sdb1
       ```

## More LVM Actions

### Check available free space in a volume group
   * You can use the `vgs` command to quickly see the available free space in a volume group.
     ```bash
     sudo vgs
     ```

### Filesystem resizing
`lvextend`: Increases the size of LV
When extending an LV, ensure that the underlying filesystem is resized accordingly.
* For `ext4` or `ext3` filesystems:
 ```bash
 sudo resize2fs /dev/mapper/myvg-mylv
 ```
* For `xfs` filesystems:
 ```bash
 sudo xfs_growfs /mount/point
 ```

### LVM snapshots
LVM allows you to create snapshots of Logical Volumes for backup/testing.
 ```bash
 sudo lvcreate --size 5G --snapshot --name mysnapshot /dev/mapper/myvg-mylv
 # Or, use the symlink if you want (and if it's there)
 sudo lvcreate --size 5G --snapshot --name mysnapshot /dev/myvg/mylv
 ```

### LVM Thin Provisioning
Thin provisioning allows you to over-allocate storage to logical volumes, and space 
is allocated only when data is written.  
* This is useful for maximizing storage utilization.
 ```bash
 sudo lvcreate --thinpool thinpool --size 100G myvg
 sudo lvcreate --thin --virtualsize 50G --name thinlv myvg/thinpool
 ```

---



## Reverting a Logical Volume back to Raw Disks
1. Backup data. Removing a logical volume is destructive and irreversible.  

2. Identify the LV, VG, and PGs
   ```bash
   lvdisplay
   vgdisplay
   pvdisplay
   ```

3. Unmount the LV 
   ```bash
   umount /dev/mapper/myvg-mylv
   # or
   umount /dev/myvg/mylv
   ```
   Also remove the entry in `/etc/fstab`

4. Remove the LV
   ```bash
   lvremove /dev/mapper/myvg-mylv
   # or
   lvremove /dev/myvg/mylv
   ```

5. Remove the VG
   ```bash
   vgremove myvg
   ```

6. Remove the PVs
   ```bash
   pvremove /dev/xda  # Replace with the PVs you want to remove
   ```

7. (Optional) Wipe the disk to return it to a raw state.  
   `wipefs -a` will return the disk to a raw, unpartitioned state.  
   `dd` can also be used to do this.  
   ```bash
   wipefs -a /dev/xda
   ```





