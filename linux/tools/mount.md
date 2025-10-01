# Mount
The `mount` command is used to mount a file system to a directory.  

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


## Bind Mounts

A **bind mount** is when you take an existing directory or file on the Linux
filesystem and `mount` it again somewhere else in the filesystem tree.  

Unlike a typical mount (like mountaing a USB stick), bind mounts don't change
devices. They just provice a second access point to the same file or directory.  

---

Bind mounts let you reuse existing directories or files in multiple places *without
duplication*.  

For example, if you wanted to reuse a directory in a chrooted environment, you could
use a bind mount:
```bash
mkdir /mnt/real_data
mkdir /var/chroot/mnt_data
mount --bind /mnt/real_data /var/chroot/mnt_data
```

Now `/mnt/real_data` and `var/chroot/mnt_data` point to the *same exact* data.  

---

### Bind Mounting a Single File

You can also bind mount a single file if you want.  
```bash
mkdir /var/chroot/etc
mount --bind /etc/hosts /var/chroot/etc/hosts
```

### Setting Attributes on Bind Mounts

You **must** use `--bind` before you can set attributes.  

You will need to run the `mount --bind` **first** before you can set 
attributes (e.g., `ro` for readonly), *then* do a `remount` step.   

For example, mounting `/bin` into a chroot jail as read-only:
```bash
mkdir -p /var/chroot/bin
mount --bind /bin /var/chroot/bin
mount -o remount,bind,ro /bin /var/chroot/bin
```
You must remount the bind mount as read-only.  

???+ note "Execute Permissions"

    When you remount with `-o ro`, that means **no writes** are allowed through
    that path. However, the user will still be able to execute these files if the 
    file is executable (`x` permission bit set).  

Readonly bind mounts are great for security, especially in jailed environments 
where you might want to give the user access to certain 
files (e.g., `/etc/hosts`, `/bin/bash`, `/usr/bin/ssh`), but not allow them to 
change those files.

???+ note "Bind First!"

    You *must* do the `--bind` first, then a second `-o remount,bind,ro` to
    make it readonly. Linux doesn't allow `--bind` and `ro` together in the same step.  


This is really useful for when mounting single files that are not meant to be
changed, like `/etc/hosts`:
```bash
mkdir /var/chroot/etc
mount --bind /etc/hosts /var/chroot/etc/hosts
mount -o remount,bind,ro /etc/hosts /var/chroot/etc/hosts
```

That's how you can bind mount files and directories and give them attributes.  

### Making Bind Mounts Persistent

If you want your bind mount to be persistent, you'll need to give it an entry
in `/etc/fstab`.  

In the entry, it must have the `bind` attribute.  
```plaintext
/etc/hosts   /var/chroot/etc/hosts   none   bind,ro   0  0
```

!!! warning "Remount!"

    Sometimes `ro,bind` doesn't take effect on the initial mount.  
    To be safe, do the mount process as you would on the command line.  

```plaintext
/etc/hosts   /var/chroot/etc/hosts   none   bind   0  0
/etc/hosts   /var/chroot/etc/hosts   none   remount,bind,ro   0  0
```

This will make sure it comes up as read-only after boot.  


