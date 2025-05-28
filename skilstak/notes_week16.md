
# Git

## Git Repos

At the top level of each directory, there is a `.git` folder. 
This is the ONLY thing that identifies a git repository.


* Best Way to Learn Git
`man gittutorial` 
This is the OFFICIAL way to learn git, from the authors of git.

* Minimum set of commands
`man giteveryday` 

* CLI Tool Info
`man gitcli`

### Test if SSH is Set Up on Github

To test if SSH is set up:
`ssh git@github.com`


There are two ways to enable SSH for GitHub:
* Add the key to GH by copy/paste
* Use the gh command line tool itself.

To set up SSH:
1. First, create an SSH key.
    * `ssh-keygen -t ed25519`
    * `ed25519` is optimized for signing.
    * It is safe to use the default file with no passphrase. 
        (passphrase would need to be typed in every single time. it is best practice to have a passphrase for EVERY SSH key)
    * Rob recommends to use no passphrase and regenerate keys frequently.
1. Add the PUBLIC KEY `~/.ssh/id_ed25519.pub` to Github (as "Authentication Key")
    * Make sure it is the `.pub` file.
1. `git clone git@github.com:user/repo-name`




### Git 

* Commit frequently!
* Even pushing frequently is fine!

`git restore <file>` can restore from staged files!

`git add -A .` recursively adds all files in `.` that haven't been committed.


The `gh` tool can handle pretty much anything Git/GitHub-related

#### Merge Conflicts
They suck.

##### Best way for beginners to resolve merge conflicts:
1. Rename the root folder of the repo
1. Clone the remote repo
1. Make the necessary changes from the renamed repo to the cloned repo
1. Push the changes from the cloned repo.
1. `rm -rf renamed_repo`


### Files in `.ssh`:
-rw-------
If these files are too permissive, problems can arise.
NEVER show the `~/.ssh/id_ed25519` to ANYONE.
This is where the SSH private key is stored.

Public key is in `~/.ssh/id_ed25519.pub`
This one is safe to share.

Default `ssh-keygen` will use RSA. ed25519 is safer.


#### Very Secure Way to Store SSH Keys
`KeePassXC`
Extremely secure. A hacker's tool.
Has a built-in SSH agent, allows you to have passphrases on your keys and automatically inputs them.

## SSH Configuration

## Permissions/Ownership
Biggest mistake beginners make: Wrong permissions on files.


Private key - Encodes/encrypts
Public key - Decodes/decrypts



`find .ssh -ls`



`cat ~/.ssh/known_hosts`
Lists the "footprint" of the host. It's the fingerprint that goes alone with the MACHINE at a given IP address.


