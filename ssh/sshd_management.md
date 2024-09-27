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

### Applying Changes to `sshd_config`

Reload any changes to SSH with `systemctl`:
```sh
sudo systemctl restart ssh
```




