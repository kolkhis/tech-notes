


# Reformat a Disk/USB Drive in Windows w/ `cmd`

## Check for System File Corruption 

`sfc`: System File Checker/Corruption
1. Open `cmd` as administrator.
1. Run the following command to check for, and repair, system file corruption:
```sh
sfc /scannow
```
Once the scan is done, follow any prompts to repair corrupted files.

`chkdsk`: Check Disk
```sh
chkdsk /f <drive_letter>:
```
Replace `<drive_letter>` with the drive letter of the USB drive. This command will schedule a disk check at the next system restart.

## Reformat using `diskpart`

Use DiskPart:
1. Open Command Prompt as an administrator.
1. Type `diskpart` and press Enter to open the DiskPart utility.
1. Type `list disk` to display a list of all connected disks.
1. Identify the USB drive by its size. Note its disk number.
1. Type `select disk <disk_number>` 
    * Replace `<disk_number>` with the actual disk number of your USB drive.
1. Type `list partition` to display a list of partitions on the selected disk.
1. Type `select partition <partition_number>` 
    * Replace `<partition_number>` with the partition number of the unwanted partitions.
1. Type `delete partition override` to forcibly delete the selected partition.
1. Repeat the above steps for each unwanted partition you want to remove.
1. To format the drive, reselect it and run `format` on it.
```sh
DISKPART> format fs=FAT32 quick label=UbuntuServer
```


The default allocation unit size (cluster size) for the FAT32 file system is typically used in this
scenario, and it's the recommended choice for creating bootable media.

If you want to choose a different allocation size, add `unit=64k` where `64k` is the allocation unit 
size. The filesystem can also be changed to other formats.
```sh
DISKPART> format fs=exFAT quick label=SkinnyDrive unit=64k
```

