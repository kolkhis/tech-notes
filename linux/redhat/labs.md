# RHCSA Practice Labs

These are a collection of labs that will cover essential RHCSA study points.

Doing these labs will be a great way to get hands-on with the tools we'll be
using in the RHCSA exam.  



## Configuring Apache Webserver SELinux Contexts

The lab scenario is as follows.  

### Scenario

Your company wants Apache configured with the following requirements:
- Apache must listen on TCP port `8081`.
- Website files must be stored under `/srv/rhcsa-web`.
- The website must display:
  ```plaintext
  RHCSA SELinux Lab
  ```
- `/srv/rhcsa-web/uploads` must be writable by Apache.
- Remote clients must be able to access port `8081`.
- SELinux must remain enforcing.
- Everything must persist across a reboot.

Do not solve SELinux problems by:
- Disabling SELinux
- Leaving SELinux permissive
- Using chcon as the permanent solution
- Generating a custom policy with audit2allow

Use SELinux the correct way. Set contexts and booleans properly. This will
help to gain a deeper understanding of Apache and SELinux.  




