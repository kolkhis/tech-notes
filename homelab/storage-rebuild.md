# Building Redundant Storage 

After going through a headache with a failed drive, I'm rebuilding my Proxmox
lab's storage setup to be redundant.  

When Proxmox was installed intially, we used LVM instead of ZFS.  

If we had used ZFS for the root filesystem/boot drive, we could have leveraged 
the internal mirroring that it supports.  

But, we didn't, so we're going to set up RAID1 mirroring for the LVM.  

We did use ZFS for `vmdata`, but that came later.  

## Setting up RAID1 for Root Filesystem
This is what we'll do to set up RAID1 for our boot drive, in case that ever
fails. 

If the boot drive fails, we still want to maintain our data.   

- `/dev/sda` is the main boot disk that contains the root filesystem.  
- `/dev/sdc` is the disk that I'll be using for the backup.  

## High Level Overview

These are the basic steps I took to migrate my root filesystem, which was 
installed via the Proxmox VE installer with LVM, to a RAID1 array.    

These steps would also work with any other Debian-based Linux system
installation that was done with LVM. The names of the volume groups will
change, but the same fundamental principles will work.  


### Creating a RAID1 Array for the Root Filesystem  

This is the truncated version of the writeup. Contains just the basic commands
used and brief explanations on what they're doing and the state of the
migration.  

!!! info "Root Access Required"

    These command assume root access. Use `sudo` if you're not on the root user.  

1. Add new physical disk to server.
    - In my case, I also needed to use passthrough mode for the disk by rebooting into 
      BIOS and changing the device settings to "Convert to Non-RAID disk" (the hardware 
      RAID controller in my server would prevent the OS from using it).  

1. Copy the boot drive's disk partition table to the new drive.
   ```bash
   sgdisk --backup=table.sda /dev/sda
   sgdisk --load-backup=table.sda /dev/sdc
   sgdisk --randomize-guids /dev/sdc # To make the GUIDs unique
   ```
    - This mirrors the boot drive's partitions so we don't need to create them
      manually.  

1. Create a **degraded** RAID1 array using the new disk.  
   ```bash
   mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdc3 missing
   ```
    - Degraded, in this context, means leaving the second disk out of the array ("`missing`").  
    - `/dev/sda3` is where the root filesystem LVM lives, so we use `/dev/sdc3`
      (the backup disk's equivalent).
    - Confirm it's been created
      ```bash
      cat /proc/mdstat
      ```
      We should see our `md1` array here with `[U_]` (one of two devices):
      ```plaintext
      Personalities : [raid1]
      md1 : active raid1 sdc3[0]
            233249344 blocks super 1.2 [2/1] [U_]
            bitmap: 2/2 pages [8KB], 65536KB chunk
      ```

1. Add the RAID device to LVM.
   ```bash
   pvcreate /dev/md1
   pvs # confirm it's there
   ```
    - This adds the RAID array as a physical volume (PV) to be used by LVM.  
    - The `pvs` output should look something like this:
      ```plaintext
        PV         VG  Fmt  Attr PSize    PFree
        /dev/md1       lvm2 ---   222.44g 222.44g
        /dev/sda3  pve lvm2 a--  <222.57g  16.00g
      ```

1. Add the array to the `pve` Volume Group.  
   ```bash
   vgs # confirm VG name
   vgextend pve /dev/md1
   ```
    - We can transfer all the data from the `/dev/sda` disk to the
      `/dev/md1` RAID array now that they're in the same volume group.
    - Confirm it's been added.  
      ```bash
      vgs # confirm the `#PV`
      ```
      Check the `#PV` column. It should be `2`.  
      ```plaintext
      VG  #PV #LV #SN Attr   VSize    VFree
      pve   2  20   0 wz--n- <445.01g <238.45g
      ```

1. Live-migrate all LVs from the old PV (`/dev/sda3`) onto the array.  
   ```bash
   pvs # confirm PV names
   pvmove /dev/sda3 /dev/md1
   ```
    - This step will take a while. It will migrate all of the data on `/dev/sda3` to `/dev/md1`.  
        - You can keep an eye on the elapsed time with this:
          ```bash
          ps -o etime -p "$(pgrep pvmove)"
          # Or keep it running to see it count up:
          watch -n 5 'ps -o etime -p "$(pgrep pvmove)"'
          ```
    - Once it's done, make sure to confirm the migration succeeded.
      ```bash
      vgdisplay pve
      vgdisplay pve | grep -iP "free\s+pe\s+/\s+size"
      lvs -o +devices | grep md1
      ```
    - Check the free space for the old physical volume.
      ```bash
      sudo pvs
      ```
      Notice the `PFree` column in relation to `PSize`.  
      ```plaintext
      PV         VG  Fmt  Attr PSize    PFree
      /dev/md1   pve lvm2 a--   222.44g  <15.88g
      /dev/sda3  pve lvm2 a--  <222.57g <222.57g
      ```
      The `/dev/sda3` PV now is 100% free.  

1. Remove the original (`/dev/sda3`) from the `pve` volume group.  
   ```bash
   vgreduce pve /dev/sda3
   ```
   Output you should get:
   ```plaintext
   Removed "/dev/sda3" from volume group "pve"
   ```
    - At this point, LVM only uses `/dev/md1`. The LV root now physically
      lives in the RAID array.  

1. Save the RAID configuration.
   ```bash
   mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf
   update-initramfs -u
   ```
    - These make sure that the array is assembled during early boot.  
    - `update-initramfs -u` might be `dracut --regenerate-all --force` on
      some RedHat distros. We're on Proxmox, though, so that's not relevant here, but
      should be noted.  

1. Verify before reboot.
   ```bash
   lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
   ```
   You should see:
   ```plaintext
   └─sdc3                                                  222.6G part
     └─md1                                                 222.4G raid1
       ├─pve-swap                                              8G lvm   [SWAP]
       ├─pve-root                                           65.6G lvm   /
       ...
   ```
    - This confirms the LV for `/` is built on top of `/dev/md1` (in `/dev/sdc3`) instead of
      `/dev/sda3`.  

1. Reboot the system.
   ```bash
   reboot
   ```
   Check that the root filesystem is mounted with the RAID device.  
   ```bash
   cat /proc/mdstat
   lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
   findmnt /
   mount | grep ' / '
   ```

1. Once we've comfirmed that everything boots correctly and the RAID array
   is healthy, we can finally add the old boot disk to the mirror.  
   ```bash
   mdadm --add /dev/md1 /dev/sda3
   ```
   Then confirm:
   ```bash
   watch -n 2 "cat /proc/mdstat"
   ```
   Wait until it finishes syncinc. When we see `[UU]`, it means both disks are in sync.  
   ```plaintext
   Personalities : [raid1] [raid0] [raid6] [raid5] [raid4] [raid10]
   md1 : active raid1 sda3[2] sdc3[0]
         233249344 blocks super 1.2 [2/2] [UU]
         bitmap: 1/2 pages [4KB], 65536KB chunk

   unused devices: <none>
   ```
   When the RAID entry looks like this, it's complete.  


### Setting up Redundant Boot

This is optional, if your boot drive fails and you've already set up the RAID
array, your data is safe. But, you may need to boot from a recovery image in
that situation if you don't set up redundant boot.  

We're essentially going to mirror the ESP (EFI System Partition) on the
original boot disk (partition `/dev/sda2`) to the new backup disk, but not with
RAID.  

This part assumes you've already done the steps above to migrate the root LVM 
into a RAID array.  

1. Identify the boot partitions to turn into ESPs. The 
   `/dev/sda2` partition on my machine is mounted to `/boot/efi`, so `/dev/sdc2` 
   will be my backup (since the partition table is mirrored).
   ```bash
   findmnt /boot/efi
   #TARGET    SOURCE    FSTYPE OPTIONS
   #/boot/efi /dev/sda2 vfat   rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname
   ```

1. Format the redundant boot partition as FAT32. It'll be `/dev/sdc2` for me.  
   ```bash
   sudo mkfs.vfat -F32 /dev/sdc2
   ```
   Verify that the filesystem was created.
   ```bash
   lsblk -f /dev/sdc2
   ```
   The `FSVER` column should be set to `FAT32`.  

1. Mount the new ESP . Just a temp location to sync the
   boot files.
   ```bash
   sudo mkdir -p /boot/efi2
   sudo mount /dev/sdc2 /boot/efi2
   ```
   Verify that it's mounted.
   ```bash
   lsblk /dev/sdc2
   findmnt /boot/efi2
   ```

   !!! warning inline end "Include the trailing slashes!"
        Make sure you include the trailing slashes in the directory names. If
        you don't, it will copy the `efi` directory *itself*, causing the ESP
        filesystem hierarchy to be incorrect.  

1. Sync the EFI contents from the original boot partition.  
   ```bash
   rsync -aiv --delete /boot/efi/ /boot/efi2/
   ```
    - Output should look something like this:
      ```plaintext
      sending incremental file list
      cd+++++++++ EFI/
      cd+++++++++ EFI/BOOT/
      >f+++++++++ EFI/BOOT/BOOTx64.efi
      >f+++++++++ EFI/BOOT/fbx64.efi
      >f+++++++++ EFI/BOOT/grubx64.efi
      >f+++++++++ EFI/BOOT/mmx64.efi
      cd+++++++++ EFI/Dell/
      cd+++++++++ EFI/Dell/BootOptionCache/
      >f+++++++++ EFI/Dell/BootOptionCache/BootOptionCache.dat
      cd+++++++++ EFI/proxmox/
      >f+++++++++ EFI/proxmox/BOOTX64.CSV
      >f+++++++++ EFI/proxmox/fbx64.efi
      >f+++++++++ EFI/proxmox/grub.cfg
      >f+++++++++ EFI/proxmox/grubx64.efi
      >f+++++++++ EFI/proxmox/mmx64.efi
      >f+++++++++ EFI/proxmox/shimx64.efi

      sent 12,191,057 bytes  received 249 bytes  24,382,612.00 bytes/sec
      total size is 12,187,234  speedup is 1.00
      ```
    - Verify that both directories have the same contents.
      ```bash
      ls -alh /boot/efi /boot/efi2
      diff <(ls -alh /boot/efi/**) <(ls -alh /boot/efi2/**)
      ```
      No output on the `diff` is a good thing.  

1. Install GRUB on both paritions.
   ```bash
   sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=proxmox --recheck
   sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi2 --bootloader-id=proxmox --recheck
   ```
    - You can use the same `bootloader-id` for both entires. If you want it to
      be more specific (to be able to boot from a specific disk), give the two
      disks distinct `bootloader-id` values.  

1. Rebuild the GRUB menu.
   ```bash
   sudo update-grub
   ```

1. Add firmware boot entries for both drives to make sure UEFI firmware can
   boot from either disk.  
   ```bash
   sudo efibootmgr -c -d /dev/sda -p 2 -L "Proxmox (sda2)" -l '\EFI\proxmox\grubx64.efi'
   sudo efibootmgr -c -d /dev/sdc -p 2 -L "Proxmox (sdc2)" -l '\EFI\proxmox\grubx64.efi'
   ```
    - Verify with:
      ```bash
      sudo efibootmgr
      ```
      You should see them as:
      ```plaintext
      Boot00006* Proxmox (sda2)
      Boot00007* Proxmox (sdc2)
      ```
      Numbers may vary.  
    - We can also add removable fallback loaders to act as a safety net if
      NVRAM entries are ever lost (this part is optional).  
      ```bash
      sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable
      sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi2 --removable
      ```
      This writes a standard fallback loader to `\EFI\BOOT\BOOTX64.EFI`.  

1. Check that both ESPs exist and are populated. 
   ```bash
   sudo find /boot/efi{,2}/EFI -maxdepth 2 -type f
   ```
   Then check boot entries again.
   ```bash
   sudo efibootmgr -v
   ```

1. Test by rebooting. If we really want to test failover, we can test by
   disconnecting one disk at a time.  

That should be it for setting up both a redundant root filesystem with RAID and
mirroring the EFI System Partition.  

## Steps and Explanations

This is a little more long-form than the steps written above, but the process
is the same.  

### Backup and Mirror Partition Table
Create a mirror of the main boot drive's partition table on the new backup drive.  
Here we'll use `sgdisk` to save the GUID partition table.  

This will create the same partitions on the backup disk that the main boot disk 
has, essentially mirroring the drive's partition layout. All partitions on the
new disk will be the same size as the original.  
```bash
sudo sgdisk --backup=table.sda /dev/sda
sudo sgdisk --load-backup=table.sda /dev/sdc
sudo sgdisk --randomize-guids /dev/sdc
```

- `sgdisk`: Command-line GUID partition table (GPT) manipulator for Linux/Unix

- `--backup=table.sda /dev/sda`: Save `/dev/sda` partition data to a backup file.
    - The partition backup file is `table.sda`.  
- `--load-backup=table.sda /dev/sdc`: Load the `/dev/sda` partition data from the backup file.
- `--randomize-guids /dev/sdc`:
    - Randomize the disk's GUID and all partitions' unique GUIDs (but not their  
      partition type code GUIDs).  
    - Used after cloning a disk in order to render all GUIDs unique once again.

!!! info "Check your own disks!"

    These are the disks that I used.  
    `/dev/sda` is *my* main boot drive, it may not be *your* main boot drive.  
    `/dev/sdc` is *my* backup drive, it may not be *your* backup drive.  
    
    If you're using these notes as a guide, check which disks you need to be
    using on your machine.  

### Create RAID1 Array for Root Filesystem
We'll need one partition for this.

- `/` (root): All the data in the root filesystem, will hold the LVM

If we were using BIOS (Legacy boot), we'd need one more.  

- `/boot`: Not needed on UEFI boot systems.  
    - This is **only for systems that use BIOS/Legacy Boot mode.**
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

    The new, empty disk is `/dev/sdc` in this example. Don't put in the `/dev/sda3`
    partition, or it will be wiped.

Create the RAID array (degraded) with the **new backup disk's** `/dev/sdc3` partition.  
```bash
sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdc3 missing
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

The `[U_]` indicates that one out of two drives is present in the array and it
is healthy.

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
    - If you skip this step and your system boots fine, it's possible your RAID
      array may be given a random name (e.g., `md127`). If that happens, you
      can simply run the command and reboot to get the name you gave it.  

### Reboot and Confirm
Reboot the machine.  
```bash
sudo reboot
```
Then check that root `/` is on `md1`.  
```bash
lsblk
```
Check for this section:
```plaintext
└─sdc3                                                    8:35   0 222.6G  0 part
  └─md1                                                   9:1    0 222.4G  0 raid1
    ├─pve-swap                                          252:0    0     8G  0 lvm   [SWAP]
    ├─pve-root                                          252:1    0  65.6G  0 lvm   /
    ...
```
That shows us that the root filesystem `pve-root`, mounted on `/`, lives on the
new `md1` RAID array.  


### Finish the Mirror
Add the **old** partition (`/dev/sda3`) to the array now.  
```bash
sudo mdadm --add /dev/md1 /dev/sda3
```

Keep checking the `/proc/mdstat` file for `UU`.  
```bash
watch -n 2 "cat /proc/mdstat"
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



## UEFI ESP Boot Redundancy (No `mdadm`)
This is how you'd create redundancy for the **OS boot**. This step is
optional if all you want is data backup for your root filesystem.  

Again, we don't use `mdadm` RAID for UEFI boot data. The EFI firmware does not
play well with `md` metadata.  

```bash
sudo mkfs.vfat -F32 /dev/sdc2
sudo mkdir -p /boot/efi2
sudo mount /dev/sdc2 /boot/efi2
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



### Replacing a Failed Boot Disk (DR)
If `/dev/sda` fails, we'll still have the backup to boot from. But we'll want
to replace the disk with a new one to maintain redundancy.  

1. Replace it with a new disk of equal or larger size.

2. Clone the partition table:
   ```bash
   sudo sgdisk --backup=table.sdb /dev/sdc  # Use the original backup disk
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

### If GRUB Fails to Find Root Device

If GRUB is failing to find the root device when booting, we can specifically
add RAID as a preload module in `/etc/default/grub`.  

```bash
GRUB_PRELOAD_MODULES="lvm mdraid1x"
```
Then run:
```bash
sudo update-grub
```

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
wipefs -a /dev/sdc # clear old zfs labels
wipefs -a /dev/sdd # clear new Kingston SSD 
```

Create new, **mirrored** pool.  
```bash
sudo zpool create vmdata mirror /dev/sdc /dev/sdd
sudo zpool status
```

Add to Proxmox, then verify.  
```bash
pvesm add zfspool vmdata -pool vmdata
pvesm status
```



## Troubleshooting

If GRUB fails to find the root device, we can modify `/etc/default/grub` to
preload RAID by adding `mdraid1x` to `GRUB_PRELOAD_MODULES`.

```bash title="/etc/default/grub"
GRUB_PRELOAD_MODULES="lvm mdraid1x"
```

If the RAID root doesn't boot, we can use a rescue/live CD to re-check
`/etc/fstab` (shouldn't be an issue with LVM) and bootloader settings.

