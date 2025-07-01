# Logrotate

The `logrotate` tool is used to, as the name suggests, rotate logfiles.  

It backs up older logs, compresses them, and saves them for a specific 


## Configuring Logrotate

Logrotate uses the `/etc/logrotate.conf` file and files in `/etc/logrotate.d` to
determine which log files to rotate, and the rules that should be applied to that
file.  

Using `/etc/logrotate.d` can be more helpful when configuring log rotation for
specific applications. Each application's logs can have its own file in this
directory, which makes it easier to manage the rotation configuration.  

---

### Logrotate Config File Format

Configuring `logrotate` has a basic `pattern { rules }` syntax.  

You specify a pattern as a filename (or list of filenames) that the rules within the
braces `{ ... }` will apply to.  

An example:
```bash
/home/kolkhis/github-backups/backup.log {
    create
    daily
    rotate 7
    compress
    missingok
    notifempty
    copytruncate
}
```

<!-- > TODO: Add explanation -->







