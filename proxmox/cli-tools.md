# Proxmox CLI Tools

Proxmox ships with a number of command-line tools for administration.  

For a list, just type `pve` and then ++tab+tab++ to trigger completion.  

## `pveum`

The `pveum` (Proxmox VE User Management) tool is used for managing Proxmox
users.  

This can be used to add new users:
```bash
pveum user add test@pve
```

### Realms

Proxmox realms are authentication backends. These realms define how and where
Proxmox verifies a user's credentials.  

A base Proxmox installation has two "realms" by default.  

1. `pve`
2. `pam`

See them with:
```bash
sudo pveum realm list
```


#### `pve` Realm

The `pve` realm is Proxmox VE's internal authentication realm.  
It's managed entirely inside Proxmox, **not** the Linux OS.  
The internal configuration database for this realm is in `/etc/pve/user.cfg`.  

Adding a user in this realm will not add a Linux user account.  

This realm is mainly intended for application integrations (e.g., Terraform,
Ansible, etc.).  

If we want to associate Proxmox API keys with a user account, create the new 
user in the PVE realm.  
```bash
pveum user add terraform@pve
```
- We can also verify the realm name before adding if we want:
  ```bash
  pveum realm list
  ```

#### `pam` Realm

The `pam` realm uses the underlying systm's `/etc/passwd` as well as PAM
(Pluggable Authentication Modules).  

Users in this realm *must* exist as Linux users on the PRoxmox host.  
In the `pam` realm, passwords are verified using the same Linux PAM stack as
SSH.  

When attempting to add a user in the PAM realm, the user account must already 
exist on the base Linux system.  

```bash
sudo useradd -m terraform
passwd terraform
pveum user add terraform@pam
```

When using the PAM realm, we can't create API tokens for the user. PAM is
password-based auth only.  


