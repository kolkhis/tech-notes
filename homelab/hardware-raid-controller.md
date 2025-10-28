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

The default mode for the PERC H730 integrated RAID controller is RAID mode.  

This mode allows the controller to aggregate disks into virtual RAID volumes,
which effectively masks the individual disks themselves.  

This mode is fine if we're opting for a hardware RAID configuration for our
backup and striping disks.  

However, if we want to use any of the advanced features of Proxmox by utilizing
the all features of ZFS, or if we want to use software RAID via `mdadm`, this mode is not
ideal.  

#### Setting up a Hardware RAID Array
If we ever did want to set up a RAID array using the hardware RAID controller,
this must be done during boot in the system setup.  

We'd need to configure a RAID array using the RAID controller's setup utility
(like the PERC configuration, typically accessed with ++ctrl+r++ at boot time).  

If we wanted to use hardware RAID for our Proxmox installation:

- Enter the RAID controller menu during boot and create the RAID array (RAID1,
  RAID5, RAID10, etc.).  

- Save the RAID configuration and exit. The controller now exposes a single
  logical disk, which will be available to the OS.  

- Boot into the Proxmox VE installer and select the RAID array we created as
  the installation target. This will be treated as any other storage device.  

- Post-install, we can format and manage the logical disk with `ext4`, `xfs`,
  `lvm`, etc., but we won't have OS-level access to individual disks, nor can
  we use some of the more advanced features of ZFS, which require direct drive 
  control.  

- For monitoring or management, we would need to ensure the RAID controller
  drivers are loaded and compatible with Proxmox's kernel, to avoid possible 
  detection issues.  
    - Some controllers may require manual driver installation.  


Keep in mind, hardware RAID abstracts away the physical disks. All disk
management, redundancy, and failures are handled by the controller, not by
Proxmox/Linux.  

Also keep in mind, we lose access to features like ZFS or Ceph that require 
direct disk control and SMART data.  


This approach is standard when using hardware RAID on Dell servers for Proxmox,
but it's only really optimal if hardware RAID features (e.g., cache, BBU,
redundancy) are **required**, *and* we don't need the advanced software RAID
features of `mdadm` or ZFS.  

!!! warning "Honestly..."

    Just use HBA/JBOD with software RAID via `mdadm` or ZFS.


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

