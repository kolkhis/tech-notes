
# Notes from The Linux Foundation Courses


## Introduction to Linux - LFS101

## The Three "Main" Families of Linux
There are three major families of Linux distributions:

* Red Hat
* SUSE
* Debian

### Red Hat Family Systems (incl CentOS, Fedora, Rocky Linux)
Red Hat Enterprise Linux (RHEL) heads up the Red Hat family.  

* The basic version of CentOS is virutally identical to RHEL.  
    * CentOS is a close clone of RHEL, and has been a part of Red Hat since 2014.  
* Fedora is an upstream testing platform for RHEL.  
* Supports multiple hardware platforms.  
* Uses `dnf`, an RPM-based package manager to manage packages.  
* RHEL is a popular distro for enterprises that host their own systems.  


### SUSE Family Systems (incl openSUSE)
SUSE (SUSE Linux Enterprise Server, or SLES) and openSUSE are very close to each
other, just like RHEL/CentOS/Fedora.  

* SLES (SUSE Linux Enterprise Server) is upstream for openSUSE.  
* Uses `zypper`, an RPM-based package manager to manage packages. 
* Includes `YaST` (Yet Another Setup Tool) for system administration.  
* SLES is widely used in retail and other sectors.  



### Debian Family Systems (incl Ubuntu and Linux Mint)

Debian provides the largest and most complete software repo to its users of any other
Linux distribution.  
 
* Ubuntu tries to provide a compromise of long term stability and ease of use.  
* The Debian family is upstream for several other distros (including Ubuntu).  
    * Ubuntu is upstream for Linux Mint and other distros.  
* Uses `apt`, a DPKG-based package manager to manage packages.  
* Ubuntu is widely used for cloud deployments.  

--- 

## Linux History Overview

Linux is an open-source OS. Initially developed on and for intel x86-based PCs. Since
then, it's been ported to many other hardware platforms, from embedded appliances to
the world's biggest supercomputers.  


Linux, the kernel, was started in 1991 by Linus Torvalds.  
In 1992, Linux was re-licenced with the GPL by GNU, the operating system, which is from the
Free Software Foundation (FSF), which promotes freely available software.   


Combining the kernel with other systems from the GNU project, other developers create
complete operating systems - Linux distributions - which first appeared in the mid 90s.  

---

In 1998, major companies (IBM and Oracle) announced their support for the Linux
platform. These companies then began major development efforts too. 

Today, Linux is used by more than half of the servers on the internet, the majority
of smartphones (via Android, which is built on top of Linux), more than 90% of
the public cloud workload, and *all* of the world's most powerful supercomputers.  


### The Linux Philosophy 

Linux borrows a lot from UNIX operating systems. It was written to be a free and
opern source alternative.

Files are stored in a hierarchial filesystem. The top node of the system is `root` (or just `/`).  
Whenever possible, Linux makes everything available as files or objects that look
like files.  
Processes, devices, and network sockets are all represented by file-like objects.  
These can often be worked with using the same tools used for regular files.  

Linux is a fully multitasking OS, meaning multiple threads of execution are executed
simultaneously. 
Linux is also a multiuser operating system with builtin networking an service
processes known as "daemons".  



### The Linux Community

The Linux community is made up of people across the world in many different roles.  
Developers, system administrators, users, and vendors, all connect with each other in
many ways.

* IRC (Internet Relay Chat), like with WeeChat, HexChat, Pidgin, XChat, etc.
* Linux User Groups, both local and online.  
* Newsgroups and mailing lists (incl the Linux Kernel Mailing List)
* Online communities and discussion boards  
* Collaborite projects hosted on Github/Gitlab
* Community events (hackathons, install fests, open source summits, embedded linux conferences, etc.)

The site `linux.com` is hosted by the Linux Foundation. It has news, discussion
threads, and free tutorials and tips.  





### Linux Terminology Overview

Some common terminology you'll see in Linux:

* Kernel: The glue between the hardware and applications.  
* Distributon: Collection of software, combined with the Linux kernel, making up a Linux-based OS
* Boot Loader: Program that boots the operating system (GRUB/ISOLINUX)
* Service: Program that runs as a background process 
    * E.g.: `httpd`, `nfsd`, `ntpd`, `ftpd`, `sshd`, `named`, etc.   
* Filesystem: Methods for storing and organizing files. 
    * E.g., `ext3`, `ext4`, `FAT`, `XFS`, `NTFS`, `Btrfs` (butterFS), `ZFS`, etc. 
* X Window System: Graphical subsystem on nearly all Linux systems.  
* Desktop Environment: The GUI on top of the operating system, using the X Window system.  
    * E.g., GNOME, KDE, Xfce, Cinnamon, MATE, Fluxbox, etc.
* Command Line: Interface for typing commands on top of the operating system
* Shell: The command line interpreter. Interprets the command line input and instructs
         the OS to perform any necessary tasks and commands.  
    * `bash`, `sh`, `tcsh`, `zsh`, `fish`, `ksh`


### Definition of Linux Distributions 

A Linux distribution consists of the Linux kernel, plus a number of other software
tools for file-related operation, user management, and software package management. 

Each of those tools provides a part of the complete system.
Each tool is usually its own separate project.  

The most recent Linux kernel, and earlier versions, can be found in the 
[Linux Kernel Archives](https://www.kernel.org/).  

Linux distributions may be based on different kernel versions. 
The RHEL 8 Linux distribution is based on the 4.18 kernel, which isn't new but is
very stable. RHEL 9 is based on the much newer 5.14 kernel.  

The kernel is not an all-or-nothing proposition; many distributions include
customized versions of older versions of the kernel.  
RHEL/CentOS has incorporated many of the more recent kernel improvements by using 
a *CUSTOMIZED* older version of the Linux kernel, as have Ubuntu, openSUSE, Fedora,
etc..  

Other essential tools that make up distributions:
C/C++ and Clang compilers
gdb debugger
core system libraries, which applications need to link with in order to run
Low-level interface for rendering graphics on the screen
Higher-level desktop environment
Package managers. Systems for installing and updating various components (including the kernel itself).

---

#### Who Uses What Distros?

CentOS and CentOS Stream are popular free alternatives to RHEL.  
Large organizations (enterprise/gov't) tend to choose the major
commercially-supported distros from Red Hat, SUSE, and Canonical (Ubuntu).  

The RHEL variants (CentOS, AlmaLinux) are designed to be binary-compatible with
RHEL... In most cases, binary software packages will install properly across all
these distributions.  

Ubuntu and Fedora are widely used by developers, and are popular in the educational realm.  

---

Commercial distributors (Red Hat, Ubuntu, SUSE, and Oracle) provide long term
fee-based support for their distros, as well as hardware and software certification.  

All major distributors provide update services to keep the system updated with
security patches, bug fixes, and performance improvements.  







