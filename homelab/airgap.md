# Airgapping the Homelab

To improve security, the system will be air-gapped.
This will be done with a bastion node that contains a user account that is jailed to
a chrooted environment.  

## Overview

There will be 1 node with a jailed user.
There will be an ingress to the homelab via this node.  

This node will be responsible for taking input from the user to determine where they
need to go.  

The jailed user will have a custom shell script as their shell, set in `/etc/passwd`.  

Likely `rbash` will be used as the background shell that runs the custom shell script 
to minimize the potential of the user breaking out of the jail.  

```plaintext
| Outside  | (SSH)  | Bastion Host | (SSH) |  Destination Host
| Internet |  --->  | JailedUser   |  ---> |  Unjailed User
```



## Building a Chroot Jail

On the proposed jumpbox, use a chrooted environment in which to jail users.  

`/var/chroot` is a good location, it's out of the way and won't be interfered with.  

```bash
mkdir /var/chroot
```

We'll need to build out the directory structure so that `/var/chroot` can pretend to
be a root environment.  

The directories needed:

- `/bin`
- `/lib64`
- `/dev`
- `/etc`
- `/home`
- `/usr/bin`
- `/lib/x86_64-linux-gnu`

```bash
# Brace expansion to one-line it
mkdir -p /var/chroot/{bin,lib64,dev,etc,home,usr/bin,lib/x86_64-linux-gnu}
ls -l /var/chroot   # verify
```


---

Then we can copy over some binaries.  

```bash
cp /usr/bin/bash /var/chroot/bin/bash
```

The binary won't be able to work by itself.  
Binaries usually have linked libraries that they use as dependencies.  

We can get a list of those linked libraries with `ldd`.  

```bash
ldd /bin/bash
```
Copy them over:
<!-- ldd /bin/bash | perl -pe 's/.*?(\/.*?)\(.*?\)$/\1/' # filter the paths -->
<!-- ldd /bin/bash | perl -pe 's/.*?(\/.*?)\(.*/$1/' -->
<!-- ldd /bin/bash | sed -E 's/^[^\/]*(\/.*)\(.*$/\1/' -->
```bash
# extract only paths
for LLIB in $(ldd /bin/bash | perl -ne 'print $1 . "\n" if s/^[^\/]*(\/.*)\(.*$/\1/'); do
    cp $LLIB /var/chroot/$LLIB
done 

# or use awk (will see an error)
for LLIB in $(ldd /bin/bash | awk '{print $(NF -1)}'); do
    cp $LLIB /var/chroot/$LLIB
done
```

---

Certain system files also need to be present to get the expected functionality.  
- `/etc/passwd`
- `/etc/group`
- `/etc/nsswitch.conf`
- `/etc/hosts`

Copy them over to the chroot jail:  
```bash
for file in "passwd" "group" "nsswitch.conf" "hosts"; do
    cp "/etc/$file" "/var/chroot/etc/$file"
done
```

Now those base files are in the jail. 

Give the jailed user some binaries.  
```bash
for binary in "bash" "ssh" "curl"; do 
    cp "/usr/bin/$binary" "/var/chroot/usr/bin/$binary"
done
```

### Create Special Files
A functional shell expects to have certain system files.  
For example, in the SSH program, it may redirect something to `/dev/null`, but what
if there is no `/dev/null` in the user's environment? Things will break.  

So, some of these files need to be created.  
```bash
mknod -m 666 "${CHROOT_DIR}/dev/null" c 1 3
mknod -m 666 "${CHROOT_DIR}/dev/tty" c 5 0
mknod -m 666 "${CHROOT_DIR}/dev/zero" c 1 5
mknod -m 666 "${CHROOT_DIR}/dev/random" c 1 8 
mknod -m 666 "${CHROOT_DIR}/dev/urandom" c 1 9
```

### Copy Name Switch Service Files
The chroot jail needs the NSS files in order to have network functionality.  

```bash
cp -r /lib/x86_64-linux-gnu/*nss* /var/chroot/lib/x86_64-linux-gnu/
```


## High Level Steps
Make sure you're on the bastion host.  
```bash
ssh bastion
```
Create the chroor jail dir.
```bash
mkdir /var/chroot
```
Create the directory structure of the jail.
```bash
mkdir -p /var/chroot/{bin,lib,dev,etc,home,usr/bin,lib/x86_64-linux-gnu}
```

Move in executables.
```bash
cp /usr/bin/bash /var/chroot/bin/bash
cp /usr/bin/ssh /var/chroot/bin/ssh
cp /usr/bin/curl /var/chroot/bin/curl
```
Copy in their link libraries.
```bash
for pkg in $(ldd /bin/bash | awk '{print $(NF-1)}'); do; cp $pkg /var/chroot/$pkg; done
for pkg in $(ldd /usr/bin/ssh | awk '{print $(NF-1)}'); do; cp $pkg /var/chroot/$pkg; done
for pkg in $(ldd /usr/bin/curl | awk '{print $(NF-1)}'); do; cp $pkg /var/chroot/$pkg; done
```

Move in system files.
```bash
for f in {passwd,group,nsswitch.conf,hosts}; do cp /etc/$f /var/chroot/etc/$f; done
```

Make character special files.  
```bash
mknod -m 666 "/var/chroot/dev/null" c 1 3
mknod -m 666 "/var/chroot/dev/tty" c 5 0
mknod -m 666 "/var/chroot/dev/zero" c 1 5
mknod -m 666 "/var/chroot/dev/random" c 1 8
mknod -m 666 "/var/chroot/dev/urandom" c 1 9
```

Copy over name switch service libraries.
```bash
cp -r /lib/x86_64-linux-gnu/*nss* /var/chroot/lib/x86_64-linux-gnu
```

---

Set up user account for the "free" user on the destination host.
```bash
exit # if ssh'd into bastion
useradd -m freeuser
passwd freeuser
```

Set up a user account for the jailed user on the bastion host.  
```bash
ssh bastion
useradd -m jaileduser
passwd jaileduser
```

Add rule for `jaileduser` in `/etc/ssh/sshd_config`.  
```bash
Match User jaileduser
ChrootDirectory /var/chroot
```

Restart the SSH daemon.
```bash
systemctl restart ssh
```

---

Create a `bastion.sh` script to use as the user's shell.  
```bash
#!/bin/bash
declare INPUT
read -n 2 -t 20 -p "Select one of the following:
1. Connect to DestinationHost
2. Exit
" INPUT
case $INPUT in
    1)
        printf "Going to DestinationHost.\n"
        /usr/bin/ssh freeuser@destinationhost
        exit 0
        ;;
    2)
        printf "Leaving now.\n"
        exit 0
        ;;
    *)
        printf "Unknown input.\n"
        exit 0
        ;;
esac
exit 0
```

Copy the script into the chroot jail.
```bash
cp bastion.sh /var/chroot/bin/bastion.sh
chmod 755 /var/chroot/bin/bastion.sh
```

Set the `bastion.sh` script as the user's shell in `/etc/passwd` and copy it to the
chroot jail.  
```bash
vi /etc/passwd # Change 'jaileduser's shell to /bin/bastion.sh
cp /etc/passwd /var/chroot/etc/passwd
```

Finished.

Test. Try to SSH to `jaileduser@bastion`:
```bash
ssh jaileduser@bastion
# enter password
```



## Resources
- []()
- [ProLUG Chroot Jail Killercoda Lab](https://killercoda.com/het-tanis/course/Linux-Labs/204-building-a-chroot-jail)
- [ProLUG Bastion Host Killercoda Lab](https://killercoda.com/het-tanis/course/Linux-Labs/210-building-a-bastion-host)
    * [gh](https://github.com/het-tanis/prolug-labs/tree/main/Linux-Labs/210-building-a-bastion-host)


