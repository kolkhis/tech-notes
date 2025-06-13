# Airgapping the Homelab

To improve security, the system will be air-gapped.
This will be done with a bastion node that contains a user account that is jailed to
a chrooted environment.  


## Table of Contents
* [Overview](#overview) 
* [Building a Chroot Jail](#building-a-chroot-jail) 
    * [Create the Directory Structure](#create-the-directory-structure) 
    * [Copy over Binaries (and Linked Libraries)](#copy-over-binaries-and-linked-libraries) 
        * [Copy all of the Binaries](#copy-all-of-the-binaries) 
    * [Copy over Required System Files](#copy-over-required-system-files) 
    * [Create Special Files](#create-special-files) 
    * [Copy Name Switch Service Files](#copy-name-switch-service-files) 
    * [Create the User Account](#create-the-user-account) 
        * [Create a Custom Shell](#create-a-custom-shell) 
* [High Level Steps](#high-level-steps) 
* [Enhancements (TODO)](#enhancements-todo) 
* [Resources](#resources) 


## Overview

There will be 1 node with a jailed user.
There will be an ingress to the homelab via this node.  

This node will be responsible for taking input from the user to determine where they need to go.  

The jailed user will have a custom shell script as their shell, set in `/etc/passwd`.  

Likely `rbash` will be used as the background shell that runs the custom shell script 
to minimize the potential of the user breaking out of the jail.  


```plaintext
| Outside  | (SSH)  | Bastion Host | (SSH) |  Destination Host
| Internet |  --->  | JailedUser   |  ---> |  Unjailed User
```

---

The concepts implemented here:

- Strong security posture

    - Using a chroot jail with a custom shell (and possibly `rbash`) enforces the
      rule of least privilege and containment.  
        - `rbash` cannot redirect output.  

    - Air-gapping the internal network by forcing access through a bastion host is a
      standard practice in secure enterprise environments.  

- User isolation
- SSH restrictions
- Minimal userland

Tools used:

- `bash`/`rbash`
- `ldd` (binary dependencies)
- `mknod`, character devices (special files)
- SSH `Match` blocks.  


## Building a Chroot Jail

On the proposed jumpbox, use a chrooted environment in which to jail users.  

### Create the Directory Structure

`/var/chroot` is a good location, it's out of the way and won't be interfered with.  

If we wanted to make multiple chroot environments on the same host for multiple user
accounts, we could name the chroot directories accordingly (`/var/chroot_user1`, `/var/chroot_user2`, etc.).  

For now, we'll only do one.  
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

### Copy over Binaries (and Linked Libraries)

Then we can copy over some binaries.  

Let's start with one, bash.  
```bash
cp /usr/bin/bash /var/chroot/bin/bash
```

Now, the binary won't be able to work by itself.  
Binaries typically have linked libraries that they use as dependencies.  

We can get a list of those linked libraries by using the `ldd` program.  

```bash
ldd /bin/bash
```
This shows all the linked libraries that `bash` depends on in order to function
properly.  

Copy them over to the chroot environment.  

Extract them however you want.  
<!-- ldd /bin/bash | perl -pe 's/.*?(\/.*?)\(.*?\)$/\1/' # filter the paths -->
<!-- ldd /bin/bash | perl -pe 's/.*?(\/.*?)\(.*/$1/' -->
<!-- ldd /bin/bash | sed -E 's/^[^\/]*(\/.*)\(.*$/\1/' -->
```bash
# extract only paths with perl
for LLIB in $(ldd /bin/bash | perl -ne 'print $1 . "\n" if s/^[^\/]*(\/.*)\(.*$/\1/'); do
    cp $LLIB /var/chroot/$LLIB
done 

# Using grep -o ('-o'nly print match)
for LLIB in $(ldd /bin/bash | grep -o '/[^ ]*'); do
    cp $LLIB /var/chroot/$LLIB
done 

# or use awk (will see an error)
for LLIB in $(ldd /bin/bash | awk '{print $(NF -1)}'); do
    cp $LLIB /var/chroot/$LLIB
done
```

#### Copy all of the Binaries

Let's do that for all the binaries we want to give them.  

Give the jailed user their binaries.  
Of course, we'll need the linked libraries for those binaries as well.  

We can do this by looping over what we want to give them.  
```bash
for binary in {bash,ssh,curl}; do 
    path=$(which $binary)
    cp "$path" "/var/chroot$path"
    for lib in $(ldd "$binary" | grep -o '/[^ ]*'); do
        cp "$lib" "/var/chroot$lib"
    done
done
```


---

### Copy over Required System Files

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

### Create the User Account

We'll need an actual user account to put in jail.  
Let's make one called `jaileduser`, and give him a password `testpass`.  
```bash
useradd -m jaileduser
printf "testpass\ntestpass\n" | sudo passwd jaileduser
```

Now, we'll need to add some rules in `/etc/ssh/sshd_config` to dump him in the jailed
environment when he connects.  

```bash
sudo vi /etc/ssh/sshd_config
```

Add the lines:
```bash
Match User jaileduser
ChrootDirectory /var/chroot
```

Then restart the SSH service.  
```bash
sudo systemctl restart ssh
```


#### Create a Custom Shell

Now we can create a custom shell for the jailed user. This is just going to be a bash
script.  

An example:
```bash
#!/bin/bash
declare INPUT
read -r -n 2 -t 20 -p "Welcome!
Select one of the following:
1. Connect to DestinationHost
2. Exit
> " INPUT
case $INPUT in
  1)
      printf "Going to DestinationHost.\n"
      ssh freeuser@destinationhost
      exit 0
      ;;
  2)
      printf "Leaving now.\n"
      exit 0
      ;;
  *)
      printf "Unknown input. Goodbye.\n"
      exit 0
      ;;
esac
exit 0
```

Make sure it's executable.  
```bash
chmod 755 bastion.sh
```

Once that's made, copy (or hardlink) it over to `/var/chroot/bin/bastion.sh`.  
```bash
ln ./bastion.sh /var/chroot/bin/bastion.sh
# or
cp ./bastion.sh /var/chroot/bin/bastion.sh
```

---

Now, set the script as the user's shell in `/etc/passwd`.  
```bash
sudo vi /etc/passwd
```
Then change the line.  
```bash
jaileduser:x:1001:1001::/home/jaileduser:/bin/sh
# change to:
jaileduser:x:1001:1001::/home/jaileduser:/bin/bastion.sh
```

Alternatively, you can use `sed` to accomplish this.  
```bash
sudo sed -i '/jaileduser/s,/bin/sh,/bin/bastion.sh,' /etc/passwd
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


---

## Setting up Logging

Since our bastion script is using `rbash` (restricted bash), redirection is not
allowed.  

That means the typical:
```bash
printf "User entered: %s\n" "$INPUT" >> $LOGFILE
```
will not work.  

Sidebar: Though the standard `>` and `>>` redirection operators are disallowed, we
can still use the pipe (`|`) redirection operator, as well as the `<` input
redirection operator.  

But, we won't necessarily need those to set up logging.  
We can use `logger`.  

Now, `logger` is not a builtin command, so it does need to be installed in the chroot
environment alongside `rbash`, `ssh`, and `ping`, but it will allow us to write logs
stright to the systemd journal (`journald`), which will then be available through
`journalctl` (or in `/var/log/syslog` or `/var/log/messages` by default depending on 
your distro).  

For example:
```bash
logger -t bastion "Test message"
tail -n 1 /var/log/syslog
# Output:
# Jun  6 20:27:40 jumpbox01 bastion: Bastion tag test message
```

The `-t` sets the tag, which will be the current `$USER` by default.  

If we wanted to, we could also use `logger` to write logs 
to `/var/log/auth.log` (on Debian-based systems only).  
```bash
logger -t bastion -p auth.info "Test message"
tail -n 1 /var/log/auth.log
# Output:
# Jun  6 20:30:07 jumpbox01 bastion: Test info severity
```

- `-p`: Sets the priority for the log, formatted as `facility.level`.  
    - Defaults to `user.notice`.  

Note that this will not write to `/var/log/secure` on RedHat-based systems, it will write to `/var/log/messages` (tested on Rocky).  

---

Ultimately, `logger` sends log entries to the system logger (`/dev/log` or
`journald`), and if you're running `rsyslog`, logs end up to wherever your config 
routes them. This is usually `/var/log/syslog` (Debian) or `/var/log/messages` (RedHat).    

We can set up a custom file through `rsyslog` for our bastion program if we want. We
would need to add a file in `/etc/rsyslog.d/`, and use `rsyslog`'s quirky
configuration syntax:  
```bash
# /etc/rsyslog.d/50-bastion.conf
if $programname == 'bastion.sh' then /var/log/bastion.log
& stop
```

But, for our purposes, we will likely already be collecting logs from
the default system log location with our log collection tool (promtail/alloy, etc).  



## Enhancements (TODO)

* [ ] Log all external access attempts to a file (inside the jail).

  E.g., when a user tries to connect to an external host from within the jump server.  
  ```bash
  logfile="/var/log/bastion_access.log"
  echo "$(date): User input '$INPUT'" >> "$logfile"
  ```
    - To keep it inside the jail, mount `/dev/log` and use `logger` with `rsyslog`.
        - `man logger`
        - `man rsyslog`

* [ ] Set up fail2ban for jumpserver.

* [ ] Support multiple destinations
    * [ ] Read from an SSH config file for destinations. Dynamically generate prompt for user
          based on that.
        - Parse `~/.ssh/config` file and print out shortnames? Hostnames? User@Hostname?

* Add more defense-in-depth
    * [ ] `Seccomp` or `AppArmor`/`SELinux`: You could optionally add AppArmor/SELinux 
      restrictions on the jailed shell or rbash.
    * [ ] `iptables`/`nftables` rule to restrict the jailed user to only be able to SSH out 
      to certain IPs (destination hosts).
    * [ ] Read-only bind mounts for even more restricted jail environments (advanced).
      ```bash
      # Example
      mount --bind /bin /var/chroot/bin
      mount -o remount,bind,ro /bin /var/chroot/bin
      mount -o remount,bind,ro,nosuid,nodev,noexec /bin /var/chroot/bin
      ```
        - Combine with `nosuid`, `nodev`, and `noexec` for even more lockdown:
          ```bash
          mount --bind /bin /var/chroot/bin
          mount -o remount,bind,ro,nosuid,nodev,noexec /bin /var/chroot/bin
          ```

* [ ] Copy over `~/.ssh/config` file to give access to all local inventory's
  hostnames, IPs, etc.  
    - Run script from host user environment?

* [ ] Make jail setup script idempotent

    * [x] Before copying libraries and binaries, check stat on the destination path and skip 
      if already present.

    * [ ] Use `install -Dm755` for cleaner binary copying with permission setting in one go.

* [ ] Automate the whole setup with Ansible (great for portfolio).
    - Create ansible role for this.  

---

* Testing coverage ideas

    * [ ] SSH login succeeds and shows menu
    * [ ] Restricted to menu options (try to run commands like `ls`, `cd /`, `echo`)
    * [ ] User cannot escape the chroot via symlinks, process manipulation, or `scp`
    * [ ] Confirm logs or alerts on each access (build a log watcher or Promtail integration)


## Future Improvements

- Parse an ansible inventory file for SSH destinations 
- Use `readonly bind` mounts instead of copying binaries/libraries
- Add support for logging user actions to a central Loki+Promtail/Alloy instance
- Implement per-user logging and session auditing
- Add MFA or TOTP-based verification on top of password login
- Add AppArmor or Seccomp profile to further restrict jailed shell behavior
- Replace `rbash` with a minimal statically compiled Go binary as a shell

| Feature                        | Why                                               
| ------------------------------ | --------------------------------------------------
| **Parse Ansible inventory**    | Makes system infrastructure-aware and dynamic 
| **Readonly bind mounts**       | Improves maintainability and reduces duplication  
| **Centralized logging (Loki)** | Integrates with modern observability stacks       
| **Per-user auditing**          | Helps in compliance or intrusion forensics        
| **MFA/TOTP**                   | Hardens authentication beyond passwords           
| **AppArmor/Seccomp**           | OS-level sandboxing against syscall abuse         
| **Go binary shell**            | More portable, smaller attack surface than `rbash`


## Resources
- []()
- [ProLUG Chroot Jail Killercoda Lab](https://killercoda.com/het-tanis/course/Linux-Labs/204-building-a-chroot-jail)
- [ProLUG Bastion Host Killercoda Lab](https://killercoda.com/het-tanis/course/Linux-Labs/210-building-a-bastion-host)
    * [gh](https://github.com/het-tanis/prolug-labs/tree/main/Linux-Labs/210-building-a-bastion-host)



