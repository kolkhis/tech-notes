# Misc. SSH Notes


## Running Sudo Commands over SSH

Use `-t` to run sudo commands over ssh.  

```bash
ssh -t user@target 'sudo echo "hi"'
```
This will prompt you for the `sudo` password for the remote user.  

The `-t` forces a pseudo-terminal allocation.  

