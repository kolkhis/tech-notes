# Samba

Samba is a type of network attached storage that is compatible with both Linux and Windows machines.  

## Setting up Samba

This page describes how you'd set up Samba on a Linux machine.  

### Installing Samba

Install the Samba package with the package manager.  
```bash
# Debian-based
sudo apt-get update
sudo apt-get install -y samba
# RedHat-based
sudo dnf install -y samba
```

- You can additionally install `samba-client` package if you want access to tools like
  `smbclient`, `smbget`, etc.  
 

Choose/create the directory to server over Samba.  
```bash
sudo mkdir -m0755 -p /srv/samba/share1
```

---

### Configuring your Samba Share

Configure Samba to share the directory in `/etc/samba/smb.conf`.  
```bash
sudo vi /etc/samba/smb.conf
```

- This file may be under `/usr/local/samba/lib/smb.conf` or `/usr/samba/lib/smb.conf` 
  on some systems.  

Add an entry following the format specified in the file.  

An example, which will create a public share that anyone on your network can access:  
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
In this case, `//192.168.x.x/PublicShare` (replace `x` with your host IP).  
```bash
sudo mount -t cifs //192.168.x.x/PublicShare /mnt -o guest
```
This will mount the share directly to the `/mnt` directory. If you want it to have
its own directory, create one first.  
```bash
sudo umount /mnt # if you mounted already
sudo mkdir -p /mnt/samba
sudo mount -t cifs //192.168.x.x/PublicShare /mnt/samba/ -o guest
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

You can use the `smbpasswd` command to manage Samba users.  
```bash
sudo smbpasswd -a sambauser  # Add a user and change password
sudo smbpasswd -x sambauser  # Delete a user
sudo smbpasswd sambauser     # Change password
```

The `smbpasswd -a sambauser` will add the user as a Samba user, **and** change the 
Samba password for the user `sambauser`.  

This user account **must already exist on the host** (e.g., have an entry in `/etc/passwd`).  

You can use the `pdbedit` command to view current Samba users and details.  
```bash
sudo pdbedit -L             # List all Samba users in /etc/passwd format
sudo pdbedit -Lv sambauser  # Inspect the user details of sambauser
```

- `pdbedit -L` will list all the Samba users by default. Specify a username  
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

## Securing Samba Shares

You can limit the access to a Samba share inside the config file.  
There are also config options for setting default file permissions, setting read-only
access for certain users, giving write access to certain users, and more.  

Find the entry you want to limit, and decide how you want to limit it.  

### Limit Access by IP

- You can only allow access to a certain IP (or multiple, separated with commas,
  spaces, or tabs):
  ```ini
  [MyShare]
     hosts allow = 192.168.1.11, 192.168.1.12
     hosts deny = ALL
     ...
  ```

- Allow access to an entire subnet by leaving out the last number of the IP:
  ```ini
  [MyShare]
     hosts allow = 192.168.1.
     hosts deny = ALL
     ...
  ```
  This only allows any IP in the `192.168.1.0/24` subnet.  

- Specify more than one subnet by separating with spaces, commas, or tabs:  
  ```ini
  [MyShare]
     hosts allow = 192.168.1. 127.
     hosts deny = ALL
     ...
  ```
  This allows any IP in the `192.168.1.0/24` subnet, and the localhost.  


- You can allow entire subnets with **exceptions** as well:
  ```ini
  [MyShare]
     hosts allow = 192.168.1. except 192.168.1.12
     hosts deny = ALL
  ```
  This will allow the whole subnet except for `192.168.1.12`


- You can also specify a subnet mask directly (CIDR notation isn't supported).
  ```ini
  [MyShare]
     hosts allow = 10.0.0.0/255.0.0.0
     hosts deny = ALL
  ```

- You can also just specify hosts that *aren't* allowed to access the share:
  ```ini
  [MyShare]
     hosts deny = 192.168.4.
  ```

- Specify both a `hosts allow` and `hosts deny` to only allow trusted subnets:
  ```ini
  [MyShare]
     hosts allow = 192.168.1. 127.
     hosts deny = ALL
  ```

### Limit by User

- Specify users that can have access to the share:
  ```ini
  [MyShare]
     guest ok = no
     valid users = sambauser @sambagroup
  ```
    - Only the user `sambauser` and members of the group `sambagroup` will be able to
      access this share.  
    - This will not allow guest access.  

- You can specifically prevent certain users from accessing a share:
  ```ini
  [MyShare]
     guest ok = no
     valid users = sambauser @sambagroup
     invalid users = troll
  ```

- You can also make shares read-only for specific users:  
  ```ini
  [MyShare]
     guest ok = no
     valid users = sam sambauser @sambagroup
     read list = sam
  ```
  Now the user `sam` will have read-only access to the share.  

- Do the same with write access.  
  ```ini
  [MyShare]
     guest ok = no
     valid users = sam sambauser @sambagroup
     write list = sambauser
  ```
  Even if the share is read-only, `sambauser` will have write access.  


### Hiding Files from Unauthorized Users

You can simply set `hide readable` in your `smb.conf` entry to hide files from users
who do not have read access to them.  

```ini
[MyShare]
   guest ok = no
   valid users = sambauser @sambagroup
   hide unreadable = yes
```
This will prevent the user from seeing any files they don't have access to.  

This *kind of* enforces security through obscurity, which is not a solid security posture,
but it's still a good measure to take if you don't want users messing with files they
can't access.  

### Setting Permissions

- We can set the **default permissions** for files that are **newly created** in the share.  
  Use the `create mask` option to specify the permissions they should have.  
  ```ini
  [MyShare]
     guest ok = no
     valid users = sambauser @sambagroup
     create mask = 640
  ```
  This sets the **maximum allowed permissions** for new files created on the share.  
    - This limits the maximum permissions to `rw-r-----` (`640`) for new files.

- We can also enforce minimum permissions on directories in the share with `force directory mode`.  
  ```ini
  [MyShare]
     guest ok = no
     valid users = sambauser @sambagroup
     force directory mode = 750
  ```
  This will ensure that the **minimum** permissions on any new directories created 

- We can also control what permissions bits the client is allowed to modify by
  setting the `security mask`.   
  ```ini
  [MyShare]
     guest ok = no
     valid users = sambauser @sambagroup
     security mask = 750
  ```
  This limits which permission bits a client is allowed to modify (e.g., with `chmod`).  
  Clients can only change permission bits that are included in this mask.  


- We can force certain permission bits on directories.  
  ```ini
  [MyShare]
     guest ok = no
     valid users = sambauser @sambagroup
     force security directory mask = 500
  ```
    - `force security directory mask` forcibly overwrites directory permissions when the 
      client attempts to change them.
    - This forces the owner to always have `r-x` and others to always have `---`, 
      regardless of what the client tries to set.
    - It overwrites permission changes on directories, forcing these bits.

---

There are a bunch of other options for controlling how permissions work in your samba
shares.  

Below is a table explaining what each option does.  

| Option                          | Purpose                                        |
| ------------------------------- | ---------------------------------------------- |
| `directory mask`                | Max allowed permissions for new directories    |
| `force create mode`             | Forces minimum permissions for new files       |
| `force directory mode`          | Forces minimum permissions for new directories |
| `security mask`                 | Limits `chmod` permissions on files            |
| `directory security mask`       | Limits `chmod` permissions on directories      |
| `force security mask`           | Forces `chmod` permissions on files            |
| `force security directory mask` | Forces `chmod` permissions on directories      |
| `inherit permissions`           | New files inherit parent directory permissions |
| `inherit owner`                 | New files inherit parent directory ownership   |
| `force user`                    | Forces all file ownership to a specific user   |
| `force group`                   | Forces all file ownership to a specific group  |
| `map archive`                   | Map Windows archive attribute                  |
| `map hidden`                    | Map Windows hidden attribute                   |
| `map system`                    | Map Windows system attribute                   |

Using these options gives you very granular control over what a user can do on your
Samba shares.  

For instance, if you want to give a user write access but you don't want to allow
them to *set* write permissions on files. That type of control is extremely useful.  


## Install tl;dr

```bash
# Server-side
sudo apt-get update
sudo apt-get install -y samba
# Or, on RedHat-based systems:
sudo dnf install -y samba samba-common samba-client

# Create share directory
sudo mkdir -p /srv/samba/share

# Add config entry for share
sudo vi /etc/samba/smb.conf
```

The config entry should look like this:
```ini
# For shares that don't require authentication
[PublicShare]
   path = /srv/samba/share1
   browsable = yes
   read only = no
   guest ok = yes

# for a share that requires authentication
[SecureShare]
   path=/srv/samba/share1
   browsable = yes
   read only = no
   guest ok = no
   valid users = sambauser
```

After changing the `smb.conf`, restart the `smbd` service.  
```bash
sudo systemctl restart smbd
```

If you're using a secure share with authentication, add some login credentials.  
```bash
sudo useradd sambauser
sudo passwd sambauser
sudo smbpasswd -a sambauser
```

Then, on your **client** machines, install `cifs-utils`.  
```bash
sudo apt-get install -y cifs-utils
```

Then mount the Samba share.  
```bash
sudo mount -t cifs //192.168.x.x/ShareName -o guest
# Or, if using a secure share
sudo mount -t cifs //192.168.x.x/ShareName -o username=sambauser
```

> Alternatively, use [`sambaclient`](#using-sambaclient) to interact with the Samba share.  

To access the share on Windows, open File Explorer and either type `\\server-ip\ShareName`
into the File Explorer URI bar, or right click on "Network", then "Map network drive...".  


| Task            | Command
| ----------------| -------
| Install Samba   | `sudo apt install samba` or `sudo dnf install samba samba-common samba-client`
| Create Share    | `sudo mkdir -p /srv/samba/share1`
| Configure Share | Add to `/etc/samba/smb.conf`
| Restart Samba   | `sudo systemctl restart smbd`
| Mount Share (Linux)    | `sudo mount -t cifs //server-ip/share /mnt -o guest`
| Access Share (Windows) | `\\server-ip\sharename`
| Add Samba User         | `sudo smbpasswd -a sambauser`
| List Samba Users       | `sudo pdbedit -L`
| Command-Line Client    | `smbclient //server-ip/share -U sambauser`

## Linux/Unix Password Sync

This part is configured by default on some installations of Samba on Linux.  
But, if you find that your Samba user's password and the Linux user's password are
out of sync with each other, you'll need to configure password sync.  

---

If Samba is not configured for password sync, when you change the password of a user 
using either `passwd` or `smbpasswd`, the passwords for the Linux system and the 
Samba share will be out of sync.  
This is avoided by setting the `unix password sync = yes` in the `[global]` section 
of the samba config file `/etc/samba/smb.conf`.  

```ini
[global]
unix password sync = yes
passwd program = /usr/bin/passwd %u
passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
```
The `passwd program` and `passwd chat` options need to be set for the Unix password
sync to work properly on Linux.  

The `passwd chat` line needs to **exactly match** the output of the `passwd program` 
being used (in this case, `/usr/bin/passwd`) returns when changing a password using 
that program.

## Clearing SMB Sessions on Windows

If you've made changes to the Samba share or credentials and try to reconnect via 
Windows, then you may run into an issue where you get an error looking something
like:  
```txt
The network folder specified is currently mapped using
a different user name and password.  
To connect using a different user name and password, first
disconnect any existing mappings to this network share.
```

You can clear the cached credentials using PowerShell:
```sh
net use
```
This will show network drives.  

If you see your drive there (`\\192.168.x.x\ShareName`), that's your Samba session
that you need to clear.  
```sh
net use \\192.168.x.x\ShareName /delete
# Or, delete all samba sessions
net use * /delete
```
This will clear it, and you'll be able to map/mount the Samba share again through
File Explorer.  



## Resources

- `man samba`
- `man 5 smb.conf`
- <https://linux-training.be/networking/ch21.html>
- <https://www.tecmint.com/install-samba-rhel-rocky-linux-and-almalinux/>
- <https://www.suse.com/support/kb/doc/?id=000016742>
