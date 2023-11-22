

# Getting User Public Keys for Github

## Github

To get a specific user's public keys from Github,
you just need to execute a `curl` command.

```bash
USER="Kolkhis"
curl https://github.com/${USER}.keys
curl https://github.com/${USER}.gpg
```
It's simply `https://github.com/`, followed by the 
target user's username, with either `.keys` or `.gpg`
at the end.  

### .keys

Curling `https://github.com/USERNAME.keys` will return
the public SSH keys for the given username.  

### .gpg

Curling `https://github.com/USERNAME.gpg` will return
the public GPG keys for the given username.  


## Adding to Authorized Keys

If you find the need, you can easily add these keys
to your `~/.ssh/authorized_keys` files with a one-liner.

```bash
USER="Kolkhis"
curl https://github.com/${USER}.keys | tee -a ~/.ssh/authorized_keys
```


## Gitlab

Gitlab will respond the same exact way when using
`curl` on the same endpoint.

```bash
USER="Kolkhis"
curl https://gitlab.com/USER.keys
curl https://gitlab.com/USER.gpg
```






