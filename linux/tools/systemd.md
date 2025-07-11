# systemd

`systemd` is a system and service manager for Linux.  

Many `systemd` functions are available through `systemctl` (systemd control).  

## `systemd` File Locations

* `/var/log/journal/` stores `systemd` logs, and can be accessed with `journalctl`.  
* `/etc/systemd/system` is where custom service files are stored.  
    * The files in this directory are called **unit files**.  
    * You’ll also find `*.wants/` and `*.requires/` files/directories here, representing 
      dependencies and conditional requirements for services. E.g.:  
        * `network-online.target.wants/`: Services that require the network to be online.
        * `multi-user.target.wants/`: Services to start in multi-user mode (non-graphical mode).



## What `systemd` does

It does a number of things on the system:

* Provides parallelization capabilities
    * Boots up services in parallel to reduce startup times.
* Uses socket a D-Bus activation for starting services
    * Starts services only when needed, based on socket or D-Bus requests.
* Offers on-demand starting of daemons and services
    * Delays the launch of certain services until explicitly required.
* Keeps track of processes using Linux control groups
* Maintains mount and automount points (i.e., `.mount` and `.automount` services)  
    * Controls mount points, allowing automated and on-demand mounting of filesystems.
* Implements a transactional, dependency-based service control logic.
    - E.g., `Wants=network-online.target`


## Creating a Systemd Service 
Service files (or "Unit Files") are what define systemd services.  

These unit files go in the `/etc/systemd/system/` directory.  
These files contain the instructions and conditions for the service to start.

The `/usr/lib/systemd/system/` directory holds **system** service files, but
use `/etc/systemd/system/` when adding new ones.


An example service file, `/etc/systemd/system/example.service`:
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

### Service File Section Entries


- The `[Unit]` section has some common directives:
    - `Description=`: A short description of the service
    - `After=`: Make sure this service starts *after* the listed targets/services.
        - This does not guarantee that the service will start *only* if the
          dependency is active, it's just a startup order.
    - `Wants=`: Similar to `Requires=`, but softer. If the wanted service fails to
      start, this one will continue.

Every unit file should contain a `[Unit]` section, regardless of what kind of unit
file it is (`.timer`, `.mount`, etc.).  

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
    * `StandardOutput= / StandardError=`: Controls log output locations.  

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


## Mounting Filesystems with Systemd

Systemd can handle mounting file systems.  

The basic way to do this is by using a `.mount` unit file. These contain the UUID of
the filesystems that are to be mounted and where they should be mounted.

Systemd also has the ability to handle auto-mounting filesystems.  
You can create a `.automount` unit file to specify the instructions for doing this.  

### `.mount` Unit Files
The `.mount` unit file should have a `[Mount]` section.  
```ini
[Mount]
What=/dev/disk/by-uuid/f5755511-a714-44c1-a123-cfde0e4ac688
Where=/mount/point
Type=ext4
```

### `.automount` Unit Files
The `.automount` file **requires** a corresponding `.mount` file, and should have the 
same base name as the `.mount` file, just with a `.automount` suffix.  

```ini
[Automount]
Where=/mount/point
DirectoryMode=0755

[Install]
WantedBy=multi-user.target
```




## Types of Unit Files

There are many types of unit files that systemd supports, each with a file extension
that reflects the type of unit file it is.  

- `.service`: Defines a service or daemon process
- `.socket`: Describes an IPC or network socket for socket activation
- `.timer`: Used to schedule service activation (like cron, but systemd)
    - Muse be paired with `.service` files.  
- `.mount`: Manages mount points in the filesystem (like `/etc/fstab`, but systemd)
- `.automount`: Defines automount behavior for on-demand mounting
    - This requires a corresponding `.mount` unit file.  
- `.target`: Tracks kernel devices (via `udev`).  
    - These are rarely user-defined unit files.  
    - Often used like "runlevels", e.g., `multi-user.target`, `graphical.target`
- `.swap`: Controls swap devices or files.  
- `.path`: Triggers a service when a file or directory changes (e.g., `inotify`)
    - This can be used to set up a kind of tripwire. 
    - They use the `inotify` Linux kernel API, just like `inotifywait`.  
- `.slice`: Used for resource control a `cgroups` (control groups) hierarchy
- `.scope`: Represent an externally created process (e.g., via `systemd-run`)
    - These are auto-generated when launching transient processes.  
    - Transient processes are processes that systemd didn't start through a static
      unit file.  
- `.busname`: D-Bus name activation unit. These are rare. You won't need to worry 
  about these unless you're writing a D-Bus daemon.  
- `.network`: Not a unit file *directly*, these are configuration files for the
  `systemd-networkd` service. 
    - Only use these if you're using `systemd-networkd` instead of NetworkManager, and 
      you're setting up headless servers or containers.  
    - These would go in `/etc/systemd/network/`.  
- `.link`: Configures links (NICs) for `systemd-networkd`.  
- `.netdev`: Defines virtual network devices (`vEth`, `bridge`, etc.)
    - These can create virtual network devices that can be used on bare metal, VMs,
      containers, etc.  


These different unit file types can be broken down into **user-facing** unit types
and **advanced/internal** unit types.  

### User-Facing Unit File Types

These are the most relevant to admins or users that are writing systemd services or
working with other systemd functionality.  

| Unit Type    | Description
| ------------ | -----------
| `.service`   | Defines a service or daemon (like `sshd`, `nginx`, or your own script).
| `.timer`     | Schedules the start of a service, similar to `cron`. Must pair with a `.service`.
| `.mount`     | Describes a mount point (alternative to `/etc/fstab`).
| `.automount` | Enables on-demand mounting. Requires a matching `.mount` unit.
| `.path`      | Watches a file or directory and triggers a `.service` when it changes.
| `.socket`    | Describes a listening socket that triggers a `.service` on demand.
| `.target`    | Groups units together for coordination. Like runlevels.
| `.swap`      | Describes swap files/devices.
| `.slice`     | For grouping services into resource-control domains (uses cgroups).

### Internal Unit File Types

These unit files are rarely written directly by users or admins. They're usually
managed dunamically by systemd or udev.  


| Unit Type  | Description
| ---------- | -----------
| `.scope`   | Represents a transient process started outside systemd's unit control (e.g., `systemd-run bash`).
| `.busname` | Used for D-Bus name-based activation. Only makes sense for services exposing D-Bus interfaces.
| `.device`  | Dynamically generated to track kernel devices (via udev).
| `.link`    | Used by `systemd-networkd` to configure persistent NIC naming, MTU, etc.
| `.network` | Used by `systemd-networkd` to assign IPs, gateways, etc.
| `.netdev`  | Defines virtual devices like `veth`, `bridge`, `vxlan`, etc.


## `.path` Example

We can watch for a new file in some directory and then process it:  
```ini
# file-watcher.path
[Path]
PathChanged=/some/dir
Unit=run-script.service

[Install]
WantedBy=multi-user.target
```

Systemd waits for an event (new file, modification, etc.), then triffers the
`.service`.  

The actual event **is not passed to the service**. 
You can use the service to determine what happened and why.  


## Resources

- `man systemd`
- `man 5 systemd.unit` (for `[Unit]` and `[Install]`)
- `man 5 systemd.service` (for `[Service]`)
- `man 5 systemd.socket` (for `[Socket]`)
- `man 5 systemd.device` (for `[Device]`)
- `man 5 systemd.mount` (for `[Mount]`)
- `man 5 systemd.automount` (for `[Automount]`)
- `man 5 systemd.timer` (for `[Timer]`)
- `man 5 systemd.swap` (for `[Swap]`)
- `man 5 systemd.target` (for `[Target]`)
- `man 5 systemd.path` (for `[Path]`)
- `man 5 systemd.slice` (for `[Slice]`)
- `man 5 systemd.scope` (for `[Scope]`)
- `man 5 systemd.kill`
- `man 5 systemd-system.conf`
- `man 7 systemd.directives`
* [Systemd Service Files](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html#)
* [Systemd Syntax](https://www.freedesktop.org/software/systemd/man/latest/systemd.syntax.html)

- [Systemd Mount](https://www.freedesktop.org/software/systemd/man/latest/systemd.mount.html)
- [Systemd Automount](https://www.freedesktop.org/software/systemd/man/latest/systemd.automount.html)


