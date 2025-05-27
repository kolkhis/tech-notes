# Linux Filesystem Structure and Components

## File System Hierarchy

| Path     | Description
| -------- | -----------------
| `/`      | The top-level directory is the root filesystem. Contains all of the files required to boot the operating system before other filesystems are mounted as well as the files required to boot the other filesystems. After boot, all of the other filesystems are mounted at standard mount points as subdirectories of the root
| `/bin`   | Contains essential command binaries
| `/boot`  | Consists of the static bootloader, kernel executable, and files required to boot the Linux OS.
| `/dev`   | Contains device files (special files) for every hardware device attached to the system
| `/etc`   | Local system configuration files. Also stores config files for applications
| `/home`  | Stores the home directories for all users (except root).
| `/lib`   | Shared library files that are required for system boot.
| `/media` | External removable media devices such as USB drives are mounted here
| `/mnt`   | Temporary mount points for regular filesystems
| `/opt`   | Optional files like third-party tools are usually saved here
| `/root`  | The home directory for the `root` user
| `/sbin`  | This directory contains executables used for system-administration.
| `/tmp`   | The operating system and many programs use this directory to store temporary files. This directory is generally cleared upon system-boot and may be deleted at other times without any warning.
| `/usr`   | Contains executables, libraries, man files, etc.
| `/var`   | This directory contains variable data files (e.g., log files).


## Components

| Component         | Description
| ----------------- | -------------
| `Bootloader`      | A piece of code that runs to guide the bootleg process to start the operating system. Parrot uses the GRUB bootloader.
| `OS Kernel`       | The kernel is the main component of an operating system. It manages the resources for system's I/O devices at the hardware level.
| `Daemons`         | Background services are called "daemons" in Linux. Their purpose is to ensure that key functions such as scheduling, printing and multimedia are working correctly. These small programs load after the computer is booted.
| `OS Shell`        | The operating system shell (command interpreter).
| `Graphics Server` | This provides a graphical sub-system (server) that allows graphical programs to run locally or remotely on an X-windowing system. E.g., `X` or `X-server`.
| `Window Manager`  | Also known as a graphical user interface (GUI). E.g., GNOME, KDE, MATE, Unity and Cinnamon. 
| `Utilities`       | Applications or utilities are programs that perform particular functions for the user or another program.

## Linux Architecture

| Layer            | Description 
| ---------------- | ----------------- 
| `Hardware`       | Peripheral devices such as the system's RAM, hard drive, CPU and others
| `Kernel`         | The core of the operating system, whose function is to virtualize and control hardware resources like CPU, allocated memory, accessed data, etc. The kernel gives each process its own virtual resources and prevents/mitigates conflicts between different processes
| `Shell`          | A command-line interface (CLI), also known as a shell that a user can enter commands into to execute the kernels functions.
| `System Utility` | Makes all of the system's functionality available to the user. 

