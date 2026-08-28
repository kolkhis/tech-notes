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
    - harry
        - Primary group: admins
        - Secondary group users
        - User ID 3455

    - natasha
        - Supplementary groups: admins and users
        - User ID of 3456

    - sarah
        - Must not be a member of the admins group
        - Must not have access to an interactive shell

    - bruce
        - Member of  admins group
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

    - The group owner of the directory must be admins
    - Members of the admins group must have full access (read, write, and execute)
    - No access must be granted to users outside the admin group
    - The directory owner must remain root, with full access
    - All newly created files and directories within `/groups/admins` must 
      automatically inherit the admin group ownership

- Configure `/groups/users` as follows:

    - The group owner must be users
    - Owner and members of the users group must have read, write, and execute access
    - Other users must have no access
    - New files created in this directory can only be deleted by the file owner or root.



## Good to Know


- For repo setup, `gpgcheck=0` disables signature verification, which is 
  acceptable in local/test repositories for exam purposes.

- In the actual RHCSA exam, repo links will point to a fully functional 
  repository source, enabling real package access and installations after 
  configuring as we've done above.
    - `man dnf.conf` (search 'repo options')

## Things to Work On
such a
- Convert subnet mask to CIDR notation
- /etc/sysconfig/network-scripts/
- Does RHEL10 have a flatpak repo?
- Can we install packages on our exam boxes that were not specified?
    - e.g., `dnf-plugins-core`
- SELinux (ports, etc.)
- Firewalld
- Special permission bits


