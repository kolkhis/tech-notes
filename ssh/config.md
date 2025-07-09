# SSH Config

###### > `man ssh_config(5)`

You can specify a per-user SSH configuration file at `~/.ssh/config`.  

In this file, you can define helpful aliases for establishing SSH connections to remote hosts.  

---
## User Configuration
### Config File Loading Order

The SSH client reads its configuration in this order:

1. Options passed directly to the `ssh` command.  
2. User config: `~/.ssh/config`
3. System-wide config: `/etc/ssh/ssh_config.d/` (in Debian)
4. System-wide config: `/etc/ssh/ssh_config` 

### Basic User SSH Config Syntax

A typical SSH config entry will look like this:

```ssh
Host hostname
    SSH_OPTION value
    SSH_OPTION value
    SSH_OPTION value
```

It specifies a **pattern** for `Host`.  
Then it specifies some parameters to use for the SSH connection to that host.  


### Using SSH Config for Aliases

The most common usage for SSH config files is to define aliases to make it easier
to connect.  

To define a remote host:
```ssh
Host my-host
    User kolkhis
    Hostname 192.168.1.10
```

This is a minimal config entry only containing the necessary items to connect to a
server on port 22:

- `Host my-host`: The alias you want to give to the remote host.  
    - This is a **pattern**.  
- `User kolkhis`: The remote user account you want to use.  
- `Hostname 192.168.1.10`: The destination/IP of the remote host.  

This effectively creates an alias `my-host` for `kolkhis@192.168.1.10`.  
So with the `~/.ssh/config` entry, instead of:
```bash
ssh kolkhis@192.169.1.10
```
You can do:
```bash
ssh my-host
```



---

### Other User Config Options

You can specify more details for SSH config entries.  

You have the `Host` entry, then you can have:  

- `User`: The remote user.  
- `Hostname`: The destination host (IP/hostname).  
- `Port`: The port to use for SSH (default `22`).  
- `IdentityFile`: The private key file to use as your identity file.  
- `LogLevel`: The log level to use for the connection (default `INFO`).  
- `Compression`: Whether or not to use compression (default `no`).  
* `NumberOfPasswordPrompts`: The number of password prompts before giving up.  (default `3`).  
- ... and more  

More options in `man ssh_config`.  

### Using Multiple Entries to Match Hosts

Since the `Host` line is a **pattern**, you can specify multiple `Host` entries to
match a single host.  

E.g.:
```bash
Host my-host
    User kolkhis
    Hostname 192.168.1.10

Host *
    Port 22
    Compression yes
    LogLevel INFO

Host 192.168.1.*
    IdentityFile ~/.ssh/special-key
```

This does 3 things.  

1. Defines a host `my-host` as `kolkhis@192.168.1.10`
2. Defines as host pattern `*` (matches **all** hosts) and sets some values.  
   This will also match `my-host`, and these values will also be applied.  
    - Port is set to 22
    - Compression is turned on
    - LogLevel set to INFO
3. Defines a host pattern in the `192.168.1.0/24` range (e.g., `192.168.1.[0-255]`).  
    - Sets the `IdentityFile` to `~/.ssh/special-key` for all hosts in this
      range.  
    - This will also match `my-host`.  

---


## `SSHD_CONFIG`

The `/etc/ssh/sshd_config` file defines rules for the SSH daemon.  

The rules here are what controls how users enter the system via SSH.  

By default, the rules defined here affect **all** incoming SSH connections.  
If you want to define more specific rules for specific users, use a [`Match` 
block](#match-blocks).  


More about this in [hardening SSH](./hardening_ssh.md).  

### `Match` Blocks

You can use `Match` blocks in the SSHD config file to define conditional logic that
enforces rules only for certain users.  

> **NOTE:** When using `Match` blocks, the rules inside will apply to the group
> either until the end of the file or until the next `Match` block. Global rules
> cannot come after a `Match` block unless you reset with `Match all`. 



#### Matching Users

You can match usernames inside `Match` blocks using `Match User <username>`:  
```bash
Match User user1
    ChrootDirectory /var/chroot_user1
```
`Match User user1`: This matches the username that a user logs in with, and sets
the rules underneath it for the matched user.  

Here, we set `ChrootDirectory` to `/var/chroot`.  

Essentially what this is doing is:
```bash
ssh user1@remote-host
# then, immediately:
chroot /var/chroot_user1
```

#### Matching Groups
You can also use `Match Group <groupname>` to match users that belong to a specific 
group.  

```bash
Match Group groupname
    ForceCommand script.sh
    PermitTTY no
```

#### Resetting Match

Like noted previously, when using a `Match` block, the rules will keep applying to
the matched users/group until either the end of file or until the next `Match` block
starts.  

```bash
Match Group groupname
    ForceCommand script.sh
    PermitTTY no

PasswordAuthentication yes
```

Here, `PasswordAuthentication yes` will only apply to the group `groupname`.  
The indentation is only for readability.  

In order to reset to global options, use `Match all`.  
```bash
Match Group groupname
    ForceCommand script.sh
    PermitTTY no

Match all
PasswordAuthentication yes
```

Now, `PasswordAuthentication` will be applied globally.  


