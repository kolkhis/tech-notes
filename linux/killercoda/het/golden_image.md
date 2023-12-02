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

If the Firewall doesn't allow access through the port, **the port is not compromised if someone opens it**.  
It's still a problem, but it's not something that can be exploited.  

Mitigating Controls: Physical, Technical, Administrative 

