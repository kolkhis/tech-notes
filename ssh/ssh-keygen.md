# `ssh-keygen`

The `ssh-keygen` tool is used to manage your local host's SSH keys, generate
new ones, and manage your `known_hosts` file.  

## Generating a Permanent SSH Key

```bash
ssh-keygen -C mycomment -f /tmp/somekey -t ed25519
```  

- `-f /tmp/somekey`: Save the private key to `/tmp/somekey`.  
    - This can be omitted and will default to `~/.ssh/id_ed25519` (or `rsa` if you're
      still using that).  

- `-C mycomment`: An optional comment to add to the end of the key.  
    * **Note**: The `-C mycomment` is optional and can be safely deleted from the public 
      key if you don't want it there.  

The output will look something like this:

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

- For setting up a root user's access on a server, the key should go 
  to `/root/.ssh/username_ed25519`, with their username in the place of `id`.  

- When this is added to `~/.ssh/authorized_keys` it will have generic comments.  

- To configure SSH access for GitHub, check out [SSH for Git/GitHub](../git/ssh_for_git.md).  

## Generating a Temporary SSH Key

Sometimes a generic SSH key pair is needed for testing or other purposes where using a user's
specific key is less desirable.  

In these cases, just overwrite the comment and force the key pair to be written 
in some place else with `-f /path/to/new/privkey`.  
That key can then be used with `ssh -i <path>`.  

```bash
ssh-keygen -C mycomment -f /tmp/somekey -t ed25519
ssh -i /tmp/somekey server
```

The `-i` flag specifies the identity file to use.
This has the advantage of not giving up user-specific information in examples and such.


## Verifying Cryptographic Similarity

You can use `ssh-keygen` to check for cryptographic similarity between the private
key and public key (to make sure they are the correct key pair).  

```bash
# Check the private key
ssh-keygen -y -e -f id_ed25519
ssh-keygen -l -f id_ed25519
# Check the public key
ssh-keygen -y -e -f id_ed25519.pub
ssh-keygen -l -f id_ed25519.pub
```

- `-y`: Reads a private OpenSSH file format and prints a public key to stdout.  
- `-e`: Reads a public or private OpenSSH key file and prints a public key to
        stdout in the format specified by `-m` (defaults to `RFC4716`). 

- `-l`: Prints the fingerprint of a public key file.  
    - If used with a private key, it will print the fingerprint of the
      corresponding public key.  

- `-f`: Specifies the file.  

Then you can compare those two values. If they're the same, they're part of the
same key pair. 

Compare the output with `diff` using process substitution:  
```bash
diff <(ssh-keygen -l -f ./id_ed25519.pub) <(ssh-keygen -l -f ./id_ed25519)
```

## Regenerating a Public Key

If you lose a public key, you can regenerate it using the private key.  

```bash
ssh-keygen -f ~/.ssh/id_ed25519 -y > ~/.ssh/id_ed25519.pub.new
```

The `-y` prints the corresponding public key to stdout, which can then be
redirected into a new public key file.  

## Removing a Key from Known Hosts

If you have a key in your `known_hosts` file that needs to be removed (i.e., the host
key has been changed), you can use `ssh-keygen` to remove it from the `known_hosts` by
using the `-R` flag.  

```bash
ssh-keygen -f ~/.ssh/known_hosts -R destination
```

- `-f`: Specifies the `known_hosts` file to remove the key(s) from.  
- `-R`: Tells `ssh-keygen` to remove all keys belonging to the hostname (`destination`)
        from the `known_hosts` file.  


## Generating Host Keys

Each SSH server has host keys, usually one of each type (rsa, dsa, ecdsa,
ed25519). These host keys live in `/etc/ssh/ssh_host_*`.  

If you happen to get the "Host Key Verification Failed" error, simply removing
the host key from your `known_hosts` file should get rid of this error (see
above).  

However, if the server's keys are somehow lost, or for some other reason you 
need to generate new host keys, this can be done with the `-A` option.  
```bash
ssh-keygen -A
```
This will regenerate the host keys as if it were a fresh installation.  



