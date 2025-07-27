# `dd`

The `dd` command is used for many things.  
It can be used for copying files, deleting files, formatting disks, embedding data
into files, performing read/write tests, and more.  


## Disk Read/Write Test with `dd`

`dd` is a good tool to test read speeds and test write speeds of disks. 
Before doing speed tests, it may be a good idea to run `sync` to flush the disk cache.  


### Testing Disk Write Speeds
To test the write speed of a disk, you can use the `dd` command to create a large
file and measure how long it takes to write the file to the disk.  
```bash
dd if=/dev/zero of=testfile bs=1G count=1 oflag=direct
```

* `if=/dev/zero`: The input file is `/dev/zero`. This is a special file that generates a stream of zero bytes.  
* `of=testfile`: The output file, which will be created and written to the disk.  
* `bs=1`: The block size is 1 gigabyte. Can adjust this to test different block sizes.  
* `count=1`: The number of blocks to write to the disk. In this case, just one.  
* `oflag=direct`: Set the output flag to `direct`.  
    - This bypasses caching to get a more accurate measure of the disk's write speed.  


### Testing Disk Read Speeds
To test the read speed of a disk, read from the file created in the write test and
measure how quickly it can be read into memory.  
```bash
dd if=testfile of=/dev/null bs=1G count=1 iflag=direct
```

* `if=testfile`: The input file, created in the write test.  
* `of=/dev/null`: The output is sent to `/dev/null`, which discards all data sent to it.  
* `bs=1 count=1`: Reads the file in 1 gigabyte blocks.  
* `iflag=direct`: Bypasses caching for more accurate measurements.  


---

After running these commands, `dd` will output statistics, including the speed in bytes per second.  
```plaintext
1073741824 bytes (1.1 GB) copied, 2.345 s, 458 MB/s
```

When you're done, remove the test file to free up space.  


## Creating a Bootable USB Drive with `dd`

> Quick note: This is a destructive operation. Creating a bootable USB drive 
> will wipe all the data that's on it.  

First locate your USB drive.  
```bash
lsblk -f
```
If you run this before you insert your drive, then run it again after, you can easily
identify which device is your USB drive.  

We'll use this as an example:
```bash
sdb
└─sdb1        exfat  1.0   backups
                                  3035-9085
```

Once you've identified your drive, unmount it (`umount`) if it's mounted anywhere.  
```bash
sudo umount /dev/sdb*
```

- The `/dev/sdb*` glob ensures all partitions are unmounted.  

Then, pick the ISO you want to create bootable media from.  
I'll use `/ISOs/linuxmint-22.1-xfce-64bit.iso` in this example.  

```bash
sudo dd \
    if=/ISOs/linuxmint-22.1-xfce-64bit.iso \
    of=/dev/sdb \
    bs=4M \
    status=progress \
    oflag=direct \
    conv=fsync
```

- `if=`: Input file. The ISO you want to write.  
- `of=`: Ouput file. The **block device**, not the partition.  
- `bs=4M`: Block size of `4M` gives a good speed/safety tradeoff.  
- `status=progress`: Shows a progress bar.  
- `oflag=direct`: Skip the caching process entirely.  
    - More reliable for straight up writing to a disk.  
- `conv=fsync`: Forces flush to disk after write buffers to ensure all data is written.  
    - Calls `fsync()` on the output file after each block is written.  
    - Ensures that the data written to the kernel buffer is immediately flushed to
      the disk instead of waiting in RAM for the OS to decide when to write.  
    - You could also use `fdatasync` for this, but `fsync` also writes metadata.  


Note we're not writing to the partition `sdb1`, we're writing directly to the block
device itself.  

Once `dd` finished, you should see an output like this:
```bash
123456789+0 records in
123456789+0 records out
xxxx bytes (x.x GB) copied, x seconds, x.x MB/s
```

Once that's done, the drive should be ready.  

Go ahead and run a `sync` and `eject` it.  
```bash
sync && sudo eject /dev/sdb
```

- `sync`: Forces the system to flush all filesystem write buffers to disk.  
    - This is a safeguard in case something is still buffered.  
- `eject`: Tells the OS to safely detach the device.  
    - Flushes any remaining buffers.  
    - Unmounts the device if it's mounted.  
    - Signals the drive to power down (or pop out, if it's a CD).  

---

### Inspecting the Written Drive

This part is optional.  
You can mount the USB after writing and inspect it if you want to check that it was
written correctly.  
```bash
udisksctl mount -b /dev/sdb1
ls /run/media/$USER/*
```

- `udisksctl`: A CLI frontend to the `udisks2` daemon. 
    - Used by most desktop Linux systems.    
- `mount -b`: Tells it to mount a block device.  


Using `udisksctl` to mount prevents you from needing to specify a filesystem type.
It also handles the mountpoint.  

If it's available on the system by default (desktop Linux distros), then it's a 
user-friendly alternative to `mount` and doesn't require `sudo` access.  

When you're done with the inspection, use `udisksctl` to unmount it.  
```bash
udisksctl unmount --block-device /dev/sdb
```

---

If you **want** to use `mount` instead, you'll need to determine the filesystem type.  
```bash
lsblk -f
```
Find the filesystem of the bootable partition (e.g., `iso9660`, `vfat`).  

Create the mountpoint.  
```bash
mkdir -p /mnt/usb
```

Mount the drive.  
```bash
sudo mount -t iso9660 /dev/sdb1 /mnt/usb
```
This is just being explicit about the filesystem type.  
By default, `mount` will try to auto-detect the filesystem type. So you don't
necessarily need to specify it each time.  
```bash
sudo mount /dev/sdb1 /mnt/usb
```


