
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




## Useful `systemd` commands
```bash
systemctl list-units --state=failed
```
`systemctl --failed` is good shorthand for this.  


* `systemctl cat ssh`
This will show you the configuration used for the ssh service.

* `cd /etc/systemd/system && ls`
This is the directory where systemd stores its service files.
You can find `target` files, `service` files, and `socket` files.

It will specify `target.wants/` and `service.wants/` directories, as well as 
`service.requires/` directories. These are the directories where systemd will look for
the configuration files for the services that it is managing.

```bash
systemd-analyze --help
```
This will output all of the different arguments and commands that
you can use with `systemd-analyze`.


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

