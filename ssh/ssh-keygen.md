# Generating a SSH Key For Github

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

- For setting up a user's access on a server, the key should go to `/root/.ssh/username_ed25519`.  

- When this is added to `~/.ssh/authorized_keys` it will have generic comments.  

- To configure SSH access for GitHub, check [here](../git/ssh_for_git.md).  




## Generating a Temporary SSH Key

Sometimes a generic SSH key pair is needed for testing or other purposes where using a user's
specific key is less desirable. In these cases, just overwrite the comment and force the key pair
to be written in some place else. That key can then be used with `ssh -i <path>`. 
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

The `-y` prints the corresponding public key to stdout.  


