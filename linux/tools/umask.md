# `umask`

The `umask` (user file creation mask) is not just a tool on Linux, it's a low-level
setting that shapes file permissions behind the scenes.  

It defines the **default permissions** for new files and directories that a user
creates.  

## How the `umask` Works

The `umask` is like a filter that subtracts permissions from a full set.  

It specifies a *mask* of bits to be removed from a file's **mode** attributes using
octal notation.  

When a file or directory is created, files get base permissions of `0666`
(`-rw-rw-rw-`), and directories get base permissions of `0777` (`-rwxrwxrwx`).  

Then the `umask` is *subtracted* ([bitwise](#bitwise-operation)) from these base permissions.  

---



## Bitwise Operation

The `umask` is applied as a bitwise operation on new file creation.  

This is done with a bitwise `AND` using the bitwise **inverse** of the umask.  

An example: 
```bash
umask 0022
```

- File default is `0666` (binary `110 110 110`)
- `umask` is `0022` (binary `000 010 010`)
    - It uses the bitwise inverse (`111 101 101`) for this operation under the hood.  


We use a bitwise `NOT` on the umask to get the bitwise inverse of the umask and then 
use that to bitwise `AND` with the default file permissions.  
```bash
  110 110 110  # Default permissions
& 111 101 101  # Bitwise NOT (inverse) of the umask (~000 010 010)
-------------
  110 100 100  # 0644 = -rw-r--r--
```

So basically this is the formula:
```bash
final_perms = default_perms & ~umask
```

The `&` is a bitwise `AND`, and the `~` is a bitwise `NOT`.  


The bitwise operation is done per-bit, so it's more granular than just "subtracting" in
decimal.  

---

An easy way to remember what the final permissions will be with any given umask is to
just substract the umask (per digit) from the default permissions.  

When creating a normal file with a umask of `0022`, we'd subtract `0022` from `0666`
(per-digit).  
```bash
  0666
- 0022
------
  0644
```


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
So `newdir` will have the permissions `0755` (`drwxr-xr-x`)

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

Then we have `0027`, which removes access to any users that are neither the owner nor group
members.   
```bash
umask 0027
touch newfile # 0666 - 0027 = 0640 (-rw-r-----)
mkdir newdir  # 0777 - 0027 = 0750 (drwxr-x---)
```
This umask value removes all access from "others" (not owner or group member), and 
removes write access from group memebers.    

---

## Three v. Four Digits

You'll usually see the umask represented as either three or four numbers.  

```bash
umask 022
umask 0022
```

Both of these are valid.  
The leading `0` on the second example is just indicating the the value is octal.  
This is good practice, but the leading zero is optional.  
You can use just three numbers if you want.  


## Looking at the Docs

If you look into the documentation for the actual system calls being made when
creating new files, you can see how the permissions are calculated.  

For example, in the `mkdir()` C function (`man 2 mkdir`), you'll see
in the description how the permissions are calculated for the newly created
directory.  

```c
int mkdir(const char *pathname, mode_t mode);
```

> It is modified by the process's umask in the usual way: in the absence of a default 
> ACL, the mode of the created directory  is (`mode & ~umask & 0777`).

So we have the `mode`, specified in the function call. That number is then bitwise
`AND`'d with the inverse (`~`) of the `umask`, and finally bitwise `AND`'d again with
the default permissions of directories (`0777`).


## Default UMASK for New Users

The `umask` values are stored in `/etc/login.defs`.  

This is where `pam_umask` gets its value. It sets the **default umask for new
home directories** when creating users via `useradd`.  

Modifying the umask here will not modify it for accounts that already exist.  

```bash
grep -in 'umask' /etc/login.defs
```
You'll see a line that says:  
```bash
UMASK		022
```

This is the default umask. Your number may be different, `022` is the
"historical" default umask value for Debian.  

!!! notes

    If `HOME_MODE` is also set in `/etc/login.defs,` that will take priority when 
    adding a new user. If that setting is not present in `/etc/login.defs`, then the 
    `UMASK` value is used to calculate the mode.  

Check for the `HOME_MODE` setting:
```bash
grep -in '^HOME_MODE' /etc/login.defs
```

