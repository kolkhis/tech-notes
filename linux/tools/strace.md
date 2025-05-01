# `strace` - The Stack Tracing Tool


Use `strace` to track the system calls that a program makes.  
This is typically shown as C code on a Linux system, and shows the system call itself
and its output.  


## `strace` Usage

To see each of the syscalls a command makes, you can run the command directly after
the `strace`/`strace [opts]`:
```bash
sudo strace mkdir ~/testdir
```
This is a simple `strace` call, tracing a `mkdir` call.  
It will only show the system calls made by the `mkdir` process, not any child
processes it may spawn.  

If you need to see the `strace` of the child processes, you can also use the `-f` or
`-ff` options.  
```bash
sudo strace -ff mknod -m 666 /tmp/mynull c 1 3
```

You can also specify the maximum string size with `-s` (default is 32).  
```bash
sudo strace -ffs320 mknod -m 666 /tmp/mynull c 1 3
```





