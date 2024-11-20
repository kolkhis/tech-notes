

# `ssh-copy-id`

This command makes it easy to set up key-based authentication for SSH.  
It copies your local public key into the remote server's `authorized_keys` file.  

## Using `ssh-copy-id`
You'll need to have password authentication enabled on the remote server.  

This is enabled by default but if you want to check:  
* Check this in `/etc/ssh/sshd_config` (on the remote server):
  ```bash
  cat /etc/ssh/sshd_config | grep 'PasswordAuthentication'
  # or
  cat /etc/ssh/sshd_config | grep 'AuthenticationMethods'
  ```
    * If `PasswordAuthentication` commented out (with a `#`), it will be enabled by default.  
    * If `AuthentcationMethods` is only set to `publickey`, password authentication will be disabled.  


* You'll also need `PubkeyAuthentication` enabled on the remote server in order to 
  use key authentication after running the command.
  ```bash
  cat /etc/ssh/sshd_config | grep -i 'PubkeyAuthentication'
  cat /etc/ssh/sshd_config | grep -i 'AuthenticationMethods'
  ```
    * If `PubkeyAuthentcation` is commented out, it will be disabled by default, and
      you need to uncomment it.  
    * If `AuthenticationMethods` is set (not commented out), it needs to include `publickey`.  


You'll need a public and private SSH key. See [ssh-keygen](./ssh_keygen.md).  
* In `~/.ssh/` you should have 2 files.
    * `id_*` where `*` is `rsa`, `ed25519`, etc. This is your private key.  
    * `id_*.pub`, same as above. This is your public key.  
* If you don't have these, use `ssh-keygen -t ed25519` to generate SSH keys.  


* Use `ssh-copy-id`:
  ```bash
  ssh-copy-id user@hostname
  ```
  You'll enter your password, just this once, and SSH will set up key-based
  authentication for you (assuming it's enabled in `sshd_config`).  

* Test that it worked by connecting: 
  ```bash
  ssh user@hostname
  ```

### Using `ssh-copy-id` Example 
```bash
# Check your local public key
cat ~/.ssh/id_ed25519.pub
 
# If you don't have one, make one
ssh-keygen -t ed25519 -C "Optional. Comment goes here."

# On the local machine
ssh-copy-id username@remotehost
```
You'll be prompted for the password.  
Then you're done.  
```bash
ssh username@remotehost
```

As long as `PubkeyAuthentication` is enabled on the remote server, then you'll be
able to login without entering a password.  


## How it works

When you login with `ssh-copy-id`, it takes your public key and appends it to the 
remote server's `authorized_keys` file (`/home/user/.ssh/authorized_keys`).  

Step by step:
* It looks in your local machine for your public key (e.g., `~/.ssh/id_ed25519.pub`)
* Then appends it to `/home/user/.ssh/authorized_keys` on the remote server.   
    * It only adds it to the `authorized_keys` file for the user you're logging in as.  
    * If the `authorized_keys` file doesn't exist, this will create one.  

* This also makes sure the correct permissions are set for SSH files.  
    * `700` for the `~/.ssh/` directory.  
    * `600` for the `~/.ssh/authorized_keys` file.  

### Default Supported Key Types 

```bash
~/.ssh/id_rsa
~/.ssh/id_ecdsa
~/.ssh/id_ecdsa_sk
~/.ssh/id_ed25519
~/.ssh/id_ed25519_sk
~/.ssh/id_dsa
```







