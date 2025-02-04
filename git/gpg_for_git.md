# GPG for Git  
For more information on just GPG, see `../linux/tools/gpg.md`

## Table of Contents
* [Adding a GPG Key to Github](#adding-a-gpg-key-to-github) 
    * [Generate a New GPG Key](#generate-a-new-gpg-key) 
    * [Add the New GPG Key to Github](#add-the-new-gpg-key-to-github) 
* [Signing Commits with GPG](#signing-commits-with-gpg) 
* [Plain GPG Protected Credential Helper](#plain-gpg-protected-credential-helper) 
    * [Using GPG for Github Authentication](#using-gpg-for-github-authentication) 
* [Setting up a GPG Agent](#setting-up-a-gpg-agent) 

## Adding a GPG Key to Github  

### Generate a New GPG Key  
First, you'll need to generate a GPG key before you can add it to Github.  
1. Run the command to generate a new key:  
    ```bash  
    gpg --full-generate-key  
    ```
2. Specify the type. RSA (default) is good. 
3. Specify key size (4096)  
4. Enter when key will expire   
    * This is optional. You can leave it blank if you don't want the key to expire.  
5. Verify  
6. Enter your user info 
    * **Note**: Use the email associated with your GitHub account. 
7. Set a password

---  

### Add the New GPG Key to Github

1. List your GPG keys to find the Key ID.
   ```bash  
   gpg --list-secret-keys --keyid-format=long  
   ```
    * You will see an output that looks like this:  
      ```bash  
      /home/user/.gnupg/secring.gpg  
      -----------------------------  
      sec   4096R/<Your-Key-ID> 2021-01-01 [expires: 2024-01-01]  
      # or  
      sec   rsa4096/<Your-Key-ID> 2021-01-01 [expires: 2024-01-01]  
      ```
    * Take `<Your-Key-ID>`. This is your Key ID.  

1. Add the public key to GH account.  
    * Export your public key using your Key ID: 
      ```bash  
      gpg --armor --export <Your-Key-ID>  
      ```
        * If you want, redirect to a file (` > gpg_key.txt`) for easy copypasta.  
    * On Github, go to Profile -> Settings -> SSH and GPG keys.  
    * Select "Add GPG Key", and paste your public key.  


## Signing Commits with GPG  
1. Configure Git to use your GPG key.  
    * Set your `signingkey` in your `.gitconfig`:  
      ```bash  
      git config --global user.signingkey <Your-Key-ID>  
      ```
    * To sign all commits by default in any local repository on your computer:  
      ```bash  
      git config --global commit.gpgsign true  
      ```

## Plain GPG Protected Credential Helper  
Using GPG authentication with git is not as straightforward as using
SSH authentication.  
You have to set up a credential helper and then set up a password manager.  

### Using GPG for Github Authentication
* If you're using HTTP/HTTPS authentication, and you want to authenticate with  
  your GPG key, you can set up a credential helper:  
  ```bash  
  git config --global credential.credentialStore gpg  
  ```
* Initialize `pass` with the Key ID you got when you generated the GPG key.
  ```bash  
  pass init <Your-Key-ID>  
  ```

## Setting up a GPG Agent
By default, GPG requires a passphrase every time you use it (e.g., to sign a commit).  
You're able to cache the passphrase by using `gpg-agent`.  
To enable caching, set up `gpg-agent` by adding a few entries into `~/.gnupg/gpg-agent.conf`:  
```bash
mkdir ~/.gnupg
echo "default-cache-ttl 600" >> ~/.gnupg/gpg-agent.conf
echo "max-cache-ttl 7200" >> ~/.gnupg/gpg-agent.conf
```
* `default-cache-ttl 600`: Caches the passphrase for 10 minutes.  
* `max-cache-ttl 7200`: Maximum cache duration of 2 hours.  

Restart the GPG agent:
```bash
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
```

---
If you're using GPG to sign Git commits, make sure Git is using `gpg-agent` by adding
an entry into `~/.bashrc`:
```bash
export GPG_TTY=$(tty)
```
Reload bash with `exec bash -l` or `source ~/.bashrc` and you're set.  


