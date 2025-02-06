# Jailing Users in Linux (SSH)

When a user enters your system via SSH, you may not want them to have full access to
everything.  

## Table of Contents
* [sshd_config](#sshd_config) 
* [Setting up the Chroot Directory](#setting-up-the-chroot-directory) 
* [Setting Login Shell as a Script](#setting-login-shell-as-a-script) 
* [Jailed Programs](#jailed-programs) 
* [How to Build a Chroot Jail](#how-to-build-a-chroot-jail) 
    * [Setting up the Chroot Jail](#setting-up-the-chroot-jail) 
    * [Populating the Jail](#populating-the-jail) 
* [Example: Jail users with a Script](#example-jail-users-with-a-script) 

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

## Jailed Programs
When jailing processes (or users), you need to make sure that any program you give it has the
necessary libraries (its dependencies).  
If you're trying to create a jail that has `bash`, you need to make sure that bash's
dependencies are there.  
```bash
ldd /bin/bash
```
This will show the libraries that bash depends on in order to run.  


## How to Build a Chroot Jail
### Setting up the Chroot Jail
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
      cp $pkg /var/chroot/$pkg
  done
  ```

5. Test the chroot jail.  
  ```bash
  echo $$  # Check your current shell's PID
  chroot /var/chroot
  echo $$  # Check again
  ```
  Test by using commands that you haven't added to the jail, and commands that you have.  

### Populating the Jail
Add in the system files needed for user functionality, the binaries (`curl`, `ssh`, etc.) alone with their dependent link libraries.  

```bash
for file in {passwd,group,nsswitch.conf,hosts}; do
    printf "Copying File: %s\n" "$file"
    cp /etc/$file /var/chroot/etc/$file
done
```

* SSH requires the file(s) `/dev/random`/`/dev/urandom`.  
    * If the jailed process needs SSH, make sure these are available.  


## Example: Jail users with a Script

You can specify a script as a user's login shell, rather than /bin/bash.  
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
    - `-p "Type where yo uwant to go:`: The prompt that the user will see.  
    - `-t 5`: Timeout after 5 seconds.  
    - `RESPONSE`: Save the user's input into a variable with this name.  

## Resources
* [Chroot Jail ProLUG Lab](https://killercoda.com/het-tanis/course/Linux-Labs/204-building-a-chroot-jail)

