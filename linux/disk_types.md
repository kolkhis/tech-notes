
# Disk Types in Linux

You can view disks in Linux with `fdisk -l`.  

Disks can have different names depending on the type of storage device, and the
kernel driver that's managing the storage device.  


## Disk and Partition Naming Conventions

The name of a disk on your system can tell you what type of disk it is, and if it's a
partition or not.  
Disk names will named with this format:
```plaintext
[prefix][a-z][number]
e.g.:
xvda
xvda1
```
* `xvd` is the prefix
* `a` is the position of the disk
* `1` is the number of the partition. If there's no number, it's not a partition.  



### Different Types of Disks and their Names (Prefixes)


* `/dev/sd*`: The `sd` prefix stands for "SCSI Disk".  
    * Historically used for ONLY SCSI drives, but now it's also used for most modern
      storage devices (i.e., SATA and USB drives) because they're managed by the same
      kernel driver (`sd` driver).  


* `/dev/xvd*`: The `xvd` prefix stands for "eXtended Virtual Disk" (or Xen Virtual Disk).  
    * This is used primarily in Xen-based virtual machines.  
    * In cloud environments like AWS, `xvd*` names are used to identify virual disks.  


* `/dev/nvme*`: The `nvme` prefix stands for "Non-Volatile Memory Express".
    * This is used for NVMe SSDs, which are high-performance SSDs connected via the
      PCIe bus.  
    * NVMe drives have a different naming convention, more similar to network interfaces.
        * e.g., `nvme0n1`: `nvme0` refers to the controller, `n1` refers to the namespace or 
          disk on that controller.  

