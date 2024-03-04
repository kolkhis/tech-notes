

# Hardening SSH with Authorized Keys

## Table of Contents
* [Overview](#overview) 
    * [Generating an SSH Key](#generating-an-ssh-key) 
    * [Authorizing The User](#authorizing-the-user) 
    * [Change Authentication Method of SSH](#change-authentication-method-of-ssh) 

## Overview

I found multiple attempts to login to my server via SSH.  

All of these attempts failed due to wrong
passwords or non-existent usernames.

So even though no one succeeded in getting in to my server, I still want to make sure 
no one can get in unless I want them to.

To do this, I changed the SSH server (`sshd`) configuration to only allow those with 
authorized SSH keys to connect.

* "client" refers to the Local Machine
* "server" refers to the Remote Machine

### Generating an SSH Key

If you don't already have an SSH key, you'll need to generate one.  

On the client, generate an SSH key with:
```bash
ssh-keygen -t ed25519
```
* Optionally you can add a comment to the key with `-C "comment"`.  

Next, grab the public key (NOT THE PRIVATE KEY!) from `~/.ssh/id_ed25519.pub`.
Public keys will always end with `.pub`.
```bash
cat ~/.ssh/id_ed25519.pub
```

### Authorizing The User
On the Server, add the contents of the public key file to `~/.ssh/authorized_keys`.

If the file doesn't exist, create it.


### Change Authentication Method of SSH

Now we need to go to the server's SSH configuration file, and change a few things.

1. Open `/etc/ssh/sshd_config` as root (`sudo`):
    ```bash
    sudo vi /etc/ssh/sshd_config
    ```
    * Make sure to run with `sudo`, since this file requires root access to write to.

2. Find `PermitRootLogin`, uncomment it and change to `no`:
    ```sh
    PermitRootLogin no
    ```
    * This will prevent the root user from logging in via SSH.  

3. Do the same for `PasswordAuthentication`:
    ```sh
    PasswordAuthentication no
    ```
    * This will disable password authentication.  

4. Find `AuthorizedKeysFile` and uncomment it.
    * It should look like this:
    ```bash
    AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2
    ```
    * You can add more files to the list if you want to. 


5. Add the setting `AuthenticationMethods` and set it to `publickey`:
    ```sh
    AuthenticationMethods publickey
    ```

6. Now, reload SSH with `systemctl`:
    ```sh
    sudo systemctl restart ssh
    ```

Now your server will only accept SSH connections from clients that have their
public keys in the `.ssh/authorized_keys` file.  



