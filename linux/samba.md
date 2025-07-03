# Samba

Samba is a type of network attached storage that is compatible with Windows machines.  



## Setting up Samba

This page describes how you'd set up Samba on a Linux machine.  

### Install

Install the Samba package.  
```bash
# Debian-based
sudo apt-get update
sudo apt-get install -y samba
# RedHat-based
sudo dnf install -y samba samba-common samba-client
```

- On RedHat systems, you need to specify all 3 packages, where as Debian-based 
  systems just need the `samba` package (it will install the others automatically).  


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

> Tip: You can use `testparm` to make sure your config is valid.  

Restart the samba service after making changes to the files.  
```bash
sudo systemctl restart smbd
```

---

### Mount / Access the Share

#### Access Share from Linux
To access the share from Linux, you need the `cifs-utils` package.  
```bash
sudo apt-get install -y cifs-utils
```

- CIFS stands for "Common Internet Filesystem".  

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

- `-o guest`: No username or password is sent. The Samba server must have `guest ok =
  yes` enabled for the share to accept unauthenticated connections.  


You may need to change the ownership of the Samba share on the Samba server if you
want to write to the shares.  

---

#### Access Share from Windows

To access the Samba share from Windows, just open the File Explorer and type
`\\server-ip\ShareName` in the navigation bar.  

If you want to mount it, open File Explorer and right click on "Network", and then
select "Map network drive".  

Enter the address the same way, `\\server-ip\ShareName`, and select a drive letter,
then click "Finish".  

---

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

- `valid users = sambauser` specifies a **single** Samba user.  
    - If you specified `@smbusers`, it will allow all users in the group `smbusers`
      access to the share.    

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
Give the user a password and then set the Samba password.  
```bash
sudo smbpasswd -a sambauser
```

- This adds the user to Samba's **internal password database** (e.g., adds a
  `smbpasswd` user).  
    - This is stored in `/var/lib/samba/private/passdb.tdb` (or in
      `/var/lib/samba/private/smbpasswd` on some systems).  
        - `.tdb` is a "Trivial Database", a binary database file.  
    - On legacy systems, it may be in `/etc/samba/smbpasswd`.  
    - This is not a file to be edited directly. Use `smbpasswd` to manage it.  

- The `smbpasswd` user is a Samba-specific user stored in `/var/lib/samba/private/`.  
  **Requires** a matching Linux user to exist.

- You can use `sudo pdbedit -L` to verify it was successful.  
    - Use this command to view the Samba users on the system.  


Then, we can mount the Samba share in an authenticated manner.  
```bash
sudo mount -t cifs //server-ip/SecureShare /mnt/samba-secure -o username=sambauser
```
It will prompt you for the password you set using `smbpasswd`.  
Once you've entered it, it's mounted!  

--- 

If you want to have write access to the share on the clients, change the ownership of
the share to your Samba user:
```bash
sudo chown -R sambauser:sambauser /srv/samba/
```

Also make sure `read only = no` in your `smb.conf` file.  

---

## Managing Samba Users

You can use the `smbpasswd` command to edit the passwords for Samba users.  
```bash
sudo smbpasswd -a sambauser
```

- This will change the Samba password for the user `sambauser`. This user account must
  already exist on the host (e.g., have an entry in `/etc/passwd`).  

You can use the `pdbedit` command to view current Samba users and details.  
```bash
sudo pdbedit -L             # List all Samba users in /etc/passwd format
sudo pdbedit -Lv sambauser  # Inspect the user details of sambauser
```

- This will list all the Samba users.  
- The Samba users will share a UID with the system's corresponding user.  
    - E.g., `sambauser` has UID `1002` in `/etc/passwd`. `pdbedit -L` will show
      `1002` as `sambauser`'s UID.  



## Using `sambaclient`

If you don't want to mount the Samba share directly, you can use `sambaclient` to 
open up a prompt to interact with the share.  
```bash
sambaclient //server-ip/ShareName
```
Type `?` or `help` to see a list of commands.  

The `get` command will copy a file to your home directory by default.  
```bash
get hi.txt
```
This copies `hi.txt` to your home dir.  

Use `put` to copy a local file into the Samba share.  
```bash
put /home/kolkhis/somefile somefile
```
This copies the local file `/home/kolkhis/somefile` to the NFS share.  


---

## tl;dr

| Task                   | Command                              |
| ---------------------- | ------------------------------------ |
| Install Samba          | `sudo apt install samba`             |
| Create Share Directory | `sudo mkdir -p /srv/samba/share`     |
| Configure Share        | Add to `/etc/samba/smb.conf`         |
| Restart Samba          | `sudo systemctl restart smbd`        |
| Access (Windows)       | `\\server-ip\sharename`              |
| Access (Linux)         | `//server-ip/sharename`              |

