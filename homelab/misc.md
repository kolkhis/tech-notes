# Misc.

A collection of miscellaneous notes for my homelab.  


## Disk Setup

- `/dev/sda`: Main boot disk, RAID1 mirrored to `/dev/sdc`.  
    - `sda1`: Reserved for BIOS partition
    - `sda2`: UEFI boot partition (`/boot/efi`)
    - `sda3`: Root filesystem, tmpfs, etc.
- `/dev/sdb`: ZFS pool `vmdata`, mirrored to `/dev/sdd`.  
- `/dev/sdc`: Mirrored RAID1 array (mdadm) backup of `/dev/sda`.  
    - Paritions mirrored from `/dev/sda`, UEFI system partition cloned.  
- `/dev/sdd`: Mirrored ZFS pool from `/dev/sdb`.  


