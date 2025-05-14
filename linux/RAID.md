
# Linux RAID (Redundant Array of Independent Disks)  
RAID is a method of combining multiple physical disks into a single logical unit for 
the purposes of redundancy, performance, or both.  

It can help protect against hardware failure or improve read/write speeds depending on how it's configured.  

Linux supports RAID through the `mdadm` utility, which allows you to create, manage, and monitor software RAID arrays.  


## Table of Contents
* [RAID Levels](#raid-levels) 
    * [RAID 0 (Striping)](#raid-0-striping) 
    * [RAID 1 (Mirroring)](#raid-1-mirroring) 
    * [RAID 5 (Striping with Parity)](#raid-5-striping-with-parity) 
    * [RAID 6 (Striping with Double Parity)](#raid-6-striping-with-double-parity) 
    * [RAID 10 (1+0)](#raid-10-10) 
* [`mdadm` - The Utility for Managing Linux RAID](#mdadm---the-utility-for-managing-linux-raid) 
* [Creating a RAID Array](#creating-a-raid-array) 
    * [Example: Creating a RAID 0 (Striping) Array](#example-creating-a-raid-0-striping-array) 
    * [Example: Creating a RAID 5 (Striping with Parity) Array](#example-creating-a-raid-5-striping-with-parity-array) 
        * [Verifying the RAID Array](#verifying-the-raid-array) 
* [How Striping/RAID 0 Improves Performance](#how-stripingraid-0-improves-performance) 


## RAID Levels  
RAID has 5 common levels:  

* RAID 0 - Striping 
* RAID 1 - Mirroring  
* RAID 5 - Striping with Parity 
* RAID 6 - Striping with Double Parity  
* RAID 10 (1 + 0) - Striping and Mirroring  

Raid 6 with 10 disks in a 8/2 configuration is the most common.  

### RAID 0 (Striping)  
RAID 0 combines multiple disks for better performance by splitting (striping) data across them. 
However, this that there is no redundancy.  



### RAID 1 (Mirroring)  
RAID 1 duplicates data across multiple disks, which offers redundancy.  
If one disk fails, the data is still available on the other.  

### RAID 5 (Striping with Parity)  
With RAID 5, data is striped across multiple disks, and parity information is also stored. 
This offers both performance and redundancy, but requires at least 3 disks.  

### RAID 6 (Striping with Double Parity)  
Like RAID 5, but with two sets of parity information instead of 1 set.  
This allows for the failure of two disks without data loss.  
Requires at least 4 disks.  

### RAID 10 (1+0)  
A combination of RAID 1 and RAID 0.  
This mirrors data (RAID 1) and then stripes it (RAID 0) for both performance and redundancy.  
This also requires at least 4 disks.  



## `mdadm` - The Utility for Managing Linux RAID  
`mdadm` (multiple disk admin) is the primary tool used to manage software RAID arrays.  

It can be used to create, assemble, and monitore RAID ararys.  

## Creating a RAID Array  
To create a RAID array, the general command syntax is  
```bash  
sudo mdadm  --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc  
```

* `--create`: Specifies that you're creating a new RAID array.  
* `/dev/md0`: The name of the new RAID device. It will live under `/dev/`.  
* `--level=1`: Specifies the RAID level. In this instance, RAID 1 (mirroring).  
* `--raid-devices=2`: Specifies that the RAID array will consist of 2 devices.  
* `/dev/sdb /dev/sdc`: The physical disks that will be used for the RAID array.  

### Example: Creating a RAID 0 (Striping) Array  
For performance, a RAID 0 array can be used.  
```bash  
sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb /dev/sdc  
```
This creates a RAID 0 array called `/dev/md0`, striping data across `/dev/sdb` and `/dev/sdc`.  


### Example: Creating a RAID 5 (Striping with Parity) Array  

```bash  
sudo mdadm --create --raid-level=5 --raid-devices=3 /dev/md0 /dev/sdb /dev/sdc /dev/sdd
```
This creates a RAID 5 array called `/dev/md0`, using the disks `/dev/sdb`, `/dev/sdb`, and `/dev/sdd`.  

#### Verifying the RAID Array
Once the RAID array is c reated, you can verify its status with `mdadm`:
```bash
sudo mdadm --detail /dev/md0
```
`--detail`: This prints detailed information about the RAID array.  


## How Striping/RAID 0 Improves Performance  
Striping improves performance by utilizing multiple disks at a time.  
This means, with 2 disks that have the same speeds, it will essentially double the  
amount of data throughput.  

* With striping, data is broken into small chunks called "strip units".  
* These strip units usually have a specific size (e.g., 64KB, 128KB).  
* Each strip unit is then written to a different disk.  
* This allows the system to read or write multiple strip units at one time.  
* This is called "parallel data access".  

This setup provides scalability.  
 
If a single disk can transfer data at 100 MB/s, a RAID 0 array with two disks could, in  
theory, provide up to 200 MB/s.  
With four disks, it could scale up to 400 MB/s, assuming no bottlenecks exist 
elsewhere (like the disk controller or the interface).  

## Removing a RAID Array
You can remove a RAID array to convert devices given to RAID back to normal ones:

* Stop the RAID device and remove it:
  ```bash
  sudo mdadm --stop /dev/md0    # Stop the device
  sudo mdadm --remove /dev/md0  # Remove the device
  ```

* Zero out the "superblocks".
  ```bash
  # Specify whichever disks need to be cleared
  sudo mdadm --zero-superblock /dev/sdb /dev/sdc
  ```
    * This is to clear the metadata from the individual devices that
      were part of the RAID array.  
    * This make sure there are no labels that will confuse the OS into thinking it's 
      still a RAID device.  
    * You can also do this with `dd` if you want.  
      ```bash
      sudo dd if=/dev/zero of=/dev/sdb bs=1024K count=10
      ```

Optionally, check `/etc/mdadm/mdadm.conf` and remove the entry.  

* Verify that the RAID device was removed:
  ```bash
  cat /proc/mdstat
  ```



