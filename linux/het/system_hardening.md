
# System Hardening and the Golden Image  

## DMZ - Demilitarized Zone  
This is where incoming traffic should go first.  
* Allowed to be hit from the outside.  
* It's in a zone that's not as trusted as systems on the network.  

Outside traffic can go in through the DMZ. 
It sits there and things can go into the system through
bastions (e.g., web servers, bastion hosts).  


## /etc/passwd  
All the user names that have `/sbin/nologin` in `etc/passwd` aren't allowed 
into the system.  
The usernames that have `/bin/bash` are allowed users.  
* This is one of the simplest ways to turn off accounts.  
* It has eliminated an attack vector.  
* If a user keeps trying to get in, it can get locked out.  
    * This is not usually true for `root`.  
    * In "Trusted Solaris", even root can get locked out.  

With SSH, you can enable:  
* Certificate based login  
* Key-based login  
This will disable SSH access for anyone who doesn't have a private key  
to match one of the public keys in an `authorized_keys` file (e.g., `~/.ssh/authorized_keys`).  


## SSH Config Files  
There are two config files, one for outbound connections, and one for inbound connections.  
* `/etc/ssh`: Outgoing connections  
* `/etc/sshd`: Incoming connections  

Sudo attempts: su - user  
* `sudo su -`: Will show failed login attempts as root.  

## Verbose SSHing: See what is happening behind the scenes  
You can add up to 3 `v`'s to SSH for different verbosity levels.  
```bash  
ssh -vvv  
```



## Lock down keys properly  
* `NIST 800-57` - Recommendation for [key management](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final)  


## Rules of thumb  
* Remove user accounts that don't belong  
* All default passwords changed (PCI-DSS)  
* All default accounts either disabled or removed if not used  
* Benchmarks (CIS, STIG, OpenSCAP, )  
* Software: 
    * Patch the most current version.  
    * Keep it updated/patched.  
    * Should only be there if it's needed  
    * Should only be running if it's needed  
* HIDS (Host Intrustion Detection System) (The See-er)  
    * Good logging systems  
        * Loki  
        * syslog running  
* HIPS (Host Intrustion Prevention System) (The Do-er)  
    * Tripwire  
    * Fail2ban  
        * Every HIPS system in *monitor mode* is effectively a HIDS  
    * Host level Firewalls (on)  
    * Connection cannot happen by root  
        * Inside our `/etc/ssh/sshd_config` - enable "no root allowed"  

Software should only be there if you need it.  

## CIS Benchmarks  
CIS benchmarks are the industry standard for system hardening.  
Some examples of benchmarks:  
* Filesystem Types:  
    * `cramfs` <- CIS Benchmark 1.1.1.1 - Ensure mounting of cramfs filesystems is 
      disabled (Automated). 
    * `squashfs`: Mounting things as a stateless images  
* The `/tmp` directory:  
    * 1.1.2.1 Make Sure `/tmp` is on its own partition, and no exec  
    * 1.1.2.3 Make Sure `noexec` option is set on `/tmp` partition  

CIS Ubuntu Benchmarks  
* Scored  
* Unscored  



An ansible playbook can go through and check for these things.  

Start with what's visible/vulnerable  

In the event that you're not allowed to login as root, with ansible  
you can go in as a normal user and escalate privs.  

## Simple Network Checks  
You have a set number of ports that are open: 0-65534.  
```bash  
netstat -ntulp  
```
Ideally, you should be able to explain what each of these is doing.  
```bash  
netstat -tulp  
```
This shows the names of the ports.  
* 53 for DNS  
* 22 for SSH  
* etc...  





pam_  
portable auth module  


