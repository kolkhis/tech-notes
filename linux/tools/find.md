
# Finding Files

The bulk of this file is notes on the `find` command.  
Before that, some other commands to find files.  



## Table of Contents
* [`tree`](#tree) 
* [`ls`](#ls) 
* [`which`](#which) 
* [The `find` Command](#the-find-command) 
* [Quick Overview of File Timestamps](#quick-overview-of-file-timestamps) 
* [tl;dr: Examples](#tldr-examples) 
    * [Skipping directories (Omitting directories)](#skipping-directories-omitting-directories) 
        * [If `-prune` doesn't work use an Operator instead](#if--prune-doesnt-work-use-an-operator-instead) 
    * [Finding files that match multiple conditions](#finding-files-that-match-multiple-conditions) 
    * [Searching files by age](#searching-files-by-age) 
* [Executing commands on found file(s)](#executing-commands-on-found-files) 
    * [Executing a command for *each* file found](#executing-a-command-for-each-file-found) 
        * [Grep inside Found Files](#grep-inside-found-files) 
    * [Executing a command on *all* files *simultaneously*](#executing-a-command-on-all-files-simultaneously) 
    * [Searching files by permissions](#searching-files-by-permissions) 
        * [Conditional Search Examples](#conditional-search-examples) 
* [`find` Options](#find-options) 
    * [Global Options](#global-options) 
    * [Change How `find` Handles Symbolic Links](#change-how-find-handles-symbolic-links) 
    * [Get Diagnostic Information from `find`](#get-diagnostic-information-from-find) 
    * [`find` Query Optimization](#find-query-optimization) 
* [Testing Files with `find`](#testing-files-with-find) 
    * [Users and Groups](#users-and-groups) 
    * [Permissions](#permissions) 
* [Testing Timestamps of Files with `find`](#testing-timestamps-of-files-with-find) 
    * [Other Tests That Use Timestamps](#other-tests-that-use-timestamps) 
* [Performing Actions on Files Using `find`](#performing-actions-on-files-using-find) 
* [Operators For Multiple Conditions](#operators-for-multiple-conditions) 
    * [Searching with and/or Examples](#searching-with-andor-examples) 
* [Permission Searching](#permission-searching) 
    * [Searching for Permissions Examples](#searching-for-permissions-examples) 
* [Timestamps Explained](#timestamps-explained) 


## `tree`
* `tree -I '.git'` - Tree view of current directory and subdirectories.  
    * `-I`(gnore) the `.git` directory.  
## `ls`
```bash
ls -I '.git'          # List current directory, -I(gnore) .git/
ls -I '.git' *.md     # List all markdown files in current directory
ls -I '.git' **/*.md  # List all markdown files, recursively (**). Requires `set -o globstar` in bash.
```

## `which`
The `which` command will show you where the executable binary is
for a command or script:  
```bash
which bash
# /usr/bin/bash
```

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
##### Examples start on line 1147 of [man find](`man://find 1147`)

### Skipping directories (Omitting directories) with `-prune`
The `-prune` option tells `find`: "if the file is a directory, don't descend into it."  
This allows you to skip over the contents of a specific directory.  

Skip directories with `find`:
* To **SKIP** a directory and print all other files found:  
  ```bash  
  find . -path ./src/emacs -prune -o -print  # skip the ./src/emacs dir
  find . -name '.git' -prune -o -print       # skip the .git dir
  ```
  So, here, we're using `find` to specifically search for the directory we want to
  skip, then using `-prune` to say "don't descend into this directory."  
  Then, we're using an `OR` operator (`-o`) to `-print` any files that *don't* match
  the pattern.  

* Skip the contents of any `.git` folders, and search for `*.py` files
  ```bash
  find . -path ".git" -prune -o -path "./*.py" -print
  find . -path ".git" -prune -o -name "*.py" -print
  ```

* Exclude **multiple** directories by using the `OR` operator `-o` inside escaped parentheses: `\(  \)`
  ```bash
  find . -type d \( -path ./dir1 -o -path ./dir2 -o -path ./dir3 \) -prune -o -name '*.txt' -print
  ```
    - This evaluates everything in the parentheses first, and then does a `-prune` on
      all the directories found there. Then, it says `-o -name '*.txt' -print` (or, with
      file extension `.txt`, print the output).  

#### If `-prune` doesn't work, use an Operator instead:
Use the `-not` operator:
```bash
find -name "*.md" -not -path "./directory/*"
```

---

### Finding files that match multiple conditions
Check the [Operators for Multiple Conditions](#Operators-for-Multiple-Conditions)
section for more notes on the operators.  

---  

### Searching files by age  
Search for files in your home directory that've been modified in the last 24 hours:  
```bash  
find $HOME -mtime 0  
```

---  

## Executing commands on found file(s)  
### Executing a command for *each* file found  
* Run `cat` on `target.md` if it is found:  
```bash  
find . -name 'target.md' -exec cat '{}' ';'  
```
##### *The braces `{}` and semicolon `;` can either be quoted or escaped.*  

#### Grep inside Found Files
```bash  
find . -name 'target.md' -exec grep -i 'tar.gz' '{}' ';'  
```
This uses `grep` to find the word `tar.gz` inside the found files.  

---  

Run `my_script` on every file in or below the current directory:  
```bash  
find . -type f -exec my_script '{}' \;  
```

---  

### Executing a command on *all* files *simultaneously*  
Pass all files to `my_script` as arguments:  
```bash  
find . -type f -exec my_script '{}' +  
```
* `'{}'` expands to the names of the file(s) that are found with `find`.  
* `+`: Tell `find` to pass **all** files to `my_script` as arguments.  
    * This is different than using `';'`, which passes the found file to `exec` one
      at a time.  
    * More efficient than `;` in this case, which would invoke the script once per file.  

---  

### Searching files by permissions 
More in [Permission Searching](#Permission-Searching).  
###### Note: the `-perm` argument supports both octal notation and symbolic notation (`u=x`, '755' etc)
Overview:  
Examples of checking for files with owner write and group write permissions:
```bash  
find . -perm 220       # Match if ONLY the given permissions are there. (exact match)  
find . -perm -220      # Match if given perms are there. Can have more perms. (match if perms exist)  
find . -perm /220      # Matches if ANY of the given permissions are there.  
find . -readable       # Checks that 'r' is present for current user  
find . -writable       # Checks that 'w' is present for current user  
find . -executable     # Checks that 'x' is present for current user  
find . \! -executable  # Checks that 'x' is absent for current user  
```

The symbolic notation equivalents of those examples:
```bash
find . -perm g=w,o=w    # Must have only the permissions given.  
find . -perm -g=w,o=w   # All given permissions must exist. May have other perms.  
find . -perm /g=w,o=w   # At least one of the permissions must exist.  
```

#### Conditional Search Examples:  
* Search for files in `/sbin` that are executable but not readable:  
```bash  
find /sbin /usr/sbin -executable \! -readable -print  
```

* Search for files in the current directory with read and write permission for their 
  owner, and group, but other users can read but not write to.  
```bash  
find . -perm 664  
```



---  


## `find` Options  
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

A numeric argument  `n`  can be specified to tests (like `-amin`, `-mtime`, `-gid`, `-inum`, `-links`, `-size`, `-uid` and `-used`)  
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
    * The file names considered for a match with  `-name` will never include a slash, 
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
    * `l`:  symbolic link  
        * this is never true if the `-L` option or the `-follow` option is in effect, 
          unless the symbolic link is broken. 
            * If you want to search for symbolic links when -L is in effect, use -xtype.  
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
    * You can use `-printf` with the `%F` directive to see the types of your filesystems.  

## Testing Timestamps of Files with `find`
For testing the timestamps on files:  
* `-daystart`: Measure times from the beginning of today rather than from 24 hours ago.  
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

* `-newer reference`: Time of the last data modification of the current file is more recent than that of the last data modification of the `reference` file.  

* `-anewer reference`: Time of the last access of the current file is more recent than 
                       that of the last data modification of the reference file.  

* `-cnewer reference`: Time of the last status change of the current file is more recent than  
                       that of the last data modification of the `reference` file.  



* `-newerXY reference`: Succeeds if timestamp `X` of the file being "found" is newer than timestamp `Y` of the file `reference`.  
    * The letters `X` and `Y` can be any of the following letters:  
        * `a`:  The access time of the file reference  
        * `B`:  The birth time of the file reference  
        * `c`:  The inode status change time of reference  
        * `m`:  The modification time of the file reference  
        * `t`:  reference is interpreted directly as a time  





## Performing Actions on Files Using `find`
There are several "actions" you can specify when using `find`.  
These actions will determine how the found files will be handled.  
- `-print` (default): Outputs the file names separated by newlines.
- `-print0`: Outputs the file names separated by NULL bytes.  
    - This is generally considered safer since funky filenames won't break
      things.  
- `-printf <format>`: Format print. Doesn't add a newline like `-print`.  
    - Useful for listing extended data about the file (atime, mtime, users, etc.).  
    - Field widths/precision same as `printf()` in C.  
    - Many of the fields are printed as `%s` rather than `%d`
    - The `-` flag does work (it forces fields to be left-aligned).  
- `-fprint <file>`: Same as `-print`, but instead output to `<file>`
- `-fprint0 <file>`: Same as `-print0`, but instead output to `<file>`
- `-fprintf <file>`: Same as `-printf`, but instead output to `<file>`

- `-ls`: List found files just like `ls -dils`.  
- `-fls <file>`: Like `-ls` but write to `<file>`, just like `-fprint`.

- `-prune`: If the file is a directory, don't descend into it.  
    - If `-depth` is specified, `-prune` is ignored.
- `-delete`: Delete found files.
    - This implies `-depth`. So using `-prune` with `-delete` is not effective.
- `-exec {} \;`: Execute a command on the file.  
    - The `'{}'` expands to the current filename. This is optional.
- `-execdir {} \;`: Like `-exec`, but the command run from the directory containing 
  the file.  
- `-ok command \;`: Like `-exec` but asks the user first.
- `-okdir command \;`: Like `-execdir` but asks the user first.
- `-quit`: Just quits.

---

* `-exec command {} +`: Like `-exec` but runs the specified `command` on **all** of 
  the files as arguments to the one command.
    * Works by appending each selected file name at the end. 
    * The number of invocations of the command will be much less than the number of 
      matched files.  

* `-execdir command {} +`: Same as `-execdir`, but with `-exec cmd {} +`


Using `-prune` to **skip** the directory `./src/emacs` and print all other files found:
```bash  
find . -path ./src/emacs -prune -o -print  
```


## Operators For Multiple Conditions


* `-and` / `-a` / `expr1 expr2`
    * Match multiple conditions
        * `-a` and `expr1 expr2` are POSIX-compliant, `-and` is NOT.
    * Putting the expressions next to each other without this operator will have the same effect.
    ```bash
    find . -name '*.py' -and -path './sr*py*'
    find . -name '*.py' -a -path './sr*py*'  # Same thing. POSIX-compliant
    find . -name '*.py' -path './sr*py*'     # Same thing. POSIX-compliant
    ```
    * This will match any `.py` files in `./src/python`.


* `-not` / `\!`
    * Using `-not` is one way to exclude certain files 
        * This is **not** POSIX-compliant.
    * A bang `!` can be used. It needs to be either escaped (`\!`) or quoted (`'!'`).
        * This **is** POSIX-compliant.
    * If whatever follows `-not` or `\!` evaluates to true, it won't match.
    ```bash
    find . -not -type d
    ```
    * This will match everything that isn't itself a directory.


* `-or` / `-o`
    * Or; Match files with either `expr1` or `expr2`
        * `-or` is **not** POSIX-compliant.  
        * `-o` **is** POSIX-compliant.
        ```bash
        find . -type d -o -name '*.txt'
        ```
        * This will match any directory and any `.txt` file.

* Parentheses: Force precedence. Anything in parentheses will be evaluated first.
    * Parentheses either need to be escaped or quoted:
```bash
find . \( -path "./my*pt.py" \) -path './some*path'
find . '( -path "./my*pt.py" )' -path './some*path'
```

### Searching with and/or Examples
```bash
find . -name '*.py' -and -path './sr*py*'   # This will match any `.py` files in `./src/python`.
find . -name '*.py' -a -path './sr*py*'  # Same thing. POSIX-compliant
find . -name '*.py' -path './sr*py*'     # Same thing. POSIX-compliant

find . -type d -o -name '*.txt'             # This will match any directory and any `.txt` file.

find . -not -type d                         # Matches everything that's not a directory
```


## Permission Searching  
There are four main ways to search for permissions.  
One way is to use these:
```bash
find . -readable        # Readable by Current User
find . -writable        # Writable by Current User
find . -executable      # Executable by Current User
find . \! -readable     # NOT Readable by Current User
find . \! -writable     # NOT Writable by Current User
find . \! -executable   # NOT Executable by Current User
```
The next three ways use the `-perm` option.  
Using `-perm 220`, `-perm -220`, and `-perm /220`:  
```bash  
find . -perm 220    # Matches if ONLY the given permissions are there (exact matching). 
find . -perm -220   # Matches if given permissions are there. File can have more than 
#                        just the given permissions.  
find . -perm /220   # Matches if ANY of the given permissions are there.  
```

### Searching for Permissions Examples

* Search for files which are executable but not readable.  
```bash  
find /sbin /usr/sbin -executable \! -readable -print  
```

---

* Search for files with read and write permission for their owner, and group,  but  
   which other users can read but not write to.  
Match the given permissions **EXACTLY**.  
```bash  
find . -perm 664  
```
Files that have these perms, but also have other permission bits set (for example if  
someone can execute the file) will not be matched.  

---

* Search for files which have read and write permission for their owner and group, and  
other users can read, without caring about any extra permission bits  
(for example the executable bit).  

Doesn't match perms exactly, only checks if the given permissions are present.  
```bash  
find . -perm -664  
```
This will match a file with 0777 (since 6, 6, and 4 are present).  

---

* Search for files which are writable by somebody (their owner, or their group,  or any‐  
body else).  
```bash  
# ANY  
find . -perm /222
```

---

* Search for files which are writable by either their owner or their group.  

```bash  
# ANY  
find . -perm /220  
find . -perm /u+w,g+w  
find . -perm /u=w,g=w  
```

All three of these commands do the same thing, first uses octal, others use symbolic  
representation.  
The files don't have to be writable by both the owner and group to be matched; either will do.  

---

* Search for files which are writable by both their owner and their group.  

```bash  
find . -perm -220  
find . -perm -g+w,u+w  
```
Both these commands do the same thing.  


---

* A more elaborate search on permissions.  
```bash  
find . -perm -444 -perm /222 \! -perm /111  
find . -perm -a+r -perm /a+w \! -perm /a+x  
```
* These two commands both search for files that are:  
    1. readable for everybody (`-perm -444` or `-perm -a+r`)  
    1. have at least one write bit set (`-perm /222` or `-perm /a+w`)  
    1. but are not ex‐ ecutable for anybody (`! -perm /111` or `! -perm /a+x` respectively).  

---



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
    * It's important to note that `ctime` is not the creation time of the file.
        * Unix and traditional Linux filesystems do not store the creation time of a file.  
* `stat {file}` will show all three of `{file}`'s timestamps.  
* Modification Time: `ls -lt` will list files with their modification times.  
* Access Time: Use `ls --time=atime -lt` to list files with access times.  
* Change Time: Use `ls --time=ctime -lt` to list files with change times.  

## "Best Practice": Using `-print0`
For "maximum safety," it's recommended to use `-print0` when finding files with `find`.  
This requires the use of `mapfile` instead of `read` when reading the filenames into
an array.  
This is used to make sure filenames with spaces or newlines don't break.  

E.g., reading a list of files into an array variable:
```bash
declare -a FILES
mapfile -d '' -t FILES < <(find . -name '*.md' -print0)
```
- `mapfile`: Reads input and indexes it into an array.  
  - `-d ''`: Use a null character to delimit strings (items in the array).
    - This is necessary since `-print0` separates the filenames with a NULL byte (`\0`).  
  - `-t`: Strips the trailing delimiters (NULL bytes) from files before storing them.  
  - `FILES`: The array name.  
  

The `-print0` ends each filename with a NULL byte instead of a newline.  
So that's why we need to split on `\0` (with `-d ''`).  


## `find` with `-printf`
Using `-printf` allows for some extended control over what, and how, you see output.  
The `-printf` option doesn't add newlines to the end.  
This interprets escapes `\` and `%` directives.  

This can also be used to format the output by padding with spaces or aligning text.  
- E.g., field widths and precision, just like in C.

Escapes and directives can be found at `man://find +710`.  

Printf Directives can be used to find *information* about the file as well, like
permissions, modification times, the files' dirnames, etc..  
Some useful directives:
- `%f`: Get the basename of the files. Like running `basename $file` on each file.  
- `%s`: Size of the file in bytes.

- `%a` will output the file's `atime` (last accessed time - `ctime()` in C).  
    - `%Ak` (where `k` is a C `strftime` format) will print the access time in that
      format. 
- `%c`: Last metadata OR content change time.  
- `%t`: Last modification time.
    - `%Tk` (where `k` is a C `strftime` format)
- `%m`: Octal permission bits.
- `%M`: Symbolic permission bits.
- `%b` will show the amount of disk space used for the file.  
- `%h`: The leading directories of the file's name (all but the actual filename).  
- And many more.

