# GNU Privacy Guard (GPG)

## Generating a New GPG Key

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
    * **Note**: Use the email associated with your Github account to use with Github. 
7. Set a password

## Exporting the Public Key

Before you can export your public key, you'll need to get the Key ID associated with it.

* To get the Key ID, run the following command:
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

Now you can export your public GPG key using your Key ID. 
* Run the following command:
  ```bash
  gpg --armor --export <Your-Key-ID>  
  ```
* You can easily redirect to a file for convenience.
  ```bash
  bash gpg --armor --export <Your-Key-ID> > gpg_key.txt
  ```

---

To export your public GPG key(s) based on your email address (which is associated with the key) 
instead of the Key ID, run the following command:
```bash
gpg --armor --export <EMAIL>
```

## Other GPG Information

### Revoking Keys (Creating a Revocation Certificate)
Create a revocation certificate in case you need to revoke your key in the future:
```bash
gpg --gen-revoke <Your-Key-ID>
```

### Trust Levels
Understand and set the trust level of keys.
```bash
gpg --edit-key <Your-Key-ID>
```

### Back Up Your GPG Keys!
It's crucial to back up both your public and private keys, as
well as the revocation certificate.

### Using GPG Agent
A GPG agent can remember your passphrase for a specified period, making
repeated signing less tedious.

### GPG in Different Environments
Be aware of how GPG works on different operating systems, especially
if you’re using multiple machines.




