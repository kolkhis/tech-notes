
# Finding Files - Using `find`

* `tree -I '.git'` - Tree view of current directory and subdirectories.
    * -I(gnore) the `.git` directory.
* `ls -I '.git'` - List current directory.
    * -I(gnore) the `.git` directory.
* `ls -I '.git' **/*.md` - List all markdown in current directory and subdirectories.
    * -I(gnore) the `.git` directory.

## The `find` Command
The king: `find`. Has 5 "main" arguments.  
`-H`, `-L`, `-P`, `-D` and `-O` must appear before the first path name if used.  
You can specify the type of regex used with `-regextype` (`find -regextype help`)  



## Quick Overview of File Timestamps
| **Attribute** | **Meaning**                                           |
|---------------|-------------------------------------------------------|
|   `atime`     | file ***Accessed*** time                              |
|   `mtime`     | file's ***contents*** ***Modified*** time             |
|   `ctime`     | file's ***metadata OR contents*** ***Changed*** time  |

* `stat {file}` will show all three of `{file}`'s timestamps.
 
* Modification Time: `ls -lt` will list files with their modification times.
* Access Time: Use `ls --time=atime -lt` to list files with access times.
* Change Time: Use `ls --time=ctime -lt` to list files with change times.

## tl;dr: Examples

* Skipping directories (Omitting directories)  
To **SKIP** the directory `./src/emacs` and print all other files found:
```bash
find . -path ./src/emacs -prune -o -print
```

---

* Searching files by age
Search for files in your home directory that've been modified in the last 24 hours:  
```bash
find $HOME -mtime 0
```


* Searching files by permissions
```bash
find . -perm -220  # Match if given permissions are there. Can have more permissions.
find . -perm 220  # Match if ONLY the given permissions are there. 
find . -perm /220   # Matches if ANY of the given permissions are there.
find . -readable    # Checks that 'r' is present for current user
find . -writable    # Checks that 'w' is present for current user
find . -executable  # Checks that 'x' is present for current user
find . \! -executable  # Checks that 'x' is absent for current user
```


---

* Executing a command on a file  
In this example, we're using `cat`:
```bash
find . -name 'target.md' -exec cat ';'
```

---

* Executing a command for each file  
Run `my_script` on every file in or below the current directory:
```bash
find . -type f -exec my_script '{}' \;
```

---

* Executing a command on **all** files simultaneously  
Pass all files to `my_script` as arguments:
```bash
find . -type f -exec my_script '{}' +
```

---

* Searching files by permissions (more in [Permission Searching](#Permission-Searching))  
Search for files that are executable but not readable:  
```bash
find /sbin /usr/sbin -executable \! -readable -print
```
Search for files with read and write permission for their owner, and  group, but
which other users can read but not write to.
```bash
find . -perm 664
```

---


### `find` Options
### Global Options
* `-depth`: Process each directory's contents before the directory itself.  
    * `-d`: POSIX-compatible `-depth`
    * The `-delete` action also implies `-depth`.
* `-ignore_readdir_race`: `find` won't give an error message when it fails to `stat` a file.
    * `-noignore_readdir_race`: Turns off the effect of `-ignore_readdir_race`.  
* `-maxdepth levels`: Descend at most `levels` levels of directories below the starting points.
* `-mindepth levels`: Don't apply any tests or actions at levels less than `levels`.
* `-mount`: Don't descend directories on other filesystems.
    * An alternate name for `-xdev`, for compatibility with some other versions of `find`.
* `-noleaf`: Don't optimize by assuming that directories contain 2 fewer subdirectories than their hard link count (`.` and `..`).
    * This option is needed when searching filesystems that don't follow the Unix 
      directory-link convention, like CD-ROM or MS-DOS filesystems or AFS volume mount points.
* `-path pattern`: File name matches shell pattern `pattern`.  
    * The metacharacters do not treat  `/`  or  `.` specially; so, for example,
    ```bash
    find . -path "./sr*sc"
    ```
     will print an entry for a directory called `./src/misc`.


* `-follow`: Deprecated - use `-L` instead
* `-help` / `--help`: help.



### Change How `find` Handles Symbolic Links
The first 3 deal with symbolic links:
* `-P`: Never follow symbolic links. (default)
* `-L`: Follow symbolic links
* `-H`: Don't follow symbolic links, except while processing the command line arguments.

### Get Diagnostic Information from `find`
* `-D debugopts`: Print diagnostic information; 
    * use to diagnose problems with why find is not doing what you want.
    * `debugopts` should be comma separated. 
    * `find -D help` for full list of options.
        * `exec`: info on `-exec`, `-execdir`, `-ok`, & `-okdir`  
        * `all`: enables all of the other debug options (except help)

### `find` Query Optimization
* `-Olevel`:  Enables query optimisation. *Should* make `find` run faster or consume less resources.
    * `-O0`:  Same as `-O1`
    * `-O1`:  Default.
    * `-O2` and `-O3`: More optimized stuff, rtfm 🙃


## Testing Files with `find`
There are a ton of tests available to `find`.  

Some tests, allow comparison between the file currently
being examined and some reference file specified on the command line.
( for example `-newerXY` and `-samefile`, `-cnewer`, `-anewer`, `-newer` ).  
See [Timestamps Explained](#timestamps-explained).  

A  numeric  argument  `n`  can  be  specified to tests (like `-amin`, `-mtime`, `-gid`, `-inum`, `-links`, `-size`, `-uid` and `-used`)  
* `+n`: for greater than `n`
* `-n`: for less than `n`
* `n`:  for exactly `n`


* `-regex pattern`: File name matches regular expression `pattern`.
    * `-iregex pattern`: Like `-regex`, but the match is case insensitive.

* `-path pattern`: File name matches shell pattern `pattern`.
    * `-ipath pattern`: Like `-path` but the match is case insensitive.
    * `-iwholename pattern`: See `-ipath`. This alternative is less portable than `-ipath`.
    * `-wholename pattern`: See `-path`. This alternative is less portable than `-path`.

* `-name pattern`: Base of file name (the path with the leading directories removed) matches shell pattern pattern.
    * The file names considered for a match  with  `-name` will never include a slash, 
        * `-name a/b` will never match anything
        * (you probably need to use `-path` instead).

    * `-iname pattern`: Like `-name`, but the match is case insensitive.
    * `-lname pattern`: File is a symbolic link whose contents match shell pattern `pattern`.
    * `-ilname pattern`: Like `-lname`, but the match is case insensitive.


* `-type c`: File is of type c:
    * `b`:  block (buffered) special
    * `c`:  character (unbuffered) special
    * `d`:  directory
    * `p`:  named pipe (FIFO)
    * `f`:  regular file
    * `l`:  symbolic  link  
        * this is never true if the `-L` option or the `-follow` option is in effect, 
          unless the symbolic link is broken. 
            * If you want to search for  symbolic links when -L is in effect, use -xtype.
    * `s`:  socket
    * `D`:  door (Solaris)
* `-xtype c`: The same as `-type` unless the file is a symbolic link.

---

### Users and Groups
* `-user uname`: File is owned by user `uname` (numeric user ID allowed).
* `-nogroup`: No group corresponds to file's numeric group ID.
* `-nouser`: No user corresponds to file's numeric user ID.
* `-gid n`: File's numeric group ID is less than, more than or exactly `n`.
* `-group gname`: File belongs to group `gname` (numeric group ID allowed).
* `-uid n`: File's numeric user ID is less than, more than or exactly `n`.

### Permissions
* `-perm mode`: File's permission bits are **exactly** `mode` (octal or symbolic).
* `-perm -mode`: **All** of the permission bits `mode` are set for the file.
* `-perm /mode`: **Any** of the permission bits `mode` are set for the file.



---

* `-samefile name`: File refers to the same inode as `name`.

* `-links n`: File has less than, more than or exactly `n` hard links.
* `-inum n`: File has inode number smaller than, greater than or exactly `n`.


* `-size n[cwbkMG]`: File uses less than, more than or exactly `n` units of space, rounding up.
    * `b`: for 512-byte blocks (this is the default if no suffix is used)
    * `c`: for bytes
    * `w`: for two-byte words
    * `k`: for kibibytes (KiB, units of 1024 bytes)
    * `M`: for mebibytes (MiB, units of 1024 * 1024 = 1048576 bytes)
    * `G`: for gibibytes (GiB, units of 1024 * 1024 * 1024 = 1073741824 bytes)

* `-context pattern`: (SELinux only) Security context of the file matches glob pattern.
---
* `-false`: Always false.
* `-true`:  Always true.

* `-empty`: File is empty and is either a regular file or a directory.

* `-readable`: Matches files which are readable by the current user.

* `-writable`: Matches files which are writable by the current user.

* `-executable`: Matches files which are executable and directories which are searchable 
                 by the current user.

* `-fstype type`: File is on a filesystem of type type.
    * An incomplete list: `ufs`, `4.2`, `4.3`, `nfs`, `tmp`, `mfs`, ` S51K`, `S52K`
    * You  can  use `-printf` with the `%F` directive to see the types of your filesystems.

## Testing Timestamps of Files with `find`
For testing the timestamps on files:  
* `-daystart`: Measure times from the  beginning of today rather than from 24 hours ago.
(for `-amin`, `-atime`, `-cmin`, `-ctime`, `-mmin`, and `-mtime`)

|   **Option**      |  **Timestamp Tested**              |
|-------------------|------------------------------------|
|   `-amin  ±n`     |   Access Time in Minutes           | 
|   `-atime ±n`     |   Access Time in Days              | 
|   `-cmin  ±n`     |   Status Change Time in Minutes    | 
|   `-ctime ±n`     |   Status Change Time in Days       |
|   `-mmin  ±n`     |   Modification Time in Minutes     | 
|   `-mtime ±n`     |   Modification time in Days        |  
|`-cnewer reference`| Status Change Time of the current file is more recent than`reference` file |
|`-anewer reference`| Access Time of the current file is more recent than `reference` file |

* `±`: Plus or Minus - `n` can be positive or negative.
    * `-amin +5`: Finds files accessed **MORE** than `5` minutes ago.
    * `-amin -5`: Finds files accessed **LESS** than `5` minutes ago.
    * `-amin 5`: Finds files accessed **EXACTLY** `5` minutes ago.


### Other Tests That Use Timestamps

* `-used n`: File was last accessed less than, more 
             than or exactly `n` days after its status was last changed.

* `-newer reference`: Time  of the last data modification of the current file is more recent than that of the last data modification of the `reference` file.

* `-anewer reference`: Time of the last access of the current file is more recent than 
                       that of the  last data modification of the reference file.

* `-cnewer reference`: Time of the last status change of the current file is more recent than
                       that of the last data  modification  of  the `reference` file.



* `-newerXY reference`: Succeeds if timestamp `X` of the file being "found" is newer than timestamp `Y` of the file `reference`.
    * The letters `X` and `Y` can be any of the following letters:
        * `a`:  The access time of the file reference
        * `B`:  The birth time of the file reference
        * `c`:  The inode status change time of reference
        * `m`:  The modification time of the file reference
        * `t`:  reference is interpreted directly as a time





## Performing Actions on Files Using `find`

* `-ls`: True; list current file in ls -dils format on standard output.

* `-delete`: Delete files; true if removal succeeded.

* `-exec command ;`: Execute  command;  true  if  0 status is returned.
* `-exec command {} +`: This variant of the `-exec` action runs the specified `command` on the 
                selected files, BUT:
    * The command line is built by appending each selected 
      file name at the end; 
    * The total number of invocations of the command will be 
      much less than the number of matched files.

* `-ok command ;`: Like -exec but ask the user first.

* `-execdir command ;`
* `-execdir command {} +`: Like  -exec,  but  the  specified  command  is run from the subdirectory containing the matched file, which is not normally the directory in which you started find.
* `-okdir command ;`:
              Like -execdir but ask the user first in the same way as for -ok.


* `-print` True; print the full file name on the standard output, followed by a newline.:

* `-fls file`: True; like -ls but write to file like -fprint.

* `-fprint file`: True; print the full file name into file file.

* `-print0`: True; print the full file name on the standard output, followed  by  a  null  character (instead  of the newline character that -print uses).
* `-fprint0 file`: True;  like -print0 but write to file like -fprint.

* `-fprintf file format`: True;  like -printf but write to file like -fprint.

* `-printf format`: True; print format on the standard output, interpreting `\' escapes and `%' directives.
    * Field widths and precisions can be specified as with the `printf(3)` C function.
    * many of the fields are printed as `%s` rather than `%d`
    * the `-` flag does work (it forces fields to be left-aligned).
    * Unlike `-print`, `-printf` does not add a newline at the end of the string.
    * The escapes and directives are: `:Man find /-printf format`
        * `\a`:  Alarm bell.
        * `\b`:  Backspace.
        * `\c`:  Stop printing from this format immediately and flush the output.
        * `\f`:  Form feed.
        * `\n`:  Newline.
        * `\r`:  Carriage return.
        * `\t`:  Horizontal tab.
        * `\v`:  Vertical tab.
        * `\0`:  ASCII NUL.
        * `\\`:  A literal backslash (`\`).
        * `\NNN`:  The character whose ASCII code is `NNN` (octal).
        * A `\` character followed by any other character is treated as an ordinary character, so
         they both are printed.
        * `%%`:  A literal percent sign.
        * `%a`:  File's last access time in the format returned by the C `ctime(3)` function.
        * `%Ak`: File's  last  access time in the format specified by `k`, which is either `@` or a directive for the C `strftime(3)` function.

* `-prune` True; if the file is a directory, do not descend into it.
    * If  `-depth`  is  given,  then `-prune`  has  no effect.
    * You cannot usefully use `-prune` and `-delete` together.
    To **SKIP** the directory `./src/emacs` and print all other files found:
    ```bash
    find . -path ./src/emacs -prune -o -print
    ```

* `-quit`: Exit immediately (with return value zero if no errors have occurred).


## Permission Searching
```bash
find . -perm -220  # Match if given permissions are there. Can have more permissions.
find . -perm 220  # Match if ONLY the given permissions are there. 
find . -perm /220   # Matches if ANY of the given permissions are there.
```

* Search for files which are executable but not readable.
```bash
find /sbin /usr/sbin -executable \! -readable -print
```

* Search for files with read and write permission for their owner, and  group,  but
   which other users can read but not write to.
Match the given permissions **EXACTLY**.
```bash
find . -perm 664
```
Files with these perms but have other permissions bits set (for example if
someone can execute the file) will not be matched.  

* Search for files which have read and write permission for their owner and group, and
other users can read, without caring about any extra permission bits
(for example the executable bit).  

Doesn't match perms exactly, only checks if the given permissions are present.  
```bash
find . -perm -664
```
This will match a file with 0777 (since 6, 6, and 4 are present).

* Search for files which are writable by somebody (their owner, or their group,  or  any‐
body else).
```bash
# ANY
find . -perm /222
```

* Search for files which are writable by either their owner or their group.

```bash
# ANY
find . -perm /220
find . -perm /u+w,g+w
find . -perm /u=w,g=w
```

All  three of these commands do the same thing, first uses octal, others use symbolic
representation.  
The  files  don't have to be writable by both the owner and group to be matched; either will do.

* Search for files which are writable by both their owner and their group.

```bash
find . -perm -220
find . -perm -g+w,u+w
```
Both these commands do the same thing.



* A more elaborate search on permissions.

```bash
find . -perm -444 -perm /222 \! -perm /111
```
```bash
find . -perm -a+r -perm /a+w \! -perm /a+x
```

These two commands both search for files that are readable for everybody (-perm -444 or
-perm -a+r), have at least one write bit set (-perm /222 or -perm /a+w) but are not ex‐
ecutable for anybody (! -perm /111 or ! -perm /a+x respectively).




## Timestamps Explained
* Access Time (`atime`):
    * This timestamp is updated when the contents of a file are read by any command or application.
* Modification Time (`mtime`):
    * This timestamp is updated when the file's content is modified.
    * If you edit a file and save changes, its modification time is updated.
    * It does not change when the file's metadata (like permissions or ownership) are changed.
* Change Time (`ctime`):
    * Often confused with the modification time, the change time is updated when the
      file's **metadata** *or* **content** is changed.
    * This includes changes to the file's **permissions,** **ownership,** and **content.**
    * It's important to note that `ctime` is not the creation time of the file. Unix and traditional Linux filesystems do not store the creation time of a file.
* `stat {file}` will show all three of `{file}`'s timestamps.
* Modification Time: `ls -lt` will list files with their modification times.
* Access Time: Use `ls --time=atime -lt` to list files with access times.
* Change Time: Use `ls --time=ctime -lt` to list files with change times.


