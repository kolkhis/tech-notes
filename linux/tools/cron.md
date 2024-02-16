

# Automation on Linux Using Cron

## Table of Contents
* [Quickref](#quickref) 
* [What is Cron?](#what-is-cron?) 
    * [Basic Concepts](#basic-concepts) 
* [How to Use Cron](#how-to-use-cron) 
* [Basic Commands](#basic-commands) 
* [Tips and Tricks](#tips-and-tricks) 
* [/etc/crontab](#/etc/crontab) 


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

Cron is a time-based job scheduler in Unix-like operating systems, including Linux.
It allows you to run scripts, commands, and other software at scheduled times and intervals.
The term "cron" comes from the Greek word "chronos," meaning "time."



### Basic Concepts
* Cron Job: A scheduled task in cron.
* Cron Table (crontab): The configuration file where cron jobs are defined.
* Cron Daemon: The background service that runs the cron jobs.

In `/etc/crontab`, you can check to see the `PATH`s that cron is going to have.

## How to Use Cron


1. **Open the Crontab Configuration**
To open your user's crontab configuration, run:
```bash
crontab -e
```
This will open the crontab file in your default text editor.

2. **Define a Cron Job**
A cron job is defined by a line in the crontab, which has the following format:
```bash
* * * * * command_to_be_executed
```
* The five asterisks represent:
    1. Minute (0-59)
    1. Hour (0-23)
    1. Day of the month (1-31)
    1. Month (1-12)
    1. Day of the week (0-7, where both 0 and 7 are Sunday)

For example, to run a Python script every day at 3:30 PM:
```bash
30 15 * * * python3 /path/to/the_script.py
```

3. **Save and Exit**
Save the crontab file and exit the text editor.
The new job will be picked up by the cron daemon.


## Basic Commands
* `crontab -e`: Edit your crontab file.
* `crontab -l`: List your current cron jobs.
* `crontab -r`: Remove your crontab file, effectively unscheduling all jobs.


## Tips and Tricks

1. **Logging**: You can redirect the output to a log file to keep track of a job's execution.
```bash
30 15 * * * python3 /path/to/the_script.py >> /path/to/log.txt 2>&1
```

2. **Environment Variables**: Cron runs with a limited set of environment variables.
If your script relies on vvariables like `$PATH`, you may need to define them in the crontab or
script.

3. **Special Strings**: Cron supports special strings like `@reboot` (run at startup), `@daily` (run
   once a day), etc. For example:
```bash
@reboot python3 /path/to/the_script.py
```

1. **Troubleshooting**: 
    * Make sure it executes when I run it.
    * Set it into cron
    * Make sure that cron is running it (and putting it to logs somewhere)
    * Make the script log somewhere so I can see where it's getting in the cron executions.





## /etc/crontab
There's a system-wide crontab file at `/etc/crontab`.
There are crontab files in `/etc/cron.d` for systemd distros.

These crontabs are special since you can specify a username to run the job as.

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
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
```




