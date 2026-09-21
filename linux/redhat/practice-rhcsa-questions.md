# RHCSA Practice Questions


## Question 1
### Network Configuration

On Node1, you are logged into a Red Hat Enterprise Linux system.
Determine the system’s current local network configuration, then configure the default network interface ensXXX to meet the following requirements:

- Configure a static IPv4 address using:

    - An IP address within the same network as the current configuration, with a host ID of `50`
    - Netmask: `255.255.255.0`
    - Default gateway within the same network, with a host ID of `1`

- Configure the system to use the following DNS settings:

    - DNS server: `8.8.8.8`
    - DNS search domain: `example.local`

- Set the system hostname to:

    - `rhel-node1.example.com`

Ensure the network configuration is persistent across reboots and active immediately

??? warning "Solution"

    Use `nmcli` or `nmtui` to configure the system's network settings.
    Both are fully acceptable and the choice of which tool is used does not
    affect score.  

    ## Step 1

    Whichever tool is used, the first thing that needs to be done is
    identifying the network interface that is being used.  
    ```bash
    ip -br a
    ```
    This will show the network interfaces on the devices.  
    Look for the local network IP address:
    ```bash
    lo               UNKNOWN        127.0.0.1/8 ::1/128
    ens18            UP             192.168.4.37/22 fd61:961b:ae1c:1:be24:11ff:fe27:c5b1/64 2600:6c60:4540:2e:be24:11ff:fe27:c5b1/64 fe80::be24:11ff:fe27:c5b1/64
    ```
    Here, the active network interface is `ens18` (local network IP `198.168.x.x`).  

    The same information may be seen with `nmcli`.  
    ```bash
    nmcli device status
    ```
    > **Note**: This command can also be shortened to `nmcli d s`.  
    The output should be as follows:
    ```bash
    DEVICE  TYPE      STATE                   CONNECTION
    ens18   ethernet  connected               ens18
    lo      loopback  connected (externally)  lo
    ```
    This is a little more useful. It shows the network interface name in 
    the `DEVICE` column, and it shows the NetworkManager profile name in
    the `CONNECTION` column.  

    ## Step 2
    Once the active network interface is identified.  

    ### Using `nmtui`
    - Launch the NetworkManager TUI.  
      ```bash
      nmtui
      ```
    - Select **Edit a Connection**.  
    - Choose the active interface (e.g., `ens18`).  
    - Navigate to **IPV4 CONFIGURATION**.  
    - Change method from **Automatic** to **Manual**.  
    - Select **Show**.  
    - Apply the IPv4 settings. Enter the required values:
        - Addresses: `172.16.18.50/24`
        - Gateway: `172.16.18.1`
        - DNS servers: `8.8.8.8`
        - Search domains: `example.local`
    - Select **OK**, then exit.  
    - Then activate the connection (this is **critical**):
        - From the main `nmtui` menu, select **Activate a connection**.  
        - With `ens18` selected:
            - **Activate**
            - **Deactivate**
    - Exit `nmtui`.  

    ### Using `nmcli`
    This can also be done with `nmcli`.  

    - Modify the existing NetworkManager profile.  
      ```bash
      nmcli connection modify ens18 \
          ipv4.method manual \
          ipv4.address 172.16.18.50/24 \
          ipv4.gateway 172.16.18.1 \
          ipv4.dns 8.8.8.8 \
          ipv4.dns-search example.local \
          connection.autoconnect yes
      ```
      This makes all the required changes to the profile.  

    - Reactivate the connection profile for changes to take effect.  
      ```bash
      nmcli connection up ens18
      ```

    ## Step 3
    Change the hostname.  
    ```bash
    hostnamectl set-hostname rhel-node1.example.com
    ```
    This is immediate and will persist across reboots.  

    ## Step 4
    Ensure NetworkManager is enabled.  
    ```bash
    systemctl enable --now NetworkManager
    systemctl restart NetworkManager
    ```

    ## Verification
    ```bash
    ip a  # Confirm the IP address
    ip r  # Confirm the default gateway

    hostname                # Confirm the hostname
    cat /etc/resolv.conf    # Confirm the DNS search domain
    ```

    > **NOTE**: Remember to always include the network mask (e.g., `/24`) when 
    > configuring static IP addresses.  
    > If the subnet mask given is `255.255.255.0`, that means the CIDR notation is `/24`.

## Question 2:
### Configure DNF/RPM/YUM Repository Access

- On Node1, configure repository access using the repositories located at:
    - https://repo.example.com/rhel9_10/BaseOS
    - https://repo.example.com/rhel9_10/AppStream

Ensure the repositories are enabled, persist across reboots, and can be used to
install packages.

??? warning "Solutions"

    For this task, two new repositories must be added. This can be done by adding a 
    repository file manually or by using `dnf config-manager`.  

    ### Method 1: Using dnf config-manager

    Enable repositories via DNF config manager:
    - Enable repository access for BaseOS
      ```bash
      dnf config-manager --add-repo=https://repo.example.com/rhel9_10/BaseOS
      ```
    - Enable repository access for AppStream
      ```bash
      dnf config-manager --add-repo=https://repo.example.com/rhel9_10/AppStream
      ```
    - Verify that the repositories are available:
      ```bash
      dnf repolist
      ```
    - Both repositories should appear as enabled, however, they cannot be used
      because gpgcheck is not set.  
      Check the names given to them by `dnf config-manager` by running:
      ```bash
      ls /etc/yum.repos.d
      ```
    - Then for each of the two baseos and appstream repo files, open and enter 
      `gpgcheck=0` at the end, or run the commands:
      ```bash
      echo "gpgcheck=0" >> /etc/yum.repos.d/repo_BaseOS.repo
      echo "gpgcheck=0" >> /etc/yum.repos.d/repo_AppStream.repo
      ```

    ### Method 2: Manually Creating Repository Files
    - Create a repo file for BaseOS.  
      ```bash
      touch /etc/yum.repos.d/baseos.repo
      vi /etc/yum.repos.d/baseos.repo
      ```
        - Add the repo configuration.  
          ```toml
          [baseos]
          name=BaseOS
          baseurl=https://repo.example.com/rhel9_10/BaseOS
          enabled=1
          gpgcheck=0
          ```
    - Create a repo file for AppStream.  
      ```bash
      touch /etc/yum.repos.d/baseos.repo
      vi /etc/yum.repos.d/baseos.repo
      ```
        - Add the repo configuration.  
          ```toml
          [appstream]
          name=AppStream
          baseurl=https://repo.example.com/rhel9_10/AppStream
          enabled=1
          gpgcheck=0
          ```
    After adding the repo files, both repositories should be enabled and
    accessible.  

??? warning "Additional Notes"

    - Verification using `dnf repolist` ensures the repos are functional.  
    - Both methods persist across reboots automatically. 
    - The `gpgcheck=0` disables signature verification, which is acceptable in 
      local/test repositories for exam purposes.  
    - In the actual RHCSA exam, repo links will point to a fully functional 
      repository source, enabling real package access and installations after 
      configuring as we've done above.
        - So on the exam, we will be able to install packages from the configured repos 
          to test that they work properly.
        - `man dnf.conf` (search 'repo options')


## Question 3:
### Configuring and Securing an Apache HTTP Service

On Node1, configure the Apache HTTP Server to meet the following requirements:

- The Apache web service must be installed, enabled, and running.
- The web server must listen on TCP port 85.
- The service must be accessible from both the local system and external hosts.
- When curled or accessed via a web browser, the server must display the following message:
  ```txt
  Welcome to the Apache Web Server!
  ```

??? warning "Solutions"

    1. First, make sure Apache is installed. The package is usually called `httpd`.  
       ```bash
       dnf install -y httpd
       ```

    2. Configure Apache to listen on port 85.  
       ```bash
       vi /etc/httpd/conf/httpd.conf
       ```
       Find the `Listen` directive and change it to 85.  
       ```bash
       Listen 85
       ```
       Save the file and exit (`:wq`).  

    3. Create the web content.  
       Create or edit the default index.html page.  
       ```bash
       vi /var/www/html/index.html
       ```
       Add the required content.  
       ```plaintext
       Welcome to the Apache Web Server!
       ```
       Save and exit (`:wq`).  

    4. Allow port 85 through the firewall for external access.  
       ```bash
       firewall-cmd --permanent --add-port=85/tcp
       firewall-cmd --reload
       ```

    5. Configure SELinux to allow Apache on port 85.  
        - Apache is restricted by SELinux to use specific ports. Port 85 must
          be explicitly allowed.  
        - Check if port 85 is already allowed.  
          ```bash
          semanage port -l | grep http  
          ```
        - If port 85 is not listed (expected), add it.  
          ```bash
          semanage port -a -t http_port_t -p tcp 85
          ```
        - This step is **mandatory** if SELinux is enforcing, which it always
          is on the exam.  
        - Use `man` to find good syntax examples to use with `man semanage port`

    6. Enable and start Apache web server.  
       ```bash
       systemctl enable --now httpd
       # or
       systemctl restart httpd
       ```

    7. Verify that the requirements are met.  
       ```bash
       semanage port -l | grep http  # Should list port 85
       systemctl status httpd        # Should show Apache is enabled and running
       ```
       Check access from the local system.  
       ```bash
       curl http://localhost:85
       ```
       Check access from an external system (browser or Node2).  
       ```bash
       curl http://<NODE1_IP>:85
       ```


## Question 4:
### User and Group Management

On Node1, perform the following user and group management tasks:

- Create a group named `admins` with a fixed GID of `3500`.
- Create a group named `users`.  
- Create the following user accounts with the specified requirements:
    - `harry`
        - Primary group: `admins`
        - Secondary group: `users`
        - User ID `3455`

    - `natasha`
        - Supplementary groups: `admins` and `users`
        - User ID of `3456`

    - `sarah`
        - Must not be a member of the `admins` group
        - Must not have access to an interactive shell

    - `bruce`
        - Member of `admins` group
        - Home directory must be created explicitly

- Set the password for all created users to:
  ```txt
  password
  ```

??? warning "Solution"
    
    ## Step 1: Create the groups
    - Create `admins` group with a group ID of `3500`.  
      ```bash
      groupadd -g 3500 admins
      ```
      The `-g` specifies the GID.  

    - Create `users` group.  
      ```bash
      groupadd users
      ```

    ## Step 2: Create the users
    - Create `harry` 
      ```bash
      useradd -g admins -G users -u 3455 harry
      ```
        - `-g admins`: Assigns primary group `admins` 
        - `-G users`: Assigns secondary (supplementary) group `users`.  
        - `-u 3455`: Assigns the user ID of `3455`.  

    - Create `natasha`.  
      ```bash
      useradd -G admins,users -u 3456 natasha
      ```
        - `-G admins,users`: Assigns supplementary groups `admins` and `users`
          (these should be comma-separated).  
        - `-u 3456`: Assigns UID of `3456`.  

    - Create `sarah`.  
      ```bash
      useradd -s /sbin/nologin sarah
      ```
        - `-s /sbin/nologin`: Specifies the user's shell.  
            - `/sbin/nologin` prevents interactive shell access while still allowing 
              authentication for services.  

    - Create `bruce`.  
      ```bash
      useradd -m -G admins bruce
      ```
        - `-m`: Automatically creates the home directory for the user.  
        - `-G admins`: Adds supplementary group `admins`.  

    ## Step 3: Set passwords

    Set the password for all these users to `password`.  
    ```bash
    passwd harry
    passwd natasha
    passwd sarah
    passwd bruce
    ```
    This can also be scripted. 
    ```bash
    for u in harry natasha sarah bruce; do echo "password" | passwd --stdin "$u"; done
    ```

    ## Step 4: Verification

    Verifying that everything is correct is recommended for the exam.  

    - Verify group membership
      ```bash
      id harry
      id natasha
      id sarah
      id bruce
      id -g admins
      id -g users
      ```

    - Verify home directory of user bruce
      ```bash
      ls -ld /home/bruce
      ```

    - Verify shell access
      ```bash
      getent passwd sarah 
      ```
      Expected output should show:    `sarah:x:...:/home/sarah:/sbin/nologin`



## Question 5:
### Shared Group Directories and Permissions
On Node1, as root, create shared collaboration directories for group-based 
access with the following requirements:

- Create the following directories:
    - `/groups/admins`
    - `/groups/users`

- Configure `/groups/admins` as follows:

    - The group owner of the directory must be `admins`
    - Members of the `admins` group must have full access (read, write, and execute)
    - No access must be granted to users outside the `admins` group
    - The directory owner must remain `root`, with full access
    - All newly created files and directories within `/groups/admins` must 
      automatically inherit the `admins` group ownership

- Configure `/groups/users` as follows:

    - The group owner must be `users`
    - Owner and members of the `users` group must have read, write, and execute access
    - Other users must have no access
    - New files created in this directory can only be deleted by the file owner or root.

??? info "Hint"

    - Use the set user ID (setuid, 4), set group ID (setgid, 2), and restricted 
      deletion/sticky (1) permission bits to meet the requirements.
    - The setgid bit (2) will have every file inherit the group ownership when
      set on a directory.  
    - The sticky bit can be used to prevent anyone from deleting files in the
      directory unless they are the owner (or root). 

??? warning "Solution"

    ## Step 1
    Create the required directories.  
    ```bash
    mkdir -p /groups/admins /groups/users
    # OR
    mkdir -p /groups/{admins,users}
    ```

    ## Step 2
    Set ownership of the directories.  
    - Configure `/groups/admins`.  
        - Owner must remain `root`.  
        - Group owner must be `admins`.  
          ```bash
          chown root:admins /groups/admins
          ```

    - Configure `/groups/users`.  
        - Group owner must be `users`. 
          ```bash
          chgrp users /groups/users
          # OR 
          chown :users /groups/users
          # OR
          chown root:users /groups/users
          ```

    ## Step 3
    Set the directory permissions.  

    - `/groups/admins` requirements:
        - Full access for members of `admins`.  
        - No access for others.  
        - SETGID/SGID bit must be set so new files inherit group ownership.  
          ```bash
          chmod 2770 /groups/admins
          ```
            - `2`: SGID bit (Can also be set using `chmod g+s`)
            - `7`: rwx for owner (`root`)
            - `7`: rwx for group (`admins`)
            - `0`: no access for others

    - `/groups/users` requirements:
        - Full access for members of the `users` group.  
        - No access for others.  
        - Sticky bit set so that only `root` can delete files.  
          ```bash
          chmod 1770 /groups/users
          ```
            - `1`: Sticky bit (Can also be set using `chmod +t`)
            - `7`: rwx for owner (`root`)
            - `7`: rwx for group (`users`)
            - `0`: no access for others

    ## Step 4
    Verify the permissions.  
    ```bash
    ls -ld /etc/groups /etc/admins
    ```
    - `/groups/admins` should show `drwxrws---` 
        - The `s` in the group execute field represents the setgid bit.  
    - `/groups/users`  should show `drwxrwx--T`
        - The `T` in the other execute field represents the sticky bit.  



## Question 6:
### Configuring NFS + Autofs

On Node1, configure autofs to automatically mount remote user home directories 
with the following requirements:

- Install and enable the autofs service.

- Configure automounting so that user home directories are accessed under /homes/remote.

- The remote NFS export is available from server.example.com at /exports/home. 
  This directory contains users john and mary home directories as /exports/home
  /john & /exports/home/mary.

- Home directories must be mounted on demand and unmounted automatically after 60s of inactivity.

- The autofs configuration must persist across reboots.

- Do not manually mount the filesystem.

??? info "BONUS: Configuring Node2 as an NFS Server so that Node1 is its NFS Client"
    - Step 1: Install required NFS packages
      ```bash
      dnf install -y nfs-utils
      ```
    - Step 2: Create the export directory
      ```bash
      mkdir -p /exports/home
      #(Optional but realistic for practice)
      chmod 755 /exports/home
      ```
        - Add the directories mary and john in /exports/home with any relevant contents.
          ```bash
          # mkdir /exports/home/john 
          # echo "John's Home Directory" > /exports/home/john/file1.txt
          # mkdir /exports/home/mary
          # echo "Mary's Home Directory" > /exports/home/mary/file1.txt
          ```
    - Step 3: Configure NFS exports
        - Edit /etc/exports:
          ```bash
          vim /etc/exports
          ```
          Add the following line:
          ```bash
          /exports/home  *(rw,sync,no_root_squash) 
          ```
          This allows read/write access and ensures predictable behavior for lab environments.
          Note for simplicity, just
          ```bash
          /exports/home  *(rw)
          ```
          is sufficient and should work normally.
          The `*` in `/exports/home   *(rw)` allows access from any host; to restrict 
          access explicitly to Node1, replace `*` with Node1's hostname or IP address, for 
          example:
          ```bash
          /exports/home rhel-node1.example.com(rw) (if DNS resolution is set)
          ```
          OR
          ```bash
          /exports/home 192.168.50.25(rw) (works even if DNS resolution is not configured in /etc/hosts)
          ```

    - Step 4: Enable and start the NFS services
      ```bash
      systemctl enable --now nfs-server
      ```
        - Confirm status:
          ```bash
          systemctl status nfs-server
          ```

    - Step 5: Configure the firewall to allow NFS access
      ```bash
      firewall-cmd --permanent --add-service=nfs
      firewall-cmd --permanent --add-service=mountd
      firewall-cmd --permanent --add-service=rpc-bind
      ```
      OR scripted:
      ```bash
      for service in nfs mountd rpc-bind; do firewall-cmd --add-service="$service" --permanent; done;
      ```
        - Next (very important)
          ```bash
          firewall-cmd --reload
          ```

    - Step 7: Verification (recommended)

        - From Node2 (the NFS server):
          ```bash
          showmount -e localhost
          ```

        - From Node1 (the NFS client):
          ```bash
          showmount -e <Node2-IP>
          ```
          Expected output should include:
          ```bash
          /exports/home *
          ```

    - Result: Node2 is now successfully configured as an NFS server exporting 
      `/exports/home`, along with all its sub-directories, ready to be consumed by 
      autofs on Node1 or any other VM for the RHCSA practice scenario.


## Question 7:
### Cron Job for User
On Node1, as the user `bruce`, perform the following tasks:

- Create a cron job that executes daily at 12:45 AM.

- The job should print (echo) the message:
  ```plaintext
  EX200 Practice Test!
  ```

- The job should continue to exist and run as expected across reboots.

- Hint: Use the standard crontab for the user rather than placing scripts in
  `/etc/cron.d` unless explicitly instructed.


??? warning "Solution"

    #### Solution for Question 7

    Step 1: Switch to the user bruce
    ```bash
    su - bruce
    ```

    Step 2: Edit the user's crontab
    ```bash
    crontab -e
    ```
    OR
    ```bash
    crontab -u bruce -e (if running as root)
    ```

    Step 3: Add the cron job entry

    Hint: You can always use `cat /etc/crontab` as a cheat sheet to get information 
    on what each entry represents.

    Add the following line:
    ```bash
    45 0 * * * /usr/bin/echo "EX200 Practice Test!"     # (full path, recommended)
    ```
    OR
    ```bash
    45 0 * * * echo "EX200 Practice Test!"              # (should still work fine)
    ```
    Explanation (exam clarity):
    - `45`: minute
    - `0`: hour (12:45 AM / 00:45)
    - `* * *`: every day

    To get the correct full path, run the command `which echo`, `which log`, etc.

    Step 4: Save and exit the editor (`:wq`) OR ZZ

    The cron job is now registered in bruce’s user crontab.

    Step 5: Verify the cron job as user bruce
    ```bash
    crontab -l 
    crontab -l -u bruce # (as root)
    ```

    Expected output:
    ```plaintext
    45 0 * * * /usr/bin/echo "EX200 Practice Test!"
    ```

    Step 6: Ensure persistence across reboots

    No extra action is required.

    Why:  
    User crontabs are managed by the crond service and persist automatically across 
    system reboots, provided the service is enabled (default on RHEL).

    (Optional verification as root)
    ```bash
    systemctl status crond (ensure enabled and active)
    systemctl restart crond
    ```

    #### Extra Practice/Verification:

    You can set(edit) the cron job to run at a sooner time, say in the next minute 
    or two.

    After the set time has passed, verify that it runs as it should by running the 
    command:
    ```bash
    journalctl | grep "EX200"
    ```

## Question 8:
### Ownership, Permissions, and ACLs

On Node1, copy the file `/etc/fstab` to `/var/tmp` and configure its ownership and 
permissions to meet the following requirements:

- The copied file must be owned by `root`.
- The file must belong to the `admins` group.
- The file must not be executable by any user.
- The user owner and group owner should have read and write access.
- User `harry` must have read and write access to the file.
- User `bruce` can read but not write to the file.
- User `natasha` must have no read or write access to the file.
- All other users, including users created in the future, must have read-only 
  access to the file.
 
!!! info "Note"

    ACLs are no longer listed as an exam objective for RHEL 10.  
    However, they remain a simple yet powerful feature that every Linux system 
    administrator should understand. They take only a few minutes to learn and are 
    extremely useful for managing permissions in real-world environments, so it's 
    well worth taking the time to become familiar with them.



??? warning "Solution"

    Step 1: Copy the file to the target location
    ```bash
    cp /etc/fstab /var/tmp/fstab
    ```

    Step 2: Set ownership and group ownership
    ```bash
    chown root:admins /var/tmp/fstab
    ```

    Step 3: Remove all executable permissions
    ```bash
    chmod a-x /var/tmp/fstab
    # OR
    chmod -x /var/tmp/fstab
    # OR
    chmod ugo-x /var/tmp/fstab
    ```

    Step 4: Set base permissions for owner, group, and others

    User owner (root): read and write
    Group owner (admins): read and write
    Others: read-only
    ```bash
    chmod 664 /var/tmp/fstab
    ```

    At this point:
    - Root → 6 → read/write
    - Group (admins) → 6 → read/write
    - Others → 4 → read-only

    Note: This step grants the user, group and owner permissions in one go while also restricitng the execution permission for all, so you could skip Step 3.

    Step 5: Configure ACLs for specific user requirements

    Grant harry read and write access
    ```bash
    setfacl -m u:harry:rw /var/tmp/fstab
    ```

    Grant bruce read-only access
    ```bash
    setfacl -m u:bruce:r /var/tmp/fstab
    # OR
    setfacl -m u:bruce:r-- /var/tmp/fstab
    ```

    Explicitly deny natasha read and write access
    ```bash
    setfacl -m u:natasha:--- /var/tmp/fstab
    # OR
    setfacl -m u:natasha:- /var/tmp/fstab
    ```


    Step 6: Verify permissions
    ```bash
    ls -l /var/tmp/fstab
    ```

    Expected output:
    ```plaintext
    -rw-rw-r--+ 1 root admins ... /var/tmp/fstab
    ```
    Verify ACL configuration

    ```bash
    getfacl /var/tmp/fstab
    ```

    Expected key entries:
    ```plaintext
    # file: var/tmp/fstab
    # owner: root
    # group: admins
    user::rw-
    user:harry:rw-
    user:natasha:---
    user:bruce:r--
    group::rw-
    mask::rw-
    other::r--
    ```


## Question 9:
### Configure NTP Client Synchronization

On Node1, configure the system to synchronize its system time with the NTP 
server time.google.com and meet the following requirements:

- Configure Node1 to use `time.google.com` as its only time source.
- Ensure time synchronization is enabled and active.
- The configuration must persist across reboots.
- Verify that the system clock is synchronized with the configured NTP server.


??? warning "Solution"

    1. Install and enable the required time synchronization package if it's not 
       present (on RHEL10, Chrony is the standard NTP implementation).  
       ```bash
       dnf install -y chrony
       systemctl enable --now chronyd
       systemctl status chronyd
       ```

    2. Then edit the chrony config file. Comment out any existing `server` or
       `pool` lines, and add the `time.google.com` server.  
       ```bash
       vi /etc/chrony.conf
       ```
       Add the line:
       ```plaintext
       server time.google.com iburst
       ```
       Use `pool` if provided with a set of servers (e.g., `pool.ntp.org`, which
       will resolve to multiple addresses).  

    3. Restart `chronyd` for changes to take effect.
       ```bash
       systemctl restart chronyd
       ```

    4. Enable NTP synchronization via `timedatectl` if it's not already set.  
       ```bash
       timedatectl set-ntp true
       ```
       Verify afterwards.  
       ```bash
       timedatectl
       ```
       Ensure the two lines are set:
       ```plaintext
       System clock synchronized: yes
                     NTP service: active
       ```

    5. Verify synchronization with the time server.  
       ```bash
       chronyc sources
       ```
       The `time.google.com` server should be present in the output.  
       In this output, the `^*` indicates the active synchronization source.  




## Question 10:
### Locate, Copy, and Secure Files

On Node1, perform the following tasks:

- Locate all regular files under the `/etc` directory that are larger than 900 
  KB but smaller than 5 MB.
- Copy all matching files to the directory `/find/largefiles`.
- Preserve the original file ownership, permissions, and timestamps during the 
  copy operation.

??? warning "Solution"

    ## Step 1
    - Create the required directory `/find/largefiles`.  
      ```bash
      mkdir -p /find/largefiles
      ```

    ## Step 2
    - Locate the files matching the given specifications.  
      ```bash
      find /etc -type f -size +900k -size -5M -exec cp -a '{}' /find/largefiles \;
      ```
      This will show all the files that match the given specs and execute a
      command on each one in sequence.  
        - `-type f`: Ensure only regular files are matched.  
        - `-size +900k`: Match files over the size off 900 KB.  
        - `-size -5M`: Match files under the size off 5 MB.  
        - `-exec`: Execute the given command over each file matched.  
        - `cp -a '{}' /find/largefiles \;`: Use `cp -a` (`-a`, archive option, preserves original file permissions).  
            - `-a`: The archive option, preserves original file permissions.  
              This option preserves:  
                - ownership  
                - permissions  
                - timestamps  
                - SELinux context  
            - `'{}'`: Placeholder syntax for `-exec`, replaced by the matched filename.  
            - `/find/largefiles`: The destination for `cp`.  
            - `\;`: The end of the `-exec` command (semicolon must be escaped or quoted). 

    ## Step 3
    Verify that the files were copied to the correct location.  
    ```bash
    ls -alh /find/largefiles
    ```


## Question 11:
### Boot Configuration and Troubleshooting

On Node1, ensure that system boot messages are displayed during startup to 
assist with troubleshooting.

- Remove any kernel parameters that suppress boot messages so that verbose output is enabled.
- The configuration must persist across reboots.

## Question 12:
### Archive and Compress System Files

On Node1, create a compressed archive of the directory `/var/tmp` with the 
following requirements:

- The archive must include all files and subdirectories under `/var/tmp`
- The archive must be compressed using `gzip`
- Save the resulting archive as `/root/backup.tar.gz`
- The operation should preserve file permissions and directory structure

## Question 13:
### Configure Default File and Directory Permissions

On Node1, configure the system so that for the user `bruce`, the following 
default permissions apply:

- Newly created regular files must have permissions set to `-r-------` by 
  default.
- Newly created directories must have permissions set to `dr-x------` by 
  default.
- The configuration must apply automatically to all future files and 
  directories created by `bruce`.

Hint: think of `umask`.  

## Question 14:
### Enforce Password Policies for New Users

On Node1, configure the system so that all newly created users meet the following password requirements:

- Passwords must expire after 30 days.
- Passwords must be at least 9 characters long.

## Question 15:
### Configure Sudo Access

On Node1, perform the following tasks:

- Create a new user `jane` and ensure that `jane` can execute commands with `sudo`.
- Configure the system so that all members of the group `admins` can execute 
  commands with `sudo` without being prompted for a password.

## Question 16:
### Create a User Script That Executes at Login

On Node1, perform the following tasks as the user jane:

- Create a shell script search_bash.sh that searches for the string "bash" in 
  `/etc/passwd` and copies the matching lines, in the same order, to the file 
  `bash-users.txt` in jane's home directory.
- Configure the script to automatically run whenever `jane` logs in.

Requirement:
- Grant privileged access of `/etc/passwd` to user jane if necessary.
- The script must be user-specific; do not modify system-wide login scripts.

## Question 17:
### Reset Root Password

On Node2, assume the `root` password is unknown. Reset the root password to:
```bash
rootpass 
```
for root login.


## Question 18:
### Logical Volume Configuration

On Node2, create a logical volume named lvdata and configure it according to 
the following requirements:

- The logical volume must be created from a volume group named `vgstore` and must 
  use exactly 50 physical extents.

- The volume group `vgstore` must be created from an lvm partition on vdb (or `sdb`, 
  `nvme0n2`, or any available secondary disk as appropriate) and must use a 
  physical extent size of 8 MiB.

- Format the logical volume with the ext4 filesystem and mount it persistently on
  `/mnt/data`.

!!! info

    Don't delete the logical volume (LV) when done with the task, as this LV is
    used later on in question 20.  

## Question 19:
### Create Swap Partition

On Node2, perform the following tasks:

- Create a 512 MB swap partition on the same disk used previously (`vdb`, `sdb`, or 
  `nvme0n2`, as appropriate).

- Configure the system to use this partition as swap space.

- Ensure the swap is enabled immediately and mounted persistently so that it is 
  active after a reboot.



## Question 20:
### Resize Logical Volume

On Node2, resize the previously created logical volume lvdata in the vgstore 
volume group to use a total of 85 physical extents.

- Add a third partition of appropriate size to the secondary disk and use if 
  for this purpose.

- Ensure that the filesystem on the logical volume is adjusted appropriately so that the new space is available for use.

Requirement:

Ensure the logical volume remains mounted at /mnt/data and is usable after resizing.


```bash
lvextend -l +35 vgstore /dev/sdb3
```


## Question 21:
### Enable Recommended Tuning Profile

On Node2, perform the following task:

Enable the recommended tuning profile to optimize the system performance 
according to Red Hat best practices.

Verify that the tuning profile has been successfully applied and is active.




## Question 22:
### Containers/Flatpak Configuration



#### RHCSA 9 ONLY - Run a Rootless Container as a Systemd Service

On Node2, as the non-root user `russ` (password: `russpass`), create and manage 
a container with the following requirements:

Pull the container image registry.redhat.io/ubi9/ubi from the Red Hat registry 
(create a `developers.redhat.com` account using a browser, if required, and 
authenticate to the registry using valid credentials).

Run a container named `ubicon` based on this image.

Configure the container to:

- Map host port `8089` to container port `8089`

- Persist data by binding two host directories, including `/opt/out` on the host 
  to `/opt/in` inside the container, and a second host directory `/opt/send` to 
  `/opt/receive` in the container.

- Finally, configure the container to be managed as a user-level systemd 
  service with the name `container-ubicon`, ensuring it is enabled and 
  automatically starts on system reboot without requiring root privileges.





#### RHCSA 10 ONLY - Configure Flatpak Repositories

On Node2, perform the following tasks:

- Install the flatpak package manager using the appropriate system package 
  management tools.

- Add the official flathub remote repository to the system using the link:
    - https://flathub.org/repo/flathub.flatpakrepo

- Add the official rhel flatpak remote repository if not present. Use the link:
    - https://flatpaks.redhat.io/rhel.flatpakrepo

- Verify that all configured flatpak remotes are properly added to the system.

---

## Question 23:
### Configure SELinux Booleans/System Journals

On Node2, perform the following tasks:

- Enable the SELinux boolean `httpd_can_network_connect` so that the Apache web 
  server is allowed to initiate outbound network connections. Ensure the change 
  persists across reboots.

- Configure the system to preserve system journals.

??? warning "Spoilers"

    ```bash
    # TODO: Check if this persists across reboots
    sudo semanage boolean -m --on httpd_can_network_connect

    # alt method
    getsebool httpd_can_network_connect
    setsebool -P httpd_can_network_connect on
    # -P = persist across reboots

    sudo find / -type f -name 'journald.conf'
    ```


## Question 24:
### Secure File Transfer  / Key-Based Authentication

On Node2, perform the following tasks **as root**:

- Configure key-based, passwordless SSH authentication from Node2 to Node1 for 
  secure access to the user natasha on Node1.

- Once authentication is established, securely copy the file `/etc/fstab` from 
  Node2 to `natasha`'s home directory on Node1.

- Ensure that the copied file is owned by natasha and retains appropriate 
  permissions for her to read and write.

- Requirement: Use a secure, encrypted method for the file transfer.


## Question 25:
### At Job & Systemd Timer

#### BOTH RHCSA 9 & 10 - Create a one-time at job

On Node2, as the user `russ`, schedule a one-time job to run tonight at 21:30 
that appends the line:
```plaintext
EX200 Mock Practice 1 Complete!
```
to the file `/home/russ/practice.log`.  


#### RHCSA 10 ONLY - Systemd Service & Timer

On Node2, configure a recurring task by completing the following:

- Create an executable script named log.sh in /usr/local/bin/ that writes the 
  message RHCSA Practice Exam 1 Complete! to the system journal using the logger 
  command.

- Create a systemd oneshot service named log.service that runs the script.

- Create a systemd timer named log.timer that triggers the service every 1 minute 
  and ensures missed runs are executed after reboot (persistent behavior).

- Enable and start the timer so it begins working immediately and persists across 
  reboots.

- Verify that the timer is active and that the message appears repeatedly in the 
  system journal as the timer executes.

- Once you have confirmed the timer is working correctly, modify it so the
  service runs hourly instead.

??? warning "Spoilers"

    ```bash
    systemctl list-timers
    ```


## Good to Know

- For repo setup, `gpgcheck=0` disables signature verification, which is 
  acceptable in local/test repositories for exam purposes.

- In the actual RHCSA exam, repo links will point to a fully functional 
  repository source, enabling real package access and installations after 
  configuring as we've done above.
    - So on the exam, we will be able to install packages from the configured repos 
      to test that they work properly.
    - `man dnf.conf` (search 'repo options')

## Things to Work On


- Setting up SWAP partitions
- Physical Extents in LVM
- (question 6) NFS and autofs
- (question 8) Ownership, Permissions, and ACLs
- (question 9) Configure NTP Client Synchronization 
- (question 22) Flatpak repos and config
- (question 23) SELinux booleans and system journals
- Convert subnet mask to CIDR notation (beyond `255.255.255.0` = `/24`)
- `/etc/sysconfig/network-scripts/`
- Flatpak -- Does RHEL10 have a flatpak repo?
- Can we install packages on our exam boxes that were not specified?
    - e.g., `dnf-plugins-core`
    - Likely not, but we should get clarification on this
- SELinux (ports, etc.)
    - `semanage`
    - `semanage port`
- Firewalld (`firewall-cmd`)
- Special permission bits
    - setuid (4), setgid (2), sticky bit (1)
- PAM password quality configuration:
    - `vim /etc/security/pwquality.conf`

- Basic archive creation and extraction (`-z` to use bzip2)
    - Creation:
      ```bash
      sudo tar -czvf /root/backup.tar.gz /var/tmp/*
      ```
        - `-c`: create
        - `-z`: compress with gzip
        - `-v`: verbose
        - `-f`: filename of the archive to create
    - Extraction
      ```bash
      sudo tar -xzvf /root/backup.tar.gz -C /root/
      ```
        - `-x`: extract
        - `-z`: decompress with gzip
        - `-v`: verbose
        - `-f`: filename of the archive to extract
        - `-C`: change to directory before extracting
            - This will extract the contents of the archive into `/root/`
            - Without this option, the contents will be extracted into the
              current working directory (`$PWD`).


partprobe

