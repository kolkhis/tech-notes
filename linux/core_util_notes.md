
## Packages to install when I have Linux on desktop:
#### (Distro? Linux Mint??)

* Awesome WM (Window Manager) 

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

* `cat`

* `read`

* `grep`

* `tr`

* `echo`

* `sed`

* `awk`

* ... what else?
</details>

### Timezone change
#### Get timezone for system:
    * timedatectl
#### Find your timezone:
    * timedatectl list-timezones
#### Change it:
    * timedatectl set-timezone America/New_York


### Tmux vs Screen
#### Multiple user session:
* Both have multi-user support
* Screen allows users to share a session, but be in different windows
      * screen -r sessionowner/[pid.tty.host]
* Tmux session allows users to share a session, but switching windows switches for both users.

* attach to existing session in tmux:
      * `$ tmux attach -t 0`
      * Where 0 is the target session from `tmux ls`





### Cool Vim Tips/Tricks

Putting ! at the end of the command in vim toggles the command on and off.

Registers:
`"tyy` <- yank line to register t
`@t` <- play register as macro

Macros:
`q[char]` <- start recording a macro in the [char] register. q again to stop recording.
`@[char]` <- play the macro

Vim Filters:
`:.![cmd]` <- use the current line as stdin for `[cmd]`, stdout on current line

`<C-o>p` <- quickly pastes register while in insert mode
:h i_ctrl-o 

<details>
<summary>GPG for git</summary>

##### Plain GPG Protected Credential Helper:
1. Set git to use gpg
`$ git config --global credential.credentialStore gpg`

1. Generate gpg key
    1. Run `$ gpg --full-generate-key`
    1. Specify the type. RSA/whatever (default) is good. (is ed25519 available?)
    1. Specify key size (4096)
    1. Enter when key will expire
    1. Verify
    1. Enter User info (Email should be the same as GH account)
    1. Set a password
1. Get the secret key
`$ gpg --list-secret-keys --keyid-format=long`
It will look something like `rsa4096/<secret_key>` under the `sec` section. Only take the key.

1. Init the password with the secret key
`$ pass init <secret_key>`

1. Add the public key to GH account.
    * Get the public key with `$ gpg --armor --export <secret_key>`.
        * ` > gpg_key` for easy copypasta
    * Profile > Settings > SSH and GPG keys. Paste key.
 
</details>

<details>
<summary> Other Git Encryption Solutions:</summary> 

Just use `ssh-keygen`
`git-remote-gcrypt`
`git-secret`
`git-crypt`

BlackBox by StackOverflow

</details>




[![twitter](https://img.shields.io/badge/Twitter-blue?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/null_kol)
[![twitch](https://img.shields.io/badge/Twitch-purple?style=for-the-badge&logo=twitch&logoColor=white)](https://twitch.tv/kolkhis)
[![ko-fi](https://img.shields.io/badge/kofi-pink?style=for-the-badge&logo=kofi&logoColor=white)](https://ko-fi.com/kolkhis)


### Git Commit Messages
<details>
<summary>Git commit message convention</summary>
[type]: [description]

[body]

Where:

[type]: Indicates the type of the commit. It should be one of the following:

* feat: A new feature or functionality added.

* fix: A bug fix or error correction.

* docs: Documentation updates or changes.

* style: Changes to code formatting, indentation, etc.

* refactor: Code refactoring or restructuring without adding new features or fixing bugs.

* test: Adding or updating tests.

* chore: Maintenance tasks or other miscellaneous changes.


[description]: A brief and concise description of the change made in the commit. It should start with a capitalized verb and should not exceed 50 characters.

[body] (optional): A more detailed description of the changes made in the commit. This part is optional but can be useful for providing additional context or information about the changes.
</details>

