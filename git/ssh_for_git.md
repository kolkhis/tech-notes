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

## Getting a User's Public Keys from Github

A user's public SSH and GPG keys can be easily retrieved from GitHub.  
If the need ever arises to do this, these notes outline exactly how it's done.  

### Github Endpoints

To get a specific user's public keys from Github, simply execute a `curl` command.

```bash
GH_USER="Kolkhis"
curl https://github.com/${GH_USER}.keys
curl https://github.com/${GH_USER}.gpg
```
It's simply `https://github.com/`, followed by the target user's username, with 
either `.keys` or `.gpg` at the end.  

#### `.keys`

Curling `https://github.com/USERNAME.keys` will return
the public SSH keys for the given username.  

#### `.gpg`

Curling `https://github.com/USERNAME.gpg` will return
the public GPG keys for the given username.  

### Adding to Authorized Keys

These keys can easily be added to the local `~/.ssh/authorized_keys` files with
a one-liner.  
```bash
GH_USER="Kolkhis" curl https://github.com/${GH_USER}.keys | tee -a ~/.ssh/authorized_keys
```
Alternatively, omit the variable and use the username directly.  

### Turning it into a Script

This can be useful for when setting up a new local machine by adding
your own SSH keys from your GitHub account to the `authorized_keys` file on the
new system.  

```bash
#!/bin/bash
# Check inputs: should be `scriptname username provider` 
# or `scriptname username` for github default
if [[ $# -ne 0 ]]; then
    GH_USER="$1"
    shift
    if [[ $# -ne 0 ]]; then
        PROVIDER="$2"
        case $PROVIDER in
            gh|github|github.com)
                GIT_PROVIDER="github.com";
                shift
                ;;
            gl|gitlab|gitlab.com)
                GIT_PROVIDER="gitlab.com";
                shift
                ;;
            *)
                GIT_PROVIDER="github.com";
                shift
                ;;
        esac
    else
        GIT_PROVIDER="github.com"
    fi
else
    printf "You did not specify a username to fetch the keys for!\n"
fi

curl https://${GIT_PROVIDER}/${GH_USER}.keys | tee -a ~/.ssh/authorized_keys
```

### Keys from Gitlab

Gitlab will respond the same exact way when using `curl` on the same endpoint.

```bash
GITLAB_USER="Kolkhis"
curl https://gitlab.com/$GITLAB_USER.keys
curl https://gitlab.com/$GITLAB_USER.gpg
```

