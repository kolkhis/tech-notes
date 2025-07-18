# `top`
Using `top` will show the current status of the system.  
Its output is very detailed.  


## `top` Output

### First Line
In the first line we see something similar to this:
```plaintext
top - 19:38:28 up 2 days, 20:47, 0 users, load average: 0.52, 0.58, 0.59
```

* `top`: program name
* `19:38:28`: Current system time.  
* `up 2 days, 20:47`: System Uptime. The time from the last boot.  
* `0 users`: number of active users. Here we can see similar information to the command `who`.
* The last part is the load average. It's very important, and very often misunderstood.
  ```plaintext
  load average: 0.52, 0.58, 0.59
  ```
  These numbers show the load average for the system in the last 1 min, 5 mins,
  and 15 minutes respectively.  
    * The load average shows the average number of processes both **running**
      and **waiting** for CPU time.
    * The number of CPUs (as well as their cores && threads) should be considered
      when evaluating the load averages.  
        * For example, a load average of `10` with a 1-core CPU means that your system is 
          overloaded, but the same load average with a 12-core CPU is not overloaded.    



---

### Second Line

The second line shows information about processes in the system.
```
Tasks: 6 total, 1 running, 5 sleeping, 0 stopped, 0 zombie
```

* `total`: Shows all processes in the system
* `running`: Currently active processes.  
    * This means these processes are using CPU right now
* `sleeping`: Generally - process is waiting for something.  
    * It may be I/O operation for example.
* `stopped`: Stopped processes (e.g., with `<C-z>`)
* `zombie`: Very important state to understand.  
    * A zombie is a process that has finished its job but still exists in the process table.  
    * In simple terms, zombie processes are waiting for an `exit` signal.  
    * This can happen when the parent process fails for whatever reason.  
    * Sometimes you can kill a zombie process by killing the parent process, but this
      is usually not the case.


### Third Line

This line shows the CPU(s) utilization, splitted to specific types. Let's go through them one by one.
```
%Cpu(s): 13.9 us, 9.5 sy, 0.0 ni, 76.3 id, 0.0 wa, 0.4 hi, 0.0 si, 0.0 st
```


* `us`: user - All user processes are combined in this number.  
    * So, our sessions too.
* `sy`: system - processes owned by system (kernel)
* `ni`: nice - this is important to understand.  
    * nice allows us to change the priority of the process.  
    * The standard value for processes is 0 , but we can modify it from 19 (lowest) to 
      -20 (highest) priority.  
    * This statistic here shows all processes with the niceness set abow 0. So, the 
      processes which will be executed by the system, when "systemm will have time for it".
* `id`: idle - idle time means that the system is bored and do nothing.
* `wa`: iowait - the number repspresents the time (which is a subset of idle time)
  when the process is waiting for input/output operation.  
    * This statistic is very important, because it may show the issue outside the CPU, in 
      other hardware (but not only) components.
* `hi`: hardware interrupts.  
    * These are physical interrrupts from hardware and are handled by CPU itself.
* `si`: software interrupts. These are generated by software and are handled by kernel.
* `st`: steal time - very important to understand, especially when we are working on 
  virtualized environment.  
    * This number represents the time "stealed" from the virtual machine by hypervisor.  
    * Another words, how long our system needs to wait for resources from hypervisor.

### Fourth and Fifth Lines

Both of these lines represent the memory information.  
The difference is that the first line is physical memory and the second is swap.  
```plaintext
MiB Mem :  16217.5 total,   6184.9 free,   9808.7 used,    224.0 buff/cache
MiB Swap:  49152.0 total,  48436.2 free,    715.8 used.   6278.3 avail Mem
```

* `total, free, used`: obvious.
* `buff/cache`: A combined value of buffer memory used by the kernel and cache, as 
  well as buffer memory used by the page cache.
* `available`: means that any newly started program can use, at maximum, this amount
  of memory.  

### Processes list
Below the first five lines is the process list.  

This list contains the following fields:

* `PID`: Process ID number.  
    * It is a unique number given to the process by the system.
* `USER`: Process owner.  
    * The process was started by this user.
* `PR`: Default priority of the process, scheduled by the kernel when the process was started.
* `NI`: Nice.  
    * If `nice` was performed against the process.
* `VIRT`: Total amount of memory used by the process.
* `RES`: RAM memory used by process.
* `SHR`: Amount of memory shared with other processes.
* `S`: Process state.
* `%CPU`: Represents CPU usage.
* `%MEM`: Represents memory usage.
* `TIME+`: Total time of CPU usage by the process.
* `COMMAND`: The command that started the process.  

