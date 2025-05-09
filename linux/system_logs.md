

# System Logs on Linux


Logs are typically stored in `/var/log`, and categorized by function, like system 
messages, authentication attempts, kernel events, and application-specific logs.  

## Table of Contents
* [Important Log Files](#important-log-files) 
* [Working with Log Files](#working-with-log-files) 
    * [Viewing Logs in Real-Time](#viewing-logs-in-real-time) 
    * [Searching and Filtering Logs](#searching-and-filtering-logs) 
    * [Rotating Logs](#rotating-logs) 
    * [Clearing Logs](#clearing-logs) 
    * [Viewing Logs with `journalctl`](#viewing-logs-with-journalctl) 
    * [Related](#related) 


## Important Log Files

* `/var/log/syslog`:
     * Stores general system messages and application logs.
     * Often contains messages from services that do not have their own log files, making it useful for debugging issues across the system.
     * Common in Debian-based distributions (e.g., Ubuntu).
       * Example: View recent entries in `/var/log/syslog`:
        ```bash
        tail -n 20 /var/log/syslog
        ```

* `/var/log/messages`:
    * Similar to `/var/log/syslog`, this file logs general system messages and service-related events.
    * Common on Red Hat-based distributions (e.g., CentOS, Fedora).
      ```bash
      grep "error" /var/log/messages  # Search for 'error' logs
      head -n 20 /var/log/messages  # Timestamp here shows when the system booted up last
      cat /var/log/messages | awk '{print $1,$2}' | uniq -c # Count the number of daily entries
      ```


* `/var/log/auth.log` (or `/var/log/secure` on RH):
    * Records all authentication attempts, including successful and failed logins, as well as `sudo` usage.
    * Useful for tracking user activity and detecting unauthorized access.
  
    * Example: Check the last 10 authentication events:
  ```bash
  tail -n 10 /var/log/auth.log
  ```

* `/var/log/kern.log`:
    * Contains kernel messages and events, such as hardware errors, module loading, and driver issues.
    * Useful for troubleshooting hardware and kernel-related issues.
  
    * Example: View recent kernel messages:
  ```bash
  tail -f /var/log/kern.log
  ```

* `/var/log/boot.log`:
    * Logs messages from the boot process, which can help diagnose issues occurring during system startup.
  
    * Example: View the boot log:
  ```bash
  cat /var/log/boot.log
  ```

* `/var/log/dmesg`:
    * Contains kernel ring buffer messages, including hardware detection and boot-time events.
    * Also accessible via the `dmesg` command.
  
    * Example: View kernel messages from the last boot:
  ```bash
  dmesg | less
  ```

* `/var/log/cron`:
    * Logs all scheduled tasks (cron jobs), including successful and failed execution.
    * Useful for verifying that cron jobs are running as expected.
  
    * Example: View recent cron job logs:
  ```bash
  tail -f /var/log/cron
  ```

* Application Logs:
    * Application-specific logs are typically stored in subdirectories within `/var/log/`.  
        * For example:
        * `/var/log/nginx/` for Nginx logs.
        * `/var/log/apache2/` for Apache logs.
        * `/var/log/mysql/` for MySQL logs.

    * Example: View the Nginx access log:
      ```bash
      tail -f /var/log/nginx/access.log
      ```

## Working with Log Files

### Viewing Logs in Real-Time
To monitor logs in real-time, use the `tail -f` command, which continuously displays new entries as they are added.

* Example:
  ```bash
  tail -f /var/log/syslog
  ```

### Searching and Filtering Logs
Use `grep` to search for specific keywords in logs.

* Example: Search for errors in the kernel log:
  ```bash
  grep -i "error" /var/log/kern.log
  ```

### Rotating Logs
Log rotation manages log file sizes by archiving old logs and creating new ones.  
This is handled by the `logrotate` utility, which is configured in `/etc/logrotate.conf` and `/etc/logrotate.d/`.

* Example: Manually rotate logs:
  ```bash
  sudo logrotate -f /etc/logrotate.conf
  ```

### Clearing Logs
To free up space, you may occasionally want to clear specific logs.  
Only do this if you're sure you don't need the logs. There's no way to undo this.  

* Example: Clear the contents of `syslog`:
  ```bash
  sudo truncate -s 0 /var/log/syslog
  # or
  : > /var/log/syslog  # Clever way to truncate. : is a function with no output.
  ```

### Viewing Logs with `journalctl`
On systems that use `systemd`, `journalctl` is the command for accessing the systemd journal, which consolidates logs from various sources, including boot messages, kernel messages, and application logs.

* Example: View the latest `journalctl` logs:
```bash
journalctl -xe
```

### Misc
* Use log rotation (`logrotate`) to manage log file sizes and prevent logs from filling up disk space.
* Implementing a centralized logging solution (e.g., `rsyslog` or `ELK Stack`) 
  creates a scalable log management solution across multiple servers.
    - Or, Loki + Promtail + Grafana is another stack that works just as well.  

## Logging with Apache Kafka

### About Kafka
Put simply, Kafka is a logging tool that uses an event bus (or "message queue") to 
store and expose messages.  

It's a distributed event-streaming platform, and is specifically designed for
creating high throughput data pipelines.  

Kafka is known to be scalable. It acts as middleware between log producers and log
ingesters. Kafka can ingest logs from various sources (applications, servers,
databases, etc.) and process them, store them, and analyze them in real time.  

Kafka is typically run on a dedicated VM or hardware.  

---

Kafka is a message broker that works with a message queue (or event bus).  
* The message broker is not limited to just logs -- it can queue any sort of information.  


### Setting up Kafka
You can set up a Kafka server and write to it using the `kafkacat` tool (invoked 
as `kcat`).  

You can set up Kafka logs to be picked up by Promtail and sent to Loki.  
It can also be integrated with other monitoring stacks.  


TODO: Finish this section on setting up kafka


### Kafka Resources
- <https://www.redpanda.com/guides/kafka-use-cases-log-aggregation>
- <https://www.crowdstrike.com/en-us/guides/kafka-logging/>
- <https://killercoda.com/het-tanis/course/Linux-Labs/108-kafka-to-loki-logging>
