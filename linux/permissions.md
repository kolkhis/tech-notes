# Permissions

## Parts of the Permission String

There are 4 parts in the permission string.  
It may look something like this:
```bash
-rwxr-xr-x
```
This represents a basic file.  

The permission string can be broken down into these 4 parts:  

1. The first character indicates the type of file. (`-`)  
   The next nine characters represent the permissions for users,
   broken up into 3 characters for each permission.  
2. user (owner) - (`rwx`)   
3. group - (`r-x`)  
4. others - (`r-x`)  




## File Type Indicator Bit (first bit)
```bash
-rw------
^
# Filetype indicator bit
```

The first character in the permission string indicates the type of file:

* `-`: Regular file.
* `d`: Directory.
* `l`: Symbolic link.
* `c`: Character device file (special file that represents a device).
* `b`: Block device file (special file that represents a device such as a hard disk).
* `s`: Socket (used for IPC - inter-process communication).
* `p`: Named pipe (FIFO).


## Permission Bits

The next nine characters are in three sets of three characters,
each set representing the permissions for the 
user (owner), group, and others:

* `r`: Read permission.
    * For a file, this means the contents of the file can be read.
    * For a directory, this means the contents of the directory can be listed.

* `w`: Write permission.
    * For a file, this means the contents of the file can be modified.
    * For a directory, this means files can be created, deleted, or renamed within the directory.

* `x`: Execute permission.
    * For a file, this means the file can be executed (if it's a program or a script).
    * For a directory, this means the ability to access the directory's contents.


The three sets are:

1. User (Owner) Permissions: The first set of three characters after the file type.
2. Group Permissions: The second set of three characters.
3. Others Permissions: The third set of three characters.



## Special Permission Bits

In addition to `r`, `w`, and `x`, there are a few **special** permissions:

* `s`: **Setuid/Setgid**.
    * Appears in the **`user`** or **`group`** permission field instead of the `x`.
    * If set on a file, the file will execute with the permissions of the file owner or group.

* `t`: **Sticky bit**.
    * Appears in the **`others`** permission field.  
    * Often used on directories, like `/tmp`.  
    * Indicates that only the file owner (or root) can 
      delete or rename files in the directory.  

* `-`: Means the **absence** of a permission.
    * The `-` in a field means that the corresponding set
      of users does not have that permission.


