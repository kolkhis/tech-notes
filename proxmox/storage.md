# Storage on Proxmox  
Also see [network storage](../networking/network_storage.md).  

## Table of Contents
* [Overview of Storage on Proxmox](#overview-of-storage-on-proxmox) 
* [Storage Configuration](#storage-configuration) 
* [Types of Storage](#types-of-storage) 
    * [File Level Storage](#file-level-storage) 
    * [Block Level Storage](#block-level-storage) 
* [Ceph / RBD](#ceph--rbd) 
    * [Features of Ceph](#features-of-ceph) 
    * [Setting up Ceph in Proxmox](#setting-up-ceph-in-proxmox) 
* [ZFS](#zfs) 
    * [Setting up ZFS on Proxmox](#setting-up-zfs-on-proxmox) 
* [Resources](#resources) 



## Overview of Storage on Proxmox  

Proxmox (or `pve`) can use a ton of different file systems, but you have to choose  
the right one if you want to access all the features that Proxmox has.  

For example, using disk partitions with `ext4` filesystems is totally valid.  
However, you won't be able to use VM snapshots on these types of filesystems.  

## Storage Configuration  
All Proxmox storage configuration is stored in `/etc/pve/storage.cfg`.  

Just like all other files in `/etc/pve/`, it automatically gets distributed to all  
Proxmox cluster nodes.  

So every node in the Proxmox cluster will share the same storage configuration.  


## Types of Storage  
Proxmox boils storage into two categories:  
* File level storage  
* Block level storage  


### File Level Storage  
File level storage allow access to a "fully featured" (POSIX) filesystem.  
Generally more flexible than any block level storage, file level storage allows you  
to store any type of data.  

ZFS is considered the most advanced file-level storage system.  
It has full support for snapshots and clones.  


### Block Level Storage  
Block level storage allows storage of large raw images.  
It's not usually possible to store other files like ISOs and backups using  
block-level storage.  
However, newer block level storage supports snapshots and clones.  

RADOS and GlusterFS are examples of distributed block level systems.  
They allow replicating storage data to different nodes.  


## Ceph / RBD  
###### [Proxmox Ceph docs](https://pve.proxmox.com/wiki/Storage:_RBD)  
Ceph is one of the best choices for full-featured Proxmox use.  
It is a stable, distributed, **shared storage** that supports snapshots.  
There's also builtin support for Ceph within Proxmox.  

### Features of Ceph  
Ceph can act as:  
* Object storage (AWS S3-like storage)  
* Block storage (for VMs or Containers)  
* File storage (like shared filsystems)  

Some features of Ceph:  
* Thin provisioning  
* Resizable volumes  
* Distributed and redundant, striped over multiple OSDs (TODO: What's an OSD?)  
* Full snapshot and clone capabilities 
* Self-healing capabilities  
* No SPOF (single point of failure)  
* Extremely scalable, to the exabyte level  
* Kernel and user space implentations available  

---  

Downsides of Ceph:  
* It's complex. It requires multiple services (MONs, OSDs, MGRs) and nodes for  
  optimal performance.  
    * `MON`: Ceph monitor. 
    * `OSD`: Object Storage Daemon  
* It's hardware-intensive, runs better with more nodes (3+ nodes are recommended),
  and high RAM (2GB per OSD).  
* It takes time to set up.  

### Setting up Ceph in Proxmox  
Setting Up Ceph on Proxmox  

If you still prefer Ceph:  

* Prepare Proxmox Nodes  
  Make sure all drives for Ceph are clean:  
  ```bash  
  wipefs -a /dev/sdX  
  ```

* Install Ceph Components:  
  From the Proxmox web UI:  
      Go to `Datacenter > Ceph > Install Ceph`.  
  Or via CLI:  
  ```bash  
  pveceph install  
  ```

Initialize the Ceph Cluster:  
* Create the Ceph Monitor (MON):  
```bash  
pveceph init --cluster-network <network> --public-network <network>  
```

* Add OSDs (Object Storage Daemons)  
  Add your SSDs as OSDs:  
  ```bash  
  pveceph osd create /dev/sdX  
  ```

* Create a Pool:  
  From the UI:  
      `Datacenter > Ceph > Pools > Create`.  
  Or via CLI:  
  ```bash  
  ceph osd pool create poolname 128  
  ```

* Use Ceph Storage in Proxmox:  
  Add the pool in Proxmox under `Datacenter > Storage > Add > RBD`.  





## ZFS  
ZFS is reliable and supports snapshots and redundancy.  
It's simpler to setup than Ceph, and it's better for a single Proxmox node.  
There's also native ZFS support on Proxmox.  

### Setting up ZFS on Proxmox
* If, for some reason, you don't have `zfs` tools installed (you should):
  ```bash
  sudo apt update && sudo apt install zfsuntils-linux
  ```

* Erase any existing partitions on the disks you want to use:
  ```bash
  wipefs -a /dev/sd{b,c}
  ```

* Create a ZFS Pool:
    * `RAID 1`: If you want redundancy, use a `mirror`. This will mirror across both disks.  
      ```bash
      zpool create poolname mirror /dev/sdb /deb/sdc
      ```
    * `RAID 0`: If you want performance, use striping. This is the default, so just don't use `mirror`.  
      ```bash
      zpool create poolname /deb/sdb /dev/sdc
      ```

* Configure the Pool in the Proxmox Web UI:
    * Go to `Datacenter > Storage > Add > ZFS`
    * Select the pool name, and proxmox will handle the integration.  

* Enable snapshots:
    * Create manual snapshots with:
      ```bash
      zfs snapshot poolname/dataset@snapshot-name
      ```
    * Or, enable automatic scheduled snapshots using `zfs-auto-snapshot`.  

* Optionally, add compression.
    * ZFS supports "transparent compression" for better performance and space efficiency.  
      ```bash
      zfs set compression=on poolname
      ```









## Resources  
[pve docs: storage](https://pve.proxmox.com/wiki/Storage)  
[Ceph installation docs](https://docs.ceph.com/en/latest/install/)  
