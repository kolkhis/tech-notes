# Samba

Samba is a type of network attached storage that is compatible with Windows machines.  



## Setting up Samba

Set up Samba on a Linux machine.  

### Install
Install the Samba package.  
```bash
# Debian-based
sudo apt-get update
sudo apt-get install -y samba
# RedHat-based
sudo dnf install -y samba samba-common samba-client
```

- RedHat systems need all 3 packages.  


Choose/create the directory to server over Samba.  
```bash
sudo mkdir -p /srv/samba/share1
chmod 755 /srv/samba/share1
```

---

### Configure
Configure Samba to share the directory.  
```bash
sudo vi /etc/samba/smb.conf
```

Add an entry following the format specified in the file.  

```ini
[PublicShare]
   path = /srv/samba/share1
   browsable = yes
   read only = no
   guest ok = yes
```

- `path`: The directory to serve
- `browsable`: Will make it visible in Windows and Linux network browsers
- `read only`: Allows/disallows writing to the share
- `guest ok`: Enables/disables requiring authentication

Restart the samba service after making changes to the files.  
```bash
sudo systemctl restart smbd
```

---

### Mount / Access the Share

To access the share from Linux, you need the `cifs-utils` package.  
```bash
sudo apt-get install -y cifs-utils
```
<!-- TODO: What does CIFS stand for? -->

The Samba share will be available using `//server-ip/ShareName`.  
In this case, `//192.168.x.x/PublicShare`.  
```bash
sudo mount -t cifs //192.168.4.11/PublicShare /mnt -o guest
```
This will mount the share directly to the `/mnt` directory. If you want it to have
its own directory, create one first.  
```bash
sudo umount /mnt # if you mounted already
sudo mkdir -p /mnt/samba
sudo mount -t cifs //192.168.4.11/PublicShare /mnt/samba/ -o guest
```
<!-- TODO: What is the -o guest option? -->


## Adding Authentication to the Samba Share

You can add user-based authentication to the Samba share by modifying the entry in
`/etc/samba/smb.conf`.  
```ini
[SecureShare]
   path=/srv/samba/share1
   browsable = yes
   read only = no
   guest ok = no
   valid users = sambauser
```

This is mostly the same as the `PublicShare` config, but we are **not** allowing
guests (`guest ok = no`).   
We're specifying a single user that's allowed access to the share (username
`sambauser`).  

---

Then, you'll need to create a user on the system with the correct name.  
```bash
sudo useradd sambauser
sudo passwd sambauser
```









