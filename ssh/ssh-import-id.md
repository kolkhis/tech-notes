# `ssh-import-id`

This tool allows you to connect to a public key server, retrieve users' public keys,
and append them to the current user's `~/.ssh/authorized_keys` file.  

It can import keys from GitHub or Launchpad.  

## Importing Public Keys from GitHub
There's an additional function from `ssh-copy-id` that will allow you to copy your
GitHub SSH authentication keys instead of your local user's keys.  

The command for this is `ssh-copy-id-gh` (not supported on all distros by default).  
```bash
ssh-copy-id-gh USER_ID_1 [USER_ID_2] ... [USER_ID_n]
# or
ssh-copy-id gh:USER_ID_1 [gh:USER_ID_2] ... [gh:USER_ID_n]
```
There are two ways to do this:
- Use the `ssh-import-id-gh` command.  
- Prepend `gh:` to the user IDs.  

This uses the GitHub API, located at `https://api.github.com/users/%s/keys`, 
where `%s` is the GitHub username.  

This can take several user IDs at once.  

