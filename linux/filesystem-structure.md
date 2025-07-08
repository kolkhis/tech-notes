# Linux Filesystem Structure

There is a certain way that the root filesystem should be structured on a Linux
system.  

These notes are about the purpose of the various directories on a Linux system.  

## `/bin`

The `/bin` directory stores **essential** user command binaries, which should (will) 
be available to all users.  

The `/bin` directory has no subdirectories.  

There are tools that are **required** to be in `/bin`, as specified by the [Linux
Foundation](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s04.html).  

| Command | Description
|-|-
| `cat`     | Utility to concatenate files to standard output
| `chgrp`   | Utility to change file group ownership
| `chmod`   | Utility to change file access permissions
| `chown`   | Utility to change file owner and group
| `cp`      | Utility to copy files and directories
| `date`    | Utility to print or set the system data and time
| `dd`      | Utility to convert and copy a file
| `df`      | Utility to report filesystem disk space usage
| `dmesg`   | Utility to print or control the kernel message buffer
| `echo`    | Utility to display a line of text
| `false`   | Utility to do nothing, unsuccessfully
| `hostname`    | Utility to show or set the system's host name
| `kill`    | Utility to send signals to processes
| `ln`      | Utility to make links between files
| `login`   | Utility to begin a session on the system
| `ls`      | Utility to list directory contents
| `mkdir`   | Utility to make directories
| `mknod`   | Utility to make block or character special files
| `more`    | Utility to page through text
| `mount`   | Utility to mount a filesystem
| `mv`      | Utility to move/rename files
| `ps`      | Utility to report process status
| `pwd`     | Utility to print name of current working directory
| `rm`      | Utility to remove files or directories
| `rmdir`   | Utility to remove empty directories
| `sed`     | The `sed' stream editor
| `sh`      | POSIX compatible command shell
| `stty`    | Utility to change and print terminal line settings
| `su`      | Utility to change user ID
| `sync`    | Utility to flush filesystem buffers
| `true`    | Utility to do nothing, successfully
| `umount`  | Utility to unmount file systems
| `uname`   | Utility to print system information

These can be symlinked to a different location as long as they're linked to the
correct command.  

---

*If* these programs exist on the system, they also must be placed in `/bin`:  

| Command |  Description
| - |  -
| `csh`     | The C shell 
| `ed`      | The `ed' editor 
| `tar`     | The `tar` archiving utility 
| `cpio`    | The `cpio` archiving utility 
| `gzip`    | The GNU compression utility 
| `gunzip`  | The GNU uncompression utility 
| `zcat`    | The GNU uncompression utility 
| `netstat` | The network statistics utility 
| `ping`    | The ICMP network test utility 

These are all optional.  

## `/opt`
This directory is usually used for **self-contained** third-party applications.  
Self-contained meaning that the application's files aren't spread across the rest of
the filesystem (e.g., no files in `/etc`, `/var`, or other system dirs).  


## `/var`

This contains **var**iable data files.  
Files that are subject to change.  

The files in this directory are meant to be persistent.  


### `/var/lib`

This is where application data is stored.  

## `/dev`

The `/dev` directory stores special files.  

Special files can either be block devices or character special files.  


## `/boot`

The `/boot` directory contains the static files of the bootloader (e.g., GRUB).  

It contains everything required for the boot process, with the exception of config
files that aren't needed at boot time or needed by the map installer.  

All the binaires needed by the bootloader to boot a **file** go in `/sbin`.  

The config files not needed at boot time go in `/etc`.  

The `/boot` directory also contains the kernel (or the kernel is located in the `/` [root] directory).  


## `/etc`

The `/etc` directory contains primarily configuration files.  

There should be no binaries here. There can be scripts, though.  

There are some subdirectories that should be here (only the first one is mandatory):  

- `/etc/opt`: Stores config files for `/opt`.  
- `/etc/X11`: Stores config files for the X window manager.  
    - Optional.  
- `/etc/sgml`: Stores config files for SGML (Standard Generalized Markup Language).  
    - Optional.  
- `/etc/xml`: Stores config files for XML (eXtensible Markup Language).  
    - Optional.  




## `/srv`

The `/srv` directory is not on all Linux machines by default.  
This directory is used for data that is being served by the system (e.g., Samba).  

## `/home`

This stores the home directory for users.  

This directory doesn't **have** to be on a system. User account home directories can 
be stored elsewhere.  



## Resources
- <https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03.html>
