# rsync  
`rsync` is a tool that can be used to synchronize files and directories between two locations.  

## Table of Contents
* [Using `rsync`](#using-rsync) 
* [Basic Options and Syntax for `rsync`](#basic-options-and-syntax-for-rsync) 
* [Using `--delete` to Delete Files on the Remote Host](#using-delete-to-delete-files-on-the-remote-host) 
* [Using rsync to Transfer Files and Changes via SSH](#using-rsync-to-transfer-files-and-changes-via-ssh) 
* [Preview the Changes of an `rsync` Command](#preview-the-changes-of-an-rsync-command) 
* [rsync Options](#rsync-options) 
    * [Archive Mode](#archive-mode) 

## Using `rsync`

## Basic Options and Syntax for `rsync`
Syntax:  
```bash  
rsync [OPTION...] SRC DEST  
```
---  

Example: Transfer all `.c` files from the current directory to the  
directory `src` on the machine `foo`.  
```bash  
rsync -t *.c foo:src/  
```

* `-t`: Preserves modification times.  
* `*.c`: Pattern to match files.  
* `foo:src/`: Remote directory to transfer files to.  
    * Syntax for the remote directory is the same as SSH: `machine:directory`

This will transfer all files matching a pattern (`*.c`) from the current  
directory to the remote directory (`foo:src/`) via SSH.  


## Using `--delete` to Delete Files on the Remote Host
The `--delete` option will delete files on the remote host that aren't
on the local host.
 
You don't need to specify which files to delete.
If the file or directory doesn't exist on the local host, `rsync` will
automatically delete it on the remote host with `--delete`.
 
E.g.,:
Remote host has the new file called `test.txt`. 
Local host does not have the file `test.txt`.
The `--delete` option will the file `test.txt` on the remote host.





## Using rsync to Transfer Files and Changes via SSH  
Synchronize all files from a local directory to a remote directory via SSH.  
```bash  
rsync -avz -e ssh user@192.168.0.11:/path/to/files/ /path/to/local/home/  
# or  
rsync -avz -e ssh user@homelab:/path/to/files/ /path/to/local/home/  
```
Replace `user@192.168.0.11` or `user@homelab` with the remote host's IP address or name.  

* `-a`: Archive mode (preserves permissions, symlinks, etc.)  
* `-v`: Verbose (shows the files being transferred)  
* `-z`: Compress file data during the transfer.  
* `-e ssh`: Use SSH for the data transfer.  



## Preview the Changes of an `rsync` Command 
Before making any changes, it's a good idea to preview the changes that'll be made.  
 
You can preview the changes from an `rsync` command 
without actually making any changes.  
 
To do this, use the `-n` (`--dry-run`) option.  

```bash  
rsync -avn -e ssh user@homelab:/path/to/files/ /path/to/local/home/  
```

* `-a`: Archive mode (preserves permissions, symlinks, etc.)  
* `-v`: Verbose (shows the files being transferred)  
* `-n`: Dry run. Performs a trial run with no changes made. (`--dry-run`)  
    * Don't transfer files, just show what would be transferred.  
    * Also called "dry run."  
* `-z`: Compress file data during the transfer (`--compress`).  
* `-e ssh`: Use SSH for the data transfer  
* `/path/to/files/`: Source directory on the remote host  


---

## rsync Options  

* `-t`: Preserves file modification times. (`--times`)  
* `-U`: Preserves file access times (use times). (`--atimes`)  
* `-a`: Archive mode (preserves permissions, symlinks, etc.)  
    * Preserves symlinks, devices, attributes, permissions,
      ownerships, etc.  
 

* `-n`: Dry run. Performs a trial run with no changes made. (`--dry-run`)  
    * Don't transfer files, just show what would be transferred.  
* `-v`: Verbose (shows the files being transferred)  
* `-e ssh`: Use SSH for the data transfer  
 
* `-z`: Compress file data during the transfer.  
    * Compresses the file data as it's being sent to the destination machine.  
    * Reduces the amount of data being transmitted (useful over a slow connection).  
    * Supports multiple compression methods. Will choose one for you unless you're  
      using the `--compress-choice` (`--zc`) option.  

* `-y`: Fuzzy. Look for a basis file for any destination file that is missing.  
    * Looks in the same directory as the destination file for a file that has  
      an identical size and modification time, or a similarly-named file.  


* `-h`: Output numbers in a more human-readable format. (`--human-readable`)  
    * There are 3 possible levels (each `-h` increases level, i.e., `-hhh`):  
        1. Output numbers with a separator between each set of 3 digits (either a comma or a period).  
        2. Output numbers in units of 1000 (with a character suffix for larger units).  
        3. Output numbers in units of 1024.  





### Archive Mode  
Using `-a` (`--archive`) is equivalent to `-rlptgoD`.

It will tell `rsync` to recurse down any directories and preserve many of the 
attributes of the files.  

The only things it does not preserve:

* `ACL` (Access Control Lists), use `-A` for this.
* `xattr`, use `-X` for this. 
* `atime`, use `-U` for this
* `crtime`, use `-N` for this.
* Finding/preserving hardlinks, use `-H` for this.  


