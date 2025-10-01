# RHCSA Tasks

This page contains some tasks that may be required in the RHCSA exam.  

## Reset Root Password
Knowing how to reset the password of the `root` user is **super** important for syadmins.  

Boot in recovery mode.
```bash
reboot
```
Then when we get into GRUB, select the kernel, and press ++e++.  

Go down to the line that starts with `linux`.  
Go to the end of the line and type in `rd.break`.  

Hit ++ctrl+x++. Then you'll be booted into emergency mode.

Then run the commands:
```bash
mount -o remount,rw /sysroot/
chroot /sysroot
```
This will bring the root filesystem back online. 

Now, change the password itself.
```bash
passwd
```
Change the password to **the one that you're given**.  
Don't just pick one. You usually need to set the password to a specific value.

Then, run:
```bash
touch /.autorelabel
```
This is primarily for SELinux. It will ensure that SELinux applies labels the way that it's supposed to.  

Exit the chrooted environment. 
```bash
exit
```
Reboot the system.  
```bash
reboot
```

Now try logging in with the password that you set.  

## Enable Persistent Storage for Journald
One of the RHCSA exam objectives is:

> "Preserve system journals"

The process here is fairly straightforward.  
```bash
journalctl --no-pager | grep -i '/log/journal' | tail
```

In these logs, you'll see the location for the Runtime Journal:  
```plaintext
Oct 01 10:53:08 localhost systemd-journald[271]: Runtime Journal (/run/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 73M, 65M free.
Oct 01 10:53:14 rhel systemd-journald[662]: Runtime Journal (/run/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 73M, 65M free.
Oct 01 10:53:14 rhel systemd-journald[662]: Runtime Journal (/run/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 73M, 65M free.
```

We can see that the journal is logging to the `/run/log/journal/` directory, which
does not persist across reboots.  

To set it up to be persistent, edit `/etc/systemd/journald.conf`.  

!!! note 

    If the file does not exist, create it.  
    ```bash
    sudo touch /etc/systemd/journald.conf
    ```

Add a line under the `[Journal]` section:
```ini
[Journal]
Storage=persistent
```

Then create the directory:
```bash
mkdir /var/log/journal
```

Then restart `journald`:
```bash
systemctl restart systemd-journald
```

If you're on RHEL9+, you'll need to flush the log data stored in
`/run/log/journal/` into `/var/log/journal/`.  
```bash
journalctl --flush
```

Now check the logs again, in the same way:
```bash
journalctl --no-pager | grep -i '/log/journal' | tail
```
Now we should see:
```plaintext
Oct 01 11:01:28 rhel systemd-journald[3696]: Runtime Journal (/run/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 73M, 65M free.
Oct 01 11:01:51 rhel systemd-journald[3696]: Time spent on flushing to /var/log/journal/6a521d735b0a43b6a5443c89f42a3570 is 72.686ms for 2184 entries.
Oct 01 11:01:51 rhel systemd-journald[3696]: System Journal (/var/log/journal/6a521d735b0a43b6a5443c89f42a3570) is 8M, max 2.7G, 2.7G free.
```
We can see the previous logging to `/run/log/journal`, then we see our
`--flush` command being logged, and finally we see our `/var/log/journal`
directory being written to.  

These journal databases will now persist across reboots.  

Reboot the machine to verify.  

```bash
reboot
```

Check the journal with `-b -1` to check the previous boot.  
```bash
journalctl -b -1
```

---



