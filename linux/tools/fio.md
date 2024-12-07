# `fio` - Benchmarking Utility

The `fio` tool can be used to perform benchmarking and baselining on a system.  

This tool is recommended over `dd` for disk benchmarking since `dd` does not actually 
write to disk until its process has completed.  


## Table of Contents
* [Using Fio](#using-fio) 
    * [Random Read/Write Disk Performance](#random-readwrite-disk-performance) 
    * [I/O Latency Test](#io-latency-test) 
    * [Test Under Load](#test-under-load) 
    * [Analyze System-Level Metrics while testing](#analyze-system-level-metrics-while-testing) 
    * [Testing Network I/O](#testing-network-io) 
* [Output Reports](#output-reports) 
* [Using Config Files](#using-config-files) 
    * [Direct I/O (bypass page cache)](#direct-io-bypass-page-cache) 


## Using Fio

Using `fio` is hardly simple. But it is very explicit in its arguments.  


### Random Read/Write Disk Performance
Use 
```bash
fio --name=randrw --rw=randrw --bs=4k --size=1G --numjobs=1 \
    --ioengine=libaio --runtime=60 --group_reporting \
    --filename=/disk/mountpoint/file
```
* `--name=randrw`: The name of the job. This can be anything.  
* `--rw=randrw`: Test both random reads and writes.  
* `--bs=4k`: Block size. `4k` is typical for random I/O.  
* `--size=1G`: Total amount of data to test.  
* `--numjobs=1`: The total number of concurrent jobs to run.  
    * This defines how many concurrent threads will run.  
    * For multiiple threads, the workload is split among them.  
* `--runtime=60`: Runs the test for 60 seconds.  
    * If the specified `--size` is completed before `--runtime`, the test will
      continue performing operations until the runtime is reached.  
        <!-- * Does this mean the amount of data is increased? Or does this just mean that -->
        <!--   the process will continue to run without actually doing anything? -->
* `--ioengine=libaio`: Defines the I/O envine to use for the test.  
    * `libaio` (Linux asynchronous I/O) is a kernel-based I/O engine that uses
      asynchronous operations for efficient disk access. 
    * Other `ioengine` options:
        * `sync`: Synchronous I/O engine (Each operation completes before the next starts).  
        * `psync`: Uses `pread`/`pwrite` for synchronous I/O.  
        * `mmap`: Uses memory-mapped I/O.  
        * `net`: For testing network performance.  
* `--group_reporting`: Consolidates results for all jobs into a single summary report.  
    * Without this, `fio` outputs individual job results.  

### I/O Latency Test

```bash
fio --name=latency --rw=read --bs=4k --size=1G --numjobs=1 \
    --ioengine=libaio --runtime=60 --group_reporting \
    --filename=/disk/mountpoint/file
```
Tests the latency of random read operations on the specified file.  
Can be used for evaluating the performance of a storage system under read-heavy workloads.  
Same flags as the `randrw` test but with the `--rw=read` for read-only.  


### Test Under Load
Test a disk that is under the load of 16 concurrent jobs.  
```bash
fio --name=concurrent --rw=randrw --bs=64k --size=10G --numjobs=16 \
    --ioengine=libaio --runtime=120 --group_reporting \
    --filename=/disk/mountpoint/file
```
This uses 16 concurrent jobs to test 10G of data with a block size of 64k.  
* `--bs=64k`: Block size increased to 64k for testing workloads with larger sequential reads/writes.  
* `--runtime=120`: Ensures all jobs run for at least 120 seconds, even if the data size completes early.  
* This simulates real multi-threaded workloads (e.g., database queries or heavy multi-user applications).  

### Analyze System-Level Metrics while testing
Use other commands to monitor system metrics during testing to evaluate the impact on
CPU, memory, and network.  
```bash
iostat -x 1
vmstat 1
sar -u 1
```

### Testing Network I/O
```bash
fio --name=net-test --rw=write --bs=128k --size=1G --numjobs=4 \
    --ioengine=net --filename=hostname:port
```
This takes a network address as its "filename".  
Using the `net` ioengine




## Output Reports
`fio` generates detailed outputs including:
* Throughput/Bandwidth (`bw`)
* Input/output operations per second (`iops`)
* Latency 
    * Completion latency (`clat`)
    * Submission latency (`slat`)
    * Total latency (`lat`)

Example output:
```bash
READ: bw=116MiB/s (121MB/s), 116MiB/s-116MiB/s, io=15.1GiB, run=60001msec
WRITE: bw=115MiB/s (120MB/s), 115MiB/s-115MiB/s, io=15.0GiB, run=60001msec
```

## Using Config Files
Instead of passing all arguments on the command line, you can create a configuration
file `test.fio` for repeatability.  
```ini
[randrw]
rw=randrw
bs=4k
size=1G
numjobs=1
ioengine=libaio
runtime=60
group_reporting
filename=/disk/mountpoint/file
```
Run it with:
```bash
fio test.fio
```

### Direct I/O (bypass page cache)
If you specify `direct=1`, you can bypass the page cache for more accurate
measurements from the test.  


## Explanation of Runtime vs Size
`--size` specifies the total amount of data to read/write for the test.  
Once the specified size is completed, the test would normally stop if `--runtime` is
not set.  

`--runtime` Introduces a time-based limit for the test. 
If this limit is longer than the time required to process the specified `--size`,
then `fio` continues to perform operations by looping back to the beginning.  

When the `runtime` is longer than twhat the `size` alone would require:
* The amount of data processed increases.  
* Results such as bandwidth (`bw`), IOPS, and latency are measured across the
  entire `runtime`, not just against the `size`.  

### Example of Runtime vs Size
```bash
fio --name=example --rw=randrw --bs=4k --size=1G --runtime=60 \
    --ioengine=libaio --filename=/disk/testfile
```
If processing `1G` takes 20 seconds:
* The test will loop and repeat the 1G workload 3 times (20 seconds * 3 = 60 seconds).
* Total data processed will be approximately 3G.

This simulates real-world workloads.  
It helps assess how the system handles sustained workloads rather than just short
bursts of activity.  




