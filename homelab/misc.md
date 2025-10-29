# Misc.

A collection of miscellaneous notes for my homelab.  


## Disk Setup

- `/dev/sda`: Main boot disk, RAID1 mirrored to `/dev/sdc`.  
    - `sda1`: Reserved for BIOS partition
    - `sda2`: UEFI boot partition (`/boot/efi`)
    - `sda3`: Root filesystem, tmpfs, etc.
- `/dev/sdb`: ZFS pool `vmdata`, mirrored to `/dev/sdd`.  
- `/dev/sdc`: Mirrored RAID1 array (mdadm) backup of `/dev/sda`.  
    - Paritions mirrored from `/dev/sda`, UEFI system partition cloned.  
- `/dev/sdd`: Mirrored ZFS pool from `/dev/sdb`.  


## Ubuntu Server Templates

In making templates for Ubuntu Server 22.04 and 24.04, I'm keeping a list of
packages I'm manually installing here.  

???+ note "Side note: Listing manually installed packages"

    Manually installed packages can be listed by using `apt-mark`:
    ```bash
    apt-mark showmanual
    ```
    This will list *some* packages that were installed by the system itself during
    installation. The default packages listed will depend on what installation
    method was selected during the OS install process.  

    If we chose "Ubuntu Server (Minimal)" in the installer, we'd have less
    packages. I chose the default, which installs a few more packages useful for 
    admins.  

    The output of this on a relatively clean installation of Ubuntu Server 24.04:
    ```bash
    kolkhis@ubuntu-server-24-04:~$ apt-mark showmanual
    base-files
    bash
    bsdutils
    dash
    diffutils
    findutils
    grep
    grub-pc
    gzip
    hostname
    init
    linux-generic
    login
    ncurses-base
    ncurses-bin
    openssh-server
    perl-doc
    ubuntu-minimal
    ubuntu-server
    ubuntu-server-minimal
    ubuntu-standard
    util-linux
    ```
    The only one listed here that I manually installed myself was `perl-doc`.  



