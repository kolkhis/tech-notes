# Misc. Troubleshoting Notes

These are personal notes from troubleshooting errors in my homelab.  

- Running Proxmox VE (Debian GNU/Linux 12 (bookworm))

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

We'll try to clear the errors and resume I/O.  

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
  Output:
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
  Output:
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
  Output:
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

Going forward, we'll need to build any ZFS pools with redundancy.  
Mirroring will be sufficient (software RAID 1), striping is not necessary.
`raidz1/2/3` is also an option.  

We'll also need to monitor `zpool status` on a regular basis to check for such
issues.  

In addition to `zpool status`, we'll do `zpool scrub vmdata` to verify all
checksums. If the device `vmdata` is replicated, the `scrub` will repair any
damage discovered from the backup.    

### Followup 

The disk was undetectable for a bit. I reseated the drive in the caddy and ran
a `zpool clear` against `vmdata`. It managed to bring the pool back online just 
long enough to run `status -v` see errors:
```bash
kolkhis@home-pve:~$ sudo zpool status -v vmdata
  pool: vmdata
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
  scan: scrub in progress since Mon Sep 29 15:10:13 2025
        3.48G / 75.7G scanned at 8.37K/s, 0B / 75.7G issued
        0B repaired, 0.00% done, no estimated completion time
config:

        NAME        STATE     READ WRITE CKSUM
        vmdata      ONLINE       0     0     0
          sdb       ONLINE       0     0     0
          sdc       ONLINE       0     0     0

errors: Permanent errors have been detected in the following files:

        vmdata/vm-100-disk-0:<0x1>
        vmdata/vm-100-disk-0@pre-playbooks-with-ansible:<0x1>
        vmdata/vm-203-disk-0:<0x1>
        vmdata/vm-204-disk-0@clean-cluster-init:<0x1>
        vmdata/vm-100-disk-0@pre-playbooks:<0x1>
        <0x1420>:<0x1>
        <0x1d22a>:<0x1>
        <0x1e231>:<0x1>
        <0x294d>:<0x1>
        <0x1ca7e>:<0x1>
        <0x1299>:<0x1>
        <0x27cc>:<0x1>
        <0x27d8>:<0x1>
        <0x1d1de>:<0x1>
```

This did give some insight as to which VMs are affected.  
I can plan my migration to the new disk accordingly. We'll need to delete the
affected VMs.  

- `100`
- `203`
- `204`

!!! note "Spoiler Alert"

    There were more than 3 affected VMs.  

### Killing Fdisk

When trying to use `fdisk -l` to inspect the disks, it hangs. Tried on several
instances.  
Trying to use `killall`, it reports successful kills on 2 of the processes, but
they're still running in `ps -ef`.  

Trying to use a different signal produced the same results.  

Solution was to use `pkill` instead of `kill` or `killall`:  
```bash
sudo pkill -9 -f fdisk
```

This killed most of the errant processes but not all of them.  

On using `ps aux` to examine the process states, they were found to have had a
state of `D`, which is "uninterruptible sleep (usually IO)." Only a reboot or
hardware fix can stop these.  


### Removing the Drive from the ZFS Pool

I physically removed the drive that was causing issues.  

The drive was: FIKWOT FX815 512GB. I guess it tracks that a $20 drive on Amazon only lasts for 8 months.  

The pool was set up as a stripe, with no redundancy. ZFS can't detach a disk from a striped pool.  

The `/dev/sdb` disk is a single stripe with no redundancy so it's unrecoverable.  

We'll have to wipe and rebuild from scratch.  

- We'll stop anything touching the pool.  
  ```bash
  sudo systemctl stop pvedaemon.service pvestatd.service pveproxy.service
  ```
  Then wipe and rebuild.
  ```bash
  sudo zpool destroy -f vmdata
  #cannot open 'vmdata': pool I/O is currently suspended
  ```
  Can't do that. We'll wipe the disk itself of all zfs labels.  
  ```bash
  sudo wipefs -a /dev/sdb
  #wipefs: error: /dev/sdb: probing initialization failed: Device or resource busy
  ```
  Can't do that either. Something is still using the disk.  
  We'll reboot. Uptime is 25 days, haven't rebooted since removing the new
  disk.  

- After rebooting, the disk is no longer seen as being part of a pool.  
  ```bash
  cat /proc/mounts | grep -i vmdata
  zfs list # no datasets available
  sudo zpool status # no pools available
  ```
  Some of our VMs are still available. I was able to launch a RHEL 10 VM.  
  We will check what disks are in use and make backups (if we can) before wiping anything.  

### Cleanup 

The VMs that were using `vmdata` are gone, there is no chance for recovery.  
They need to be removed.  

- We'll check what storage devices the VMs are using before wiping anything.  
  ```bash
  sudo pvesm status
  ```
  Output:
  ```plaintext
  zfs error: cannot open 'vmdata': no such pool

  zfs error: cannot open 'vmdata': no such pool
  
  could not activate storage 'vmdata', zfs error: cannot import 'vmdata': no such pool or dataset
  
  Name             Type     Status           Total            Used       Available        %
  local             dir     active        67169672        25986616        37725216   38.69%
  local-lvm     lvmthin     active       136593408       130118880         6474527   95.26%
  vmdata        zfspool   inactive               0               0               0    0.00%
  ```
  The `vmdata` ZFS pool is shown as inactive. So that *should* imply that none of
  the VMs that are currently able to run rely on this.  

- Let's look at the disk used for each running VM.  
  I wrote a small script to loop over VMIDs and grep for disk in their configs.  
  ```bash title="check-storage"
  #!/bin/bash

  if [[ $EUID -ne 0 ]]; then
      printf >&2 '[ERROR]: Run script as root.\n'
      exit 1
  fi

  if ! command -v qm > /dev/null 2>&1; then
      printf >&2 '[ERROR]: Could not find the qm command.\n'
      exit 1
  fi

  declare -a VMID_LIST
  IFS=$'\n' read -r -d '' -a VMID_LIST < <(sudo qm list | awk 'NR > 1 {print $1}')

  for vmid in "${VMID_LIST[@]}"; do
      printf "VMID: %d - %s\n" "$vmid" \
          "$(qm config "$vmid" | grep -i 'disk' | grep -v 'agent:')"
  done
  ```
  Utilizes `qm config` to list out the VM config and greps for the `disk`
  setting, showing what storage disk is being used for each VM.  

- Ran script:
  ```bash
  sudo ./check-storage
  ```
  The output:
  ```plaintext
  VMID: 100 - scsi0: vmdata:vm-100-disk-0,iothread=1,size=80G
  VMID: 101 - scsi0: vmdata:vm-101-disk-0,iothread=1,size=60G
  VMID: 102 - scsi0: local-lvm:vm-102-disk-0,iothread=1,size=32G
  VMID: 103 - scsi0: vmdata:base-103-disk-0,iothread=1,size=32G
  VMID: 104 - scsi0: local-lvm:vm-104-disk-0,iothread=1,size=80G
  VMID: 105 - scsi0: local-lvm:base-105-disk-0,iothread=1,size=80G
  VMID: 106 - scsi0: local-lvm:vm-106-disk-0,size=32G
  VMID: 201 - scsi0: vmdata:base-103-disk-0/vm-201-disk-0,iothread=1,size=32G
  VMID: 202 - scsi0: vmdata:base-103-disk-0/vm-202-disk-0,iothread=1,size=32G
  VMID: 203 - scsi0: vmdata:base-103-disk-0/vm-203-disk-0,iothread=1,size=32G
  VMID: 204 - scsi0: vmdata:base-103-disk-0/vm-204-disk-0,iothread=1,size=32G
  VMID: 205 - scsi0: vmdata:base-103-disk-0/vm-205-disk-0,iothread=1,size=32G
  VMID: 1010 - scsi0: local-lvm:vm-1010-disk-0,iothread=1,size=80G
  VMID: 1020 - scsi0: local-lvm:vm-1020-disk-0,iothread=1,size=80G
  VMID: 9000 - scsi0: local-lvm:base-9000-disk-0,size=32G
  VMID: 9001 - scsi0: vmdata:base-9001-disk-0,iothread=1,size=32G
  ```
  The output was a little bit long, but incredibly informative. 

- It seems that the affected disks include templates (`103`, `9001`), and any VMs that
  were linked clones of that template are now useless.
    - These are VMs with the IDs `201-205`.  
    - So in addition to those 5, we have `100`, `101`, `103`, and `9001` that were
      reliant on the `vmdata` ZFS pool.  

- In total, 9 VMIDs relied on `vmdata`.  
  ```bash
  sudo ./check-storage | grep -ic 'vmdata' # 9
  ```
  Extracting the VMIDs:
  ```bash
  sudo ./check-storage | grep -i 'vmdata' | cut -d' ' -f2
  ```
  We get the VMID list of affected VMs:
  ```plaintext
  100
  101
  103
  201
  202
  203
  204
  205
  9001
  ```

- Added those VMIDs to a small script to decommission/destroy all of them:
  ```bash
  declare -a DELETE=( 100 101 103 201 202 203 204 205 9001 )
  for vmid in "${DELETE[@]}"; do 
      if [[ $(sudo qm status "$vmid") == "status: running" ]]; then
          qm stop "$vmid"
      fi
      qm destroy "$vmid" || {
          printf >&2 '[ERROR]: Failed to destroy VM with ID: %d\n' "$vmid"
          continue
      }
  done
  ```

!!! note

    I expanded on this script to be more of a utility, allowing the user to pass in
    VMIDs as arguments. Additionally added verification guards to make sure the
    user does not delete anything unintentionally.  
    Full script:
    <https://github.com/kolkhis/lab-utils/blob/main/pve/destroy-vms>

- Two of the VMIDs failed to destroy. 
    - The ones that did not get removed with `qm destroy` are templates (`103` and `9001`).  
    - They're 
    - Command:
      ```bash
      sudo qm destroy 103
      ```
      Output:
      ```plaintext
      zfs error: cannot open 'vmdata': dataset does not exist
      ```
      The same error appears when trying to remove the template via the web UI.  

- To remove the kaput templates, we'll need to manually delete their
  configuration files (stored in `/etc/pve/qemu-server/<VMID>.conf`).  
  ```bash
  sudo rm /etc/pve/qemu-server/{103,9001}.conf
  ```
  This removed the two templates.  



## Rebuilding Storage with Redundancy

### Suggested ZFS Rebuild
This approach uses ZFS internal mirroring rather than traditional software RAID 
through `mdadm`.  

Although, once we can afford a new disk, we will set up software RAID1 (mirror)
on the main PVE boot drive.  

Wipe and rebuild
```bash
wipefs -a /dev/sdb # clear old zfs labels
wipefs -a /dev/sdd # clear new Kingston SSD 
```

Create new, **mirrored** pool.  
```bash
sudo zpool create vmdata mirror /dev/sdb /dev/sdd
sudo zpool status
```

Add to Proxmox, then verify.  
```bash
pvesm add zfspool vmdata -pool vmdata
pvesm status
```

### Setting up RAID1 for Boot Drive
This is what we'll do to set up RAID1 for our boot drive, in case that ever
fails. We don't want to have to reinstall and reconfigure Proxmox as a whole if
our boot drive fails.  



#### Backup and Mirror Partition Table
Create a mirror of the main boot drive's partition table on the new backup drive.  
Here we'll use `sgdisk` to save the GUID partition table 
```bash
sudo sgdisk --backup=table.sda /dev/sda
sudo sgdisk --load-backup=table.sda /dev/sdb
sudo sgdisk --randomize-guids /dev/sdb
```

- `sgdisk`: Command-line GUID partition table (GPT) manipulator for Linux/Unix

- `--backup=table.sda /dev/sda`: Save `/dev/sda` partition data to a backup file.
    - The partition backup file is `table.sda`.  
- `--load-backup=table.sda /dev/sdb`: Load the `/dev/sda` partition data from the backup file.
- `--randomize-guids /dev/sdb`:
    - Randomize the disk's GUID and all partitions' unique GUIDs (but not their  
      partition type code GUIDs).  
    - Used after cloning a disk in order to render all GUIDs unique once again.

!!! note

    These are example disks. `/dev/sda` is the main boot drive, but `/dev/sdb`
    will likely not be the backup drive when we get one.  

#### Create RAID1 Arrays for `/boot` and `/`
We'll need at least two partitions for this.  

- `/boot`: Small, `ext4`, no LVM
- `/` (root): The rest, will hold the LVM

```bash
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda2 /dev/sdb2
sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sda3 /dev/sdb3
```

???+ note "Adjust Parition Numbers"

    We'll need to adjust the partition numbers accordingly.  
    If we look at the `lsblk` output for `/dev/sda`, we'll see the paritions we
    need to back up:
    ```plaintext
    ├─sda1                                                  8:1    0  1007K  0 part
    ├─sda2                                                  8:2    0     1G  0 part /boot/efi
    └─sda3                                                  8:3    0 222.6G  0 part
      ├─pve-swap                                          252:0    0     8G  0 lvm  [SWAP]
      ├─pve-root                                          252:1    0  65.6G  0 lvm  /
      ├─pve-data_tmeta                                    252:2    0   1.3G  0 lvm
      │ └─pve-data-tpool                                  252:4    0 130.3G  0 lvm
      │   ├─pve-data                                      252:5    0 130.3G  1 lvm
      │   ├─pve-vm--102--state--clean--install--with--ssh 252:6    0   4.5G  0 lvm
      │   ├─pve-vm--102--state--clean--install--ansible   252:7    0   4.5G  0 lvm
      │   ├─pve-vm--102--disk--0                          252:8    0    32G  0 lvm
      │   ├─pve-vm--104--disk--0                          252:9    0    80G  0 lvm
      │   ├─pve-vm--104--state--clean--install            252:10   0   8.5G  0 lvm
      │   ├─pve-vm--1010--disk--0                         252:11   0    80G  0 lvm
      │   ├─pve-vm--1020--disk--0                         252:12   0    80G  0 lvm
      │   ├─pve-vm--106--disk--0                          252:13   0    32G  0 lvm
      │   └─pve-vm--106--state--clean                     252:14   0   8.5G  0 lvm
      └─pve-data_tdata                                    252:3    0 130.3G  0 lvm
        └─pve-data-tpool                                  252:4    0 130.3G  0 lvm
          ├─pve-data                                      252:5    0 130.3G  1 lvm
          ├─pve-vm--102--state--clean--install--with--ssh 252:6    0   4.5G  0 lvm
          ├─pve-vm--102--state--clean--install--ansible   252:7    0   4.5G  0 lvm
          ├─pve-vm--102--disk--0                          252:8    0    32G  0 lvm
          ├─pve-vm--104--disk--0                          252:9    0    80G  0 lvm
          ├─pve-vm--104--state--clean--install            252:10   0   8.5G  0 lvm
          ├─pve-vm--1010--disk--0                         252:11   0    80G  0 lvm
          ├─pve-vm--1020--disk--0                         252:12   0    80G  0 lvm
          ├─pve-vm--106--disk--0                          252:13   0    32G  0 lvm
          └─pve-vm--106--state--clean                     252:14   0   8.5G  0 lvm
    ```
    We see that `/dev/sda2` is the boot partition and `/dev/sda3` is the partition
    with all the logical volumes.  

    The `/dev/sda1` partition is the BIOS boot partition, used by GRUB when the
    disk uses GPT partitioning on a system booting in legacy BIOS (not UEFI).  
    

#### Add `/dev/md1` as a PV to LVM, mirror LVs or rebuild them

We could also boot from a live CD and reinstall GRUB on both disks.  
```bash
sudo grub-install /dev/sda
sudo grub-install /dev/sdb
update-grub
```

- `grub-install`: Install GRUB boot code and points it to our `/boot` and `/boot/efi` partitions.  
    - `/dev/sda`: current system
    - `/dev/sdb`: backup/mirror drive

- `update-grub`: Rebuilds `/boot/grub/grub.cfg` (the GRUB menu),

This makes sure that both drives are bootable. If `/dev/sda` dies, we can boot
directly from `/dev/sdb` in BIOS or UEFI.  

#### Save RAID Config
```bash
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
update-initramfs -u
```

- `mdadm --detail --scan`: Scans all active RAID arrays (`/dev/md*`) and prints
  their config.  
    - Then we save those RAID array configs to `/etc/mdadm/mdadm.conf` to make
      them persistent/permanent and they'll auto-mount on boot.  

- `update-initramfs -u`: Rebuilds the `initramfs` and makes sure RAID modules and
  `mdadm.conf` are baked in.  
    - The `initramfs` is the small Linux image the kernel loads before the root 
      filesystem is ready.
    - It needs to include the `mdadm` tools and RAID metadata so it can assemble 
      RAID arrays before mounting `/`.  
    - Without doing this, the system might fail to boot because the RAID
      wouldn't be assembled early enough.  


#### Reboot and Confirm
Reboot the machine.  
```bash
sudo reboot
```
Then check `/proc/mdstat`.  
```bash
cat /proc/mdstat
```

Look for the entries related to the new RAID arrays:
```plaintext
Personalities : [raid1]
md0 : active raid1 sda2[0] sdb2[1]
      1047552 blocks super 1.2 [2/2] [UU]

md1 : active raid1 sda3[0] sdb3[1]
      234376192 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```

