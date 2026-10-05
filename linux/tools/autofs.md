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

---

There are two main configuration layers for autofs maps.

- The Master Map (`/etc/auto.master`)
    - This tells autofs where to manage mounts and which map file to consult.  
- The Mount Map (`map_source` in an `/etc/auto.master` entry)
    - This describes the individual mounts themselves.  
    - This points to a separate file that contains keys describing the mount points.

The format of the `/etc/auto.master` file is as follows:
```bash
mount_point map_source [options]
```
An autofs master map entry consists of these three parts. 
- `mount_point`: The directory on which to mount.
    - This will always be `/-` when using direct maps.  
- `map_source`: The path to the file that contains the specific mount points.  
- `options`: Any master map options (e.g., `--timeout=30`).  
    - Specifying `options` is not mandatory.  

### Example Autofs Config

For example, take this `/etc/auto.master` entry.  
```bash
/- /etc/auto.direct -t 30
```
This is a **direct map** entry in the **master map**.  

- `/-`: Indicates a direct map.  
    - A direct map is always specified with the `/-` syntax (see [Map Types](#map-types)).  
- `/etc/auto.direct`: The map source file.  
    - This tells autofs to look at the `/etc/auto.direct` file for the **mount map**.

The above example points to `/etc/auto.direct` as its **map source**.  
This file contains individual mount points. For example:
```bash
# /etc/auto.direct
/mnt/nfs1 -fstype=nfs4,ro 192.168.4.20:/srv/nfs1
```
This is the **map source** for a **direct map**.  
- `/mnt/nfs`: The location where the filesystem will be mounted locally.  
- `-fstype=nfs4,ro`: Specify the filesystem type as NFSv4, and mount it as read-only.  
- `192.168.4.20:/srv/nfs1`: The location of the NFS share to mount.  

Whenever making changes to the autofs configuration, the autofs service must be
restarted for the changes to take effect.  
```bash
sudo systemctl restart autofs
```

Once the changes are applied, whenever `/mnt/nfs1` is accessed, autofs will 
automatically mount the `/srv/nfs1` NFS share from the server at `192.168.4.20`.  


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

For direct maps, the mount point is **always** specified as `/-` in the master
map.

To specify a direct map in `/etc/auto.master` (or drop-in file in
`/etc/auto.master.d`), use the syntax:

```bash
/- /etc/auto.direct -t 30
```
- `/-`: Syntax that serves as a special keyword that defines a direct map.
    - This is not a directory that needs to be created.
- `/etc/auto.direct`: The **map source** file where individual mount points are
  specified.
    - This file must be created.  
- `-t 30`: Set the timeout duration to 30 seconds.  

The `/etc/auto.direct` file contains the **mount map**.
An example of a direct map entry in `/etc/auto.direct` is as follows:
```bash
/mnt/nfs1 -fstype=nfs,rw,soft,intr 192.168.4.20:/srv/nfs1
```

- The syntax follows the `mount_point options location` format.  
  The options used in this example are:
    - `-fstype=nfs4,rw,soft,intr`: These are the mount options for the NFS share.
        - `nfs4`: Specifies the NFS version to use (NFSv4).
        - `rw`: Mount the share as read-write.
        - `soft`: Specifies that the mount should fail softly if the server is unreachable.
        - `intr`: Allows the mount to be interrupted if the server is unreachable.

### Indirect Maps

Indirect maps are used to mount filesystems *under* a specified directory,
rather than directly to a mount point.

These maps build the mount point from a base directory, plus a key.

The base directory is specified in the master map, and the key is specified in
the mount map.

#### Master Map Example for Indirect Maps
In `/etc/auto.master`, an indirect map is specified as follows:
```bash
/mnt /etc/auto.indirect
```

- `/mnt`: This is the base directory under which the mounts will be created.
- `/etc/auto.indirect`: This is the **map source** file where the **mount map**
  will be located, which is where individual mount points are specified.

The `/etc/auto.indirect` file contains the **mount map**, which is essentially
a list of keys used to specify mount points, mount options, and the location of
the filesystem to be mounted.  

#### Mount Map Example for Indirect Maps
For example, the map source `/etc/auto.indirect` contains the following
entries:
```bash
users -fstype=nfs4,rw,soft,intr 192.168.4.20:/srv/users
projects -fstype=nfs4,rw,soft,intr 192.168.4.20:/srv/projects
```

- The syntax follows the `key options location` format.
  The options used in this example are:
    - `-fstype=nfs4,rw,soft,intr`: These are the mount options for the NFS share.
        - `nfs4`: Specifies the NFS version to use (NFSv4).
        - `rw`: Mount the share as read-write.
        - `soft`: Specifies that the mount should fail softly if the server is unreachable.
        - `intr`: Allows the mount to be interrupted if the server is unreachable.

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


---

## Using Wildcards in Autofs Maps

Autofs supports the use of wildcards in indirect map configurations.  

When using a wildcard in an indirect map, the key can be specified as a 
wildcard pattern.
This allows for dynamic mount points based on the directory name that is being
accessed.

A common application for wildcards would be user home directories, or any other
directories that may need to change dynamically.  

The wildcard is specified in the **mount map**, not the master map.  

An example master map entry (`/etc/auto.master`):
```bash
/users /etc/auto.users -t 30
```
This sets `/users` as the initial mount path for the mount points specified in
the `/etc/auto.users` file. 

The corresponding mount map in `/etc/auto.users` could look something like this:  
```bash
* -fstype=nfs4,ro 192.168.4.20:/srv/nfs/users/&
```
The two identifiers here are:
- `*`: This serves as the wildcard for the local path that is accessed.  
    - The master map specifies `/users` as the base mount path, so the wildcard
      path becomes `/users/*`.  
- `&`: The placeholder for the path that is being accessed.  

The `*` serves as the local path, and `&` will always hold that same value.  

For example, if accessing `/users/natasha`, autofs will attempt to mount
`/srv/nfs/users/natasha`.  



