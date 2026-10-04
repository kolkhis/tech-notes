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


### Task 5: Demonstrate on-demand behavior

Show that:

- The NFS share is not mounted initially.
- Accessing the path triggers the mount.
- Leaving the path and waiting causes the NFS mount to expire.
- Accessing it again remounts it.

Do not remain inside the automounted directory while testing expiration. As
long as the directory is being accessed (e.g., a shell has that directory as
it's working directory), the mount will remain active.  

??? warning "Solution"

    This solution assumes that the NFS server is already set up.  


    ### Task 1: Preflight checks

    Determine whether:
    - The required client packages are installed.
      ```bash
      sudo dnf install -y nfs-utils autofs
      ```
    - The NFS server resolves by name.
      ```bash
      getent hosts nfs-server.lab.example.com
      ```
    - The NFS server is reachable.
      ```bash
      ping -c 3 nfs-server.lab.example.com
      ```
        - It is possible that the firewall on the NFS server will block the ICMP
          packets that come from `ping`, so even if this fails, the server may still be 
          reachable.  
    - Its exports are visible.
      ```bash
      showmount -e nfs-server.lab.example.com
      ```
        - `showmount -e` shows any exported shares from the given endpoint.  

    ---

    ### Task 2: Projects indirect map

    Configure autofs so that accessing `/shares/projects` mounts:
    ```bash
    nfs-server.lab.example.com:/srv/nfs/projects
    ```

    #### Requirements:
    - Use an indirect map.
    - Mount it read-only using NFSv4.
    - Use a 30-second inactivity timeout.

    #### Solution:

    - Add an entry in `/etc/auto.master` that will point `/shares` to a key in
      another file. This is the workflow to create an indirect map.  
      ```bash
      /shares /etc/auto.shares -t 30
      ```
      Using `.shares` for the `/shares` mountpoint is a typical naming
      convention.  
        - The `-t 30` ensures a 30-second timeout, meeting the last
          requirement.  

    - Create the `auto.shares` file and define its mapping. 
      ```bash
      projects   -fstype=nfs4,ro nfs-server.lab.example.com:/srv/nfs/shares/projects
      ```
        - `projects`: This is a "key" for the `auto.master` entry, not
          necessarily a path. Accessing `/shares/projects` will dynamically
          create all directories needed.  
        - `-fstype=nfs4,ro`: Set the filesystem type to NFS4 with read-only
          permissions.  
        - `nfs-server.lab.example.com:/srv/nfs/shares/projects`: This is the
          remote endpoint that will be mounted.  

    ---

    ### Task 3: Wildcard user map

    Configure a wildcard map so that `/remotehome/alice` mounts:
    ```bash
    nfs-server.lab.example.com:/srv/nfs/users/alice
    ```
    and accessing `/remotehome/bob` mounts:
    ```bash
    nfs-server.lab.example.com:/srv/nfs/users/bob
    ```
    **Do not create a separate map entry for every username.**

    #### Solution
    - Create a similar entry to the `shares` entry in `/etc/auto.master`, but
      point it to a different file.  
      ```bash
      sudo vi /etc/auto.master
      ```
      Add the following mapping.  
      ```bash
      /remotehome /etc/auto.users -t 30
      ```

    - Create the `/etc/auto.users` file.  
      ```bash
      touch /etc/auto.users
      sudo vi /etc/auto.users
      ```

    - Add the mapping using a wildcard.  
      ```bash
      * -fstype=nfs4,ro nfs-server.lab.example.com:/srv/nfs/users/&
      ```
        - `*`: This is the wildcard. It will match any local path accessed in `/remotehome`.  
        - `&`: This is the placeholder for any matched directories on the NFS share.  
        - This way, any newly created `users` directories in the NFS share will
          be accessible without needing to add more 

    ---

    ### Task 4: Persistence

    Ensure autofs:

    - Is running immediately.
    - Starts automatically at boot.
    - Still works following a reboot.

    #### Solution
    Simply enable/start the service.  
    ```bash
    sudo systemctl enable --now autofs
    ```

    ### Task 5: Demonstrate on-demand behavior

    This is mostly a verification step.  

    Show that:

    - The NFS share is not mounted initially.
      ```bash
      findmnt /shares/projects
      ```
    - There should be no mount point. Access that directory.
      ```bash
      cd /shares/projects
      ```
    - Accessing the path triggers the mount.
      ```bash
      findmnt /shares/projects
      ```
    - Leaving the path and waiting causes the NFS mount to expire.
      ```bash
      cd ~
      sleep 30
      findmnt /shares/projects
      ```
    - Accessing it again remounts it.
      ```bash
      cd /shares/projects
      findmnt /shares/projects
      ```


## Finding and Terminating Resource-Intensive Processes

For practice purposes, we will create these resource intensive processes
manually.  

First, a CPU-intensive process. This can be a bash script with an infinite
while loop.  

This will be `/usr/local/bin/rhcsa-cpu-hog`:
```bash
#!/bin/bash
while :; do
    :
done
```

A memory intensive process can be a simple python script.  

This will be `/usr/local/bin/rhcsa-memory-hog`:
```python
#!/usr/bin/python3

import sys
import time

mebibytes = int(sys.argv[1])
memory = bytearray(mebibytes * 1024 * 1024)

# Touch every memory page so it becomes resident in physical memory.
for offset in range(0, len(memory), 4096):
    memory[offset] = 1

time.sleep(3600)
```

Run these scripts with `nohup` and background the processes.
```bash
nohup /usr/local/bin/rhcsa-cpu-hog > /dev/null 2>&1 &
nohup /usr/local/bin/rhcsa-memory-hog > /dev/null 2>&1 &
```
This will create two processes that are saturating both CPU and memory usage.  

The task is to identify and terminate these processes without using their names
(since we already know the process names for this example).  


