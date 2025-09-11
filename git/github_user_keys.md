# Getting User Public Keys for Github

You can retrieve a user's public SSH and GPG keys from GitHub.  

If you ever find the need to do this, these notes outline how you can.  

## Github Endpoints

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

### Turn it into a Script
```bash
#!/bin/bash
# Check inputs: should be `scriptname username provider` 
# or `scriptname username` for github default
if [[ $# -ne 0 ]]; then
    USER="$1"
    shift
    if [[ $# -ne 0 ]]; then
        PROVIDER="$1"
        case $PROVIDER in
            gh|github|github.com)
                GIT_PROVIDER="github.com";
                ;;
            gl|gitlab|gitlab.com)
                GIT_PROVIDER="gitlab.com";
                ;;
            *)
                GIT_PROVIDER="$1";
                ;;
        esac
    else
        GIT_PROVIDER="github.com"
    fi
else
    printf "You did not specify a username to fetch the keys for!\n"
fi

curl https://${GIT_PROVIDER}/${USER}.keys | tee -a ~/.ssh/authorized_keys
```


## Gitlab

Gitlab will respond the same exact way when using
`curl` on the same endpoint.

```bash
USER="Kolkhis"
curl https://gitlab.com/USER.keys
curl https://gitlab.com/USER.gpg
```






