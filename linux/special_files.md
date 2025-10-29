# Special Files

The term "special file" on Linux/Unix means a file that can generate or receive data.  
Since "everything is a file™," this includes storage devices, pipes, file
descriptors, and character special files.  

## Common Special Files

- `/dev/null`: A character special file that can receive data.  
- `/dev/random`: A character special file that can generate data.  
- `/dev/sda`: A block special file that can receive and generate data.  

## Creating Special Files with `mknod`
<!-- mknod special files make block device files block files -->
The `mknod` command is used to create block special files, character special files,
or pipes (FIFOs/named pipes).  

The term "special file" on Linux/Unix means a file that can generate or receive data.  

Syntax:
```bash
mknod [OPTION]... NAME TYPE [MAJOR MINOR]
```

- `NAME`: The path to the special file.  
- `TYPE`: You can specify the `TYPE` of file:  
    - `p`: Pipe (FIFO) special file.  
        - Not sure why you'd want to use this over `mkfifo`, but here we are.  
    - `b`: Block device special file. Requires major/minor numbers.  
    - `c`: Character special file. Requires major/minor numbers.  
- `MAJOR`: Major device number (identifies the driver).  
- `MINOR`: Minor device number (identifies the specific device handled by that driver).  

Also see [Special File major and minor numbers](#special-file-major-and-minor-numbers).  


### Example: Creating a Null Device with `mknod`
```bash
ls -l /dev/null
# crw-rw-rw- 1 root root 1, 3 Mar  4 13:38 /dev/null
```
You can see the major and minor numbers of `/dev/null` are `1` and `3` respectively.  
We can use those to duplicate the file with `mknod`.  
```bash
sudo mknod /tmp/mynull c 1 3
sudo chmod 666 /tmp/mynull
```

- This creates a character device at `/tmp/mynull` with major `1` and minor `3`.  
- That matches the null device (`/dev/null`).  

You can also save yourself the `chmod` and use the `-m` option:
```bash
sudo mknod -m 666 /tmp/mynull c 1 3
```

### `mknod` Options

There are two main options/flags for `mknod`.  
One for permissions, the other for SELinux contexts.  

- `-m`/`--mode=`: Specify the `mode` (permissions) for the special file.  
- `-Z`/`--context[=context]`: Specify the SELinux context for the special file.  
    - If `-Z` is used, it adjusts the SELinux context to the
      system default type for the destination file.  
    - If the long option is used, but no context is given, it does the same as `-Z`.  
    - If the long option is used and a context is given, it will set the context for
      the file.  

## Special File Major and Minor Numbers

When specifying either a block or character special file with `mknod`, you need to 
specify major and minor device numbers.  

- The `MAJOR` number tells the kernel which driver to use (e.g., the block driver).  
    - This is like the "class" of device.  
- The `MINOR` number tells the kernel which instance of the device the file refers to.  
    - This is the "specific device in that class."

There are a few ways to determine the major/minor numbers for specific files.  

- You can check major and minor numbers with `stat`.  
  ```bash
  stat /dev/sda
  ```
  Output:
  ```plaintxt
    File: /dev/sda
    Size: 0               Blocks: 0          IO Block: 4096   block special file
  Device: 5h/5d   Inode: 323         Links: 1     Device type: 8,0
  Access: (0660/brw-rw----)  Uid: (    0/    root)   Gid: (    6/    disk)
  Access: 2025-04-28 15:44:20.295315382 -0400
  Modify: 2025-03-04 13:38:48.603526535 -0500
  Change: 2025-03-04 13:38:48.603526535 -0500
   Birth: -
  ```
  You can see the `Device type: 8,0`.  
  This is the major and minor number.  

- Alternatively, you could simply use `file` and it should print the
  major/minor.  
  ```bash
  file /dev/null
  ```
  Output:
  ```plaintext
  /dev/null: character special (1/3)
  ```
  The `1/3` specifies a major number of `1` and minor number of `3`.  

- Or, using `ls -l` on a special file, you can see its major and minor numbers.  
  ```bash
  ls -l /dev/sda
  ```
  Output:
  ```plaintext
  brw-rw---- 1 root disk 8, 0 Mar  4 13:38 /dev/sda
  ```
  This is a block device (`b`) with a major number of `8` (driver: `sd`), and a minor
  number of `0` (`/dev/sda`).  
  `/dev/sda1` would be minor number `1`.  

### Extracting Major/Minor Numbers

As far as programmatically parsing the major/minor device numbers, I'd say
using `file` produces the most easily parsable output.  

The output is a single line of text, with device numbers presented in a block 
of text at the end of the line, wrapped in parentheses and separated by a 
forward slash (`/`).  

This can be easily parsed by `cut`, `perl`, `awk`, etc.  
```bash
file /dev/null | cut -d' ' -f4
file /dev/null | awk '{print $NF}'
file /dev/null | perl -ae 'print "$F[-1]\n"'
```
All of these commands will extract the last field in the output.  
```plaintext
(1/3)
```

From there, it's as simple as removing the parentheses and splitting based on
the `/`.  

---

There are a number of ways to remove parentheses and split on a character.  

- Probably the easiest way to extract the numbers is to create a longer pipeline.  
  ```bash
  file /dev/null | cut -d' ' -f4 | tr -d '()' | awk -F'/' '{print $1, $2}'
  ```
  Output:
  ```plaintext
  1 3
  ```

- We can read them into variables by utilizing `IFS` and `read`:
  ```bash
  IFS='()/' read -r _ _ _ maj min < <(file /dev/null)
  printf "maj: %s, min: %s\n" "$maj" "$min"
  ```
  This uses underscores to discard parts of the input we don't want. 
  Output:
  ```plaintext
  maj: 1, min: 3
  ```
  This also gives us the variables to work with.  

- We can use perl with a bit of regex.  
  ```bash
  file /dev/null | perl -ane '$F[-1] =~ s/\(([\d\/]+)\)/$1/g; print "$F[-1]\n";'
  ```
  Or omit the splitting entirely and just grab the `1/3`.  
  ```bash
  file /dev/null | perl -ne 'print "$1\n" if m/\(([\d\/]+)\)/;'
  ```

