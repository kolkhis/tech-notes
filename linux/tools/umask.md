# `umask`

The `umask` (user file creation mask) is not just a tool on Linux, it's a low-level
setting that shapes file permissions behind the scenes.  

It defines the **default permissions** for new files and directories that a user
creates.  

## How the `umask` Works

The `umask` is like a filter that subtracts permissions from a full set.  

It specifies a *mask* of bits to be removed from a file's **mode** attributes.  

When a file or directory is created, files get base permissions of `0666`
(`-rw-rw-rw-`), and directories get base permissions of `0777` (`-rwxrwxrwx`).  

Then the `umask` is *subtracted* (bitwise) from these base permissions.  

---

### Examples of `umask`

A common umask is `0022`.  

If we have a `umask` of `0022`, we'd subtract `0022` from the default permissions.  
```bash
umask 0022 && touch newfile
```
So `newfile` will have the base permissions of `0666` since it's a normal file.  

Subtract the `umask` from it.  
```bash
0666 - 0022 = 0644
```
So `newfile` will have the permissions `0644` (`-rw-r--r--`).  

---

If we make a directory with the same `umask` of `0022`:
```bash
umask 0022 && mkdir newdir
```

The base permissions of the directory are `0777`.  
```bash
0777 - 0022 = 0755
```
So `newdir` will have the permissions `0755` (`-rwxr-xr-x`)

## Common `umask` Values

Two of the most common default umask values are `0002` and `0022`.  
```bash
umask 0002
touch newfile1 # 0666 - 0002 = 0664
mkdir newdir1  # 0777 - 0002 = 0775

umask 0022
touch newfile2 # 0666 - 0022 = 0644
mkdir newdir2  # 0777 - 0022 = 0755
```

When the `umask` is set to `0000`, it is effectively turned off (which is dangerous,
let's not do that).  

Another common one would be `0077`, which is very restrictive. This gives the owner
full access and no permissions to anyone else.  

```bash
umask 0077
touch newfile # 0666 - 0077 = 0600
mkdir newdir  # 0777 - 0077 = 0700
```

Then we have `0027`, which removes access to any users that are the owner or group
memebers.   
```bash
umask 0027
touch newfile # 0666 - 0027 = 0640
mkdir newdir  # 0777 - 0027 = 0750
```









