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

??? warning "Spoilers"

    Use `nmcli` or `nmtui` to configure the system's network settings.


## Question 2:
### Configure DNF/RPM/YUM Repository Access

- On Node1, configure repository access using the repositories located at:
    - https://repo.example.com/rhel9_10/BaseOS
    - https://repo.example.com/rhel9_10/AppStream

Ensure the repositories are enabled, persist across reboots, and can be used to
install packages.

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

## Question 4:
### User and Group Management

On Node1, perform the following user and group management tasks:

- Create a group named admins with a fixed GID of 3500.
- Create a group named users
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

??? info "Spoilers"

    - Use the set user ID (setuid, 4), set group ID (setgid, 2), and restricted deletion/sticky (1) permission bits to meet the requirements.
    - The setgid bit (2) will have every file inherit the group ownership when
      set on a directory.  
    - The sticky bit can be used to prevent anyone from deleting files in the
      directory unless they are the owner (or root). 


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

## Question 9:
### Configure NTP Client Synchronization

On Node1, configure the system to synchronize its system time with the NTP 
server time.google.com and meet the following requirements:

- Configure Node1 to use time.google.com as its only time source.
- Ensure time synchronization is enabled and active.
- The configuration must persist across reboots.
- Verify that the system clock is synchronized with the configured NTP server.

## Question 10:
### Locate, Copy, and Secure Files

On Node1, perform the following tasks:

- Locate all regular files under the `/etc` directory that are larger than 900 
  KB but smaller than 5 MB.
- Copy all matching files to the directory `/find/largefiles`.
- Preserve the original file ownership, permissions, and timestamps during the 
  copy operation.

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

- (question 9) Configure NTP Client Synchronization 
- (question 8) Ownership, Permissions, and ACLs
- NFS and autofs
- Convert subnet mask to CIDR notation (beyond `255.255.255.0` = `/24`)
- `/etc/sysconfig/network-scripts/`
- Does RHEL10 have a flatpak repo?
- Can we install packages on our exam boxes that were not specified?
    - e.g., `dnf-plugins-core`
    - Likely not, but we should get clarification on this
- SELinux (ports, etc.)
- Firewalld
- Special permission bits
    - setuid (4), setgid (2), sticky bit (1)
- PAM password quality configuration:
    - vim /etc/security/pwquality.conf

```bash
sudo tar -czvf /root/backup.tar.gz /var/tmp/*
```


