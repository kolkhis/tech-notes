# `vmstat`

The `vmstat` command provides information about system processes, memory,
paging, block device I/O, traps, disks, and CPU activity

## Basic Usage

### Summary of System Resource Usage

Run the command with no arguments to get a summary of the current system.  
```bash
vmstat
```

To see updates in real-time:
```bash
vmstat 1 5
```

* `1`: Update every second
* `5`: Run 5 times every `x` number of seconds (`1` in this case)

---

### Getting Disk Statistics

You can see a summary of disk statistics by using the `-D` flag:
```bash
vmstat -D
```
Or, get a more detailed view of disk statistics with `-d`:
```bash
vmstat -d
```



## `vmstat` Output

Understand the output of `vmstat` (see below for more detailed explanations).  

* [Procs](#procs-processes) (Processes):
    * `r`: The number of processes waiting for run time.
    * `b`: The number of processes blocked waiting for I/O to complete.

* [Memory](#memory):
    * `swpd`: The amount of virtual memory used.
    * `free`: The amount of idle memory.
    * `buff`: The amount of memory used as buffers.
    * `cache`: The amount of memory used as cache.

* [Swap](#swap):
    * `si`: Amount of memory swapped in from disk (/s).
    * `so`: Amount of memory swapped out to disk (/s).

* [IO](#io-inputoutput):
    * `bi`: Blocks received from a block device (blocks/s).
    * `bo`: Blocks sent to a block device (blocks/s).

* [System](#system):
    * `in`: The number of interrupts per second, including the clock.
    * `cs`: The number of context switches per second.

* [CPU](#cpu) (shown as percentages of total CPU time):
    * `us`: Time spent running non-kernel code. (user time, including nice time)
    * `sy`: Time spent running kernel code. (system time)
    * `id`: Time spent idle.
    * `wa`: Time spent waiting for IO.
    * `st`: Time stolen from a virtual machine. Relevant in virtualized environments.


### Procs (Processes)

* `r`: This is the number of programs (processes) waiting for their turn to run
  on the computer's processor (CPU).  
    * This is like how many people are waiting in line at a shop.  
* `b`: This is the number of processes that are sleeping and cannot be woken
  up until they get a specific piece of data or event.  
    * Like a chef waiting for an ingredient that's not yet delivered.

### Memory

* `swpd`: This represents the amount of virtual memory used.  
    * Virtual memory is like an extension of your computer's real memory (RAM), but
      it's slower because it uses part of your hard drive.
* `free`: This shows how much memory is not being used right now.
* `buff`: Buffers are temporary holding spots for data that's being transferred
  between different programs or between programs and hardware.  
* `cache`: Cache is a small storage area that keeps copies of data from
  frequently used parts of your memory to speed up access.  
    * Like keeping your most-used books on your desk for quick
      access instead of fetching them from the bookshelf each time.

### Swap

Swap is used when there's not enough memory (RAM) for all the processes that are
currently running. Swap is way slower than RAM. Even with a fast SSD, it's still
orders of magnitude slower than your system's memory.  

* `si` and `so`: These indicate how much data is being moved between your
  RAM and your hard drive's swap space (a designated area used as virtual memory).  
    * `si`: swap-in (loading into RAM)
    * `so`: swap-out (moving out of RAM to make space).  
    * Like moving books between your desk and a storage box under
      the desk to make room for what you currently need.

### IO (Input/Output)



* `bi` and `bo`: Block device input and block device output.  
    * These show how much data is being read (`bi`) from or written (`bo`) to block devices like hard drives.  
    * A block device is a piece of hardware that stores data in fixed-size chunks (blocks).  
    * `bi` is loading stuff in, and `bo` is taking stuff out.

### System

* `in`: Interrupts. This is the number of interrupts per second.  
    * An interrupt is a signal to the CPU that it needs to stop and do something else.  
* `cs`: Context Switch. This is the number of context switches per second.  
    * A context switch occurs when the CPU switches from running one process to another.  
    * i.e., it's working on a task, then stopping to work on a different task, and
      later returning to the original task.

### CPU

* `us`: User. Time the CPU spends running programs' code.
* `sy`: System. Time the CPU spends running system (kernel) code, like managing memory or devices.
* `id`: Idle. Time the CPU is doing nothing.
* `wa`: Wait. Time the CPU waits for IO operations to complete before doing more work.
* `st`: Stolen. Time "stolen" from this virtual machine by the hypervisor for other tasks (in 
        virtual environments).



