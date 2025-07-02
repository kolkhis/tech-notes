# NFS

NFS (Network File Share) is a way to serve a mountpoint over a network.  

## Setting up NFS

### Install the NFS Utility

To set up an NFS share on Linux, first install the NFS server.  
```bash
sudo apt-get install -y nfs-kernel-server
# Or, on RedHat-based systems
sudo dnf install nfs-utils
```

Enable and start the NFS server.  
```bash
sudo systemctl enable --now nfs-server
```

Make or choose the directory you want to serve over NFS.  
```bash
sudo mkdir -p /nfs/share1
```

---

Now, we need set up our NFS server to **export** the directory.  
This will make it available to other machines over the NFS server.  

Edit the `/etc/exports` file.  
```bash
sudo vi /etc/exports
```
Add an entry to this file on its own line containing the absolute path to the 
directory you want to export, following the examples at the top of the file:  
```bash
/nfs/share1  192.168.4.0/24(rw,sync,no_subtree_check)
```

- This will allow any IP in the range given in the CIDR address `192.168.4.0/24` to
  access this NFS share.  
  This allows all IPs from `192.168.4.1` to `192.168.4.254`.

- If you want to specify a smaller range, you can create a smaller subnet.  
  ```bash
  /nfs/share1  192.168.4.11/28(rw,sync,no_subtree_check)
  ```
  This will allow IPs from `192.168.4.11` to `192.168.4.27`.  
  The higher the CIDR, the lower the number of available IPs.  

- You can also specify host-specific rules on the same line.  

<!-- TODO: Add section explaining /etc/exports entries -->

After saving the file with the new entry, use the `exportfs` command to load the new
NFS config.  
```bash
exportfs -rav
```

The share will now be accessible over the network.  

### Mounting an NFS Share

From a client machine, you also need the NFS package in order to mount an NFS share.  
Some distros have these by default.  
```bash
sudo apt-get install -y nfs-common
# Or, on RedHat-based systems
sudo dnf install nfs-utils
```

With that package installed, you should be able to mount the NFS share.  
```bash
sudo mount -t nfs 192.168.4.11:/nfs/share1 /mnt/share1
```

This will mount the remote NFS share to the local directory `/mnt/share1`


## Auto Mounting NFS Shares with `/etc/fstab`
If you want to automount the NFS share, you can add an entry if `/etc/fstab` on the client.  
```bash
sudo vi /etc/fstab
```

Add the line:
```bash
192.168.4.11:/nfs/share1 /mnt/share1 nfs defaults 0 1
```

Replace the IP and directories with your host and the NFS directory location.  

That's it.

## Auto Mounting NFS Shares with Systemd

Use `.mount` and `.automount` files in order to use systemd to automount the NFS
share.  

Pay attention to your file names here.  

In `/etc/systemd/system/mnt-share1.mount`:
```ini
[Unit]
Description=Mounts NFS share 1
After=network.target

[Mount]
What=192.168.4.11:/nfs/share1
Where=/mnt/share1
Type=nfs
Options=default
TimeoutSec=5

[Install]
WantedBy=multi-user.target
```

Then, in `/etc/systemd/system/mnt-share1.automount`:
```ini
[Unit]
Description=Auto mounts NFS share 1
After=network.target

[Automount]
Where=/mnt/share1
TimeoutIdleSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start the automount service.  
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now mnt-share1.automount
```

> **NOTE**: Make sure your unit file names reflect the path of the mount point!  

If you see an error in `journalctl` that says something like 
"`Where= setting doesn't match unit name. Refusing.`," your naming convention is wrong.  

### Systemd Mount File Name Convention

Your `.mount` and `.automount` files need to reflect the mount point path in their
names.  

Check what your mount/automount files should be called with the following command:
```bash
systemd-escape -p --suffix=mount '/mnt/share1'
```

Plug your mount point into that string and it will show you what your service should
be called.  

Your file names should be the mount point path, separated by hyphens (`-`) rather
than slashes.  

So, from the example in this page:

- Your mount point is `/mnt/share1`
- Name the unit files `mnt-share1.mount` and `mnt-share1.automount`.  

Likewise, if you were mounting at `/home/you/nfs`, name the unit files
`home-you-nfs.mount`, same with the `.automount`.  

Again, the `systemd-escape` command will properly escape your mount point and give
you a systemd-compliant filename.  

---

## `/etc/exports` Entries

The `/etc/exports` file controls **which directories** are shared over NFS, and **who can
acess them**.  

Each line in `/etc/exports` defines a directory to share over NFS in the following format:  
```bash
<directory> <client>(<options>) <client>(<options>)
```

- The `<directory>` is the directory to serve over NFS.  

- The `<client>(<options>)` specifies which hosts to allow access to, and what
  permissions they should have on the NFS share.  

- You can specify multiple clients on the same line, with different permissions.  


---

### Client Formats

You can specify the `<client>` in a number of different ways.  
Some of the most common `<client>` formats are:

- `192.168.1.0/24`: CIDR notation  
    - This specifies the entire subnet `192.168.1.0` (host bits `1` through `254`).  
- `192.168.1.11`: Specific IPs  
    - This specifies a single host to give access to the NFS share.  
- `homelab`: Specific hostname  
    - This specifies a single host by name, if it's resolvable.  
    - This entry should be in `/etc/hosts` to resolve properly.  
- `*`: Wildcard  
    - This makes the NFS share available to **any client**.  
    - **Not recommended** for security reasons.  
- `@netgroup`: NIS (Network Information Service) netgroup.  
    - This is mostly used in enterprise setups.  

---

### Options

After you specify the `client`, you need to specify `options` in parentheses.  

```bash
DIR HOST(OPTIONS)
```

The `OPTIONS` can be used to specify the permissions for the specific `HOST` (or
`HOSTS`), as well as how the NFS share will behave on the client.  

Available options include:

- `rw`: Read/write access.  
- `ro`: Read-only access.  
- `sync` The NFS server writes changes to the disk **immediately** before sending a success response to the client.  
    - This is recommended for safety and data integrity.  
- `async`: Faster than `sync` but possible to lose data (e.g., system crash).  
    - With `async`, the NFS server can cache write operations in memory and send a success response
      to the client **before** actually writing to the disk.  
- `subtree_check`: Ensures clients can only access the exported directory.  
    - This is the default. Slower than `no_subtree_check`.  
    - When you export a subdirectory (not a whole filesystem), NFS checks the full path 
      to ensure the client is only accessing the exported directory.
    - Better than `no_subtree_check` for security, but slower.  
- `no_subtree_check`: Skips directory path checks.  
    - This is usually the recommended approach, especially if you're exporting entire filesystem trees.  
    - Faster than `subtree_check`, usually fine in most use cases.  
- `no_root_squash`: Allows root on the client to act as root on the NFS server.  
    - This means `root` on the client will retain full root permissions on the NFS share.  
    - This is **dangerous**. If the client gets compromised, the NFS share is compromised. **Not recommended**.  
- `root_squash`: Maps the client's root user to the `nfsnobody` user.  
    - This is the safe approach.  
- `all_squash`: Maps **all** users to the `nfsnobody` user.  
- `anonuid=UID`: Specify an anonymous UID.  
- `anongid=UID`: Specify an anonymous GID.  


### Reloading Exports

After changing the /etc/exports file, you need to reload the changes.  
```bash
sudo exportfs -rav
```

- `-r`: Re-exports all directories in the `/etc/exports` file.  
    - This also syncs `/var/lib/nfs/etab` with `/etc/exports`.  
- `-a`: Exports/un-exports all entries in the `/etc/exports` file.  
- `-v`: Verbose output.  

