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

