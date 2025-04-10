# STIG - Security Technical Implementation Guides

STIGs (Secure Technical Implementation Guides) are a set of security standards that 
come from DISA (the US Department of Information Systems Agency).  

STIGs are viewed with the STIG Viewer, which can be downloaded here: 
- STIG Viewer Downloads: <https://public.cyber.mil/stigs/srg-stig-tools/>
* STIG Downloads: <https://public.cyber.mil/stigs/downloads/>



## STIG Status
Each STIG needs to be assigned a status.  

By default, there are four states a STIG can be in:
- Not Reviewed: The STIG has not yet been reviewed. 
- Open: 
- Not Applicable: The STIG does not apply in the current environment.
- Not a Finding: The STIG has been completed.


## Security Controls
Every STIG can be categorized into a type of security control.  
The types of security controls are as follows:

* Categories:
    * Technical
    * Managerial
    * Operational
    * Physical
* Controls:
    * Preventative
    * Deterrent
    * Detective
    * Corrective
    * Compensating
    * Directive

## STIG Remediation Tools

There are STIG remediation tools that are available for download.  

To find downloads for remediation tools, go to the STIG [downloads page](https://public.cyber.mil/stigs/downloads/)
and search for `<distro> ansible` (i.e., `Red Hat Ansible`).  

Let's download one.  
```bash
cd /root
mkdir stigs
cd stigs
wget -O U_RHEL_9_V2R4_STIG_Ansible.zip https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_RHEL_9_V2R4_STIG_Ansible.zip
unzip U_RHEL_9_V2R4_STIG_Ansible.zip
mkdir ansible
cp rhel9STIG-ansible.zip ansible/
cd ansible
unzip rhel9STIG-ansible.zip
```
The `V2R4` is the version. If this doesn't work, try incrementing the version
(`V2R5`) since they apparently do not care about backwards compatibility or older
versions.  

### OpenSCAP Playbooks and Scripts
You can also use OpenSCAP to generate Ansible Playbooks and Bash scripts to remediate
STIGs.  


* Install the required tools:
  ```bash
  dnf install -y \
      openscap-scanner \
      openscap-utils \
      scap-security-guide
  ```

By using `oscap` with `xccdf` (the eXtensible Configuration Checklist Description
Format), you can generate fix scripts or playbooks.  

---

Generate some Ansible for RHEL 9:
```bash
oscap xccdf generate fix --profile ospp --fix-type ansible /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml > draft-disa-remediate.yml
# Examine the playbook
vim draft-disa-remediate.yml
```

Generate a bash script for RHEL 9:
```bash
oscap xccdf generate fix --profile ospp --fix-type bash /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml > draft-disa-remediate.sh
# Examine the script
vim draft-disa-remediate.sh
```



## Resources
- [HIPAA Security Safeguards](https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/index.html)
- [STIG Viewer Downloads](https://public.cyber.mil/stigs/srg-stig-tools/)
