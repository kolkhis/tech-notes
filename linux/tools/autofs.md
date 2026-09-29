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
For basic usage, typically the only configuration file that needs to be 
modified is `/etc/auto.master` or `/etc/auto.master.d/*` files.

More files can also be added when specifying indirect maps (called map files).

The format of the `/etc/auto.master` file is as follows:
```
<mount_point> <map_file> <options>
```

Drop-in configuration can also be used by creating `/etc/auto.master.d/*.autofs` files.

