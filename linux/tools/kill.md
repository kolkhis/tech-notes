


# The Kill Builtin
The `kill` command is used to send a signal to a process, usually to end it.  


## A Note on Signals

`SIGTERM` is always preferred over `SIGINT` and `SIGQUIT`.
* This is because `SIGTERM` allows the process to perform any cleanup before exiting.  
* `SIGTERM` is the default signal sent to a process with it is killed with `kill`

---

When bash is interactive, **without** any traps: 
* `SIGTERM` is ignored (so that `kill 0` does not kill an interactive shell).
* `SIGINT` is caught and handled (so that the wait builtin is interruptible).

In all cases, bash ignores `SIGQUIT`.

If job control (`man://bash 2375`) is in effect, bash ignores `SIGTTIN`, `SIGTTOU`, and `SIGTSTP`.
  
## Job Control

The shell associates a job with each pipeline.
It keeps a table of currently executing jobs, which may be listed with the `jobs` command.

When bash starts a job asynchronously (in the background), it prints a line that looks like:
```bash
[1] 25647
```
This indicates that:
* this job is `job number 1`. 
* the PID of the last process in the pipeline associated with this job is `25647`.

All of the processes in a single pipeline are members of the same job.
Bash uses the job abstraction as the basis for job control.

Naming a job can be used to bring it into the foreground: 
* `%1`  is  a  synonym  for  `fg %1`, bringing job 1 from the background into the foreground.
* `%1 &` resumes job 1 in the background, equivalent to `bg %1`.
