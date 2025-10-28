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

??? warning "Spoiler Alert"

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

The drive was: FIKWOT FX815 512GB. I guess it tracks that a $20 drive on Amazon
only lasts for 8 months.  

The pool was set up as a stripe, with no redundancy. ZFS can't detach a disk
from a striped pool.  

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

- To remove the cooked templates, we'll need to manually delete their
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

### Setting up RAID1 for Root Filesystem
When Proxmox was installed intially, we used LVM instead of ZFS.  

If we had used ZFS, we could have leveraged the internal mirroring that it
supports. But, we didn't, so we're going to set up RAID1 mirroring for the LVM.  

This is what we'll do to set up RAID1 for our boot drive, in case that ever
fails. 

If the boot drive fails, we still want to maintain our data.   


#### Backup and Mirror Partition Table
Create a mirror of the main boot drive's partition table on the new backup drive.  
Here we'll use `sgdisk` to save the GUID partition table.  

This will create the same partitions on the backup disk that the main boot disk has.  
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

#### Create RAID1 Array for Root Filesystem
We'll need one partition for this.

- `/` (root): All the data in the root filesystem, will hold the LVM

- `/boot`: Not needed on UEFI boot systems.  
    - This is **ONLY FOR SYSTEMS WITH BIOS/LEGACY BOOT MODE.**
    - If the `/dev/sda2` is UEFI (mounted at `/boot/efi`) then we do **NOT**
      create a RAID array for it.  

!!! warning

    We need to create the array **degraded** first, using **only the new disk**, 
    so we don't touch the live boot disk. We do this by providing `missing` in
    place of the live partition.  

    If we use the live disk when creating the array, they'll be clobbered first.  
    This will cause data loss.  

    The new, empty disk is `/dev/sdb` in this example. Don't put in the `/dev/sda3`
    partition, or it will be wiped.

Create the RAID array (degraded) with the new backup disk's `3` partition.  
```bash
sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdb3 missing
```

???+ note "What about `/dev/sda1`?"

    The `/dev/sda1` partition is the BIOS boot partition, used by GRUB when the
    disk uses GPT partitioning on a system booting in legacy BIOS (not UEFI).  
    This partition is a tiny raw area that GRUB uses to stash part of its own
    boot code. It has no filesystem, no files, no mountpoint.  

    In UEFI boot systems, `/dev/sda1` will contain BIOS boot instructions for
    backwards compatibility, even if the disk is in EUFI mode. Make sure to
    check it.  

Check to make sure the new array exists and is healthy.  
```bash
sudo mdadm --detail /dev/md1
```
Output should look like:
```plaintext
/dev/md1 : active raid1 sdb3[0]
      [U_]
```

#### Migrate the Root Filesystem LVM to RAID1

1. Use `pvcreate` on the array and extend the VG.  
   ```bash
   sudo pvcreate /dev/md1
   ```
   This adds `/dev/md1` to LVM as a physical volume.  
   
2. Add the array to the `pve` Volume Group.  
   ```bash
   sudo vgextend pve /dev/md1
   ```

3. Live-migrate all LVs from the old PV (`/dev/sda3`) onto the array
   ```bash
   sudo pvs # confirm PV names
   sudo pvmove /dev/sda3 /dev/md1
   ```

4. Remove `/dev/sda3` from the volume group.  
   ```bash
   sudo vgreduce pve /dev/sda3
   ```

This should have migrated all of the data on `/dev/sda3` to `/dev/md1`.  

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

#### UEFI ESP Boot Redundancy (No `mdadm`)
This is how you'd also create redundancy for the **OS boot**. This step is
optional if all you want is data backup.  

Again, we don't use `mdadm` RAID for UEFI boot data. The EFI firmware does not 
read `md` metadata.  

```bash
sudo mkfs.vfat -F32 /dev/sdb2
sudo mkdir -p /boot/efi2
sudo mount /dev/sdb2 /boot/efi2
sudo rsync -a --delete /boot/efi/ /boot/efi2/
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi  --bootloader-id=proxmox  --recheck
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi2 --bootloader-id=proxmox2 --recheck
sudo update-grub
```

??? notes "What is ESP?"

    ESP stands for EFI System Partition. It's the FAT32 partition (in this
    layout, it's `/dev/sda2) that UEFI firmware reads at boot time to find
    bootloader files (e.g., `/EFI/BOOT/BOOT64.EFI` or
    `/EFI/proxmox/grubx64.efi`)


#### Reboot and Confirm
Reboot the machine.  
```bash
sudo reboot
```
Then check that root `/` is on `md1`.  
```bash
lsblk
```

#### Finish the Mirror
Add the **old** partition (`/dev/sda3`) to the array now.  
```bash
sudo mdadm --add /dev/md1 /dev/sda3
```

Keep checking the `/proc/mdstat` file for `UU`.  
```bash
cat /proc/mdstat
```

Look for the entry related to the new RAID array:
```plaintext
Personalities : [raid1]
md1 : active raid1 sda3[0] sdb3[1]
      234376192 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```

The `[UU]` at the end means the mirror is healthy and synchronized.  

---

#### Replacing a Failed Boot Disk
If `/dev/sda` fails, we'll still have the backup to boot from. But we'll want
to replace the disk with a new one to maintain redundancy.  

1. Replace it with a new disk of equal or larger size.

2. Clone the partition table:
   ```bash
   sudo sgdisk --backup=table.sdb /dev/sdb  # Use the original backup disk
   sudo sgdisk --load-backup=table.sdb /dev/sda
   sudo sgdisk --randomize-guids /dev/sda
   ```

3. Add its partitions back into the arrays:
   ```bash
   sudo mdadm --add /dev/md1 /dev/sda3
   ```

4. Recreate and sync the EFI partition:
   ```bash
   mkfs.vfat -F32 /dev/sda2
   mount /dev/sda2 /boot/efi2
   rsync -a --delete /boot/efi/ /boot/efi2/
   grub-install --target=x86_64-efi --efi-directory=/boot/efi2 --bootloader-id=proxmox2 --recheck
   ```

5. Wait for `md` to show `[UU]`.

## Boot Filesystem

```plaintext
kolkhis@home-pve:~/lab-utils/pve$ sudo fdisk -l /dev/sda
Disk /dev/sda: 223.57 GiB, 240057409536 bytes, 468862128 sectors
Disk model: INTEL SSDSC2BB24
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: DBBB07FB-37D6-4248-B7F7-2284ABC256E9

Device       Start       End   Sectors   Size Type
/dev/sda1       34      2047      2014  1007K BIOS boot
/dev/sda2     2048   2099199   2097152     1G EFI System
/dev/sda3  2099200 468862094 466762895 222.6G Linux LVM
```

This uses UEFI boot. Since `/boot/efi` is on `/dev/sda2`.  
Don't put EFI system partition data on mdadm RAID. UEFI firmware generally
can't read `md` metadata.  

So we can't make the actual OS boot into a RAID1 array.  
However, we can make the root filesystem data (the LVM) into a RAID array.  

Instead, make two independent ESPs and keep them in sync.  

### Creating a Redundant UEFI Boot
Instead of creating a RAID1 mirror, we make a partition and add all the boot
data to that.  
```bash
mkfs.vfat -F32 /dev/sdb2
mkdir -p /boot/efi2
mount /dev/sdb2 /boot/efi2
rsync -a --delete /boot/efi/ /boot/efi2/
grub-install --target=x86_64-efi --efi-directory=/boot/efi  --bootloader-id=proxmox
grub-install --target=x86_64-efi --efi-directory=/boot/efi2 --bootloader-id=proxmox2
update-grub
```

## Status: io-error

- 10/22/25

This morning I tried to SSH into one of my VMs. It says "no route to host," so I 
check the homelab's status.  

Through the Proxmox Web UI, all VMs have a yellow warning indicator on them,
which I've never seen before. 

Hovering over one of the VMs, the hover text is "`Status: io-error`".  

I check some basic disk info:

- Command:
  ```bash
  cat /proc/mdstat
  ```
  Output:
  ```plaintext
  Personalities : [raid1] [raid0] [raid6] [raid5] [raid4] [raid10]
  md1 : active raid1 sdc3[0] sda3[2]
        233249344 blocks super 1.2 [2/2] [UU]
        bitmap: 1/2 pages [4KB], 65536KB chunk
  
  unused devices: <none>
  ```
  The `[UU]` indicates that both disks are healthy. This is the RAID array that
  holds the all the LVM for the root filesystem as well as some of the VM
  storage.  

- Command:
  ```bash
  zpool status
  ```
  Output:
  ```plaintext
    pool: vmdata
   state: ONLINE
  config:
  
          NAME        STATE     READ WRITE CKSUM
          vmdata      ONLINE       0     0     0
            sdb       ONLINE       0     0     0
  
  errors: No known data errors
  ```
  This looks fine, but I hadn't used this ZFS pool at all for any of the VMs yet.  

All 3 disks that are currently connected passed the `smartctl -a`
self-assessment check.  

I decide to check journald logs.  

- Command:
  ```bash
  root@home-pve:~# journalctl -p err -b | grep -iE 'zfs|md|sda|sdb|io|blk'
  ```
  Output:
  ```plaintext
  Oct 20 16:07:10 home-pve.lab pvedaemon[3027612]: connection timed out
  Oct 20 16:07:10 home-pve.lab pvedaemon[2768934]: <root@pam> end task UPID:home-pve:002E329C:05A06896:68F69664:vncproxy:1000:root@pam: connection timed out
  Oct 20 16:13:26 home-pve.lab pmxcfs[1699]: [ipcs] crit: connection from bad user 1000! - rejected
  Oct 20 16:13:26 home-pve.lab pmxcfs[1699]: [libqb] error: Error in connection setup (/dev/shm/qb-1699-3029009-33-cLzVOD/qb): Unknown error -1 (-1)
  Oct 20 16:13:26 home-pve.lab pmxcfs[1699]: [ipcs] crit: connection from bad user 1000! - rejected
  Oct 20 16:13:26 home-pve.lab pmxcfs[1699]: [libqb] error: Error in connection setup (/dev/shm/qb-1699-3029009-33-CCJc9A/qb): Unknown error -1 (-1)
  Oct 20 16:13:26 home-pve.lab pmxcfs[1699]: [ipcs] crit: connection from bad user 1000! - rejected
  Oct 20 16:13:26 home-pve.lab pmxcfs[1699]: [libqb] error: Error in connection setup (/dev/shm/qb-1699-3029009-33-GpSx4V/qb): Unknown error -1 (-1)
  Oct 20 16:13:26 home-pve.lab pmxcfs[1699]: [ipcs] crit: connection from bad user 1000! - rejected
  Oct 20 16:13:26 home-pve.lab pmxcfs[1699]: [libqb] error: Error in connection setup (/dev/shm/qb-1699-3029009-33-7BKqdM/qb): Unknown error -1 (-1)
  ```
  No error in I/O that I can see.  

- I'll check to see if storage is full.  
  Command:
  ```bash
  df -h
  ```
  Output:
  ```plaintext
  Filesystem            Size  Used Avail Use% Mounted on
  udev                   16G     0   16G   0% /dev
  tmpfs                 3.2G  2.5M  3.2G   1% /run
  /dev/mapper/pve-root   65G   26G   36G  42% /
  tmpfs                  16G   52M   16G   1% /dev/shm
  tmpfs                 5.0M     0  5.0M   0% /run/lock
  efivarfs              304K  126K  174K  42% /sys/firmware/efi/efivars
  /dev/sda2            1022M   12M 1011M   2% /boot/efi
  /dev/fuse             128M   28K  128M   1% /etc/pve
  tmpfs                 3.2G     0  3.2G   0% /run/user/1000
  /dev/sdc2            1022M   12M 1011M   2% /boot/efi2
  vmdata                462G  128K  462G   1% /vmdata
  ```
  Storage is not full.

- Maybe it's a different issue. Are the mounted drives somehow readonly?  
  ```bash
  mount | grep -wi 'ro'
  ```
  Output:
  ```plaintext
  /dev/mapper/pve-root on / type ext4 (rw,relatime,errors=remount-ro)
  ramfs on /run/credentials/systemd-sysusers.service type ramfs (ro,nosuid,nodev,noexec,relatime,mode=700)
  ramfs on /run/credentials/systemd-tmpfiles-setup-dev.service type ramfs (ro,nosuid,nodev,noexec,relatime,mode=700)
  /dev/sda2 on /boot/efi type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
  ramfs on /run/credentials/systemd-sysctl.service type ramfs (ro,nosuid,nodev,noexec,relatime,mode=700)
  ramfs on /run/credentials/systemd-tmpfiles-setup.service type ramfs (ro,nosuid,nodev,noexec,relatime,mode=700)
  /dev/sdc2 on /boot/efi2 type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
  ```

- I can use `pvesh` to check the status of the disks...  
  ```bash
  pvesh get /nodes/home-pve/disks/list
  ```
  Output:
  ```plaintext
  ┌──────────┬─────┬─────────┬───────┬────────────┬──────────────┬────────┬───────────────────────┬────────┬──────────────────────┬───────────┬──────────┬────────────────────┐
  │ devpath  │ gpt │ mounted │ osdid │ osdid-list │         size │ health │ model                 │ parent │ serial               │ used      │ vendor   │ wwn                │
  ╞══════════╪═════╪═════════╪═══════╪════════════╪══════════════╪════════╪═══════════════════════╪════════╪══════════════════════╪═══════════╪══════════╪════════════════════╡
  │ /dev/sda │ 1   │         │    -1 │            │ 240057409536 │ PASSED │ INTEL_SSDSC2BB240G7   │        │ PHDV703406T8240AGN   │ BIOS boot │ ATA      │ 0x55cd2e414d63b19c │
  ├──────────┼─────┼─────────┼───────┼────────────┼──────────────┼────────┼───────────────────────┼────────┼──────────────────────┼───────────┼──────────┼────────────────────┤
  │ /dev/sdb │ 1   │         │    -1 │            │ 512110190592 │ PASSED │ FIKWOT_FX812_512GB    │        │ MX_00000000000030083 │ ZFS       │ ATA      │ 0x50c82d5000000084 │
  ├──────────┼─────┼─────────┼───────┼────────────┼──────────────┼────────┼───────────────────────┼────────┼──────────────────────┼───────────┼──────────┼────────────────────┤
  │ /dev/sdc │ 1   │         │    -1 │            │ 240057409536 │ PASSED │ KINGSTON_SA400S37240G │        │ 50026B77858FFF4C     │ BIOS boot │ ATA      │ 0x50026b77858fff4c │
  └──────────┴─────┴─────────┴───────┴────────────┴──────────────┴────────┴───────────────────────┴────────┴──────────────────────┴───────────┴──────────┴────────────────────┘
  ```
  The `health` section says `PASSED` for each of the disks.  


I'll try doing a bulk shutdown and restart of all VMs. In the Proxmox Web UI, I
right click my `home-pve` node and do a "Bulk Shutdown" of all VMs with the
status `io-error`.  

At 11:10, the bulk shutdown executed successfully.  
I attempt to start a VM, and the error presents itself again.  

I recently moved all the LVM stuff from the installation process to a RAID
array. I wonder if this has anything to do with the error. However, this error
did not present itself when the migration happened, or on subsequent reboots.  


- I'll check the storage.cfg to see if there are any references to the old disk
  (from before migrating to the RAID array).  
  ```bash
  root@home-pve:~# cat /etc/pve/storage.cfg
  ```
  Output:
  ```plaintext
  dir: local
          path /var/lib/vz
          content backup,vztmpl,iso
  
  lvmthin: local-lvm
          thinpool data
          vgname pve
          content images,rootdir
  
  zfspool: vmdata
          pool vmdata
          content rootdir,images
          mountpoint /vmdata
          sparse 1
  ```
  I see no reference to `/dev/sda` (the original disk that held the LVM).  

- Checking the PVs, VGs, and LVs.  

    - Command (check PVs):
      ```bash
      pvs
      ```
      Output:
      ```plaintext
      PV         VG  Fmt  Attr PSize   PFree
      /dev/md1   pve lvm2 a--  222.44g <15.88g
      ```

    - Command (check VGs):
      ```bash
      vgs
      ```
      Output:
      ```plaintext
      VG  #PV #LV #SN Attr   VSize   VFree
      pve   1  21   0 wz--n- 222.44g <15.88g
      ```

    - Command:
      ```bash
      lvs
      ```
      Output:
      ```plaintext
      LV                                        VG  Attr       LSize    Pool Origin                                   Data%  Meta%  Move Log Cpy%Sync Convert
      base-105-disk-0                           pve Vri-a-tz-k   80.00g data                                          7.76
      base-9000-disk-0                          pve Vri---tz-k   32.00g data                                    
      data                                      pve twi-aotzD- <130.27g                                               100.00 4.74
      root                                      pve -wi-ao----   65.64g                                         
      snap_vm-1010-disk-0_fm-server-bare        pve Vri---tz-k   80.00g data vm-1010-disk-0                     
      snap_vm-102-disk-0_clean-install-ansible  pve Vri---tz-k   32.00g data                                    
      snap_vm-102-disk-0_clean-install-with-ssh pve Vri---tz-k   32.00g data                                    
      snap_vm-104-disk-0_clean-install          pve Vri---tz-k   80.00g data vm-104-disk-0                      
      snap_vm-106-disk-0_clean                  pve Vri---tz-k   32.00g data vm-106-disk-0                      
      swap                                      pve -wi-ao----    8.00g                                         
      vm-1000-disk-0                            pve Vwi-a-tz--   80.00g data base-105-disk-0                          7.77
      vm-1010-disk-0                            pve Vwi-a-tz--   80.00g data base-105-disk-0                          41.05
      vm-102-disk-0                             pve Vwi-aotz--   32.00g data snap_vm-102-disk-0_clean-install-ansible 30.61
      vm-102-state-clean-install-ansible        pve Vwi-a-tz--   <4.49g data                                          27.93
      vm-102-state-clean-install-with-ssh       pve Vwi-a-tz--   <4.49g data                                          24.47
      vm-1020-disk-0                            pve Vwi-a-tz--   80.00g data base-105-disk-0                          36.20
      vm-104-disk-0                             pve Vwi-a-tz--   80.00g data base-105-disk-0                          35.50
      vm-104-state-clean-install                pve Vwi-a-tz--   <8.49g data                                          30.57
      vm-106-disk-0                             pve Vwi-a-tz--   32.00g data base-9000-disk-0                         22.60
      vm-106-state-clean                        pve Vwi-a-tz--   <8.49g data                                          33.04
      vm-3000-disk-0                            pve Vwi-a-tz--   80.00g data base-105-disk-0                          12.13
      ```

The `data` LV seems like it has 100% usage, so that storage is saturated.  
It looks like I mistakenly created a template of a VM with 80GB allocated for
storage, which is way too much. 

### Solution

The `pve-data` LV was full due to cloning templates with a large storage
allocation.  

Solution: Reallocate the amount of storage allowed for these clones.

- Check the LV in question:
  ```bash
  lvs | grep -iP 'data\s*pve'
  ```
  Output:
  ```plaintext
  data  pve twi-aotzD- <130.27g  100.00 4.74
  ```
  I destroyed one VM that was using 80GB. The output changed to:
  ```plaintext
  data pve twi-aotz-- <130.27g  99.56  4.71
  ```
  So this only trimmed 0.44% of the space being used. However, it freed up some
  space to work with.  

The actual `local-lvm` stoarge has 139.87GiB **TOTAL** storage space.  
All VM data must be migrated over to the `vmdata` ZFS pool.  



## Ubuntu Installer Fails

After rebuilding the ZFS pool and migrating most of the VMs I have over to it,
I attempted to install Ubuntu Server to replace the templates that I lost
during the drive failure incident.  

When setting up the VM via the Proxmox Web UI, I chose:

- OS
    - Using ISO from storage `local` 
      ```plaintext
      ubuntu-22.04.3-live-server-amd64.iso
      ```
    - Guest OS is Linux, version "6.x - 2.6 Kernel"

- System
    - Graphic card: Default
    - Machine: Default (i440fx)
    - SCSI Controller: VirtIO SCSI single
    - BIOS: SeaBIOS
    - QEMU Agent: Enabled

- Disks:
    - Bus/Device: SCSI 0 
    - SCSI Controller: VirtIO SCSI single
    - Storage: `vmdata`, 32 GiB
    - Discard: no
    - IO thread: yes
    - SSD emulation: no
    - Backup: yes
    - Readonly: no
    - Skip replication: no
    - Async IO: Default (io_uring)
    
- CPU
    - Sockets: 1
    - Cores: 1
    - Type: `x86-64-v2-AES`
        - I have also tried Type: `host`
    - 

- Memory: 4096 MiB
    - Ballooning Device: Enabled

- Network:
    - Bridge: vmbr0
    - Model: VirtIO (paravirtualized)
    - Firewall: enabled

### The Error

```plaintext
finish: cmd-install/stage-curthooks/builtin/cmd-curthooks/installing-kernel: FAIL: installing kernel
finish: cmd-install/stage-curthooks/builtin/cmd-curthooks: FAIL: curtin command curthooks

Traceback (most recent call last):
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/commands/main.py", line 202, in main
    ret = args.func(args)
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/commands/curthooks.py", line 2217, in curthooks
    builtin_curthooks(cfg, target, state)
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/commands/curthooks.py", line 2050, in builtin_curthooks
    install_kernel(cfg, target)
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/commands/curthooks.py", line 397, in install_kernel
    install(kernel_cfg.package)
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/commands/curthooks.py", line 362, in install
    distro.install_packages([pkg], target=target, env=flash_kernel_env())
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/distro.py", line 473, in install_packages
    return install_cmd('install', args=pkglist, opts=opts, target=target)
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/distro.py", line 255, in run_apt_command
    cmd_rv = apt_install(mode, args, opts=opts, env=env, target=target)
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/distro.py", line 303, in apt_install
    cmd_rv = inroot.subp(cmd + dl_opts + packages, env=env)
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/util.py", line 843, in subp
    return _subp(*args, **kwargs)
  File "/snap/subiquity/68711/lib/python3.12/site-packages/curtin/util.py", line 323, in _subp
    raise ProcessExecutionError(stdout_out, stderr_err)

curtin.util.ProcessExecutionError: Unexpected error while running command.

Command: ['unshare', '--fork', '--pid', '--mount-proc=/target/proc', '--', 'chroot', '/target', 'apt-get', '--quiet', '--assume-yes', '--option=Dpkg::options::=--force-confold', 'install', '--download-only', 'linux-generic']

Exit code: 100
Reason: -
Stdout: .
Stderr: .

Unexpected error while running command.
Command: ['unshare', '--fork', '--pid', '--mount-proc=/target/proc', '--', 'chroot', '/target', 'apt-get', '--quiet', '--assume-yes', '--option=Dpkg::options::=--force-confold', 'install', '--download-only', 'linux-generic']
Exit code: 100
Reason: -
Stdout: .
```

This error seems to  be part of the curtin process, and `apt-get` was the
problematic process while trying to **download** `linux-generic` (`--download-only`).
The error was presented as a Python traceback.  

The return code of `100` wasn't incredibly useful. From `man apt-get`:
```plaintext
DIAGNOSTICS
       apt-get returns zero on normal operation, decimal 100 on error.
```
However, since it was an `apt-get install` with `--download-only`, we can
assume that the **download** of the `linux-generic` kernel was failing.  

---

### OS Installation Fix

After attempting this installation process several times, using the same 
configuration (no changes made whatsoever), the install (on `vmdata`) was 
successful.  

Nothing was changed in either the VM configuration or storage setup, so I'm 
really not sure why it suddenly works. But it suddenly works.  

### Forensic Analysis

I found that the logs from the OS installation process are stored in `/var/log/install`.  
```bash
cd /var/log/install
```

I examined the installation logs after the successful installation, searching for
the step that was previously failing to see if I could find any hints as to
what the problem may have been.  
```bash
grep -rin 'install kernel'  # lines 945 and 1620
vi /var/log/install/curtin-install.log +945
```
Looking around during this step, I found the previously problematic line of 
the system call that attempted to install `linux-generic` via `apt-get`.  

- Line 987:
  ```plaintext
  Running command ['unshare', '--fork', '--pid', '--mount-proc=/target/proc', '--', 'chroot', '/target', 'apt-get', '--quiet', '--assume-yes', '--option=Dpkg::options::=--force-unsafe-io', '--option=Dpkg::Options::=--force-confold', 'install', '--download-only', 'linux-generic'] with allowed return codes [0] (capture=False)
  ```
    - This was the previously failed command. Download of the kernel itself
      (not the installation).  

- Line 1107:
  ```plaintext
  Running command ['unshare', '--fork', '--pid', '--mount-proc=/target/proc', '--', 'chroot', '/target', 'apt-get', '--quiet', '--assume-yes', '--option=Dpkg::options::=--force-unsafe-io', '--option=Dpkg::Options::=--force-confold', 'install', '-', 'linux-generic'] with allowed return codes [0] (capture=False)
  ```
    - This was not a `--download-only` as the previous `apt-get` command, this
      was the actual full installation of `linux-generic`.  

This line displayed no errors, and seems to have executed successfully.  
```plaintext
finish: cmd-install/stage-curthooks/builtin/cmd-curthooks/installing-kernel: SUCCESS: installing kernel
```
However, the following line from the error:
```plaintext
finish: cmd-install/stage-curthooks/builtin/cmd-curthooks: FAIL: curtin command curthooks
```
...was not directly under the `installing kernel` success log as it was in the
error log. Instead it came 252 lines later. This is likely due to the fact that 
the `cmd-curthooks` step only finishes with all other steps in the `cmd-curthooks/`
directory are completed successfully.   

---

### Conclusion

The only thing I can think of is that there was a temporary network failure,
causing the download of the `linux-generic` kernel to fail, which in turn
caused the entire installation process to fail.  

I didn't think that was entirely likely, as the installer does a test of the
package mirror before attempting to install, and the mirror test passed without
issue.  





