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


### Suspended ZFS Take 2

Same error as before, more errors.  

- Command run:
  ```bash
  sudo zpool status vmdata
  ```

    - Output:
      ```bash
        pool: vmdata
       state: SUSPENDED
      status: One or more devices are faulted in response to IO failures.
      action: Make sure the affected devices are connected, then run 'zpool clear'.
         see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-HC
        scan: resilvered 0B in 00:00:02 with 0 errors on Wed Sep 17 17:03:48 2025
      config:
      
              NAME        STATE     READ WRITE CKSUM
              vmdata      UNAVAIL      0     0     0  insufficient replicas
                sdb       ONLINE       0     0     0
                sdc       FAULTED     10   176     0  too many errors
      
      errors: 96 data errors, use '-v' for a list
      ```

There are 96 data errors, previously 67.  

- Command run: 
  ```bash
  sudo zpool status -v vmdata
  ```

    - Output:
      ```bash
        pool: vmdata
       state: SUSPENDED
      status: One or more devices are faulted in response to IO failures.
      action: Make sure the affected devices are connected, then run 'zpool clear'.
         see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-HC
        scan: resilvered 0B in 00:00:02 with 0 errors on Wed Sep 17 17:03:48 2025
      config:
      
              NAME        STATE     READ WRITE CKSUM
              vmdata      UNAVAIL      0     0     0  insufficient replicas
                sdb       ONLINE       0     0     0
                sdc       FAULTED     10   176     0  too many errors
      
      errors: List of errors unavailable: pool I/O is currently suspended
      ```

Just as before, we cannot read the errors due to the suspended I/O.  

- Clear the errors and resume I/O again.  
  ```bash
  sudo zpool clear vmdata
  ```

This cleared the errors and resumed I/O, but now there are some new permanent
errors in the `zpool status`.  

- Command run:
  ```bash
  sudo zpool status -v vmdata
  ```

    - Output:

      ```bash
        pool: vmdata
       state: ONLINE
      status: One or more devices has experienced an error resulting in data
              corruption.  Applications may be affected.
      action: Restore the file in question if possible.  Otherwise restore the
              entire pool from backup.
         see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
        scan: resilvered 0B in 00:00:00 with 4 errors on Thu Sep 18 19:06:07 2025
      config:
      
              NAME        STATE     READ WRITE CKSUM
              vmdata      ONLINE       0     0     0
                sdb       ONLINE       0     0     0
                sdc       ONLINE       0     0     8
      
      errors: Permanent errors have been detected in the following files:
      
              vmdata/vm-100-disk-0:<0x1>
              vmdata/vm-204-disk-0@clean-cluster-init:<0x1>
              vmdata/vm-201-disk-0:<0x1>
              vmdata/vm-204-disk-0:<0x1>
              vmdata/vm-201-disk-0@clean-cluster-init:<0x1>
      ```

The status:
```plaintext
One or more devices has experienced an error resulting in data corruption.  Applications may be affected.
```
This implies that some data is corrupted and may not be recoverable.  

The files that are corrupted are listed.  

```plaintext
vmdata/vm-100-disk-0:<0x1>
vmdata/vm-204-disk-0@clean-cluster-init:<0x1>
vmdata/vm-201-disk-0:<0x1>
vmdata/vm-204-disk-0:<0x1>
vmdata/vm-201-disk-0@clean-cluster-init:<0x1>
```

VMs with the VMIDs `100`, `201`, and `204` are nuked. they contain blocks that
failed checksums and could not be repaired.  

ZFS has marked them as permanently corrupted (the `<0x1>` is an object number).  

Any VM using these virtual disks will experience data loss, or possibly even be
unbootable.  

### Conclusion
Disk `/dev/sdc` is corrupted and must be replaced. Affected VMs
can only be restored from backup, but since this ZFS pool has no redundancy
(hardware limitations on my part), they are lost.  

Going forward, I'll need to build any ZFS pools with redundancy.  
Mirroring will be sufficient (software RAID 1), striping is not necessary.
`raidz1/2/3` is also an option.  

I'll also need to monitor `zpool status` on a regular basis to check for such
issues.  

In addition to `zpool status`, I will do `zpool scrub vmdata` to verify all
checksums. If the device `vmdata` is replicated, the `scrub` will repair any
damage discovered from the backup.    


