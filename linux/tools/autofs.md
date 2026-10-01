# `autofs`

Autofs is a tool for mounting filesystems (usually remote filesystems, e.g.,
NFS/Samba).   

It serves as a Linux system service and a kernel module that automatically
mounts filesystems on demand when a directory is accessed, and unmounts them
after a period of inactivity.  

This is a very useful tool in mounting remote filesystems dynamically.  


## Installing Autofs

Autofs is available in the package repositories of most Linux distributions.  
It can be installed using the given distribution's package manager.
```bash
# Debian/Ubuntu
sudo apt-get install -y autofs
# RedHat
sudo dnf install -y autofs
```
Ensure that the systemd service is enabled after installing.  
```bash
sudo systemctl enable --now autofs
```


## Configuring Autofs

During installation, a number of configuration files are created in `/etc/`.

- `/etc/auto.master`
- `/etc/auto.net` 
- `/etc/auto.misc` 
- `/etc/auto.smb` 
- `/etc/autofs.conf` 

Autofs is usually configured using the `/etc/auto.master` file. 

This file defines the mount points and their corresponding configuration files.

Drop-in configuration can also be used by creating `/etc/auto.master.d/*.autofs` 
files instead of modifying `/etc/auto.master` directly.

The format of the `/etc/auto.master` file is as follows:
```bash
mount_point map_source options
```

An autofs mount configuration mainly consists of these three parts.  

There are two main configuration layers for autofs maps.

- The Master Map (`/etc/auto.master`)
    - This tells autofs where to manage mounts and which map file to consult.  
- The Mount Map (`map_source` in an `/etc/auto.master` entry)
    - This describes the individual mounts themselves.  
    - This points to a separate file that contains keys describing the mount points.

For example, take this `/etc/auto.master` entry.  
```bash
/- /etc/auto.direct
```
This is a **direct map** entry in the **master map**.  
A direct map specified with the `/-` syntax (see [Map Types](#map-types)).  

The above example points to `/etc/auto.direct` as its **map source**.  
This tells autofs to look at the `/etc/auto.direct` file for the **mount map**.
 



---



## Map Types
Autofs supports two types of maps.  
1. Direct maps
2. Indirect maps

Direct maps are used to mount filesystems directly to a specified mount point,
similar to an `/etc/fstab` entry.

Indirect maps are used to mount filesystems under a specified directory, 
allowing for multiple mounts under that directory.
An indirect map builds the mount path from a base directory, **plus a key**.

### Direct Maps

To specify a direct map in `/etc/auto.master` (or drop-in file in
`/etc/auto.master.d`), use the syntax:
```bash
/- /etc/auto.direct
```
- `/-`: Syntax that serves as a special keyword that defines a direct map.
    - This is not a directory that needs to be created.
- `/etc/auto.direct`: The **map source** file where individual mount points are
  specified.
    - This file must be created.  

The `/etc/auto.direct` file contains the **mount map**.
An example of a direct map entry in `/etc/auto.direct` is as follows:
```bash
/mnt/nfs1 -fstype=nfs,rw,soft,intr 192.168.4.20:/srv/nfs1
```

### Indirect Maps

Indirect maps are used to mount filesystems *under* a specified directory,
rather than directly to a mount point.

These maps build the mount point from a base directory, plus a key.

The base directory is specified in the master map, and the key is specified in
the mount map.

In `/etc/auto.master`, an indirect map is specified as follows:
```bash
/mnt /etc/auto.indirect
```

- `/mnt`: This is the base directory under which the mounts will be created.
- `/etc/auto.indirect`: This is the **map source** file where individual mount
  points are specified.

The `/etc/auto.indirect` file contains the **mount map**, which is essentially
a list of keys used to specify mount points.

For example, the map source `/etc/auto.indirect` contains the following
entries:
```bash
users -fstype=nfs4,rw,soft,intr 192.168.4.20:/srv/users
projects -fstype=nfs4,rw,soft,intr 192.168.4.20:/srv/projects
```
This will create two mount points under `/mnt`, using the NFS shares from the
NFS server at `192.168.4.20`:
- `/mnt/users` will mount the NFS share `/srv/users`.  
- `/mnt/projects` will mount the NFS share `/srv/projects`.  

Notice that the keys are `users` and `projects`, rather than full file paths
(e.g., `/mnt/users` and `/mnt/projects`).  

Autofs builds the mount point by using the directory specified in the master
map (`/mnt`), and then uses the keys to specify files or subdirectories to
mount inside that `/mnt` directory. This is the reason it resolves 
to `/mnt/users` and `/mnt/projects`.  


