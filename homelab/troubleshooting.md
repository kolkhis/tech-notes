# Misc. Troubleshoting Notes

These are personal notes from troubleshooting errors in my homelab.  

- Running Proxmox (Debian GNU/Linux 12 (bookworm))




## ZFS State Suspended (Storage)

Notes from troubleshooting a storage ZFS issue on Proxmox.  

### The Suspended ZFS Error
I attempted to create a linked clone of a template (RHEL 10, VMID `3000`).  

When I tried, I received the following error:

```bash
zfs error: cannot open 'vmdata': pool I/O is currently suspended
```

Upon further investigation, I found that there were many errors.  

- Command run:
  ```bash
  sudo zpool status
  ```
  Output:
  ```bash
    pool: vmdata
   state: SUSPENDED
  status: One or more devices are faulted in response to IO failures.
  action: Make sure the affected devices are connected, then run 'zpool clear'.
     see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-HC
    scan: resilvered 0B in 00:00:00 with 0 errors on Mon Sep  1 13:03:19 2025
  config:
  
          NAME        STATE     READ WRITE CKSUM
          vmdata      UNAVAIL      0     0     0  insufficient replicas
            sdb       ONLINE       0     0     0
            sdc       FAULTED      8   126     0  too many errors
  
  errors: 67 data errors, use '-v' for a list
  ```


- I ran with `-v` to inspect the errors, but they were not accessible since I/O
  was suspended.
  ```bash
  sudo zpool status -v vmdata
  ```
  
  Output:
  ```bash
    pool: vmdata
   state: SUSPENDED
  status: One or more devices are faulted in response to IO failures.
  action: Make sure the affected devices are connected, then run 'zpool clear'.
     see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-HC
    scan: resilvered 0B in 00:00:00 with 0 errors on Mon Sep  1 13:03:19 2025
  config:
  
          NAME        STATE     READ WRITE CKSUM
          vmdata      UNAVAIL      0     0     0  insufficient replicas
            sdb       ONLINE       0     0     0
            sdc       FAULTED      8   126     0  too many errors
  
  errors: List of errors unavailable: pool I/O is currently suspended
  ```

So the ZFS pool `vmdata` has suspended I/O because it encountered an error it
couldn't recover from.  

When a ZFS pool is suspended, the all operations (read/writes, incl. cloning
images) fail.  

---


### Recovery Attempt

I will try to clear the errors and resume I/O.  

- Command run to clear the errors:
  ```bash
  sudo zpool clear vmdata
  ```
  This command produced no output and seemingly ran without error.  

- Command to verify I/O:
  ```bash
  sudo zpool status vmdata
  ```
  Output:
  ```bash
    pool: vmdata
   state: ONLINE
    scan: resilvered 0B in 00:00:02 with 0 errors on Wed Sep 17 17:03:48 2025
  config:
  
          NAME        STATE     READ WRITE CKSUM
          vmdata      ONLINE       0     0     0
            sdb       ONLINE       0     0     0
            sdc       ONLINE       0     0     0
  
  errors: No known data errors
  ```

This appears to have revived the `vmdata` ZFS pool.  

---

After clearing errors and resuming I/O, I was able to go back and create the
clone that I attempted before troubleshooting. Problem resolved.  





