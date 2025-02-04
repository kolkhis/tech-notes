# Using SSH with Git and GitHub
You can use SSH for both authenticating with GitHub as well as signing commits.  
This can be done with GPG, but SSH is way more straightforward.  

## Generate a New SSH Key
GitHub recently ended support for RSA keys.  
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


## SSH for Authentication
* [Generate a new ssh key](#generate-a-new-ssh-key) if you don't have one.  
* Add your SSH public key (`.pub` suffix) to GitHub as an "Authentication Key".  
    * Settings -> GPG and SSH Keys -> Add SSH Key -> Dropdown -> Authentication Key
* Then use `ssh git@github.com` to test if it worked.  


## SSH 
- Add SSH public key to github as "signing key"
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
# make a commit
git log --show-signature -1
```

