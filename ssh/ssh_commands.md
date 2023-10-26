

#  SSH Commands


SSH commands for managing the OpenSSH server  
This is intended for Linux with `systemd`, specifically Ubuntu Server.




##  Restarting the SSH Service 

SSH needs to be restarted after any changes to `/etc/ssh/sshd_config`.  
Restart SSH with `systemd` with the command:

```bash
sudo systemctl restart sshd
```  

SSH can also be restarted using `System V. Init` scripts:
```bash
sudo /etc/init.d/ssh restart
```



##  Stopping the SSH Service

SSH can be stopped with `service`:
```bash
sudo service ssh stop
```


##  View SSH Status and Current State
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






##  Enable SSH to Start on Boot
If you want the SSH service to start up when the system boots, and it does not do this by default, 
this behavior can be enabled.  
To enable this, start the SSH service using `systemd`:

```bash
sudo systemctl enable ssh
```

The output should look something like this:

```output
Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable ssh
Created symlink /etc/systemd/system/sshd.service → /lib/systemd/system/ssh.service.
Created symlink /etc/systemd/system/multi-user.target.wants/ssh.service → /lib/systemd/system/ssh.se
```




##  Disable SSH From Starting on Boot
If you **don't** want the SSH service to start up when the system boots, this behavior
can be disabled.

```bash
sudo systemctl disable ssh
```

The output should look something like this:
```output
Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install disable ssh
Removed /etc/systemd/system/multi-user.target.wants/ssh.service.
Removed /etc/systemd/system/sshd.service.
```







