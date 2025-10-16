# Building Redundant Storage 

After going through a headache with a failed drive, I'm rebuilding my Proxmox
homelab's storage setup to be redundant.  

When Proxmox was installed intially, we used LVM instead of ZFS.  

If we had used ZFS for the root filesystem/boot drive, we could have leveraged 
the internal mirroring that it supports.  

But, we didn't, so we're going to set up RAID1 mirroring for the LVM.  

- ZFS **does not** manage the ESP, so even on a ZFS-mirrored boot drive, the EFI
  partitions must be manually maintained for each boot disk. So if we
  wanted redundant boot disks, we'd have to go through at least some of these 
  steps anyway.  

We did use ZFS for `vmdata`, our extra storage pool, but that came later.  

## Setting up RAID1 for Root Filesystem

For the root filesystem (mounted at `/`), we will use a RAID1 array.  

The root filesystem on my server is mounted via LVM.   

!!! example "Find Your Own Root Filesystem"

    If you're going to be using this as a guide, make sure to check what your
    root filesystem is!
    ```bash
    findmnt /
    ```
    You'll see this type of output:
    ```plaintext
    TARGET SOURCE               FSTYPE OPTIONS
    /      /dev/mapper/pve-root ext4   rw,relatime,errors=remount-ro
    ```
    For my case, `/dev/mapper/pve-root` is the root filesystem, which is a
    logical volume (LV) through LVM. The typical naming convention here is
    `VGname-LVname`, so `pve-root` is the `root` LV, belonging to the `pve` volume 
    group (VG).  

    Find which physical volume is being used for that LV with `pvs`.  
    ```bash
    sudo pvs
    ```
    This will show you the VG that the disks are associated with. It will
    typically be `/dev/sda3`.  

    Run these commands to find your own root filesystem and its corresponding
    disk drive.  

Now that we've determined that our root files are managed in LVM, and
identified which volume groups and physical volumes are being used, that makes
migration pretty simple.  

There are four(5) main steps here (ultra-simplified).{ .annotate }

1. Add the new drive, create a degraded RAID1 array from it
2. Add the RAID array to LVM  
3. Migrate all LVM data from old drive to new RAID array  
4. Remove old drive from LVM, then add it to the RAID array  
5. These are the conceptual steps, there are many more technical steps in this
   process.

There's a lot more to it than that, but that's the concept.  

The disks that I'll be using on this page (for my case):

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
    - We can even verify that it's mirrored by looking at `lsblk`. The
      `/dev/sda3` and `/dev/sdc3` entries should look identical.  
      ```bash
      diff <(lsblk /dev/sda3) <(lsblk /dev/sdc3)
      ```
      The only difference is the disk name.  
      ```plaintext
      2c2
      < sda3                                                    8:3    0 222.6G  0 part
      ---
      > sdc3                                                    8:35   0 222.6G  0 part
      ```


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

1. Sync the EFI contents from the original boot partition.  
   ```bash
   rsync -aiv --delete /boot/efi/ /boot/efi2/
   ```
    - !!! warning "Include the trailing slashes!"
          Make sure you include the trailing slashes in the directory names. If
          you don't, it will copy the `efi` directory *itself*, causing the ESP
          filesystem hierarchy to be incorrect.  
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
   sudo efibootmgr -c -d /dev/sda -p 2 -L "Proxmox (sda2)" -l '\EFI\proxmox\shimx64.efi'
   sudo efibootmgr -c -d /dev/sdc -p 2 -L "Proxmox (sdc2)" -l '\EFI\proxmox\shimx64.efi'
   ```

    - ???+ info "Choosing the Right Loader"
          In this case, the OS loader is `shimx64.efi`.  
          This bootloader is primarily for when Secure Boot is enabled in BIOS (UEFI).  
          If you do not have secure boot enabled, you can use `grubx64.efi`
          instead of `shimx64.efi`.  
          - `shimx64.efi`: a Microsoft-signed first-stage loader that validates and then chains to GRUB. Required when Secure Boot = ON.  
          - `grubx64.efi`: GRUB directly. Works when Secure Boot = OFF (or on systems allowing it).  
          I chose `shimx64.efi` since that was what the default loader used by
          Proxmox.  
          There's really no drawback to using `shimx64.efi`, it's more
          compatible because it works whether Secure Boot is enabled or not.  

    - If you need to **delete** one of the boot entries that you made (you made
      a mistake and you need to re-do it [this definitely didn't happen to me]),
      first identify the number that was assigned to it (`Boot000X`) with:
      ```bash
      sudo efibootmgr
      ```
      Then, if you wanted to delete the `Boot0006` entry, you'd specify `-b 6` along with `-B`.  
      ```bash
      sudo efibootmgr -b 6 -B 
      ```

    - Verify with:
      ```bash
      sudo efibootmgr
      ```
      You should see them as:
      ```plaintext
      Boot0006* Proxmox (sda2)
      Boot0007* Proxmox (sdc2)
      ```
      Numbers may vary.  

    - We can also add removable fallback bootloaders to act as a safety net if
      NVRAM (Non-Volatile RAM) entries are ever lost (this part is optional).  
      ```bash
      sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable
      sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi2 --removable
      ```
      This writes a standard fallback loader to `\EFI\BOOT\BOOTX64.EFI`.  
      It guarantees the machine will still boot even if all EFI entries vanish, 
      so it's definitely a good thing to do.

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
We'll need to use one disk partition for this, cloned from the original boot
disk.

- `/` (root): All the data in the root filesystem, will hold the LVM

If we were using BIOS (Legacy boot), we'd need one more for `/boot`.  

- `/boot`: Not needed on UEFI boot systems.  
    - This is **only for systems that use BIOS/Legacy Boot mode.**
    - If `/dev/sda2` is UEFI (mounted at `/boot/efi`) then we do **NOT**
      create a RAID array for it.  
    - UEFI firmware does not play well with `md` metadata, so it's backed up in
      a different way.  

!!! warning "Degraded RAID Array"

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
    backwards compatibility, even if the system is in UEFI mode. Make sure to
    check it.  

Check to make sure the new array exists and is healthy.  
```bash
sudo mdadm --detail /dev/md1
```
Output should look like:
```plaintext
/dev/md1 : active raid1 sdc3[0]
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
   This is the volume group that all of the system's LVs are build on top of.  

3. Live-migrate all LVs from the old PV (`/dev/sda3`) onto the array
   !!! info inline end
       This will take a while. In my case, it took roughly an hour and a half.  
   ```bash
   sudo pvs # confirm PV names
   sudo pvmove /dev/sda3 /dev/md1
   ```
    - You can keep an eye on the elapsed time with this:
      ```bash
      ps -o etime -p "$(pgrep pvmove)"
      # Or keep it running to see it count up:
      watch -n 5 'ps -o etime -p "$(pgrep pvmove)"'
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
<!-- TODO(fix): Add explanations to this section -->
This is how I set up redundancy for the **OS boot** itself.  

This is *technically* optional if all you want is data backup for your root 
filesystem, but I wanted to be able to boot from the backup drive if one fails 
rather than using a bootable USB to boot into recovery mode.  


This assumes you have already [cloned your boot disk's partition table](#backup-and-mirror-partition-table).  

We don't use `mdadm` RAID for UEFI boot data because the EFI firmware does not 
play well with `md` metadata.  

We will mirror the original boot disk's ESP to the new disk.  

??? info "What is an ESP?"

    ESP stands for EFI System Partition. It's the FAT32 partition (in this
    layout, it's `/dev/sda2) that UEFI firmware reads at boot time to find
    bootloader files (e.g., `/EFI/BOOT/BOOT64.EFI` or
    `/EFI/proxmox/grubx64.efi`)

### Make a New FAT32 Filesystem

First we make a FAT32 filesystem to mirror the one one the original boot disk.  
```bash
sudo mkfs.vfat -F32 /dev/sdc2
```

### Mount the New Filesystem
After we've created the FAT32 filesystem, we need to create a mountpoint and
mount it so that we can copy over the files we need.  
```bash
sudo mkdir -p /boot/efi2
sudo mount /dev/sdc2 /boot/efi2
```
The name can be anything, doesn't have to be `efi2`, but that's what I chose
for clarity.  

### Mirror the ESP
Use `rsync` to create a full mirror of the `/boot/efi` directory into
`/boot/efi2`.  
```bash
sudo rsync -a --delete /boot/efi/ /boot/efi2/
```

!!! tip "Include trailing slashes!"

    When specifying the directories in the `rsync` command, you **must**
    include the trailing slashes to create an actual mirror.  
    If you ran this without the trailing slashes, it would copy the `/boot/efi` 
    directory **itself**, which is not what we want. We only want the
    **contents** of that directory, which is what the trailing slash tells
    `rsync`.  

Once that's done, move onto the next step.  

### Install GRUB on Both ESPs
Now that the files are there, we can use `grub-install` to install the
bootloader onto the partitions.  

```bash
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi  --bootloader-id=proxmox  --recheck
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi2 --bootloader-id=proxmox2 --recheck
```

Make sure to run `update-grub` afterwards. This will generate a new GRUB 
configuration file.  

```bash
sudo update-grub
# or, if that's not available for some reason
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

The `update-grub` command is a wrapper utility for `grub-mkconfig`, so use whichever
floats ya boat.  


### Set up EFI Boot Manager
We'll need to add some new entries into the EFI boot manager specifying our
desired bootloader.  
```bash
sudo efibootmgr -c -d /dev/sda -p 2 -L "Proxmox (sda2)" -l '\EFI\proxmox\shimx64.efi'
sudo efibootmgr -c -d /dev/sdc -p 2 -L "Proxmox (sdc2)" -l '\EFI\proxmox\shimx64.efi'
```

- `efibootmgr`: This is the userspace application used to modify the UEFI b oot
  manager. It can create, destroy, and modify boot entries.  

    - `-c`: Create a new boot entry.  
    - `-d /dev/sdX`: Specify the disk we're using.  
    - `-p 2`: Specify the boot partition on the disk.  
    - `-L "Proxmox (sdX2)"`: The label to give to the boot entry.  
    - `-l '\EFI\proxmox\shimx64.efi'`: Specify the bootloader to use.  


???+ info "Choosing the Right Bootloader"

    In this case, the OS loader is `shimx64.efi`.  
    This bootloader is primarily for when Secure Boot is enabled in BIOS (UEFI).  
    If you do not have secure boot enabled, you can use `grubx64.efi`
    instead of `shimx64.efi`.  
    - `shimx64.efi`: a Microsoft-signed first-stage loader that validates and then chains to GRUB. Required when Secure Boot = ON.  
    - `grubx64.efi`: GRUB directly. Works when Secure Boot = OFF (or on systems allowing it).  
    I chose `shimx64.efi` since that was what the default loader used by
    Proxmox.  
    There's really no drawback to using `shimx64.efi`, it's more
    compatible because it works whether Secure Boot is enabled or not.  

???+ tip "Deleting an Entry"

    If you need to **delete** one of the boot entries that you made (you made
    a mistake and you need to re-do it [this definitely didn't happen to me]),
    first identify the number that was assigned to it (`Boot000X`) with:
    ```bash
    sudo efibootmgr
    ```
    Then, if you wanted to delete the `Boot0006` entry, you'd specify `-b 6` along with `-B`.  
    ```bash
    sudo efibootmgr -b 6 -B 
    ```

Once you've created the boot entries, verify that they're there and using the
bootloader that you specified.  
```bash
sudo efibootmgr -v
```


### Add Fallback Loaders (Optional)
We can also add removable fallback bootloaders to act as a safety net if
NVRAM (Non-Volatile RAM) entries are ever lost (this part is optional).  
```bash
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi2 --removable
```
This writes a standard fallback loader to `\EFI\BOOT\BOOTX64.EFI`.  
It guarantees the machine will still boot even if all EFI entries vanish, 
so it's definitely a good thing to do.

### Changing Boot Order

The boot order should be appropriately updated after doing all these steps, but
if you want to manually change it, it can be done with the `-o` option.  

Identify the numbers associated with the boot entries.  
```bash
sudo efibootmgr
```
Then use the `Boot####` numbers in the command (comma-delimited).  
```bash
sudo efibootmgr -o 0006,0005,0004,0003
```

### Reboot

Reboot to make sure you're booting from the new boot entries.  

### Delete Old Boot Entry (Optional)

Once all that's done, you should be able to safely delete the old boot entry.  

!!! warning "Make sure you did it right!"

    This step is destructive. If you delete the original boot entry and your
    new ones are formatted incorrectly, it may cause you to be locked out of
    your system. Verify that your bootloader entries are correct before doing
    this.  

    You may want to test first by [changing the boot order](#changing-boot-order)
    to boot using the new entires.  


First, verify the **number** associated with the original boot entry.  
```bash
sudo efibootmgr
```

Find the original entry. Mine was simply labeled "`proxmox`", and it was
`Boot0005` (number `5`).  
```bash
sudo efibootmgr -b 5 -B 
```
That will delete the old boot entry.  


## Replacing a Failed Boot Disk (DR)
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

---

## ZFS Rebuild (for `vmdata`)
The `vmdata` ZFS pool was set up after the original OS installation.  
The failed drive affected this ZFS pool.  

This approach uses ZFS internal mirroring rather than traditional software RAID 
through `mdadm`.  

ZFS makes it really easy to mirror a disk for redundancy. The process is
built-in to the `zpool` utility.  

1. Wipe and rebuild
   ```bash
   wipefs -a /dev/sdc # clear old zfs labels
   wipefs -a /dev/sdd # clear new disk
   ```

2. Create new, **mirrored** pool.  
   ```bash
   sudo zpool create vmdata mirror /dev/sdc /dev/sdd
   sudo zpool status
   ```

3. Add to Proxmox, then verify.  
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
Then run:
```bash
sudo update-grub
```

If the RAID root doesn't boot, we can use a rescue/live CD to re-check
`/etc/fstab` (shouldn't be an issue with LVM) and bootloader settings.

