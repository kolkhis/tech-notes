# `sysctl`

The `sysctl` tool is used to manage kernel runtime parameters.  

It works with parameters located under `/proc/sys`, and changes made via `sysctl` 
are **immediate but not persistent** unless written to a config file.

## Table of Contents
* [Basic Usage](#basic-usage) 
* [Config Files](#config-files) 
    * [`sysctl` Priority Order](#sysctl-priority-order) 

## Basic Usage
* View all kernel runtime parameters as they're currently set:
  ```bash
  sysctl -a
  ```

* Filter for ipv4:
  ```bash
  sysctl -a | grep -i 'ipv4'  
  ```

* Filter for settings that **start** with `net.ipv4`:
  ```bash
  sysctl net.ipv4             
  ```
  Note that this will not do the same as `grep`, it will only show settings that start
  with the given argument.  

* Filter for a specific setting by name:
  ```bash
  sysctl net.ipv4.ip_forward
  ```
  This will look in `/proc/sys/` for the current state of that setting.  
  This will follow the path: `/proc/sys/net/ipv4/ip_forward`

* Set a runtime kernel parameter (**non-persistent**):
  ```bash
  sysctl net.ipv4.ip_forward=0
  ```
  This change will not persist throughout reboots.  
  You'll need to add a rule to a [config file](#config-files) to persist the change. 


* Reload kernel runtime parameters without rebooting:
  ```bash
  sysctl --system
  ```

## Config Files

To configure kernel runtime parameters to **persist** throughout reboots, you need to
add them to a config file in `/etc/sysctl.d/`.  

Custom settings should go in `/etc/sysctl.d/`, but there are other locations where
settings are stored:  
- `/usr/lib/sysctl.d/`: Vendor settings go in here. 
- `/etc/sysctl.d/`: This is where you should put your settings.  
- `/run/sysctl.d/`



### `sysctl` Priority Order
When kernel paremeters are loaded in, either on boot or with `sysctl --system`, it
looks for files in this order:
* `/etc/sysctl.d/*.conf`
* `/run/sysctl.d/*.conf`
* `/usr/local/lib/sysctl.d/*.conf`
* `/usr/lib/sysctl.d/*.conf`
* `/lib/sysctl.d/*.conf`
* `/etc/sysctl.conf`

Once a file has been loaded, any other files with the same name will be ignored. 
Since files in `/etc/sysctl.d` are loaded first, this is where we put our settings.  

