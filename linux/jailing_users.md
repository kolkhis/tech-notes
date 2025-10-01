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
ssh user1@remote-host
# then, immediately:
chroot /var/chroot_user1
```

## Setting up the Chroot Directory
Inside `/var/chroot`, you can specify a set of binaries that a user has access to.  
For a jump box, a minimal `/bin` directory with just a couple tools is needed:

- `bash`
- `ssh`
- `curl`  

Optionally, a bash script to use a the user's shell.  

The binaries given must also have their linked libraries and some special character
devices in order to function. If the jail needs network functionality, the Name
Switch Service (NSS) files must also be present in the chroot environment.    


```bash
ldd /bin/bash  # Show linked libraries for bash
```

More info on this in [how to build a chroot jail](#how-to-build-a-chroot-jail).  

## Setting Login Shell as a Script
You can specify a bash script as a user's shell in `/etc/passwd`.  
The format for lines in this file:
```plaintext
username:password:UID:GID:GECOS:home_directory:shell  
```
Where `shell` is you can put the name of a script that the user has access to.  

## Jailed Programs
When jailing processes (or users), you need to make sure that any program you give it has the
necessary libraries (its dependencies).  
If you're trying to create a jail that has `bash`, you need to make sure that bash's
dependencies are there.  
```bash
ldd /bin/bash
```
This will show the libraries that `bash` depends on in order to run.  

## How to Build a Chroot Jail

### Setting up the Jailed User Account

- Connect to the host that will have the jail and create the user.  
  ```bash
  # SSH to the machine that the chroot environment will exist on
  ssh chroot_box
  
  # Create a new user to be jailed
  useradd -m jaileduser
  
  # Set the password for the new user
  printf "somepassword\nsomepassword\n" | passwd jaileduser
  ```

- Edit `sshd_config`
  ```bash
  sudo vi /etc/ssh/sshd_config
  ```
  
  Add the lines:
  ```bash
  Match User jaileduser
  ChrootDirectory /var/chroot
  ```


- Then restart the SSH service.  
  ```bash
  systemctl restart ssh
  ```

- Add a custom script to use as the user's shell.  

  An example `bastion.sh`:  
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

    - Set this aside for after you set up the chroot jail. You'll need to copy it in later.  

- Then change the `jaileduser` shell in `/etc/passwd`.  
  ```bash
  jaileduser:x:1001:1001::/home/jaileduser:/bin/sh
  # change to:
  jaileduser:x:1001:1001::/home/jaileduser:/bin/bastion.sh
  ```

### Setting up the Chroot Jail
This should be done after the jailed user account has been created and configured in
`/etc/ssh/sshd_config`.  

1. Create the chroot filesystem
  ```bash
  mkdir /var/chroot
  ```

2. Create the directory structure inside the jail.  
  ```bash
  mkdir -p /var/chroot/{bin,lib64,dev,etc,home,usr/bin,lib/x86_64-linux-gnu}
  ls -l /var/chroot
  ```

3. Move the minimum executables for chroot to work properly.  
  ```bash
  cp /usr/bin/bash /var/chroot/bin/bash
  ```

4. Copy the link libraries that the executables need (bash shell functionality)
  ```bash
  for pkg in $(ldd /bin/bash | awk '{print $(NF -1)}'); do 
      cp $pkg /var/chroot$pkg
  done
  ```

5. You'll need some critical system files in your chroot environment.  
   ```bash
   cp /etc/{passwd,group,nsswitch.conf,hosts} /var/chroot/etc
   ```
   This copies over the files you need in the `/etc` directory.  

6. You'll need some character special files in your chroot jail for everything
   to work properly.  
   ```bash
   mknod -m 666 "/var/chroot/dev/null" c 1 3
   mknod -m 666 "/var/chroot/dev/tty" c 5 0
   mknod -m 666 "/var/chroot/dev/zero" c 1 5
   mknod -m 666 "/var/chroot/dev/random" c 1 8 
   mknod -m 666 "/var/chroot/dev/urandom" c 1 9
   ```
    - SSH requires the file(s) `/dev/random` and `/dev/urandom`.  
    - If the jailed process needs SSH, make sure these are available.  


7. You also need your name switch service files for network functionality.  
   ```bash
   cp -r /lib/x86_64-linux-gnu/*nss* /var/chroot/lib/x86_64-linux-gnu/
   ```

8. Copy over `bastion.sh` (created in [Setting up the Jailed User Account](#setting-up-the-jailed-user-account)):  
   ```bash
   cp /path/to/bastion.sh /var/chroot/bin/bastion.sh
   ```

8. Test the chroot jail.  
   ```bash
   echo $$  # Check your current shell's PID
   chroot /var/chroot
   echo $$  # Check again
   ```
   Test by using commands that you haven't added to the jail, and commands that you have.  




## Example: Jail users with a Script

You can specify a script as a user's login shell, rather than `/bin/bash`.  
You can run a script when a user logs in, and then shut them down if they don't type
something in a certain amount of time.  

Ex:
```bash
#!/bin/bash
read -r -p "Type where you want to go: " -t 5 RESPONSE
if [[ -z $RESPONSE ]]; then
    printf "Goodbye!\n"
else
    printf "Travelling to %s\n" "${RESPONSE}"
fi
```

* `read -r -p "Type where you want to go: " -t 5 RESPONSE`:
    - `-r` Sanitizes input - doesn't allow escaped chars.  
    - `-p "Type where you want to go:`: The prompt that the user will see.  
    - `-t 5`: Timeout after 5 seconds.  
    - `RESPONSE`: Save the user's input into a variable with this name.  

## Using an `rbash` Jail
The `rbash` (restricted bash) shell can be used to put very restrictive limits on
what a user can and cannot do in a system.  

It is a limited shell where users can't change directories, run certain
commands, or modify environment variables.  
It also doesn't allow the user to run any commands with slashes (e.g., `/usr/bin/id`).  

- Set a user's shell to `rbash` in `/etc/passwd` or with `chsh`:
  ```bash
  chsh -s /bin/rbash username # change a user's shell to rbash
  sed -i '/username/s,/bin/sh,/bin/rbash,' /etc/passwd
  ```

- Then create a safe directory of allowed commands.
  ```bash
  mkdir /home/username/bin
  ln -s /bin/ls /home/username/bin/
  ln -s /bin/cat /home/username/bin/
  ```

- You can then restrict the `PATH` and lock them in.  
  ```bash
  printf 'PATH=$HOME/bin' >> /home/username/.bash_profile
  chmod 755 /home/username
  chown username:username /home/username/.bash_profile
  ```
  Then the user is jailed to their home dir and is only able to run the
  commands in `$HOME/bin`.  

## Resources
* [Chroot Jail ProLUG Lab](https://killercoda.com/het-tanis/course/Linux-Labs/204-building-a-chroot-jail)


---

## Other Jailing Techniques in Linux

| Method  | Description  | Use Cases
| -- | --- | --------
| `chroot`                 | Restricts process to a directory as new `/`. Basic and easy, but bypassable if root.          | Old-school isolation, single app sandbox
| Namespaces             | Kernel feature to isolate resources: PID, NET, MNT, UTS, IPC, USER, TIME. Used by containers. | Process-level isolation (e.g. for containers or seccomp sandboxes)
| Cgroups                | Control resource usage (CPU, RAM, IO, etc.) of processes. Works with namespaces.              | Resource-limiting, DoS protection
| Seccomp                | Blocks syscalls from being used by a process. Can whitelist or blacklist syscalls.            | Reduces attack surface; used by Docker, systemd
| AppArmor / SELinux     | Mandatory Access Control (MAC) — defines what a process *can* access, even as root.            | Policy-driven hardening of services
| `unshare` / `nsenter`  | CLI tools to launch processes in new namespaces manually.                                     | Lightweight container-like jails
| `bwrap` (bubblewrap)       | Sandboxing tool used by Flatpak; combines namespaces + mounts + tmpfs                         | Desktop and service sandboxing
| `systemd-nspawn`           | `systemd`-native lightweight container runtime using chroot + namespaces                        | Service testing, network/service isolation
| Container Jails (Docker/Podman) | Full-featured OCI containerization, combining namespaces, cgroups, overlayfs, etc.            | Microservices, app isolation, ephemeral environments

---

### Other Jailing Method Examples

#### Manual Namespace Jail with `unshare`

```bash
sudo unshare --mount --uts --ipc --net --pid --fork /bin/bash
```

This puts you in a new shell with:

* An isolated process tree
* A new hostname
* An empty mount table
* No network

You’re now in a basic jail, isolated from the rest of the system.

---

#### Using `bwrap` (Bubblewrap) for Jailing

```bash
bwrap --ro-bind /usr /usr --ro-bind /bin /bin \
      --dev /dev --proc /proc --tmpfs /tmp \
      /bin/bash
```

* Filesystem is isolated
* No network unless explicitly added
* You can't escape the jail without privilege escalation

Used by `Flatpak` and some sandboxed tools like `firejail`.

---

#### Restricting Syscalls with `seccomp`
###### <https://www.man7.org/linux/man-pages/man2/seccomp.2.html>

Seccomp - Secure Computing.  

The Linux kernel has `seccomp`, which allows a process to make a one-way transition
into a "secure" state where it can only make a few syscalls:

- `exit()`
- `sigreturn()`
- `read()` and `write()` to file descriptors that are **already open**.  

Seccomp is harder to use directly, but Docker or Podman support it out-of-the-box:

```bash
podman run --rm --security-opt seccomp=./custom-seccomp.json alpine
```

Your `custom-seccomp.json` can block dangerous syscalls like `ptrace`, `mount`, or `keyctl`.

---

### Combining Tools

For truly hardened jails:

* Use `namespaces + cgroups + seccomp + AppArmor/SELinux`.  
* Add **immutable configs** (`chattr +i`) to prevent changes.  
* Monitor processes with `auditd`, `ps`, and logs.  

---


