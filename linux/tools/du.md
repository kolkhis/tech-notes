# `du`

The `du` utility is used to inspect the file space usage for a given file or
directory.  

This is a must-know tool for debugging storage issues.  

## Usage
Basic syntax for `du`:
```bash
du [OPTS] [FILE]
```



A common invocation is:
```bash
du -h ./directory
```
This will show, in "`-h`uman-readable" format, the total space that the directory
and all its contents take up on the disk.  


Another great invocation:
```bash
du -chx --max-depth=1 "$PWD"
```
This shows the total space used by the current directory, and itemizes all
immediate subdirectories (with a max depth of 1).  

- `-c`: Show the total disk space usage.  
- `-h`: Human-readable format (e.g., `5.0G`/`3.1M`/`14K`).  
- `-x`: Skips directories on different filesystems.  
- `--max-depth=1`: Do not recurse subdirectories lower than 1 level.  

### Options

Each option for `du` modifies the output and behavior.  

Most common ones:
- `-h`: Output in human-readable format (base 1024)
- `--exclude=pattern`: Exclude any files or directories that `pattern` matches the name of.  
- `-c`: Show a total disk space usage at the end of the output.  
- `-s`: Display only the total size for each file or directory specified.  
- `-0`: Delimit output with NUL bytes instead of newlines.  
- `--inodes`: Show inode usage info instead of block usage.  

Full list: `man du`

