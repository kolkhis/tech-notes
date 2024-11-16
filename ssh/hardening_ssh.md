

# Hardening SSH with Authorized Keys


## Table of Contents
* [Overview](#overview) 
* [Authorized Keys](#authorized-keys) 
* [Generating an SSH Key](#generating-an-ssh-key) 
* [Authorizing a User with Public Key Authentication](#authorizing-a-user-with-public-key-authentication) 
* [Change Auth Method of SSH to Public Key Auth Only](#change-auth-method-of-ssh-to-public-key-auth-only) 


## Overview

I found multiple attempts to login to my server via SSH.  

All of these attempts failed due to wrong passwords or non-existent usernames.

So even though no one succeeded in getting in to my server, I still want to make sure 
no one can get in unless I want them to.

---

To that end, I changed the server's SSH configuration (in `/etc/ssh/sshd_config`) to 
only allow those with authorized SSH keys to connect 


* "client" refers to the Local Machine
* "server" refers to the Remote Machine

## Authorized Keys
When an SSH connection is made, and the server's configuration has
`PublicKeyAuthentication yes` set, the server will check the user's `authorized_keys`
file to see if the user is allowed to log in.  

Authorized keys are stored in the remote user's home directory, in `~/.ssh/authorized_keys`.  

For example:
* If I'm trying to log in as `kolkhis@remote-server`, then the `authorized_keys`
  file will be `remote-server:/home/kolkhis/.ssh/authorized_keys`.  

## Generating an SSH Key

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

## Authorizing a User with Public Key Authentication
On the Server, add the contents of the public key file to `~/.ssh/authorized_keys`.

If the file doesn't exist, create it.


## Change Auth Method of SSH to Public Key Auth Only


A quick note:
Using this, you MUST have a public key in the `authorized_keys` file to access
the server. Any other authentication methods will not work.  
Only do this after accessing the server and making sure you have your key in there.
Otherwise you could lock yourself out of the server.  

---

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
    * This is a good security practice (the "Rule of Least Privilege").
    * Any user that needs root access should be in the `sudo` group.  

3. Do the same for `PasswordAuthentication`:
    ```sh
    PasswordAuthentication no
    ```
    * This will disable password authentication.  
    * This is optional, but unless you need to access the server from new devices
      frequently, it's a good idea to disable it.  

4. (Optional) Find `AuthorizedKeysFile` and uncomment it.
    * By default it is `~/.ssh/authorized_keys`, so you really only need to do this
      if you want to use more than one file (like a global file).  
    * It should look like this:
    ```bash
    AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2
    ```
    * You can add more files to the list if you want to. 

5. Add the setting `AuthenticationMethods` and set it to `publickey`:
    ```sh
    AuthenticationMethods publickey
    # Or, if you want to use both password and public key auth:
    AuthenticationMethods publickey,password
    PublicKeyAuthentication yes
    ```
    * `AuthenticationMethods publickey`: Sets public key authentication as the ONLY auth method permitted.
        * This essentially disables password authentication.  
    * `PublicKeyAuthentication yes`: This *enables* public key authentication. 
        * Use this instead if you also want to use other authentication methods.  

6. Now, reload SSH with `systemctl`:
    ```sh
    sudo systemctl restart ssh
    ```

Now your server will only accept SSH connections from clients that have their
public keys in the `.ssh/authorized_keys` file.  



---




