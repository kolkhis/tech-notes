# `cron`

## Quickref

```ini
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of the month (1 - 31)
│ │ │ ┌───────────── month (1 - 12 or JAN-DEC)
│ │ │ │ ┌───────────── day of the week (0 - 6 or SUN-SAT)
│ │ │ │ │
* * * * *
```

The fields:

1. Minute `[0,59]`

2. Hour `[0,23]`

3. Day of the month `[1,31]`

4. Month of the year `[1,12]`

5. Day of the week (`[0,6]` with `0`=Sunday)


Examples:

```ini
0 * * * * 	    # every hour
*/15 * * * * 	# every 15 mins
0 */2 * * * 	# every 2 hours
0 18 * * 0-6 	# every week Mon-Sat at 6pm
10 2 * * 6,7 	# every Sat and Sun on 2:10am
0 0 * * 0 	    # every Sunday at midnight
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


## System-wide Crontab Files

The system-wide crontab files:

- `/etc/crontab`: The system-wide central crontab file.  
- `/etc/cron.d/*`: Any files inside this directory are considered crontab files.  

There's a system-wide crontab file at `/etc/crontab`.
There are crontab files in `/etc/cron.d` for systems that use `systemd`.  

These files are read by the `cron` daemon, which runs as a background process.

These crontabs are slightly different from user-specific crontab files (e.g., 
editing with `crontab -e`), since there is an additional field in which you 
must specify a username to run the job as.

Here's what `/etc/crontab` looks like:
```bash
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
# You can also override PATH, but by default, newer versions inherit it from the environment
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

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

!!! note "Setting `SHELL` and `PATH`"

    Setting the `SHELL` variable within the crontab file will specify which
    shell/command interpreter is used to execute the commands.  
    
    Setting `PATH` will scope down which binaries are available by name
    (without invoking using full path to the binary), which could be considered
    a good practice in the event that the `PATH` variable is ever tampered
    with.  


The `user` field in a cron job is only required in system-wide cron 
files (e.g., `/etc/crontab` or cron files located in `/etc/cron.d`).

In your local crontab entries, the `user` field is not present as it will
be run by your user account.  

The entries:

1. The first entry runs on the 17th minute of every hour.  
2. The second entry runs at `06:25` every day.  
3. The third entry runs at `06:47` every Sunday (`7`).  
4. The fourth entry runs at `06:52` on the `1`st day of every month.  

All of these crontab entries will run the commands as the `root` user.  

### `/etc/cron.allow` and `/etc/cron.deny`

These files are used to specify which users are allowed to use `crontab` in
order to schedule jobs.  

- `cron.allow`: If this file exists, only the users specified in this file are allowed 
   to use `crontab` to manage entries.  
    - Specify one user per line.  

If `/etc/cron.allow` does **NOT** exist, then `/etc/cron.deny` is checked.  

- `cron.deny`: If this file exists, any users specified are denied access to `crontab`.  
    - Specify one user per line.  

If both of the files exist, the `cron.allow` file rules will take precendence 
and `cron.deny` rules are not enforced.  


## Adding a Cron Job from a Script
You can pipe the current crontab with a new line into `crontab -` to programmatically 
add a cron job without overwriting existing ones.

A simple example:
```bash
(crontab -l 2>/dev/null; printf "* * * * * printf 'This will be added to the crontab\n'\n") | crontab -
```

- `( ... )`: A subshell command group. The combined output of all the commands is 
  passed through the pipe.  
    - This would also work with a brace command group (`{ ... }`), which does
      not run in a subshell.
- `crontab -l 2>/dev/null`: List the current user's crontab.
    - Redirect stderr so there's no output if there is not crontab for the user.  
- `printf "* * * * * printf "...""`: The crontab entry. This cron job runs every minute.
    - This is combined with the output of the `crontab -l` command (due to the
      command group), then the entire output of both commands is passed through
      the pipe (`|`).  
- `| crontab -`: Load the crontab passed to it via stdin.  


This uses a command group subshell `( ... )`, which takes the current 
crontab (`crontab -l`), and appends a new line to it (`printf ...`).  
The output of this command group is shared, so the entire output will be piped to
`crontab -`, which reads the standard input and loads it as the new crontab.  

- This replaces the current crontab with the new output. So you need to include
  existing entries with `crontab -l` if you want to keep them.  

- Make sure to avoid duplicate entries by grepping first.  


A more complex example, this function will add the script it is in as a cron job to
run at 2AM every day.  
```bash
setup-cron-job(){
    local CRON_ENTRY
    if ! crontab -l | grep -i "${BASH_SOURCE[0]}" > /dev/null 2>&1; then
        printf "Setting up cron job.\n"
        CRON_ENTRY="0 2 * * * $(realpath "${BASH_SOURCE[0]}") >> $(realpath "$LOGFILE") 2>&1"
        (crontab -l 2>/dev/null; printf "%s\n" "$CRON_ENTRY") | crontab - || {
            printf >&2 "ERROR: Failed to add cron job!\n" && return 1
        }
        printf "Successfully added cron job\n"
    fi
    return 0
}
```



Cron daily runs at 3:14 AM every morning on a linux system.  

## Resources

- `man cron`
- `man crontab`
- `man 5 crontab`
- <https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html#tag_20_25_07>

