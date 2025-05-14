# GNU Privacy Guard (GPG)

GPG (GNU Privary Guard) implements the PGP (Pretty Good Privacy) standard.  
It's used to encrypt and decrypt data.  
It's also used for integrity validation for security.  


## Table of Contents
* [Installing GPG](#installing-gpg) 
* [Generating a New GPG Key](#generating-a-new-gpg-key) 
* [Exporting the Public Key](#exporting-the-public-key) 
    * [Using the Key ID](#using-the-key-id) 
    * [Using the Email Address](#using-the-email-address) 
* [Encrypting a File](#encrypting-a-file) 
* [Decrypting a File](#decrypting-a-file) 
* [Signing and Verifying Files](#signing-and-verifying-files) 
* [Other GPG Information](#other-gpg-information) 
    * [Revoking Keys (Creating a Revocation Certificate)](#revoking-keys-creating-a-revocation-certificate) 
    * [Trust Levels](#trust-levels) 
    * [Back Up Your GPG Keys](#back-up-your-gpg-keys) 
    * [Using GPG Agent](#using-gpg-agent) 
    * [GPG in Different Environments](#gpg-in-different-environments) 
* [The Keyring](#the-keyring) 
* [Keyservers](#keyservers) 
* [File Types](#file-types) 
* [Quickref](#quickref) 



## Installing GPG
GPG is usually already pre-installed on most major Linux distros.  

If you need to update or install GPG, you can use your package manager.  
Install the `gnupg` package.  
```bash
# Debian-based:
sudo apt-get update && sudo apt-get install gnupg
# RedHat-based:
dnf install gnupg
```


## Generating a New GPG Key
Generate a new GPG key pair (public/private key pair).  

1. Run the command to generate a new key:  
    ```bash  
    gpg --full-generate-key  
    ```
2. Specify the type. RSA (default) is good. 
3. Specify key size (4096 is recommended for security).    
4. Specify an expiration date for the key.  
    * Optional. You can leave it blank if you don't want the key to expire.  
5. Enter your user info  
    * **Note**: Use the email associated with your Github account to use with Github. 
6. Set a password

Then GPG will create the key pair.  
Verify by listing your keys:
```bash
gpg --list-keys
```
This displays public keys. To see private keys:
```bash
gpg --list-secret-keys
```

Each key pair will have its own unique key ID and fingerprint, as well as an 
associated email and user ID.  

You can have multiple key pairs if you need.  
GPG maintains them all in your keyring.  
You can specify which key to use by their Key ID, fingerprint, or associated email.  


## Exporting the Public Key
Exporting the GPG public key creates a file that you can share.  
It will allow other people to encrypt files for you and verify files you've signed.  

You can export your public key either by using the Key ID or the email associated with the key.  
They both achieve the same result.  


### Using the Key ID
Using the Key ID to export the public key is far more accurate

* To get the Key ID:
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
* `<Your-Key-ID>`: This is your Key ID.  

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

### Using the Email Address
If you don't want to use the key ID, you can just use the email address associated
with the key.  

To export your public GPG key using the email address associated with the key:
```bash
gpg --armor --export <EMAIL>
```


## Encrypting a File
If you're using PGP to communicate with someone, you'd use someone elses public key to encrypt a file.  

* Import their public key:
  ```bash
  gpg --import their_publickey.asc
  ```
* Encrypt the file:
  ```bash
  gpg --encrypt --recipient their_email@example.com file.txt
  ```
    * `--encrypt`: Encrypts the file.  
    * `--recipient`: Specifies the email of the public key owner.  
        * GPG determines which key to use based on the email you specify in `--recipient`.  
        * You can use a Key ID or fingerprint here instead of an email if you need to.  
            * If you have multiple keys with the same email, use the key ID or fingerprint.  
        * GPG allows partial name matches too, but this can be ambiguous.  
    * `file.txt`: The file to encrypt.  
This creates a file named `file.txt.gpg`.  
It's encrypted and can only be decrypted with the private key that matches the public key.  

## Decrypting a File
If you receive an encrypted file that was encrypted using your public key, you 
can decrypt it with your private key.  

```bash
gpg --decrypt file.txt.gpg
```
If it was encrypted with your GPG public key, GPG will prompt you for your private
key passphrase and decrypt the file.  

You can also save the output to a file:
```bash
gpg --output decrypted_file.txt --decrypt file.txt.gpg 
```

You don't need to specify which key to use to decrypt the file.  
GPG tries all your private keys in your keyring until it finds the one that matches the encryption.  


## Signing and Verifying Files
Ensuring authenticity is a common use case for GPG.  
Signing files is a way to verify integrity.  

There are three main ways to sign a file:

* To sign a file inline:
  ```bash
  gpg --armor --sign file.txt
  ```
  This generates a `file.txt.asc` file containing your signature.  
    * The file remains readable, but now contains an embedded signature that allows
      others to verify it. 
    * The file is not encrypted when doing this.  

* To just sign a file without changing its contents:
  ```bash
  gpg --clearsign file.txt
  ```
  This will generate a `file.txt.asc` that contains the original content and the signature.  
  This will be plaintext.  

* To include a separate file containing the signature:
  ```bash
  gpg --armor --detached-sign file.txt
  ```
    * This will generate a separate `file.txt.sig` file that contains the signature that
      others can use to validate.  
    * The original file will remain unchanged.  
    * If you need the signature file to be human-readable, use the `--armor` option.  


* If someone sends you a signed file, you can verify the signature using their public key.  
  To verify a signature:
  ```bash
  gpg --verify file.txt.asc
  ```
  This checks the signature against their public key in your keyring.  
    * You need to have imported their public key in order for this to work.  

* When someone gets your signed file, they can use your public key to verify
  integrity and authenticity.  
  ```bash
  gpg --verify file.txt.sig file.txt
  ```
    * They will need to have imported your public key into their keyring to do this.  

---
Other `--sign` info:

* If you use `--sign` without other options, GPG creates a "detatched signature" file.  
    * e.g., `file.txt.sig`
* If you use `--clearsign`, it embeds the signature within the file, but the content
  remains readable.  
* If you use `--sign` with `--armor`, it creates an ASCII-armored file (`.asc`).  



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

### Back Up Your GPG Keys
It's crucial to back up both your public and private keys, as
well as the revocation certificate.

* To back up your private key, export it and store it securely (e.g., on an encrypted USB drive).  
  ```bash
  gpg --armor --export-secret-keys your_email@example.com > privatekey.asc
  ```


Revoke a key if it is compromised.  

* Create a revocation certificate to invalidate your key if it's lost or compromised.  
  ```bash
  gpg --output revoke_cert.asc --gen-revoke your_email@example.com
  ```
* If you need to revoke a key pair, you can do that by importing the revocation certificate.  
  ```bash
  gpg --import revoke_cert.asc
  ```
  This will immediately mark the key as revoked.  
* To distribute a revocation if it's on a [keyserver](#keyservers) (mark a key as revoked):
  ```bash
  # after importing the revocation certificate
  gpg --keyserver keyserver.ubuntu.com --send-keys <YOUR_KEY_ID>
  ```
  Anyone that downloads this public key will see it as invalid.  


If you have a keyserver, you can refresh imported keys.  
```bash
gpg --refresh-keys
```


### Using GPG Agent
A GPG agent can remember your passphrase for a specified period, making
repeated signing less tedious.

### GPG in Different Environments
Be aware of how GPG works on different operating systems, especially
if you’re using multiple machines.


## The Keyring
Keys are stored in the keyring:

* Private keys: `~/.gnupg/pubring.kbx`
* Public keys:  `~/.gnupg/private-keys-v1.d/`

These files are managed by GPG. You should avoid modifying them directly.  



## Keyservers
A keyserver is a public repository where users can upload their public keys or search
for an download other peoples' public keys.  

Keyservers help make sure people have the most recent and legit public key for you,
which is especially important if you need to revoke/update a key.  

Using a keyserver:

* Upload your public key:
  ```bash
  gpg --send-keys <YOUR_KEY_ID> --keyserver hkp://keys/gnupg.net
  ```
* To fetch a public key:
  ```bash
  gpg --keyserver hkp://keys.gnupg.net --recv-keys <0xKEY_ID>
  ```
* To search for keys:
  ```bash
  gpg --keyserver keyserver.ubuntu.com --search-keys 'their_email@example.com'
  ```

Some popular keyservers:

* `hkp://keys.gnupg.net`
* `hkp://keyserver.ubuntu.com`


## File Types
GPG uses `.kbx` files (keybox files) and `.asc` files (ASCII-armored files).  

* Keybox files are binary files used by GPG to store public keys locally. 
    * This is an internal storage format that GPG reads and writes to when you import
      or manage keys.  
    * These files are not meant to be interacted with by users.  
* ASCII-armored files are plaintext files that store GPG keys or encrypted messages.  
    * The `.asc` format is human-readable.  
    * Often used when sharing keys or signatures via email or text.  
    * You can export keys, encrypt files, or signatures in `.asc` format for easier sharing.  


## Quickref

* Generate a key pair: `gpg --full-generate-key`
* Export your public key: `gpg --armor --export > publickey.asc`
* Encrypt a file: `gpg --encrypt --recipient email file.txt`
* Decrypt a file: `gpg --decrypt file.txt.gpg`
* Sign files: `gpg --armor --sign file.txt`
* Verify signatures: `gpg --verify file.txt.asc`

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


