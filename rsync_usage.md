
# Using `rsync` to Transfer Files and Changes via SSH

## Basic Options and Syntax for `rsync`

```bash
rsync -avz -e ssh user@homelab:/path/to/files/ /path/to/local/home/
```

* `-a`: Archive mode (preserves permissions, symlinks, etc.)
* `-v`: Verbose (shows the files being transferred)
* `-z`: Compress data
* `-e ssh`: Use SSH for the data transfer
