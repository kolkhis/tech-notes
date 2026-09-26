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

??? warning "Solution Part 1: Setting up Apache"

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

??? warning "Solution Part 2: SELinux Configuration"

    - After Apache is set up, attempt to start it.  
      ```bash
      sudo systemctl enable --now httpd
      ```
      This will fail. SELinux doesn't normally permit `httpd_t` to bind to 
      port `8081`.  

    - Allow Apache to serve on port `8081` through SELinux.  
      ```bash
      semanage port -a -t http_port_t -p tcp 8081
      ```
        - `semanage port`: The tool used to manage port mappings for SELinux.  
        - `-a`: Add a new port mapping.  
        - `-t http_port_t`: Specify the type as `http_port_t` for this mapping.  
        - `-p tcp`: Specify the protocol as `tcp`.  
        - `8081`: The port to apply this rule to.  
        - **Side note**: This is actually an example in `man semanage-port`.
          Remember that for the exam.  

    - Set the proper contexts on the custom document root directory.  

        - Check the current contexts of the files and directories.  
          ```bash
          ls -alZ /srv/rhcsa-web
          # or, to just see the SELinux contexts
          ls -1aZ /srv/rhcsa-web
          ```
          They should be as follows:
          ```plaintext
          unconfined_u:object_r:var_t:s0 .
          system_u:object_r:var_t:s0 ..
          unconfined_u:object_r:var_t:s0 index.html
          ```

        - Check the default Apache files' contexts to see what needs to be changed.  
          ```bash
          ls -a1Z /var/www
          ```
          The directory itself:
          ```plaintext
          system_u:object_r:httpd_sys_content_t:s0 .
          system_u:object_r:var_t:s0 ..
          system_u:object_r:httpd_sys_script_exec_t:s0 cgi-bin
          system_u:object_r:httpd_sys_content_t:s0 html
          ```
          The `httpd_sys_content_t` type is needed for the Apache files.  

        - Add the context for the custom document root.  
          ```bash
          semanage fcontext -a -t httpd_sys_content_t "/srv/rhcsa-web.*"
          ```

        - Set the SELinux boolean to allow `httpd` connections remotely.  
          ```bash
          semanage boolean -m --on httpd_can_network_connect
          ```
            - `semanage boolean`: One of the tools that can modify SELinux booleans.  
            - `-m`: Modify an existing boolean.  
            - `--on`: Set the boolean to `on`.  
            - `httpd_can_network_connect`: The name of the boolean to modify.  
            - This can also be done with the other tools that SELinux provides
              to interact with booleans.  
              ```bash
              getsebool httpd_can_network_connect  # Show the current value
              setsebool -P httpd_can_network_connect
              ```
                - `-P`: Persists across reboots. This is the default behavior
                  when using `semanage boolean`.  





## Configuring Autofs/NFS

### Scenario

Your organization has an NFS server named:

- `nfs-server.lab.example.com`

It exports the directories:

- `/srv/nfs/projects`
- `/srv/nfs/users/alice`
- `/srv/nfs/users/bob`

Our lab had the following configurations:
- `rhel-node1`: NFS Server. - `192.168.4.75 nfs-server.lab.example.com nfs-server`
- `rhel-node2`: NFS Client - `192.168.4.20 node1.lab.example.com node1`

The `/etc/hosts` on both nodes were modified to include these lines.  

```bash
192.168.4.75 nfs-server.lab.example.com nfs-server
192.168.4.20 node1.lab.example.com node1
```

### Requirements

Configure the **client** so that:

- The projects share appears at `/shares/projects`.
- User directories appear dynamically under `/remotehome`.
- Accessing `/remotehome/alice` mounts Alice’s directory.
- Accessing `/remotehome/bob` mounts Bob’s directory.
- Mounts are read-only.
- Inactive mounts expire after 30 seconds.
- Configuration persists across reboots.
- No NFS entries are added to `/etc/fstab`.

---

### Task 1: Preflight checks

Determine whether:
- The NFS server resolves by name.
- The NFS server is reachable.
- Its exports are visible.
- The required client packages are installed.

---

### Task 2: Projects indirect map

Configure autofs so that accessing:
```bash
/shares/projects
```
mounts:
```bash
nfs-server.lab.example.com:/srv/nfs/projects
```

#### Requirements:
- Use an indirect map.
- Mount it read-only using NFSv4.
- Use a 30-second inactivity timeout.

---

### Task 3: Wildcard user map

Configure a wildcard map so that:
```bash
/remotehome/alice
```
mounts:
```bash
nfs-server.lab.example.com:/srv/nfs/users/alice
```
and:
```bash
/remotehome/bob
```
mounts:
```bash
nfs-server.lab.example.com:/srv/nfs/users/bob
```

**Do not create a separate map entry for every username.**

---

### Task 4: Persistence

Ensure autofs:

- Is running immediately.
- Starts automatically at boot.
- Still works following a reboot.
- Task 5: Demonstrate on-demand behavior

Show that:

- The NFS share is not mounted initially.
- Accessing the path triggers the mount.
- Leaving the path and waiting causes the NFS mount to expire.
- Accessing it again remounts it.

Do not remain inside the automounted directory while testing expiration.

