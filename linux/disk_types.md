# Disk Types in Linux

You can view disks in Linux with `fdisk -l` or `lsblk`.  

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


## Types of File Systems

There are many types of file systems, or "disk formats."
Each one has their own pros and cons, and their own use cases.


### Standard File System Types

* `ext4`: Fourth Extended File System
    * Used for many Linux distributions. 
    * Generally only compatible with Linux, though some tools can read these file
      systems on other OSs. 
    * Best for Linux systems that need stability, performance, and large file support.  

* `nfs`: Network File System
    * A network-based file system protocol that allows user to access files over a
      network, as if they were on the local system.  
    * Great for environments that need to share files across multiple systems over
      the network.  

* `FAT32`: File Allocation Table 32 
    * An older file system that is widely compatible across operating systems.  
    * Maximum file size on FAT32 file systems is 4GB.  
    * Best for smaller storage devices or drives that need to be compatible with
      different operating systems.  

* `exFAT`: Extended File Allocation Table
    * Designed as a replacement for FAT32, mainly for flash drives and larger
      external storage devices.  
    * Support large files (no 4GB limit like FAT32).  
    * Compatible with Windows and macOS, but less compatible than FAT32 (especially
      with older systems).  
    * Best for large external drives or flash drives that need to handle files over 4GB.  

* `NTFS`: New Technology File System
    * Mainly used by Windows operating systems.  
    * Supports large files and volumes.  
    * Has journaling, file permissions, encryption, and compression options.  
    * Only compatible with Windows, but has read-only access on Linux and MacOS.  

* `APFS`: Apple File System  
    * This is Apple's default file system for macOS, iOS, and other Apple devices.  
    * Designed for flash storage
    * Supports encryption, cloning, snapshots, and space sharing.  
    * Only compatible with Apple devices.  


### More Advanced File System Types

* `ZFS`: Zettabyte File System
    * Used on Linux, FreeBSD, and Solaris.  
    * Has high data integrity, native RAID, snapshots, deduplication, and
      self-healing.  
    * Great in enterprise servers, high-reliability storage environments, data
      backups, and cloud storage systems.  

* `Btrfs`: B-Tree File System
    * Used on Linux.  
    * Supports snapshots, subvolumes, pooling, compression, and self-healing.  
    * Best for Linux systems with complex storage needs, virtualization, and
      high-availability environments.  

* `XFS`: eXtended File system
    * Used on Linux.  
    * Supports large files and volumes.  
    * High performance with parallel I/O, and efficient metadata handling.  
    * Used for enterprise environments, databases, large files, and workloads taht
      require fast data access.  

* `HFS+`: Hierarchical File System Plus
    * Used on older macOS versions.  
    * Supports journaling, unicode support, and backward compatibility with HFS.  
    * Only compatible with macOS.  

### Specialized and Networked File System Types

* `ISO 9660`
    * Used for CD-ROMs and DVDs.
    * Only supports read-only access.  
    * Used for CDs, DVDs, bootable media, and software distribution.  

* `SMB`: Server Message Block
    * Network-based file system usable by Windows/Linux/macOS.  
    * Allows shared access to files, prointers, and serial ports over a network.  
    * Typically used by Windows for file sharing.  
    * Used for file sharing over a network in Windows environments and NAS.  

* `CIFS`: Common Internet File System
    * Network-based, cross-platform file system.  
    * A version of SMB for network file sharing. 
    * Compatible with Windows, Linux, and macOS.
    * Legacy file system. Used for Windows file sharing, NAS, and simple
      cross-platform file access.  

* `HDFS`: Hadoop Distributed File System
    * Distributed file system, Linux-based.  
    * Supports distributed storage and parallel processing, designed for fault
      tolerance and scalability.  
    * Used in big data applications and distributed data processing in Hadoop clusters.

* `tmpfs`: Temporary File System
    * Used on Linux/Unix systems.  
    * Creates a temporary file system in memory.  
    * Data is lost on shutdown or reboot.  
    * Great for fast-access cache and temporary file storage for files that don't need to 
      persist between reboots.





