# SSH Commands

SSH commands for managing the OpenSSH server  
This is intended for Linux with `systemd`, specifically Ubuntu Server.


## Table of Contents
* [Restarting the SSH Service](#restarting-the-ssh-service) 
* [Stopping the SSH Service](#stopping-the-ssh-service) 
* [View SSH Status and Current State](#view-ssh-status-and-current-state) 
* [Enable SSH to Start on Boot](#enable-ssh-to-start-on-boot) 
* [Disable SSH From Starting on Boot](#disable-ssh-from-starting-on-boot) 
* [Managing Authentication Methods for SSH](#managing-authentication-methods-for-ssh) 
    * [Applying Changes to `sshd_config`](#applying-changes-to-`sshd_config`) 


## Restarting the SSH Service 

SSH needs to be restarted after any changes to `/etc/ssh/sshd_config`.  
Restart SSH with `systemd` with the command:

```bash
sudo systemctl restart sshd
```

SSH can also be restarted using `System V. Init` scripts:
```bash
sudo /etc/init.d/ssh restart
```



## Stopping the SSH Service
SSH can be stopped with `service`:
```bash
sudo service ssh stop
```


## View SSH Status and Current State
You can view the current status of SSH with `systemd`:
```bash
sudo systemctl status ssh
```
This will output the current status of SSH, including:
* Loaded
* Active
* Docs (man pages)
* Process 
* Main PID (the process ID)
* Tasks
* Cgroup






## Enable SSH to Start on Boot
If you want the SSH service to start up when the system boots, and it does not do this by default, 
this behavior can be enabled.  
To enable this, start the SSH service using `systemd`:

```bash
sudo systemctl enable ssh
```

The output should look something like this:

```plaintext
Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable ssh
Created symlink /etc/systemd/system/sshd.service → /lib/systemd/system/ssh.service.
Created symlink /etc/systemd/system/multi-user.target.wants/ssh.service → /lib/systemd/system/ssh.se
```


## Disable SSH From Starting on Boot
If you **don't** want the SSH service to start up when the system boots, this behavior
can be disabled.

```bash
sudo systemctl disable ssh
```

The output should look something like this:
```plaintext
Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install disable ssh
Removed /etc/systemd/system/multi-user.target.wants/ssh.service.
Removed /etc/systemd/system/sshd.service.
```




## Managing Authentication Methods for SSH
##### Also see [hardening_ssh](./hardening_ssh.md)

To manage SSH authentication methods, we need edit the server's SSH configuration 
file, which is located at `/etc/ssh/sshd_config`.  

* Open `/etc/ssh/sshd_config` as root (`sudo`):
    ```bash
    sudo vi /etc/ssh/sshd_config
    ```
    * `sudo` is required. This file requires root access to write to.

There are a number of settings here, most of them are in there by default (mostly
commented out).  

* `PermitRootLogin`: This decides whether or not to allow direct root logins via SSH.
    * It's generally unsafe to have this enabled.  
    * Uncomment it and change to `no`:
      ```sh
      PermitRootLogin no
      ```
    * This will prevent the root user from logging in via SSH.  

* `PasswordAuthentication`: Decides whether or not to allow SSH logins with passwords. 
    * Disable this if you want key-based authentication only:  
      ```sh
      PasswordAuthentication no
      ```
    * This will disable password authentication.  

* `AuthorizedKeysFile`: Where SSH will look for key-based authentication.  
    * It should look like this:
      ```bash
      AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2
      ```
    * You can add more files to the list if you want to. 


* `AuthenticationMethods`: The methods of authentication that are accepted.  
    * For key-based authentication, you'll want this set to `publickey`: 
      ```sh
      AuthenticationMethods publickey
      ```
    - We can also specify multiple authentication methods to allow, using a
      space-delimited list.  
      ```bash
      AuthenticationMethods publickey password
      ```
      This will allow both public key auth and password auth.  

    - We can even require further authentication by requiring public key
      authentication ***and*** password authentication.  
      ```bash
      AuthenticationMethods publickey,password
      ```
      This will require public key auth, **and** password auth.  
      This must be a comma-delimited list of accepted authentication methods.  

    - The above methods can be combined to allow different types of auth.  
      ```bash
      AuthenticationMethods publickey,password keyboard-interactive
      ```
      This will require both public key authentication and a password, ***or*** just
      keyboard-interactive authentication.  

    - Available options for AuthenticationMethods:
        - `password`
        - `publickey`
        - `keyboard-interactive`
        - `none` (used for accounts without passwords when `PermitEmptyPasswords` is enabled)
        - `hostbased`
        - `gssapi-with-mic`

### Applying Changes to `sshd_config`

Reload any changes to SSH with `systemctl`:
```sh
sudo systemctl restart ssh
```



## AllowGroups / DenyGroups

We can configure `AllowGroups` to work with local **and** remote groups (e.g., groups
through Active Directory).  

```bash
sudo vi /etc/ssh/sshd_config
```

Then add a line that matches the group name.  
```bash
AllowGroups ssh_users
```

Adding this will only allow users in the `ssh_users` group (local or from AD) to SSH
in. All other users will be rejected.  


You can also specify multiple group names on the same line.  
```bash
AllowGroups ssh_users admins ops_team
```
If you need to explicitly block users from certain groups, use the `DenyGroups`
directive.  
```bash
DenyGroups blocked_users
```

> **NOTE**: Any user part of a group in `DenyGroups` will **always**  be blocked,
> regardless of whether or not they're in a group specified in `AllowGroup`.  

You can also use `Match` blocks with group names to set rules for these groups.  
```bash
Match Group ssh_users
    PasswordAuthentication no
    PubkeyAuthentication yes
```

---

Side note: If filtering out users through AD, you can also filter out unwanted users
through `/etc/sssd/sssd.conf`.  
```ini
[domain/YOUR.DOMAIN]
access_provider = simple
simple_allow_groups = ssh_users
```
Or:
```ini
[domain/YOUR.DOMAIN]
access_provider = ldap
ldap_access_filter = (memberOf=cn=ssh_users,ou=Groups,dc=your,dc=domain)
```

## Remapping Port on SELinux

If you happen to change the `Port` option in your `sshd_config` file, and the
system has SELinux enabled, you will need to add the port to the SELinux 
context.  

You will likely also need to add a firewall rule.  

If you changed the port to `2222` on a server with SELinux:
```bash
perl -pi -e 's/^#?(Port )\d+/$1 2222/' /etc/ssh/sshd_config # or edit with vi
systemctl restart sshd
```

You'll need the `semanage` tool to add the port to SELinux. This is provided by 
the `policycoreutils-python-utils` package.  

```bash
dnf install -y policycoreutils-python-utils  # Install the semanage util
semanage port -a -t ssh_port_t -p tcp 2222   # Add port 2222 as SSH port
systemctl restart sshd
```

To add the port to firewalld:
```bash
firewall-cmd --permanent --add-port 2222 # Make it persistent
firewall-cmd --reload
```

## Setting a Chroot Directory

The `ChrootDirectory` option for `sshd_config` allows us to effectively jail
users.  

This option takes a pathname of a directory to `chroot` to after the user
successfully authenticates.  

This `ChrootDirectory` needs to contain all the necessary files and directories
to support a user's SSH session.  
For an interactive session, this requires:

- A shell of some sort.  
- Basic `/dev` nodes:
    - `/dev/null`
    - `/dev/zero`
    - `/dev/stdin`
    - `/dev/stdout`
    - `/dev/stderr`
    - TTY devices
    - Some programs that are put into the `chroot` directory may require some other 
      special files (e.g., `/dev/random`, `/dev/urandom`, etc.).  


