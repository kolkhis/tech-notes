# `chmod` With Octal Notation

The `chmod` command allows you to change the permissions of a file or directory.  
You can either use symbolic notation for permissions, or use the octal notation for
specifying the permissions.  

Octal notation is a concise way to set permissions on a file or directory.
It's based on the octal (base-8) numbering system, which uses digits from `0` to `7`.


## Table of Contents
* [Basics of Octal Notation](#basics-of-octal-notation) 
* [Permission Values](#permission-values) 
* [Examples](#examples) 
* [Special Permissions](#special-permissions) 
    * [Setuid (Set User ID)](#setuid-set-user-id) 
    * [Setgid (Set Group ID)](#setgid-set-group-id) 
    * [Sticky Bit](#sticky-bit) 
* [Combining Special Permissions](#combining-special-permissions) 


## Basics of Octal Notation

In octal notation, permissions are represented by a three- or four-digit number.  
Each digit represents a permission set:  

1. The first digit sets permissions for the owner.
2. The second digit sets permissions for the group.
3. The third digit sets permissions for others (everyone else).

If present, a fourth digit at the beginning sets special permissions (like the `setuid`,
`setgid`, and `sticky` bits).  

## Permission Values

Each digit in octal notation is the sum of its component permissions:

* Read (`r`) has a value of `4`  
* Write (`w`) has a value of `2`  
* Execute (`x`) has a value of `1`  

## Examples

1. Read, Write, and Execute for Owner; Read and Execute for Group and Others
   ```bash
   chmod 755 file
   ```

    * Owner: `rwx` (`4 + 2 + 1 = 7`)
    * Group: `r-x` (`4 + 0 + 1 = 5`)
    * Others: `r-x` (`4 + 0 + 1 = 5`)

2. Read and Write for Owner; Read for Group and Others
   ```bash
   chmod 644 file
   ```

    * Owner: `rw-` (`4 + 2 + 0 = 6`)
    * Group: `r--` (`4 + 0 + 0 = 4`)
    * Others: `r--` (`4 + 0 + 0 = 4`)

3. Special Permissions
   To set the `setuid`, `setgid`, and `sticky` bits, you can use a fourth digit (at the
   beginning of the number set):
   ```bash
   chmod 1755 file
   ```

    * Special bits: 1
    * Owner: rwx (7)
    * Group: r-x (5)
    * Others: r-x (5)


## Special Permissions
Special permissions like setuid, setgid, and sticky bits are advanced file permissions that provide additional control over file execution and access.


### `setuid` (Set User ID)

* Octal Value: `4`
* Symbolic Notation: s in the owner's execute field
* Effect: When a file with setuid is executed, it runs with the permissions of the 
  file's owner, not the user who ran it.


Example:
```bash
chmod 4755 my_script
```
This sets the setuid bit, making the script run as its owner.


### `setgid` (Set Group ID)

* Octal Value: `2`
* Symbolic Notation: `s` in the group's execute field
* Effect: Similar to setuid but for the group. When a file with setgid is executed, it runs with the permissions of the file's group.

Example:
```bash
chmod 2755 my_script
```
This sets the setgid bit, making the script run as its group.


### `sticky` Bit

* Octal Value: `1`
* Symbolic Notation: `t` in the others' execute field
* Effect: Mostly used on directories. It allows a file to be deleted only by its 
  owner, the directory owner, or the root user, even if the directory has write 
  permissions for others.  

Example:
```bash
chmod 1755 my_directory
```
This sets the sticky bit on a directory, restricting file deletion as described.


## Combining Special Permissions

You can combine these special permissions by adding their octal values:

* Setuid + Setgid: `4 + 2 = 6`
* Setuid + Sticky Bit: `4 + 1 = 5`
* Setgid + Sticky Bit: `2 + 1 = 3`
* All three: `4 + 2 + 1 = 7`

Example:
```bash
chmod 6755 my_script
```
This sets both the setuid and setgid bits.



