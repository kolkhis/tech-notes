# Misc Git Notes

## Table of Contents
* [Plain GPG Protected Credential Helper](#plain-gpg-protected-credential-helper) 
    * [Using GPG for Github Authentication](#using-gpg-for-github-authentication) 
    * [Generate a New GPG Key](#generate-a-new-gpg-key) 
    * [Add the New GPG Key to Github](#add-the-new-gpg-key-to-github) 
    * [Signing Commits with GPG](#signing-commits-with-gpg) 
* [Git Commit Message Conventions](#git-commit-message-conventions) 


## Plain GPG Protected Credential Helper  
Using GPG authentication (HTTPS) with git is not as straightforward as using
SSH authentication.  
You have to set up a credential helper and then set up a password manager.  

### Using GPG for Github Authentication
* If you're using HTTP/HTTPS authentication, and you want to authenticate with  
  your GPG key, you can set up a credential helper  

1. Set git to use gpg
```bash
git config --global credential.credentialStore gpg  
```

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


### Signing Commits with GPG  

1. Configure Git to use your GPG key.  
    * Set your `signingkey` in your `.gitconfig`:  
      ```bash  
      git config --global user.signingkey <Your-Key-ID>  
      ```
    * To sign all commits by default in any local repository on your computer:  
      ```bash  
      git config --global commit.gpgsign true  
      ```


#### Other Git Encryption Solutions: 

* SSH with `ssh-keygen`  
* `git-remote-gcrypt`  
* `git-secret`  
* `git-crypt`  

* BlackBox by StackOverflow



## Git Commit Message Conventions

```gitcommit
[type]: [description]

[body]
```

Where:

* `[type]`: Indicates the type of the commit. It should be one of the following:
    * feat: A new feature or functionality added.  
    * fix: A bug fix or error correction.  
    * docs: Documentation updates or changes.  
    * style: Changes to code formatting, indentation, etc.  
    * refactor: Code refactoring or restructuring without adding new features or fixing bugs.  
    * test: Adding or updating tests.  
    * chore: Maintenance tasks or other miscellaneous changes.  


* `[description]`: A brief and concise description of the change made in the commit.
    * It should start with a capitalized verb and should not exceed 50 characters.

* `[body]` (optional): A more detailed description of the changes made in the commit.
    * This part is optional but can be useful for providing additional context or 
      information about the changes.

