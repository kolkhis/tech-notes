
# SSH Connection Monitoring

## Getting SSH Logs

```bash
journalctl -u ssh --since yesterday
journalctl -u ssh --since -3d --until -2d # logs from three days ago
journalctl -u ssh --since -1h # logs from the last hour
journalctl -u ssh --until "2022-03-12 07:00:00"
```

### Realtime SSH Log Monitoring

To watch the ssh logs in realtime, use the follow flag:
```bash
journalctl -fu ssh
```

### Using Authentication Logs (`/var/log/auth.log`)

```bash
sudo grep sshd /var/log/auth.log
```
If you’re looking for a quick overview of who’s logged in recently rather than an in-depth audit log, try the lastlog command:

```bash
lastlog
```

## System Hardening for SSH
Make sure that you do not allow root to log in via `/etc/ssh/sshd_config`.
This speaks to a bigger part of layered security.
You should only allow your user to log in and then force a "sudo" up to root privilege.
```bash
sudo nvim /etc/ssh/sshd_config
# Search for PermitRootLogin, change it to:
PermitRootLogin no
```


### Useful log settings

Knowing how to view ssh logs isn’t much help if the logs you’re looking for haven’t been retained.
By default, journald retains logs until they consume up to 10% of available disk space.
To change this setting, see the SystemMaxUse setting in the journald documentation.

It’s also recommended to increase the sshd log level from the default.
Put this setting in `/etc/ssh/sshd_config`:
```sh
LogLevel VERBOSE
```

This will include more details in the sshd log, like the PID of the user’s login shell.
For debugging purposes, you can also try `LogLevel DEBUG`.


