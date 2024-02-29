
## Packages to install when I have Linux on desktop:
#### (Distro? Linux Mint??)


* Terminal
    * builtin?
    * Ghostty (hopefully)
* Terminal multiplexer
    * tmux
    * screen
* Window Manager
    * Awesome WM (Window Manager) 
    * i3wm



`man` sections:
   1   Executable programs or shell commands
   2   System calls (functions provided by the kernel)
   3   Library calls (functions within program libraries)
   4   Special files (usually found in /dev)
   5   File formats and conventions eg /etc/passwd
   6   Games
   7   Miscellaneous  (including  macro  packages  and  conventions), e.g.
       man(7), groff(7)
   8   System administration commands (usually only for root)
   9   Kernel routines [Non standard]

Trying `man 8 ls` will look in section 8 for `ls`
`man -f ls` will give the available sections/pages for `ls`.
   
### Core utils to remember
<details>
<summary>Commands</summary>

* `printf`

* `cat`

* `read`

* `grep`

* `tr`

* `echo`

* `sed`

* `awk`

</details>

## Timezone change
* Get timezone for system:
    * `timedatectl`
* Find your timezone:
    * `timedatectl list-timezones`
* Change it:
    * `timedatectl set-timezone America/New_York`


### Tmux vs Screen
#### Multiple user session:
* Both have multi-user support
* Screen allows users to share a session *and* be in different windows.
    * screen -r sessionowner/[pid.tty.host]
* Tmux session allows users to share a session, but switching windows switches for both users.

* Attach to existing session in tmux:
    * `tmux attach -t [session_name]`
    * Where `[session_name]` is the target session from `tmux ls`

* Attach to an existing `screen` session:
    * `screen -r` or `screen -R [session_name]`




### Cool Vim Tips/Tricks

Registers:
* `"tyy` <- yank line to register t  
* `@t` <- play register as macro  

Macros:
* `q[char]` <- start recording a macro in the [char] register. q again to stop recording.  
* `@[char]` <- play the macro  

Vim Filters:
* `:.![cmd]` <- use the current line as stdin for `[cmd]`, stdout on current line  
* `:%! [cmd]` <- use the entire file as stdin for `[cmd]`, stdout on current line
* Pressing `!!` in normal mode will automatically start a filter command
  for the current line (`:.!`)

`<C-o>p` <- quickly pastes register while in insert mode  
:h i_ctrl-o 

<details>
<summary>GPG for git</summary>

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

</details>

<details>
<summary> Other Git Encryption Solutions:</summary> 

* SSH with `ssh-keygen`  
* `git-remote-gcrypt`  
* `git-secret`  
* `git-crypt`  

* BlackBox by StackOverflow

</details>




### Git Commit Messages
<details>
<summary>Git commit message convention</summary>

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
</details>

[![twitter](https://img.shields.io/badge/Twitter-blue?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/null_kol)
[![twitch](https://img.shields.io/badge/Twitch-purple?style=for-the-badge&logo=twitch&logoColor=white)](https://twitch.tv/kolkhis)
[![ko-fi](https://img.shields.io/badge/kofi-pink?style=for-the-badge&logo=kofi&logoColor=white)](https://ko-fi.com/kolkhis)


