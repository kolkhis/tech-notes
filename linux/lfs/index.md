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

### Chapter Overview
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

## Setting up the Build Environment

The LFS project is built within a pre-existing Linux system.  
A disk partition is made for the LFS filesyste and that's where the new OS is
going to be built.  

The list of dependencies for builting an LFS system can be found 
[here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/hostreqs.html). 

They provide a shell script on that page that checks for the dependencies on
the host system and ensures they're on the correct versions.  

My host system used for building is Ubuntu Server 22.04.3, using the default 
LVM installation.

### Adding a New Virtual Disk

Step one is to create a partition on which to build the LFS system.  

With an LVM installation on a VM, there are two options.  

1. Add a second virtual disk.  
2. Shrink and create space for another partition in LVM.  

I'm going to opt for adding a second virtual disk to the VM in Proxmox.  

From the Proxmox Web UI, go to the VM, select the Hardware tab, and add a new 
hard disk.
Choose your storage pool (default is fine if there are no others set up).  

My current disk for build is listed as `/dev/sdb` in the system.  
This will be the dedicated LFS disk referred to for the rest of the build in 
this document.  

--- 

### Paritioning The Disk

- Book Source: [Chapter 2.4](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/creatingpartition.html)  

There are several partitions **required** for a Linux system:

- The root partition `/`
- The swap partition 
- The EFI boot parition
- The GRUB BIOS partition (optional but needed for BIOS/Legacy boot and Secure Boot)

The disk partitioning can be automated via `sfdisk`.  

Define sizes for the partitions needed via an `sfdisk` script:
```bash
# Partition table type
label: gpt
unit: sectors
first-lba: 2048

# BIOS boot partition
# This `type` specifies a BIOS Boot Partition
size=1M, type=21686148-6449-6E6D-744E-6574626F6F74, name="BIOS_Boot"

# 1. /boot (EFI System Partition) - 1GB
# type=U is the shortcut for EFI System
size=1G, type=U, name="EFI_System"

# 2. Swap - 4GB
# type=S is the shortcut for Linux Swap
size=4G, type=S, name="Linux_Swap"

# 3. / (Root) - Remainder of disk
# type=L is the shortcut for Linux Filesystem
type=L, name="Linux_Root"
```

Save that script into a file, then pass the file via stdin to `sfdisk`:
```bash
sudo sfdisk /dev/sdb < ./sfdisk_disk_layout
```

Check the disk:
```bash
sudo fdisk -l /dev/sdb
```

The output should look like:
```txt
Device        Start      End  Sectors Size Type
/dev/sdb1      2048     4095     2048   1M unknown
/dev/sdb2      4096  2101247  2097152   1G EFI System
/dev/sdb3   2101248 10489855  8388608   4G Linux swap
/dev/sdb4  10489856 67108830 56618975  27G Linux filesystem
```

- `/dev/sdb1` is our BIOS boot partition.  
- `/dev/sdb2` is our EFI system partition.  
- `/dev/sdb3` is our SWAP partition.  
- `/dev/sdb4` is our root filesystem partition.  

### Formatting Partitions with Filesystems

- Book Source: [Chapter 2.5](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/creatingfilesystem.html)

Now we can format these partitions.  

- The BIOS boot partition (/dev/sdb1) requires no filesystem.    
- EFI system partition requires FAT32
- SWAP partition requires SWAP
- Rootfs requires EXT4

```bash
mkfs.vfat -F32 /dev/sdb2
mkswap /dev/sdb3
mkfs.ext4 /dev/sdb4
```

Disk should look like this:
```txt
kolkhis@lfs-builder:~$ lsblk -f /dev/sdb
NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sdb
├─sdb1
├─sdb2 vfat   FAT32       08D0-FC00
├─sdb3 swap   1           e81488ff-eb87-4fdf-bcbc-c6bc2b335a91
└─sdb4 ext4   1.0         ea99de3f-5513-4338-8e88-878a51dade4c
```

### LFS Variable/Umask

- Book Source: [Chapter 2.6](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/aboutlfs.html)

LFS requires a `$LFS` variable to be set to the desired mountpoint for the LFS
partition.    

The umask also needs to be set to `022`. 

```bash
export LFS="/mnt/lfs"
sudo umask 022
```

### Mounting the Partition

- Book Source: [Chapter 2.7](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/mounting.html)

Mount the root filesystem partition (`/dev/sdb4`).  
```bash
mkdir -pv "$LFS"
mount -v -t ext4 /dev/sdb4 "$LFS"
chown root:root "$LFS"
chmod 755 "$LFS"
```

If we are using a swap partition, ensure that it is enabled using the `swapon` command:
```bash
sudo swapon /dev/sdb3
sudo swapon
#NAME      TYPE      SIZE USED PRIO
#/swap.img file        3G   0B   -2
#/dev/sdb3 partition   4G   0B   -3
```

### Make the Mount Persistent

Get the UUID of the root fs block device.  
```bash
lsblk -f
# ...
# └─sdb4
#     ext4   1.0                        ea99de3f-5513-4338-8e88-878a51dade4c
```

Then add an entry in /etc/fstab using the UUID.  
```bash
/dev/disk/by-uuid/ea99de3f-5513-4338-8e88-878a51dade4c  /mnt/lfs  ext4 defaults 0 0
```


## Packages

- Book Source: [Chapter 3.1](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/introduction.html)

The `$LFS/sources` directory will be used to store the packages and their
sources.  

It's recommended to make this writable and "sticky" (only the owner can delete
files inside).  
```bash
mkdir "$LFS/sources"
chmod 1755 "$LFS/sources"
```

The packages can be fetched individually or from a curated list specifically
for LFS.  

A full list, line-by-line, can be found
[here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list-systemd).  

Use `wget` to fetch all tarballs and patches.  
```bash
curl -O https://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list-systemd
wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources
```

Change ownership of the `$LFS/sources` directory to root (user and group).  
```bash
sudo chown -R root:root "$LFS/sources"
```

All packages that must be present in `$LFS/sources` can be found
[here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/packages.html),
and the patches can be found 
[here](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/patches.html).  

## Final Preparations

- [Book Source](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter04/introduction.html)
- https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter04/creatingminlayout.html

We need to create a directory structure on the rootfs to install the new tools
we downloaded.  

The script they provide:
```bash
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
```

This creates the directories:

- `/mnt/lfs/etc`
- `/mnt/lfs/var`
- `/mnt/lfs/usr/bin`
- `/mnt/lfs/usr/lib`
- `/mnt/lfs/usr/sbin`

As well as symlinks everything in `/mnt/lfs/usr/bin`, `/mnt/lfs/usr/lib`, and `/mnt/lfs/usr/sbin` to `

When creating symlinks, output should be.
```bash
# for i in bin lib sbin; do sudo ln -sv "usr/$i" "$LFS/$i"; done
'/mnt/lfs/bin' -> 'usr/bin'
'/mnt/lfs/lib' -> 'usr/lib'
'/mnt/lfs/sbin' -> 'usr/sbin'
```

Additionally, if on `x86_64` architecture, create the directory `$LFS/lib64`.  
```bash
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
```

Finally, one more directory:
```bash
mkdir -pv "$LFS/tools"
```

### Adding an LFS User

We're creating a new user account (unprivileged) for the LFS system.  

Create a user account named `lfs`.  
By default, a new group with the same name is created with `useradd`, but LFS
suggests using `groupadd` first to create the group.  
```bash
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
```

Create a psasword for the new user:
```bash
passwd lfs
```

Change ownership of everything in `$LFS` to the new user.  
```bash
chown -v lfs $LFS/{usr{,/*},var,etc,tools}
# and if on x86 architecture, do that dir
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
```

Finally, switch to the user.  
```bash
su - lfs
```

### Setting up the Environment

As the `lfs` user, create a `.bash_profile`.  

```bash
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
```
This unsets all environment variables except the ones specified (HOME, TERM,
PS1).  

This ensures that we don't read the host system's runtime configuration files,
and will only read the `.bashrc` file in the `/home/lfs` directory.  

The `.bashrc` will be as follows.  
```bash
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF
```

If the host system has an `/etc/bash.bashrc` file, remove it to prevent the
environment being populated with unwanted environment vars.  
```bash
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
```

Now, prepping to build all the stuff.  

`make` can spawn multiple processes by using the `-j` flag.  
Alternatively, set the `MAKEFLAGS` var to the desired `-j` value.  
For example, if you have an 8 core processor with 16 efficiency cores, you
could spawn up to 32 instances of `make`. 
```bash
make -j32
# or
export MAKEFLAGS=-j32
```
This is how we're going to build all these packages that we downloaded. There's
a lot of em.  

**Check how many cores you have available with `nproc`**.  

```bash
cat >> ~/.bashrc << "EOF"
export MAKEFLAGS=-j$(nproc)
EOF
```

My build environment has 2 cores.  
So, we'll do `-j2`.  

I am extending the CPUs for the host VM that will be building the packages. I'm
allocating 24 cores to it to build faster.  

- Source:
  <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter04/aboutsbus.html>

Many packages come with a test suite. Some packages' test suites are more
important than others (e.g., gcc, glibc, etc.).  

- Source:
  <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter04/abouttestsuites.html>

## Building the LFS Cross Toolchain and Temporary Tools

> This is where the real work of building a new system begins.

- Source:
  <https://www.linuxfromscratch.org/lfs/view/stable-systemd/part3.html>

This section is split into three parts:

1. Building a cross compiler and its associated libraries.  
2. Using this cross toolchain to build several utilities in a way that isolates 
   them from the host distribution.  
3. Entering the chroot environment (which further improves host isolation) and 
   constructing the remaining tools needed to build the final system.


- [Toolchain Technical Notes](https://www.linuxfromscratch.org/lfs/view/stable-systemd/partintro/toolchaintechnotes.html)

We're cross-compiling the entire toolchain. 
This means we're building the toolchain on the host system, but it's going to 
produce code for the target system (the LFS system).
The reason for this is that it will not be dependent on the host system.  

> ...anything that is cross-compiled cannot depend on the host environment.  

- Note: It's known installing GCC pass 2 will break the cross-toolchain

### Important Concepts

A few definitions for the rest of the document:

- The build: The machine where we build the programs (the host system).  
- The host: This is where the built programs will run (the LFS system). 
- The target: The machine that the compiler produces code for.  

All the packages in the book use an autoconf-based building system.  
This accepts system types in the form `cpu-vendor-kernel-os` (referred to as a
system triplet).  

The `vendor` field is often omitted.  
The `kernel` and `os` began as a single `system` field, which is why it's
called a triplet even though it's 4 fields.  

> A simple way to determine your system triplet is to run the config.guess
> script that comes with the source for many packages.

The dynamic linker (or dynamic loader) used on my host system is `/lib64/ld-linux-x86-64.so.2`
(symlinked from `/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2`).  

This finds and loads the shared libraries needed by a program.  

Check your system's dynamic linker with `ldd gcc`, or with the suggested command:  
```bash
readelf -l <name of binary> | grep interpreter
```

Using it on `/bin/bash`:
```bash
readelf -l /bin/bash | grep interpreter
#      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
```

The cross-compiler will *not* be part of the final LFS build, it's just used
for compiling the programs for the LFS system.  

> In order to cross-compile a package for the LFS temporary system, the name of
> the system triplet is slightly adjusted by changing the "vendor" field in the
> LFS_TGT variable so it says "lfs" and LFS_TGT is then specified as “the host”
> triplet via `--host`...  

---


### Prepping for the Build

The cross-compiler will be installed in a separate `$LFS/tools` directory, since 
it will not be part of the final system.

We'll be using the `--with-sysroot` option when building the cross-linker and 
cross-compiler, to tell them where to find the needed files for "the host" (the
LFS system)


Binutils is installed first because the configure runs of both gcc and glibc 
perform various feature tests on the assembler and linker

Then, we'll get a C compiler. 

It's going to be "cc1-based libgcc", which does require glibc for full
functionality (e.g., exception handling and threads), but it's enough to
compile glibc by itself.

After installing the compiler, we sanitize Linux API headers. This allows glibc
to interface with all Linux kernel features.  

Once we've done that, we can install `glibc`. This is the first package we
cross-compile.  

When compiling `glibc`:

- We'll use the `--host=$LFS_TGT` option.  
- Also the `--build=$(../scripts/config.guess)` to enable the "cross-compilation mode".  
- The `DESTDIR` variable is used to force installation into the LFS file system.  


#### Build Process Synopsis
Place all the sources and patches in a directory that will be accessible from 
the chroot environment, such as `/mnt/lfs/sources/`.

- Change to the /mnt/lfs/sources/ directory.

- For each package:

    - Using the tar program, extract the package to be built. In Chapter 5 and 
      Chapter 6, ensure you are the lfs user when extracting the package.

    - Do not use any method except the tar command to extract the source code. 
      Notably, using the `cp -R` command to copy the source code tree somewhere else 
      can destroy timestamps in the source tree, and cause the build to fail.

    - Change to the directory created when the package was extracted.

    - Follow the instructions for building the package.

    - Change back to the sources directory when the build is complete.

    - Delete the extracted source directory unless instructed otherwise.


We'll use `tar` to extract packages to be built.  

## Installing/Compiling the Packages

- [Book Source](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/chapter05.html)

The cross-compiler and all its associated tools will be installed `$LFS/tools`.

But the libraries will be installed into the final destination (the LFS system).  

### Installing Cross Binutils
Binutils needs to be installed first because glibc and gcc use this for tests
on the available linker and assembler.  

The binutils docs suggest making a dedicated build directory.  
```bash
cd $LFS/sources
tar -xJvf ./binutils-2.46.0.tar.xz
cd ./binutils-2.46.0/
mkdir build
```
Let's `time` the commands to configure and build.  
```bash
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu
# Time:
# real    0m6.452s
# user    0m4.585s
# sys     0m2.860s
```
Then we `make`.  
```bash
time make
# real    6m37.136s
# user    5m12.127s
# sys     1m37.809s
```

Then `make install`.  
```bash
time make install
# real    0m6.785s
# user    0m4.516s
# sys     0m2.823s
```

### Installing Cross GCC

GCC requires the GMP, MPFR and MPC packages
They'll be built with GCC.  

Unpack each package into the GCC source directory and rename the resulting 
directories so the GCC build procedures will automatically use them.  

```bash
cd $LFS/sources
tar -xJvf ./gcc-15.2.0.tar.xz
cd ./gcc-15.2.0

tar -xJvf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr

tar -xJvf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp

tar -xzvf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc
```

On x86_64 architecture, set default directory name for 64-bit libraries to `lib`.  
```bash
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac
```

GCC docs recommends a dedicated build directory.  
```bash
mkdir build
cd build
```

Then we can use the `configure` script.  
```bash
time ../configure             \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.43 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

# real    0m4.832s
# user    0m2.984s
# sys     0m2.537s
```

- Full breakdown of command can be found here:
  <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gcc-pass1.html>

Then we can `make` and `make install`
```bash
time make
time make install
```

#### ERRORS

Error:
```txt
libtool: link: (cd ".libs" && rm -f "libcp1plugin.so.0" && ln -s "libcp1plugin.so.0.0.0" "libcp1plugin.so.0")
libtool: link: (cd ".libs" && rm -f "libcp1plugin.so" && ln -s "libcp1plugin.so.0.0.0" "libcp1plugin.so")
libtool: link: ( cd ".libs" && rm -f "libcp1plugin.la" && ln -s "../libcp1plugin.la" "libcp1plugin.la" )
make[3]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build/libcc1'
make[2]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build/libcc1'
make[1]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build'
make: *** [Makefile:1048: all] Error 2
```

Failing at line 1048 of the makefile:
```make
all:
        +@r=`${PWD_COMMAND}`; export r; \
        s=`cd $(srcdir); ${PWD_COMMAND}`; export s; \
          $(MAKE) $(RECURSE_FLAGS_TO_PASS) \
                $(PGO_BUILD_GEN_FLAGS_TO_PASS) all-host all-target \
```

Error with verbose output:
```txt
checking for x86_64-lfs-linux-gnu-gcc... /mnt/lfs/sources/gcc-15.2.0/build/./gcc/xgcc -B/mnt/lfs/sources/gcc-15.2.0/build/./gcc/ -B/mnt/lfs/tools/x86_64-lfs-linux-gnu/bin/ -B/mnt/lfs/tools/x86_64-lfs-linux-gnu/lib/ -isystem /mnt/lfs/tools/x86_64-lfs-linux-gnu/include -isystem /mnt/lfs/tools/x86_64-lfs-linux-gnu/sys-include
checking for suffix of object files... configure: error: in `/mnt/lfs/sources/gcc-15.2.0/build/x86_64-lfs-linux-gnu/libgcc':
configure: error: cannot compute suffix of object files: cannot compile
See `config.log' for more details
make[1]: *** [Makefile:14102: configure-target-libgcc] Error 1
make[1]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build'
make: *** [Makefile:1048: all] Error 2
```
Running with `make -d`:
```txt
checking whether ln -s works... yes
checking for x86_64-lfs-linux-gnu-gcc... /mnt/lfs/sources/gcc-15.2.0/build/./gcc/xgcc -B/mnt/lfs/sources/gcc-15.2.0/build/./gcc/ -B/mnt/lfs/tools/x86_64-lfs-linux-gnu/bin/ -B/mnt/lfs/tools/x86_64-lfs-linux-gnu/lib/ -isystem /mnt/lfs/tools/x86_64-lfs-linux-gnu/include -isystem /mnt/lfs/tools/x86_64-lfs-linux-gnu/sys-include
checking for suffix of object files... configure: error: in `/mnt/lfs/sources/gcc-15.2.0/build/x86_64-lfs-linux-gnu/libgcc':
configure: error: cannot compute suffix of object files: cannot compile
See `config.log' for more details
Reaping losing child 0x5582d453d240 PID 270198
make[1]: *** [Makefile:14102: configure-target-libgcc] Error 1
Removing child 0x5582d453d240 PID 270198 from chain.
make[1]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build'
Reaping losing child 0x5612af9fada0 PID 269347
make: *** [Makefile:1048: all] Error 2
Removing child 0x5612af9fada0 PID 269347 from chain.
```

cd /mnt/lfs/sources/gcc-15.2.0/build/x86_64-lfs-linux-gnu/libgcc
grep -A20 -B5 "cannot compute suffix of object files" /mnt/lfs/sources/gcc-15.2.0/build/x86_64-lfs-linux-gnu/libgcc/config.log

---

```bash
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
    `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
```
 




## Resources

- Basic Resources: <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter01/resources.html>
- FAQs: <https://www.linuxfromscratch.org/faq/>
- <https://systemd-by-example.com/>


