# Automation on Linux Using Cron

## Table of Contents
* [Quickref](#quickref) 
* [What is Cron?](#what-is-cron) 
    * [Basic Terms](#basic-terms) 
* [How to Use Cron](#how-to-use-cron) 
* [Special Strings for Scheduling Jobs](#special-strings-for-scheduling-jobs) 
* [Basic Commands](#basic-commands) 
* [Logging with Cron Jobs](#logging-with-cron-jobs) 
    * [Environment Variables with Cron Jobs](#environment-variables-with-cron-jobs) 
* [System-wide Crontab Files - `/etc/crontab` and `/etc/cron.d/`](#system-wide-crontab-files---etccrontab-and-etccrond) 



## Quickref

Examples
```bash
0 * * * * 	    # every hour
*/15 * * * * 	# every 15 mins
0 */2 * * * 	# every 2 hours
0 18 * * 0-6 	# every week Mon-Sat at 6pm
10 2 * * 6,7 	# every Sat and Sun on 2:10am
0 0 * * 0 	    # every Sunday midnight
@reboot 	    # every reboot
```
## What is Cron?

Cron is a job scheduler daemon in Unix/Linux operating systems.
It allows you to run scripts, commands, and other software at scheduled times and intervals.

The term "cron" comes from the Greek word "chronos," meaning "time."


### Basic Terms
* Cron Job: A scheduled task in cron.
* Cron Table (crontab): The configuration file where cron jobs are defined.
* Cron Daemon: The background service that runs the cron jobs.

In `/etc/crontab`, you can check to see the `PATH`s that cron is going to have.


## How to Use Cron

The `cron` daemon uses a `crontab` to schedule jobs.  
You can schedule a `cron` job by adding an entry to the `crontab`. 

---

To open your user's crontab configuration, run:
```bash
crontab -e
```
This will open the crontab file in your default text editor (`$EDITOR` environment variable).

---

A cron job is defined by a line in the crontab, which has the following format:
```bash
* * * * * [user] command_to_be_executed
```
* The five asterisks represent:
    1. Minute (0-59)
    1. Hour (0-23)
    1. Day of the month (1-31)
    1. Month (1-12)
    1. Day of the week (0-7, where both 0 and 7 are Sunday)
* `[user]`: Only required in system-wide crontab files. Specifies the user to run the command as. 
* `command_to_be_executed`: The command that is being scheduled.  

For example, to run a Python script every day at 3:30 PM:
```bash
30 15 * * * python3 /path/to/the_script.py
```

---

The asterisks can also use the syntax `*/n`, where `n` is a number.  
For example:
```bash
*/15 * * * * echo "This will run every 15 minutes."
* */2 * * * echo "This will run every 2 hours."
* * */3 * * echo "This will run every 3 days."
```



## Special Strings for Scheduling Jobs
Instead of using the 5-asterisks method, special strings can be used for scheduling jobs.  

Common special strings:  
* `@reboot`: Run once at startup.  
* `@yearly` or `@annually`: Run once a year, equivalent to `0 0 1 1 *`.  
* `@monthly`: Run once a month, equivalent to `0 0 1 * *`.  
* `@weekly`: Run once a week, equivalent to `0 0 * * 0`.  
* `@daily` or `@midnight`: Run once a day, equivalent to `0 0 * * *`.  
* `@hourly`: Run once an hour, equivalent to `0 * * * *`.  

Examples:
```bash
@reboot  /path/to/script.sh           # Runs the script once at system startup
@yearly  /usr/bin/backup_script.sh    # Runs once a year for annual backup
@monthly /usr/local/bin/report.sh     # Runs monthly for generating a report
@weekly  /usr/local/bin/cleanup.sh    # Runs weekly for cleanup tasks
@daily   /usr/bin/daily_task.sh       # Runs daily for a general task
@hourly  /usr/bin/hourly_check.sh     # Runs hourly for status check
```

If you're using these in a system-wide crontab file (`/etc/crontab` or
`/etc/cron.d/`, etc.), then you also need to specify a `user`:
```bash
@reboot  root  /path/to/script.sh           # Runs the script once at system startup
@yearly  root  /usr/bin/backup_script.sh    # Runs once a year for annual backup
@monthly root  /usr/local/bin/report.sh     # Runs monthly for generating a report
@weekly  root  /usr/local/bin/cleanup.sh    # Runs weekly for cleanup tasks
@daily   root  /usr/bin/daily_task.sh       # Runs daily for a general task
@hourly  root  /usr/bin/hourly_check.sh     # Runs hourly for status check

# OR use the */n notation 
*/15 * * * * echo "This will run every 15 minutes."
* */2 * * * echo "This will run every 2 hours."
* * */3 * * echo "This will run every 3 days."
```


## Basic Commands
* `crontab -e`: Edit your crontab file.
* `crontab -l`: List your current cron jobs.
* `crontab -r`: Remove your crontab file, effectively unscheduling all jobs.



## Logging with Cron Jobs

You can redirect the output to a log file to keep track of a job's execution.
```bash
# In a user-specific crontab file:
30 15 * * * python3 /path/to/the_script.py >> /path/to/log.txt 2>&1
# In a system-wide crontab file:
30 15 * * * username python3 /path/to/the_script.py >> /path/to/log.txt 2>&1
```

### Environment Variables with Cron Jobs
Cron runs with a limited set of environment variables.
If your script relies on variables like `$PATH`, you may need to define them in the crontab or
script.


## System-wide Crontab Files - `/etc/crontab` and `/etc/cron.d/`
There's a system-wide crontab file at `/etc/crontab`.
There are crontab files in `/etc/cron.d` for systems that use `systemd`.

These crontabs are different from user-specific crontab files, since you must specify a username to run the job as.

These files are read by the cron daemon, which runs as a background process.

Here's what `/etc/crontab` looks like:
```bash
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
# You can also override PATH, but by default, newer versions inherit it from the environment
#PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Example of job definition:
# .--------------- Minute (1 - 59)
# | .------------- Hour (0 - 23)
# | |  .---------- Day of month (1 - 31)
# | | | .--------- Month (1 - 12) OR jan,feb,mar,apr, etc.
# | | | | .------- Day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# | | | | | 
# | | | | |    
# * * * * *  user    command to be executed
17 * * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6 * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6 * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6 1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
```

The `user` field in a cron job is only required in system-wide cron 
files (e.g., `/etc/crontab` or cron files located in `/etc/cron.d`).
 
The entries:
* The first entry runs on the 17th minute of every hour.  
* The second entry runs at `06:25` every day.  
* The third entry runs at `06:47` every Sunday (`7`).  
* The fourth entry runs at `06:52` on the `1`st day of every month.  

### The `/etc/cron.allow`/`/etc/cron.deny` files
* `cron.allow`: If this file exists, only the users specified in this file are allowed 
   to use `crontab`.  
    - Specify one user per line.  
* `cron.deny`: If this file exists, any users specified are denied access to `crontab`.  
    - Specify one user per line.  

If both of the files exist, the `cron.allow` file rules will take precendence 
and `cron.deny` rules are not enforced.  





