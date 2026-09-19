# RHCSA Practice Labs

These are a collection of labs that will cover essential RHCSA study points.

Doing these labs will be a great way to get hands-on with the tools we'll be
using in the RHCSA exam.  

!!! warning "Snapshots"

    It is highly recommended to take a snapshot of your VM before starting any of 
    these labs.  
    This will allow you to revert back to a clean state if you make a mistake.


## Configuring Apache Webserver && SELinux Contexts

This lab will have us set up and configure an Apache web server on a
non-standard port, use a non-standard directory for web site files, and 
configure SELinux to make the Apache config work, as well as allow remote 
access. 


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

Do **not** solve SELinux problems by:
- Disabling SELinux
- Leaving SELinux permissive
- Using `chcon` as the permanent solution
- Generating a custom policy with `audit2allow`

Use SELinux the correct way. Set contexts and booleans properly. This will
help to gain a deeper understanding of Apache and SELinux (and will be expected
on the RHCSA exam).  

---

It's highly recommended to attempt the lab before looking at the solution.  

??? warning "Solution"

    - Ensure the necessary packages are installed.  
      ```bash
      sudo dnf install -y httpd curl policycoreutils-python-utils
      ```

    - Create the custom document root.  
      ```bash
      sudo mkdir -p /srv/rhcsa-web/uploads
      sudo chmod 0755 /srv/rhcsa-web
      ```

    - Create the web page that will be served.  
      ```bash
      sudo vi /srv/rhcsa-web/index.html
      ```
      Add the following text to that file.  
      ```plaintext
      RHCSA SELinux Lab
      ```

    - Set the ordinary Linux permissions on the file.  
      ```bash
      sudo chmod 0644 /srv/rhcsa-web/index.html
      ```

    - Create the Apache configuration file.  
      ```bash
      sudo vi /etc/httpd/conf.d/rhcsa-lab.conf
      ```
      The config file should be as follows.  
      ```xml
      Listen 8081

      <VirtualHost *:8081>
          ServerName rhel-node1
          DocumentRoot "/srv/rhcsa-web"

          <Directory "/srv/rhcsa-web">
              AllowOverride None
              Require all granted
          </Directory>

          ErrorLog logs/rhcsa-lab-error.log
          CustomLog logs/rhcsa-lab-error.log combined
      </VirtualHost>
      ```
    - Check the syntax of the Apache webserver config.  
      ```bash
      apachectl configtest
      ```
      Look for `Syntax OK`.  

    Now Apache is set up to serve the custom document root on port 8081.  
    The next steps will require setting SELinux contexts on the new document
    root directory, enabling a specific SELinux boolean, and allowing access
    through Firewalld.  


