# Hardware RAID Controller

My server (Dell PowerEdge R730) came equipped with a hardware RAID controller.  
The model is Dell PERC H730. 

## Server Setup

When I initially set up my homelab using this server, I had a hard time
figuring out why the Proxmox VE installer could not find any disks to install
itself onto.  

The solution I came up with for this was to go into the System Setup (++f2++ on
boot), go to Device Settings, then go to the specific disks that I added and
run the "Convert to non-RAID device" operation on each of them.  

As I added more and more storage devices, this process got tiresome.  

I decided to dig a bit deeper into how I might allow passthrough to bypass the
hardware RAID controller entirely.  

## RAID Controller Modes

There are three main modes that a RAID controller can be set to.  

1. RAID Mode
2. HBA Mode
3. JBOD Mode

The default configuration for the Dell PERC H730 (and likely many other
systems' RAID controllers) is RAID mode.  

### RAID Mode

<!-- TODO -->

### HBA Mode

One of the options that I found was Host Bus Adapter (HBA) mode, which some
hardware RAID controllers support.  
This simply passes through physical drives directly to the operating system
without aggregating them or masking them behind a RAID layer.  


### JBOD Mode

The other variant of HBA is "Just a Bunch of Disks" (JBOD) mode.  
This mode denotes a configuration where each disk is presented individually, 
rather than part of a RAID array.  

This mode is often used synonomously with HBA.  

Each disk is seen by the OS as a separate storage unit, allowing direct access
and management per disk.  


## Enabling HBA Mode

I found that the PERC H730 did support HBA mode, so I opted to enable that
rather than the manual non-RAID device configuration.  

!!! note "HBA Mode on Other Models"

    I have not tested this process on other models of integrated hardware RAID
    controllers, as I do not have access to any other servers. However, I would 
    assume this process is identical on other models put out in Dell PowerEdge 
    series servers.  


To enable HBA mode through the PERC H730 hardware RAID controller, we need to
boot into the System Setup screen (++f2++ on boot).  

From there, we navigate to:

- System Setup (Main Menu)
- Device Settings
    - Select the hardware RAID controller:
      ```plaintext
      Integrated RAID Controller 1: Dell PERC <PERC H730 Mini> configuration utility
      ```
- Controller Management
- Advanced Controller Management

At the bottom of this screen, there is an option to select: "Switch to HBA mode".  

Select it and press ++enter++ and we should get a message indicating the
operation was successful.  

From there, it's a simple reboot. 

**From now on, all disks that are connected to the server should be immediately 
available to the operating system directly.**

This will allow us to utilize the disk hot-swap feature that these rack servers
afford us as administrators.  

---

