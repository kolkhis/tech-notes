# Logger

The `logger` command is used to write logs, as the name suggests.  

We can use `logger` to write messages to the system log location (`/dev/log` or `journald`).  

## Usage

The `logger` command allows us to write logs stright to the systemd journal (`journald`),
which will then be available through `journalctl` (or in `/var/log/syslog` 
or `/var/log/messages` by default depending on your distro).  

For example:
```bash
logger -t bastion "Test message"
tail -n 1 /var/log/syslog
# Output:
# Jun  6 20:27:40 jumpbox01 bastion: Bastion tag test message
```

The `-t` sets the tag, which will be the current `$USER` by default.  

## Setting Priority
If we wanted to, we could also use `logger` to write logs 
to `/var/log/auth.log` (on Debian-based systems only) by setting the priority.  
```bash
logger -t bastion -p auth.info "Test message"
tail -n 1 /var/log/auth.log
# Output:
# Jun  6 20:30:07 jumpbox01 bastion: Test info severity
```

- `-p auth.info`: Sets the priority for the log, formatted as `facility.level`.  
    - Defaults to `user.notice`.  

Note that this will not write to `/var/log/secure` on RedHat-based systems, it will write to `/var/log/messages` (tested on Rocky).  

### Formatting Priority

The format for `-p`/`--priority` requires the `facility.level` syntax.  

The facilities can be:

#### Facilities

| Facility             | Description / Typical Use
| -------------------- | ------------ |
| `auth`               | Authentication logs (login attempts, `sudo`, `su`). Goes to `/var/log/auth.log` (Debian) or `/var/log/secure` (RHEL).
| `authpriv`           | More sensitive auth data. Not always separate, but can be routed to more secure log files.
| `cron`               | Cron daemon logs (scheduled job execution, failures).
| `daemon`             | Misc system daemons not covered by other facilities (e.g., `ntpd`, `dbus`).
| `kern`               | Kernel messages (from the kernel ring buffer, not usable via `logger`). Logs to `/dev/kmsg`, not `/dev/log`.
| `lpr`                | Line printer daemon logs. Mostly obsolete unless managing legacy print servers.
| `mail`               | Mail transport logs (`postfix`, `sendmail`, etc.).
| `news`               | NNTP servers / Usenet — rarely used today.
| `syslog`             | Internal syslog messages (`rsyslogd` itself). Good for debugging `rsyslog`.
| `user`               | Default facility for general user-space processes. `user.notice` is default.
| `uucp`               | Unix-to-Unix Copy logs. Ancient and probably unused.
| `ftp`                | FTP daemon logs. Uncommon.  
| `security`           | Deprecated alias for `auth`.  
| `local0` to `local7` | Reserved for custom applications. Good for self-contained systems.  

* `kern`: Cannot be generated from userspace process, automatically converted to `user`.


#### Levels

These are the `level` options for the `facility.level`. Indicates the severity of the
log that's being sent.  

A lower number means a **higher** priority.  

| Level Name | Value | Description / Use                                                                 |
| ---------- | ----- | --------------------------------------------------------------------------------- |
| `emerg`    | 0     | System is **unusable**. Usually broadcast to all terminals (`wall`). Rarely used.
| `alert`    | 1     | Needs immediate action. E.g., corrupt system files, full disk on root.
| `crit`     | 2     | Critical condition. Hardware failures, kernel panic warnings.
| `err`      | 3     | Standard errors. Application crashes, failed services.
| `warning`  | 4     | Warnings of potential problems. Could be recoverable or ignored.
| `notice`   | 5     | Normal, but noteworthy conditions. E.g., "service started".
| `info`     | 6     | General informational messages. Health checks, connection attempts.
| `debug`    | 7     | Detailed internal messages. Good for troubleshooting.


There are also a few deprecated levels:

* `panic`: Deprecated synonym for `emerg`.  
* `error`: Deprecated synonym for `err`.  
* `warn`: Deprecated synonym for `warning`.  


---

## Dry Runs

We can perform dry runs with `logger` to see how the log message will be formatted:
```bash
logger -t bastion -p auth.info --no-act --stderr "Test message"
# Output:
# <38>Jun  6 20:59:53 bastion: Test message
```

This combines `--no-act` and `--stderr`.  

- `--no-act`: Just that. It doesn't actually perform the action.  
- `--stderr`: Writes to stderr as well as the system log.  
    - When combined with `--no-act`, it only prints to stderr.  


---


## Custom Log Files with `logger` and `rsyslog`

Ultimately, `logger` sends log entries to the system logger (`/dev/log` or
`journald`), and if you're running `rsyslog`, logs end up to wherever your config 
routes them.

This is usually `/var/log/syslog` (Debian) or `/var/log/messages` (RedHat) by default.    

We can set up a custom file through `rsyslog` for our bastion program if we want. We
would need to add a file in `/etc/rsyslog.d/`, and use `rsyslog`'s quirky
configuration syntax:  
```bash
# /etc/rsyslog.d/50-bastion.conf
if $programname == 'bastion.sh' then /var/log/bastion.log
& stop
```

This will check if the program's name is `bastion.sh`, and route the logs to the file
`/var/log/bastion.log` instead of the default location.  

