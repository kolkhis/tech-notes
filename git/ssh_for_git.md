# SSH with Git

You can use SSH for both authenticating with GitHub as well as signing commits.  
This can be done with GPG, but SSH is way more straightforward.  

## Generate a New SSH Key

GitHub does not recommend using RSA keys. The `ed25519` encryption algorithm is
more secure than RSA.  

So, generate a key that uses `ed25519` encryption.  
```bash
ssh-keygen -t ed25519 -C "Optional Comment"
```
The defaults are fine, set a passphrase if you want.  

This will generate two keys: a public key and a private key.  
Never share your private key with anyone.  
```bash
~/.ssh/id_ed25519      # Private key
~/.ssh/id_ed25519.pub  # Public key
```

The public key is the one that you will be using.  

> **Note**: **Never** share your private key with anyone.  


## SSH for GitHub Authentication
* [Generate a new ssh key](#generate-a-new-ssh-key) if you don't have one.  
* Add your SSH public key (`.pub` suffix) to GitHub as an "Authentication Key" (default).  
    * Settings -> GPG and SSH Keys -> Add SSH Key -> Dropdown -> Authentication Key
* Then use `ssh git@github.com` to test if it worked.  
* You can then test if it worked on your command line:
  ```bash
  ssh git@github.com
  ```
  If you set it up properly, you will get the message: 
  ```plaintext
  Hi <your_name>! You've successfully authenticated, bit GitHub does not provide shell access.
  ```


## SSH for Signing Commits
* [Generate a new ssh key](#generate-a-new-ssh-key) if you don't have one.  
* Add SSH public key to github as "signing key"
    * Settings -> GPG and SSH Keys -> Add SSH Key -> Dropdown -> Signing Key

Then configure your local `.gitconfig` to sign commits:
```bash
git config --global user.signingkey "/home/YOUR_USERNAME/.ssh/id_ed25519"
git config --global gpg.format ssh
git config --global tag.gpgsign true
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgSign true
mkdir -p ~/.config/git
touch ~/.config/git/allowed_signers
echo "YOUR_USERNAME $(cat ~/.ssh/id_ed25519.pub)" > ~/.config/git/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
```

Now you can test.  
Make a change, then make a commit.  
Then, run:
```bash
git log --show-signature -1
```

