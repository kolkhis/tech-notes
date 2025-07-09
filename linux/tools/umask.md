# `umask`

The `umask` (user file creation mask) is not just a tool on Linux, it's a low-level
setting that shapes file permissions behind the scenes.  

It defines the **default permissions** for new files and directories that a user
creates.  

## How the `umask` Works

The `umask` is like a filter that subtracts permissions from a full set.  

It specifies a *mask* of bits to be removed from a file's mode attributes.  

When a file or directory is created, files get base permissions of `666`
(`rw-rw-rw-`), and directories get base permissions of `777` (`rwxrwxrwx`).  

Then the `umask` is *subtracted* (bitwise) from these base permissions.  

---

### Examples of `umask`

A common umask is `022`.  

If we have a `umask` of `022`, we'd subtract `022` from the default permissions.  
```bash
umask 0022 && touch newfile
```
So `newfile` will have the base permissions of `666` since it's a normal file.  

Subtract the `umask` from it.  
```bash
666 - 022 = 644
```
So `newfile` will have the permissions `644` (`-rw-r--r--`).  

---

If we make a directory with the same `umask` of `022`:
```bash
umask 022 && mkdir newdir
```

The base permissions of the directory are `777`.  
```bash
777 - 022 = 755
```
So `newdir` will have the permissions `755` (`rwxr-xr-x`)

## Common `umask` Values

Two of the most common umask values are `0002` and `0022`.  

When the `umask` is set to `0000`, it is effectively turned off (which is dangerous,
let's not do that).  









