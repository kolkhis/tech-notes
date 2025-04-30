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




