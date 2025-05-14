


# Job Control in Bash

Job control is a feature of Bash that allows users to selectively stop
(suspend) the execution of processes and continue (resume) their execution
at a later point.  

This mechanism is particularly useful for managing multiple processes from
a single bash session, i.e., a single shell.

## Table of Contents
* [Key Concepts](#key-concepts) 
* [Job Control Commands](#job-control-commands) 
* [Referring to Jobs](#referring-to-jobs) 
* [Job States and Notifications](#job-states-and-notifications) 
* [Examples](#examples) 
    * [Running a Job in the Background](#running-a-job-in-the-background) 
    * [Suspending a Foreground Job](#suspending-a-foreground-job) 
    * [Moving a Job to the Background](#moving-a-job-to-the-background) 
    * [Bringing a Job to the Foreground](#bringing-a-job-to-the-foreground) 
    * [Listing Jobs](#listing-jobs) 
* [Exiting Bash with Active Jobs](#exiting-bash-with-active-jobs) 
* [Waiting for a Job](#waiting-for-a-job) 
* [Important Notes](#important-notes) 


## Key Concepts
* Job: A job is associated with each pipeline and can be a single command or a group of 
  commands connected by pipes.  
    * Bash maintains a table of current jobs which can be displayed using the `jobs` command.

* Process Group: A job might consist of multiple processes, especially if pipelines are 
  used.  
    * These processes share the same process group ID.

* Foreground and Background Jobs: Jobs can either run in the foreground, blocking the
  terminal until completion, or in the background, allowing the terminal to be used for
  other tasks.

* Standard File Descriptors (FD) are the primary means of interacting with processes:
    * Standard input (stdin - FD 0)
    * Standard output (stdout - FD 1)
    * Standard error (stderr - FD 2)



## Job Control Commands
* `jobs`: Lists all current jobs with their statuses.
* `fg`: Brings a job to the foreground.  
    * Usage: `fg %job_number` or `fg %job_name`.
* `bg`: Continues a job in the background.  
    * Usage: `bg %job_number` or `bg %job_name`.
* `kill`: Sends a signal to a job.  
    * Usage: `kill %job_number`.
* `ctrl+z`: Suspends the foreground job.
* `ctrl+y`: Delays suspending a job until it attempts to read input.


## Referring to Jobs
* `%n`: Refers to job number `n`.
* `%string`: Refers to a job starting with `string`.
* `%?string`: Refers to a job containing `string`.
* `%%` or `%+`: Refers to the current job.
* `%-`: Refers to the previous job.


## Job States and Notifications
* Bash reports a job's state change (e.g., from running to stopped) when it's 
  about to display the prompt.  
    * Use the `-b` option with the `set` command for immediate notifications.
* `SIGCHLD`: Bash executes any trap on SIGCHLD for each child that exits.


## Examples
### Running a Job in the Background
```bash
sleep 30 &
```
This starts the `sleep` command in the background, allowing the terminal
to be used for other commands.


### Suspending a Foreground Job
While a job is running in the foreground, pressing `<C-z>` will suspend 
it, returning control to the shell.


### Moving a Job to the Background
```bash
bg %1
```
This resumes job 1 in the background.


### Bringing a Job to the Foreground
```bash
fg %1
```
This moves job 1 into the foreground.


### Listing Jobs
```bash
jobs
```
This displays the current jobs and their statuses.


## Exiting Bash with Active Jobs
* Bash warns on exit if jobs are stopped or, if `checkjobs` is enabled, running.  
    * A second exit attempt terminates stopped jobs.


## Waiting for a Job
* The `wait` builtin waits for a job to change state.  
    * With job control enabled, `wait` returns if the job terminates.


## Important Notes
Naming a job can be used to bring it into the foreground: 

* `%1`  is  a  synonym  for  `fg %1`, bringing job 1 from the background into the foreground.
* `%1 &` resumes job 1 in the background, equivalent to `bg %1`.

* Background Processes and Terminal I/O: Background processes attempting to read from or write to the terminal can be suspended by the terminal driver (SIGTTIN or SIGTTOU signals).
* Manipulating File Descriptors: The `exec` command can be used to redirect file descriptors for the current shell session.

Understanding job control enhances multitasking capabilities in Bash, providing flexibility in how processes are managed during a shell session.

This revision provides a comprehensive overview of job control in Bash, including key 
concepts, commands, how to refer to jobs, handling job states, and practical examples.

It clarifies ambiguous points and adds detailed explanations suitable for learners.
