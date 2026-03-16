# Linux From Scratch (LFS)


## What is LFS?

- [Linux From Scratch](https://www.linuxfromscratch.org/)

Linux From Scratch (LFS) is a project that provides instructions for building 
your own custom Linux operating system directly from source code.

It is designed for Linux users who want to gain a deeper understanding of the
inner workings of the operating system.  

---

These notes will document building my own Linux operating system by using LFS
as a base. The OS will use common enterprise technologies (e.g., systemd)
rather than more obscure tools. I made this choice to gain a deeper
understanding of the OS components used in enterprise environments.  


## Starting Out

LFS follows Linux standards as closely as possible.

The standards followed: 

- [POSIX.1-2008](https://pubs.opengroup.org/onlinepubs/9699919799/)
    - The POSIX specification.  
- [Filesystem Hierarchy Standard (FHS) Version 3.0](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
    - The filesystem structure.  
- [Linux Standard Base (LSB) Version 5.0 (2015)](https://refspecs.linuxfoundation.org/lsb.shtml)
    - The LSB consists of several separate specifications:
        - Core
        - Desktop
        - Runtime Languages
        - Imaging

The core packages that are included in a system built to the LFS standard are
listed [here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/prologue/package-choices.html)
along with explanations on why they were included.  

## Setting up the Build Environment

The LFS project is built within a pre-existing Linux system.  
A disk partition is made for the LFS filesyste and that's where the new OS is
going to be built.  

The list of dependencies for builting an LFS system can be found 
[here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/hostreqs.html). 

They provide a shell script on that page that checks for the dependencies on
the host system and ensures they're on the correct versions.  

For chapters 1-4:
- Anything done as the root user after Section 2.4 must have the `LFS` environment variable set FOR THE ROOT USER.

- The `LFS` variable must be set at all times, and the `umask` needs to be set to `0022`.

For chapters 5-6:

- The partition should be at `/mnt/lfs` and always be mounted.  

- Chapters 5 and 6 must be done as the `lfs` user system account.  
    - Create the `lfs` user and group.  
    - Use `su - lfs` for each task in these chapters.  

For chapters 7-10:
- `/mnt/lfs` should be mounted.  

## Resources

- Basic Resources: <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter01/resources.html>
- FAQs: <https://www.linuxfromscratch.org/faq/>
- <https://systemd-by-example.com/>


