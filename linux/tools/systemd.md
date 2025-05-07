
# systemd

`systemd` is a system and service manager for Linux.  
Many `systemd` functions are available through `systemctl`.  

## Table of Contents
* [`systemd` File Locations](#systemd-file-locations) 
* [What `systemd` does](#what-systemd-does) 
* [Useful `systemd` commands](#useful-systemd-commands) 
* [Maniuplating Services with `systemctl`](#maniuplating-services-with-systemctl) 
    * [Start a Service](#start-a-service) 
    * [Enable a Service](#enable-a-service) 
    * [Stop a Service](#stop-a-service) 
    * [Disable a Service](#disable-a-service) 
    * [Restart a Service](#restart-a-service) 
    * [Check the Status of a Service](#check-the-status-of-a-service) 
* [List of `systemd-x` commands](#list-of-systemd-x-commands) 
* [`systemd`/`systemctl` Cheat Sheets](#systemdsystemctl-cheat-sheets) 
    * [Service Management](#service-management) 
    * [Boot Performance](#boot-performance) 
    * [Listing and Describing Units](#listing-and-describing-units) 
    * [Custom Service Files](#custom-service-files) 
    * [Journal Logs](#journal-logs) 
    * [Additional Systemd Tools](#additional-systemd-tools) 


## `systemd` File Locations

* `/var/log/journal/` stores `systemd` logs, and can be accessed with `journalctl`.  
* `/etc/systemd/system` is where custom service files are stored.  
    * The files named `*.socket`/`*.service` in `/etc/systemd/system` are called `unit files`.  
    * You’ll also find `*.wants/` and `*.requires/` directories here, representing dependencies and conditional requirements for services.  E.g.,:
        * `network-online.target.wants/`: Services that require the network to be online.
        * `multi-user.target.wants/`: Services to start in multi-user mode (non-graphical mode).



## What `systemd` does
It does a number of things on the system:
* Provides parallelization capabilities
* Uses socket a D-Bus activation for starting services
* Offers on-demand starting of daemons and services
* Keeps track of processes using Linux control groups
* Maintains mount and automount points,
* Implements an elaborate transactional dependency-based service control logic.


The primary roles of `systemd`:
* Parallelization Capabilities
    * Boots up services in parallel to reduce startup times.
* Socket and D-Bus Activation
    * Starts services only when needed, based on socket or D-Bus requests.
* On-Demand Service Launching
    * Delays the launch of certain services until explicitly required.
* Process Tracking
    * Manages processes using Linux control groups (cgroups).
* Mount and Automount Management
    * Controls mount points, allowing automated and on-demand mounting of filesystems.
* Dependency Management
    * Uses a dependency-based service control system, allowing ordered and conditional starts of services.


## Creating a Systemd Service (Service Files)
Service files (or "Unit Files") are what defines a systemd service.  
Systemd services go in the `/etc/systemd/system/` directory.  
These service files contain the instructions and conditions for the service to start.

The `/usr/lib/systemd/system/` directory also holds system service files (but
use `/etc/systemd/system/` when adding new ones).



An example service file:
```ini
[Unit]
Description=The Service Name
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/path/to/executable
User=pi
Environment=DISPLAY=:0
Restart=always

[Install]
WantedBy=graphical.target
```
* `[Unit]`: This section contains directives about when and how this service should start, 
  and if it should wait for other services.
    - `Description=`: A short description of the service
    - `After=network-online.target`: Wait until the network is up.
    - `Wants=network-online.target`: Try to bring the network up if it's not.
* `[Service]`: This is the main configuration section for how the service runs.
    - `Environment=DISPLAY=:0`: Required so Firefox knows to use the Pi's display.

### Service File Section Entries
- The `[Unit]` section has some common directives:
    - `Description=`: A short description of the service
    - `After=`: Make sure this service starts *after* the listed targets/services.
        - This does not guarantee that the service will start *only* if the
          dependency is active, it's just a startup order.
    - `Wants=`: Similar to `Requires=`, but softer. If the wanted service fails to
      start, this one will continue.

- `[Service]`: Main config section for the service:
    * `ExecStart=`: The full command to run to start the service.
    * `ExecStop=`: (Optional) Command to run to stop the service.
    * `ExecReload=`: (Optional) Command to reload the service without stopping it.
    * `User=`: User account that the service will run as. (Good security practice to avoid running as root if possible)
    * `Group=`: (Optional) Group the service will run as.
    * `Environment=`: Set environment variables for the service.
    * `Restart=`: Defines what to do if the service crashes. Common values: no, on-failure, always.
    * `RestartSec=`: How many seconds to wait before restarting the service.
    * `WorkingDirectory=`: Directory to set as the working directory.
    * `StandardOutput= / StandardError=`: Controls log o

- `[Install]`: Used when you enable the service (so it starts at boot). Tells systemd
  which **target** (boot stage) the service should be linked to.
    * `WantedBy=`: Specify which target the service should be enabled under.
        - This is commonly `multi-user.target` or `graphical.target`
            - `graphical.target`: After the graphical environment is loaded.
            - `multi-user.target`: Equivalent of "runlevel 3" - System is up,
              networking is online, no GUI.
    * `RequiredBy=`: Stronger version of `WantedBy=`. If this service fails, the
      dependent target will fail too.


## Useful `systemd` commands
- Note: `systemctl` is not the same as `sysctl` - `sysctl` is used for controlling
  kernel parameters, `systemctl` is used for controlling system processes.  


```bash
systemctl list-units --state=failed
```
* Lists units (services) that failed to start.  
* `systemctl --failed` is good shorthand for this.  


```bash
systemctl cat ssh
```
* This will show you the configuration (unit file) used for the ssh service.

```bash
cd /etc/systemd/system && ls
```
* This is the directory where systemd stores its service files.
  You can find `target` files, `service` files, and `socket` files.

  It will specify `target.wants/` and `service.wants/` directories, as well as 
  `service.requires/` directories. These are the directories where systemd will look for
  the configuration files for the services that it is managing.

```bash
systemd-analyze --help
```
* This will output all of the different arguments and commands that
  you can use with `systemd-analyze`.


```bash
systemctl is-active ssh
```
* Shows if a service is active or not.  

```bash
systemctl is-enabled ssh
```
* Shows whether or not a service is enabled.  


## Maniuplating Services with `systemctl` 

### Start a Service
```bash
sudo systemctl start <service_name>
```
Starts a specified service immediately.

### Enable a Service
```bash
sudo systemctl enable <service_name>
```
Enables a service to start at boot.

### Stop a Service
```bash
sudo systemctl stop <service_name>
```
Stops a service immediately.

### Disable a Service
```bash
sudo systemctl disable <service_name>
```
Prevents a service from starting at boot.

### Restart a Service
```bash
sudo systemctl restart <service_name>
```
Restarts a service (useful after configuration changes).

### Check the Status of a Service
```bash
systemctl status <service_name>
```
Displays active/inactive status and recent log entries for the service.


## List of `systemd-x` commands
There are a lot of `systemd` commands to perform different tasks on services and
units.  
```bash
systemd-analyze
systemd-escape
systemd-run
systemd-ask-password
systemd-hwdb
systemd-socket-activate
systemd-cat
systemd-id128
systemd-stdio-bridge
systemd-cgls
systemd-inhibit
systemd-sysext
systemd-cgtop
systemd-machine-id-setup
systemd-sysusers
systemd-cryptenroll
systemd-mount
systemd-tmpfiles
systemd-delta
systemd-notify
systemd-tty-ask-password-agent
systemd-detect-virt
systemd-path
systemd-umount
```

## `systemd`/`systemctl` Cheat Sheets

### Service Management

| Command                                 | Description
|-----------------------------------------|------------
| `sudo systemctl start <service_name>`   | Start a service
| `sudo systemctl stop <service_name>`    | Stop a service
| `sudo systemctl restart <service_name>` | Restart a service
| `sudo systemctl reload <service_name>`  | Reload a service's configuration
| `sudo systemctl enable <service_name>`  | Enable a service to start on boot
| `sudo systemctl disable <service_name>` | Disable a service from starting on boot
| `systemctl status <service_name>`       | Check the status of a service
| `systemctl is-active <service_name>`    | Check if a service is currently active
| `systemctl is-enabled <service_name>`   | Check if a service is enabled on boot
| `systemctl list-units --type=service`   | List all active services

---

### Boot Performance

| Command                                      | Description
|----------------------------------------------|-------------
| `systemd-analyze`                            | Show overall boot time
| `systemd-analyze blame`                      | List services ordered by time taken to start
| `systemd-analyze critical-chain`             | Show dependencies and startup time for each unit
| `systemd-analyze plot > boot_chart.svg`      | Generate a boot performance SVG chart

---

### Listing and Describing Units

| Command                                      | Description
|----------------------------------------------|------------
| `systemctl list-units --type=service`        | List all active services
| `systemctl list-units --state=failed`        | List failed units
| `systemctl show <service_name>`              | Display details of a service
| `systemctl cat <service_name>`               | Display the configuration of a service
| `systemctl list-dependencies <service_name>` | List dependencies of a service

---

### Custom Service Files

| Command                                      | Description
|----------------------------------------------|------------
| `sudo systemctl daemon-reload`               | Reload systemd manager configuration
| `/etc/systemd/system/<service_name>.service` | Location for custom service files
| `sudo systemctl enable <custom_service>`     | Enable custom service to start on boot
| `sudo systemctl start <custom_service>`      | Start custom service

---

### Journal Logs

| Command                           | Description
|-----------------------------------|------------
| `journalctl -u <service_name>`    | Show logs for a specific service
| `journalctl -xe`                  | Show detailed logs (useful for debugging)
| `journalctl --since "1 hour ago"` | Show logs from the past hour
| `journalctl --boot`               | Show logs from the current boot

---

### Additional Systemd Tools

| Command                       | Description
|-------------------------------|------------
| `systemd-cgls`                | View all services in a hierarchical tree
| `systemd-cgtop`               | Display CPU/memory usage for services
| `systemd-escape <string>`     | Escape strings for use as unit names
| `systemd-ask-password`        | Prompt for a password on the command line
| `systemd-run <command>`       | Run a command in a new transient scope
| `systemd-detect-virt`         | Detect if running inside a virtual environment
| `systemd-tmpfiles --create`   | Create temporary files as defined in `/etc/tmpfiles.d/`

---

## `.timer` Files
The `.timer` file can specify how often a service should run a particular thing.  

An example `gh-backups.timer` file:
```ini
[Unit]
Description=Run GH Backups Daily at 2AM

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```
- `[Unit]`: This section just gives some info about the process.  
- `[Timer]`: This is where we define the timer rules.  
    - `OnCalendar=*-*-* 02:00:00`: Run every day at 2AM.  
        - `*-*-*`: This is the syntax for "every day."  
        - `02:00:00`: The 24-hour format for 2AM.  
    - `Persistent=true`: Ensures it runs on boot if the system was off at 2AM.  

Timer files count as their own services. So they will need to be enabled:
```bash
systemctl daemon-reexec
systemctl daemon-reload
sudo systemctl enable --now gh-backups.timer
```
- `systemctl daemon-reexec`: Re-executes the `systemd` manager.  
    - This will "serialize" the manager state, re-execute the process, and
      "deserialize" the state again.  
    - Can be used as a heavy-weight `daemon-reload`. 
- `systemctl daemon-reload`: Reloads all unit files.  
    - Also re-runs all generators (`man://systemd.generator`).  
    - Recreates the entire dependency tree.  

> NOTE: The `[Timer]` section can **not** go in the `.service` file directly.  
> `systemd` separates the concern of *what* to run (`.service`) and *when* to run it (`.timer`).  

You **must** use a `.timer` unit to handle the scheduled execution.  
You can't use `OnCalender=` or other time-based fields inside a `.service` unit.  

This is by design and considered good practice. It allows you to trigger the service
manually, and schedule it via a `.timer` file.  
```bash
systemctl start gh-backup.service       # Trigger manually
systemctl enable --now gh-backup.timer  # Schedule it
```

## Environment Variables for Systemd Services
You can set an `EnvironmentFile=` in the `[Service]` section to load environment
variables for use in the service.  

An example:
```ini
[Service]
EnvironmentFile=/etc/gh-backups.env
ExecStart=/usr/local/bin/gh-backup.sh
```

The `/etc/gh-backups.env` file might look like:  
```bash
GITHUB_USER_ORG=MyOrg
GITHUB_TOKEN=ghp_xxx
S3_BUCKET="s3://my-bucket-name"
```
You don't need to use `export` on these variables.  

Using this method, the `gh-backup.sh` script won't need to source a `.env` file, 
since the variables will already be in the environment.  


## Resources
* [Systemd Service Files](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html#)
* [Systemd Syntax](https://www.freedesktop.org/software/systemd/man/latest/systemd.syntax.html)

