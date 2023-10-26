# Generating a SSH Key For Github

### Generating a Permanent SSH Key

```bash
ssh-keygen -C mycomment -f /tmp/somekey -t ed25519
```  

* Note: The comment can be safely deleted from the public key.  

```output
Generating public/private ed25519 key pair.
Your identification has been saved in /tmp/somekey
Your public key has been saved in /tmp/somekey.pub
The key fingerprint is:
SHA256:QeV8u/MLKQ6eOt+eXIE+QfuFmW5Mhkp/puuiYFTFdHg mycomment
The key's randomart image is:
+--[ED25519 256]--+
|       o+oo      |
|       oo+E      |
|      . ..+ .    |
|     .   o = =   |
|    .   S = O .  |
|   .   . + B =   |
|    o   o = &    |
|   . ....* X +   |
|      o=++X.  o. |
+----[SHA256]-----+
```

When this is added to `~/.ssh/authorized_keys` it will have generic comments.  

In `/tmp/somekey.pub` you'll find the key to add to Github.  

Then configure Git to use SSH as its default URL:
```bash
git config --global url.ssh://git@github.com/.insteadOf https://github.com/
```


For setting up a user's access on a server, the key should go to `/root/.ssh/username_ed25519`.  





### Generating a Temporary SSH Key
> Credit for the information: rwxrob

Sometimes a generic SSH key pair is needed for testing or other purposes where using a user's
specific key is less desirable. In these cases, just overwrite the comment and force the key pair
to be written in some place else. That key can then be used with `ssh -i <path>`. 
```bash
ssh-keygen -C mycomment -f /tmp/somekey -t ed25519
ssh -i /tmp/somekey server
```
The `-i` flag specifies the identity file to use.
This has the advantage of not giving up user-specific information in examples and such.


