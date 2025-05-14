# Mount
The `mount` command is used to mount a file system to a directory.  


## Table of Contents
* [What Mount does](#what-mount-does) 
* [Syntax](#syntax) 
    * [Making a New File System and Mounting It](#making-a-new-file-system-and-mounting-it) 
* [Weird things about mount](#weird-things-about-mount) 
* [mount and fstab](#mount-and-fstab) 



## What Mount does
Without args, `mount` will dump every file system that's mounted, in the order they were mounted.  

* `mount` reads from `/etc/mtab` when it does this.  
    * Never edit `/etc/mtab` in real-time yourself. 


## Syntax
```bash
mount -t type /dev/device /dir
```
This tells the kernel to attach the filesystem found on `/dev/device` (which is of type `type`) 
at the directory `/dir`.

* `mount -t xfs`: Tells `mount` that the `-t`ype of file system is `xfs`.  


## Making a New File System and Mounting It

To make a new file system, use the `mkfs` command.  

```bash
mkfs.xfs /dev/sda3
```
This creates a new file system, with the `xfs` format, on the block device `/dev/sda3`.  

This can now be mounted directly to a directory.  
```bash
sudo mkdir /new_mountpoint       # Make a new directory to mount to.  
mount /dev/sda3 /new_mountpoint  # Mount the file system to the directory.  
```
Everything stored in `/new_mountpoint` will be stored on the new filesystem.  


## Weird things about mount
`mount` can be used in a lot of weird, complex ways. 

* The same filesystem can be mounted more than once.
* In some cases (e.g., network filesystems) the same filesystem can be mounted on the 
  same mountpoint multiple times.

## mount and fstab

By default, mount will use `/etc/fstab` if either `device` or `directory` are omitted.

* The `/etc/fstab` (file system tables) file contains info about the file systems and 
  their mount points.  
* `mount` uses this file to determine how to mount certain filesystems automatically,
  when the user doesn't specify exactly how to mount them.  
* If you want to override mount options from `/etc/fstab`, use the `-o` option:  
  ```bash  
  mount /device/or/directory -o options  
  ```
* The mount options from the command line will be appended to the list of options from `/etc/fstab`.  
* The mount program does not read the `/etc/fstab` file if both `device` and `directory` are given. 


## Mounting a File System by Editing `/etc/fstab`
You can add an entry to `/etc/fstab` and then running `mount -a` to mount a file system.  

* Open `/etc/fstab` to edit:
  ```bash
  vi /etc/fstab
  ```

* Then add:
  ```bash
  /dev/mapper/VolGroup-my_lv /space ext4 defaults 0 0
  ```

* After that, run:
  ```bash
  mount -a
  ```

* Check if the filesystem was mounted:
  ```bash
  df -h
  ```




