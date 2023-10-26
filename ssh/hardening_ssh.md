

# Hardening SSH (Tell OpenSSH Who To Allow)

## Overview

I found multiple attempts to login to my server via SSH. All of these attempts failed due to wrong
passwords or non-existent usernames.
So even though no one succeeded in getting in to my server, I still want to make sure no one can
get in unless I want them to.

To do this, I changed the SSH configuration to only allow those with authorized SSH keys to connect.

### Generating a Key

Server = Remote Machine
User = Local Machine

On the User's end, generate an SSH key:
```bash
ssh-keygen -t ed25519
```
Then, grab the public key (NOT THE PRIVATE KEY!) from `~/.ssh/id_ed25519.pub`.
Public keys will always end with `.pub`.
```bash
cat ~/.ssh/id_ed25519.pub
```

### Authorizing The User

On the Server, add the entire contents of the public key file to `~/.ssh/authorized_keys`.
If the file doesn't exist, create it.


### Change Authentication Method of SSH

Now we need to go to your SSH configuration file, and change a few things.

1. Open `/etc/ssh/sshd_config` as root (`sudo`):
    ```bash
    sudo vi /etc/ssh/sshd_config
    ```
    * Make sure to run with `sudo`, since this file requires root access to write to.

2. Find `PermitRootLogin`, uncomment it and change to `no`:
    ```sh
    PermitRootLogin no
    ```

3. Do the same for `PasswordAuthentication`:
    ```sh
    PasswordAuthentication no
    ```

4. Find `AuthorizedKeysFile` and uncomment it.
    * It should look like this:
    ```bash
    AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2
    ```

5. Add a new setting called `AuthenticationMethods` and set it to `publickey`:
    ```sh
    AuthenticationMethods publickey
    ```

6. Now just reload SSH with the following command:
    ```sh
    sudo systemctl restart ssh
    ```

Now your server should only accept SSH connections from the machine you generated the SSH key with.



