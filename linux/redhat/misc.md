## Misc. RedHat/RHEL Notes

A collection of miscellaneous notes and references for Red Hat Enterprise Linux (RHEL) and related topics.



## Enabling Repositories

When installing RHEL for the first time, RPM repository access will be
unavailable until the machine is registered under a license.  

A free developer license can be used to enable repositories.  

Confirm the running OS version and architecture. 
```bash
cat /etc/redhat-release
uname -m
```

Register the system using a RedHat account. This must be the same account
enrolled in the Red Hat Developer program.  
```bash
sudo subscription-manager register
```
Optionally, pass the username.  
```bash
sudo subscription-manager register --username 'you@email.com'
```
Check the subscription information.  
```bash
sudo subscription-manager identity
sudo subscription-manager status
sudo subscription-manager list --consumed
```

Check repositories.  
```bash
sudo subscription-manager repos --list-enabled
sudo dnf repolist
```



## Resources
Exam book for RHEL 9:
- RHCSA Red Hat Enterprise Linux 9: Training and Exam Preparation Guide (EX200) Third Edition
