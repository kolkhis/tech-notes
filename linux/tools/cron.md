

# Automation on Linux Using Cron


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







