

# `ssh-copy-id`

This command makes it easy to set up key-based authentication for SSH.  

## How to use `ssh-copy-id`
* You'll need to have password authentication enabled on the remote server.  
    * Check this in `/etc/ssh/sshd_config`:
      ```bash
      cat /etc/ssh/sshd_config | grep 'PasswordAuthentication'
      ```
      If it's commented out (with a `#`), it will be enabled by default.  

* You'll need a public and private SSH key. See [ssh-keygen](./ssh_keygen.md).  
    * In `~/.ssh/` you should have 2 files.
        * `id_*` where `*` is `rsa`, `ed25519`, etc. This is your private key.  
        * `id_*.pub`, same as above. This is your public key.  
    * If you don't have these, use `ssh-keygen -t ed25519` to generate SSH keys.  


* Use `ssh-copy-id` to login to the server instead of just `ssh`:
  ```bash
  ssh-copy-id user@hostname
  ```
  You'll enter your password, just this once, and SSH will set up key-based
  authentication for you (assuming it's enabled in `sshd_config`).  


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







