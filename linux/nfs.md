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
  access this share.  
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


### Auto Mounting with `/etc/fstab`
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

### Auto Mounting with Systemd

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

Check what your mount/automount files should be called with the following command:
```bash
systemd-escape -p --suffix=mount '/mnt/share1'
```
Plug your mount point into that string and it will show you what your service should
be called.  



- `/mnt/share1`
- `mnt-share1`





































































## Misc
```bash
sudo mount -t nfs 192.168.8.168:/home/ts/nfs-share /home/sam/nfs-mount
```


Automount is a type of unit file through systemd.  

* `systemd-automount`
