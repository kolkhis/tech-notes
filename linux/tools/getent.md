# `getent`

The `getent` command is used to display `ent`ries from databases that are supported
by the Name Switch Service (NSS) libraries.  

- **NSS** is the system that lets Linux resolve names and info from different
  sources (local files, LDAP, AD, NIS, DNS, etc).  

- NSS behavior is configured in `/etc/nsswitch.conf`.  


## Supported Databases

The `getent` command can be used to retrieve a lot of information, but it is most notably
used for gathering information about users and groups.  

The most common databases you can query with `getent`:

- `passwd`: List of user accounts like in `/etc/passwd`
- `group`: List of groups like in `/etc/group`
- `shadow`: User passwords and aging info (expirations).
    - This one requires root.  
- `hosts`: Hostnames and IP addresses like in `/etc/hosts` / DNS
- `services`: Network services like in `/etc/services`
- `protocols`: Network protocols like in `/etc/protocols`
- `networks`: Network names and addresses
- `aliases`: Mail aliases (not really used anymore)

The list depends on your system's `libc` and NSS modules.  


## Use Cases

- User lookup
  ```bash
  getent passwd kolkhis
  ```
  This will show the `passwd` entry for the user `kolkhis`.  
    - This works even if the account is from LDAP or AD, hence it's sometimes
      necessary instead of looking in `/etc/passwd`.  

- Group lookups
  ```bash
  getent group sudo
  ```
  This displays all the members of the `sudo` group.  
    - Again, this works even with LDAP and AD groups.  

- Host lookups
  ```bash
  getent hosts example.com
  ```
  This uses the order specified in `/etc/nsswitch.conf` for host lookup.  
    - It may consult `/etc/hosts`, DNS, LDAP, etc. depending on your `nsswitch.conf`.    

- Service lookups
  ```bash
  getent services ssh
  ```
  This will print the port and protocol for `ssh` (e.g., `22/tcp`)


