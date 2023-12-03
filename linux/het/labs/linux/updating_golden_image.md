
# Updating a Golden Image  

## Scenario  

Your Server team has a golden image that it uses to deploy new servers.  
There is a security requirement to not introduce old vulnerabilities into the environment when deploying new servers.  
Your task is to update the image to the newest software packages.  
This process happens quarterly in your environment.  
The server has been started and you need to update the software before repackaging server back into an image.  

* Verify when the system was last patched.  

* Check if the system needs to reboot.  

* See if the system has any patches that are ready to deploy.  

* Look to see if there are any ssl packages that need to be updated.  









Use this block of code to see if today's date shows up in the patch log  
ubuntu $ grep $(date +%F) /var/log/apt/history.log  




ubuntu $ ls -l /var/run/reboot-required  
-rw-r--r-- 1 root root 32 Nov 14 10:30 /var/run/reboot-required  
ubuntu $ 


---  

1.Verify when the system was last patched.  

```bash  
cat /var/log/apt/history.log  
```
* would have been in this log  


1. When was this system last patched? Can you verify it wasn't today?  
Use this block of code to see if today's date shows up in the patch log  

```bash  
grep $(date +%F) /var/log/apt/history.log  
```

1. Check if the system thinks it needs to be restarted.  
```bash  
ls -l /var/run/reboot-required  
```
* If that exists the system thinks it needs to be restarted.  


1. Check what packages are the cause of the system wanting to reboot.  
```bash  
cat /var/run/reboot-required.pkgs  
```

1. Install a command that will help you determine when the system wants to reboot.  
    * This is useful in enterprise environments so that you can see how your 
      servers view their libraries and kernel states.  
```bash  
apt install -y needrestart  
```

1. Check if your system needs to be restarted.  
```bash  
needrestart -l  
```

1. Check if the system has anything ready to update.  
```bash  
apt update  
```

1. This checked the metadata of your packages and saw if there are any upgradable packages.  
   How many packages were upgradable?  
    * Check which packages are upgradable.  
```bash  
apt list --upgradable  
```

1. Check if there are any ssl packages that need to be updated?  
```bash  
apt list --upgradable | grep -i ssl  
```

Do you see any packages with ssl that need to be upgraded?  

---  

## Part 2: Upgrading  

You've checked the curent state of the system.  
Now it's time to upgrade everything.  

Upgrade your system.  

See what packages were upgraded.  

Verify that your system needs to restart and see if there is a newer kernel than what is running.  


1. Upgrade your system  
```bash  
time apt upgrade -y  
```

1. Approximately how long did it take for your system to upgrade?  
    * Check the apt log to see the packages that were upgraded on your system today.  
```bash  
cat /var/log/apt/history.log  
```

* Why are some items installed, and others only upgraded?  
    * This may require you to go on an internet safari to find a good answer.  

1. Check if the system wants to boot to a new kernel or not  
```bash  
needrestart -k  
```

1. So the kernel that we're currently running is not the most current (newly installed) kernel that exists on the system.  
    * How can we also verify that?  
```bash  
uname -r   #shows the current kernel  
ls /boot   #shows the installed kernels  
grep vmlinuz /boot/grub/grub.cfg  
```

So you need to think about why the `grub.cfg` menu has the new version 
and old (current) version of the kernel in there.  

This is because we always install a kernel and can fall back in the 
unlikely condition of a crash when the new kernel comes up.  

---  

We've recently chosen to remove all containerd software to prevent our developers from launching random containers anywhere in our environment.  
We have also had to remove bzip because it is an obsolete software package that gzip completely supersedes.  

* Verify that containerd is on the system and running.  

* Verify that bzip is on the system.  

* Remove the packages that should not be there and then verify they are gone.  


1. Check for containerd, if it is installed and running on your system.  
```bash
ss -ntulp | grep -i container  
systemctl status containerd --no-pager  
```
* Is it there, and is it running?  

1. Check for bzip on your system.  
```bash
dpkg -l | grep -i bzip2
which bzip2
```
* Is bzip2 installed on your system?
    * Can you find the executible?  
That `bzip` is inferior to `gzip`.


1. Remove the unwanted packages  
```bash
apt -y remove bzip2 containerd  
```

1. Verify that nothing is running or installed on your system
   that doesn't meet your system requirements.  
```bash
ss -ntulp | grep -i container  
systemctl status containerd --no-pager  

dpkg -l | grep -i bzip2
which bzip2
```
If these are removed, you've cleaned up your system to meet the new requirements.  

---  





# Golden Image  

## What is a Golden Image?  

* It's patched and has all or most of your configs on it.  
* You'd typically remove netcat, curl, and other stuff that bad 
  guys use post intrusion that none of your applications need.  

* System that we use to deploy all other system files  

* Hardened to security standards (come from governeance risk and compliance team (GRC Team))  
* PCI payment card industry  
* local/national statelaws  

- All default passwords changed (PCI-DSS)  
    * All default accounts either disabled or removed if not used  
- Benchmarks (CIS, STIG, OpenSCAP, )  
- Software  
    * Updated/patched  
    * only there if needed  
    * only running if needed  
    * HIDS (Host Intrustion Detection System) (sees)  
        * Good logging systems  
            * loki  
            * syslog running  
    * HIPS (Host Intrustion Prevention System) (does)  
        * Tripwire  
        * Fail2ban  
            * Every HIPS system in *monitor mode* is effectively a HIDS
    * Host level Firewalls (on)  
    * Connection cannot happen by root  
        * Inside our /etc/ssh/sshd_config - no root allowed  

A golden image is a system that is **hardened** to all those standards.  
"Hardened" and "Golden" can pretty much be used interchangably.  

---  
### Ports that can be attacked:  
0 - 54434  
Against TCP or UDP  
---  

If the Firewall doesn't allow it (access through the port), **the port is not compromised if someone opens a port**.
It's still a problem, but it's not something that can be exploited

Mitigating Controls: Physical, Technical, Administrative 





```bash  
for server in `cat /etc/hosts | grep -i prod-k8s | awk '{print $NF}'`; do echo "I am checking $server"; ssh $server 'uptime; uname -r'; done  
```



It's patched and has all or most of your configs on it  
Remove netcat, curl, stuff bad guys use post intrusion that none of your applications need  


Solving the Bottom Turtle  
SPIFFE-SPIRE book  

Bastion System  
prolug.asuscomm.com  

