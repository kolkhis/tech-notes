# Building Redundant Storage 

After going through a headache with a failed drive, I'm rebuilding my Proxmox
lab's storage setup to be redundant.  

When Proxmox was installed intially, we used LVM instead of ZFS.  

If we had used ZFS, we could have leveraged the internal mirroring that it
supports. But, we didn't, so we're going to set up RAID1 mirroring for the LVM.  

We did use ZFS for `vmdata`, but that came later.  


## Setting up RAID1 for Root Filesystem
This is what we'll do to set up RAID1 for our boot drive, in case that ever
fails. 

If the boot drive fails, we still want to maintain our data.   


### Backup and Mirror Partition Table
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

### Create RAID1 Array for Root Filesystem
We'll need one partition for this.

- `/` (root): All the data in the root filesystem, will hold the LVM

If we were using BIOS (Legacy boot), we'd need one more.  

- `/boot`: Not needed on UEFI boot systems.  
    - This is **ONLY FOR SYSTEMS WITH BIOS/LEGACY BOOT MODE.**
    - If `/dev/sda2` is UEFI (mounted at `/boot/efi`) then we do **NOT**
      create a RAID array for it.  
    - UEFI firmware does not play well with `md` metadata, so it's backed up in
      a different way.  

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

### Migrate the Root Filesystem LVM to RAID1

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

### Save RAID Config
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

### UEFI ESP Boot Redundancy (No `mdadm`)
This is how you'd also create redundancy for the **OS boot**. This step is
optional if all you want is data backup.  

Again, we don't use `mdadm` RAID for UEFI boot data. The EFI firmware does not read
`md` metadata.  

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


### Reboot and Confirm
Reboot the machine.  
```bash
sudo reboot
```
Then check that root `/` is on `md1`.  
```bash
lsblk
```

### Finish the Mirror
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

### Replacing a Failed Boot Disk
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

---

## ZFS Rebuild (for `vmdata`)
The `vmdata` ZFS pool was set up after the original OS installation.  
The failed drive affected this ZFS pool.  


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

