# `getent`

The `getent` command is used to display `ent`ries from databases that are supported
by the Name Switch Service (NSS) libraries.  

- **NSS** is the system that lets Linux resolve names and info from different
  sources (local files, LDAP, AD, NIS, DNS, etc).  

- NSS behavior is configured in `/etc/nsswitch.conf`.  

## Overview

The `getent` command can be used to retrieve a lot of information, but it is most notably
used for gathering information about users and groups.  

`getent` is **NSS-aware**, unlike `cat /etc/passwd` or `grep`, which only queries
local files.  

This is why `getent apsswd USER` works even if the user is in LDAP, NIS, SSSD, AD,
etc.  

If `getent` returns nothing for a query, it usually means that either the entry does
not exist, *or* NSS is misconfigured in `/etc/nsswitch.conf`.  


## Supported Databases

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


## Examples

- Show the **full** user database (local **and** remote):
  ```bash
  getent passwd
  ```

- Print only user names (first field) from NSS:
  ```bash
  getent passwd | cut -d: -f1
  ```

- Check which groups a user belongs to:
  ```bash
  getent group | grep -i kolkhis
  ```

- Resolve an IP using NSS rules:
  ```bash
  getent hosts 8.8.8.8
  ```

---

## tl;dr

- `getent`: "get entries" from NSS databases.  
- More reliable than grepping `/etc/passwd` or `/etc/group` beacuse it works with
  remote identity sources.  
- Databases include: `passwd`, `group`, `shadow`, `hosts`, `services`, and more. 
- Sources (databases) are configured by `/etc/nsswitch.conf`

## `getent` Cheatsheet

| **Database** | **Example Command**               | **What It Shows**
| ------------ | --------------------------------- | -----------------
| `passwd`     | `getent passwd kolkhis`           | User account info: `username:x:UID:GID:comment:home:shell`
| `group`      | `getent group sudo`               | Group info: `groupname:x:GID:members`
| `shadow`     | `sudo getent shadow kolkhis`      | Secure password/aging info (root only)
| `hosts`      | `getent hosts example.com`        | IP <-> hostname mappings (follows `/etc/nsswitch.conf`)
| `services`   | `getent services ssh`             | Network service to port/protocol mapping (`ssh 22/tcp`)
| `protocols`  | `getent protocols tcp`            | Protocol numbers (`tcp 6`)
| `networks`   | `getent networks loopback`        | Network names and addresses (`loopback 127`)
| `ethers`     | `getent ethers 00:11:22:33:44:55` | Ethernet MAC address database (rare)
| `aliases`    | `getent aliases postmaster`       | Mail alias database (rare, old-school Unix mail)
| `netgroup`   | `getent netgroup mygroup`         | Netgroups (used in NIS/LDAP environments)

