# Jailing Users in Linux (SSH)

When a user enters your system via SSH, you may not want them to have full access to
everything.  

## sshd_config
You can specify rules for when a user SSH's into your box in `/etc/sshd_config`:
```bash
Match User user1
ChrootDirectory /var/chroot_user1
```
`Match User user1`: This matches the username that a user logs in with, and sets
the `ChrootDirectory` to `/var/chroot`
Essentially what this is doing is:
```bash
# log in as user1
chroot /var/chroot_user1
```

## Setting up the Chroot Directory
Inside `/var/chroot`, you can specify a set of binaries that a user has access to.  
For a jump box, a minimal `/bin` directory with just a couple tools is needed:
- `bash`
- `ssh`
- `curl`  
Optionally, a bash script to use a the user's shell.  


## Setting Login Shell as a Script
You can specify a bash script as a user's shell in `/etc/passwd`.  
The format for lines in this file:
```plaintext
username:password:UID:GID:GECOS:home_directory:shell  
```
Where `shell` is you can put the name of a script that the user has access to.  


