# The Kill Builtin

The `kill` command is used to send a signal to a process, usually to end it.  

## Basic Usage

```bash
kill PID
```
The `PID` is the process ID of the process you want to kill.  

By default, `kill` will send the `SIGTERM` signal. This will tell the process
to terminate.  

---

To see a list of signals, use `kill -l`:
```bash
kill -l
```
This will list the signals and their corresponding numbers.  


## A Note on Signals

`SIGTERM` is always preferred over `SIGINT` and `SIGQUIT`.

* This is because `SIGTERM` allows the process to perform any cleanup before exiting.  
* `SIGTERM` is the default signal sent to a process with it is killed with `kill`

---

When bash is interactive, **without** any traps: 

* `SIGTERM` is ignored (so that `kill 0` does not kill an interactive shell).
* `SIGINT` is caught and handled (so that the wait builtin is interruptible).

In all cases, a `bash` process ignores `SIGQUIT`.

If job control (`man://bash`, `/^JOB CONTROL`) is in effect, bash 
ignores `SIGTTIN`, `SIGTTOU`, and `SIGTSTP`.


## Job Control

The shell associates a job with each pipeline.  
It keeps a table of currently executing jobs, which may be listed with the `jobs` command.


When bash starts a job asynchronously (in the background), it prints a line that looks like:
```bash
[1] 25647
```
This indicates that:

* `[1]`: This job is `job number 1`. 
* `25647`: The PID of the last process in the pipeline associated with this job is `25647`.

All of the processes in a single pipeline are members of the same job.
Bash uses the job abstraction as the basis for job control.

---


The `%` character introcues a job specification (jobspec).  

- Job number `2` can be referred to as `%2`. 
    - It can also be referred to by using a prefix of the name used to start it, or 
      by using a substring that appears in its command line.  
    - For example, `%ce` refers to a stopped job whose command name begins with `ce`.
        - If the prefix `ce` matches more than 1 job, Bash gives an error.  

- The `%%` and `%+` jobspecs refer to the current job, which is the last job 
  stopped while it was in the foreground or started in the background.
- The `%-` jobspec refers to the **previous job**.  

Naming a job can be used to bring it into the foreground: 

* `%1` is a synonym for `fg %1`, bringing job 1 from the background into the foreground.
* `%1 &` resumes job 1 in the background, equivalent to `bg %1`.

---

The `jobs` builtin can be used to show jobs that are under **job control**.  
```bash
jobs
```
If there's no output, it means no jobs are under job control. Try backgrounding
a process (`^Z`) and running `jobs` again.  
