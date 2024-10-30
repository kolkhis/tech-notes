
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
* `oflag=direct`: This bypasses caching to get a more accurate measure of the disk's write speed.  


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

