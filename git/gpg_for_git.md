# GPG for Git  
For more information on just GPG, see `../linux/tools/gpg.md`

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


