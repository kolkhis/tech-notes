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
cd build
```

Let's `time` the commands to configure and build.  
```bash
time ../configure --prefix=$LFS/tools \
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

---

### Reinstalling

GCC requires the GMP, MPFR and MPC packages.

```bash
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc
```

An error while trying to run `configure`:
```txt
configure: error: Building GCC requires GMP 4.2+, MPFR 3.1.0+ and MPC 0.8.0+.
Try the --with-gmp, --with-mpfr and/or --with-mpc options to specify
their locations.  Source code for these libraries can be found at
their respective hosting sites as well as at
https://gcc.gnu.org/pub/gcc/infrastructure/.  See also
```

Error while running `make`
```txt
Libraries have been installed in:
   /mnt/lfs/tools/lib/../lib

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
libtool: finish: PATH="/mnt/lfs/tools/bin:/usr/bin:/sbin" ldconfig -n /mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/15.2.0/plugin
----------------------------------------------------------------------
Libraries have been installed in:
   /mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/15.2.0/plugin

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
make[3]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build/libcc1'
make[2]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build/libcc1'
make[1]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build'
make: *** [Makefile:2654: install] Error 2
```

Manual run after changing ownership:
```txt
make[2]: *** No rule to make target 'install'.  Stop.
make[2]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build/x86_64-lfs-linux-gnu/libgcc'
make[1]: *** [Makefile:14255: install-target-libgcc] Error 2
make[1]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build'
make: *** [Makefile:2654: install] Error 2
Command exited with non-zero status 2
```


```txt
libtool: link: (cd ".libs" && rm -f "libcp1plugin.so.0" && ln -s "libcp1plugin.so.0.0.0" "libcp1plugin.so.0")
libtool: link: (cd ".libs" && rm -f "libcp1plugin.so" && ln -s "libcp1plugin.so.0.0.0" "libcp1plugin.so")
libtool: link: ( cd ".libs" && rm -f "libcp1plugin.la" && ln -s "../libcp1plugin.la" "libcp1plugin.la" )
make[3]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build/libcc1'
make[2]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build/libcc1'
make[1]: Leaving directory '/mnt/lfs/sources/gcc-15.2.0/build'
make: *** [Makefile:1048: all] Error 2
```

### Fix For Errors

We deleted the `binutils` and `gcc` directories, along with all subdirectories in
the `gcc` directory containing the dependencies `mpfr`, `mpd`, and `gmp`.  

Starting over from scratch, I wrote a script to execute each of the steps 
exactly as described in the book.

The script is below.  
```bash
#!/bin/bash

LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu # x86_64-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS="-j$(nproc)"

if [[ $USER != "lfs" ]]; then
        printf >&2 'ERROR: Run as root\n'
fi


binutils-setup(){
        cd $LFS/sources  || {
                printf >&2 "ERROR: Could not CD to %s/sources\n" "$LFS"
        }
        tar -xJvf ./binutils-2.46.0.tar.xz
        cd ./binutils-2.46.0/
        mkdir build
        cd build
        ../configure --prefix=$LFS/tools \
                     --with-sysroot=$LFS \
                     --target=$LFS_TGT   \
                     --disable-nls       \
                     --enable-gprofng=no \
                     --disable-werror    \
                     --enable-new-dtags  \
                     --enable-default-hash-style=gnu
        printf "Running make\n"
        time make
        printf "Running make install\n"
        time make install
}

dep-setup(){
        cd $LFS/sources/gcc-15.2.0 || {
                printf >&2 "ERROR: Could not CD to %s/sources\n" "$LFS"
        }
        tar -xf ../mpfr-4.2.2.tar.xz
        mv -v mpfr-4.2.2 mpfr
        tar -xf ../gmp-6.3.0.tar.xz
        mv -v gmp-6.3.0 gmp
        tar -xf ../mpc-1.3.1.tar.gz
        mv -v mpc-1.3.1 mpc
}

setup-gcc() {
        cd "$LFS/sources"
        if ! [[ -d ./gcc-15.2.0 ]]; then
                tar -xJvf ./gcc-15.2.0.tar.xz
        fi
        cd ./gcc-15.2.0

        case $(uname -m) in
          x86_64)
            sed -e '/m64=/s/lib64/lib/' \
                -i.orig gcc/config/i386/t-linux64
         ;;
        esac

        if ! [[ -d ./build ]]; then
                mkdir build
        fi
        cd build

        printf "Trying to configure now.\n"

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

        printf "Running MAKE\n"
        time make
        printf "Running MAKE INSTALL\n"
        time make install > gcc-install-logs.log
}

binutils-setup
dep-setup
setup-gcc
```
 
This fixed the issue. Ran the script as the `lfs` user to ensure correct
permissions on all files.  

```bash
su lfs
./setup-gcc
```

---


### GCC Post-Install

This install of GCC does not come with a `limits.h` header file.  
Normally it'd be in `$LFS/usr/include/limits.h`.  
It's not needed for building glibc, but it'll be needed later.  

```bash
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
```
This is having us concatenate the contents of all 3 of these files: 

- gcc/limitx.h 
- gcc/glimits.h 
- gcc/limity.h

Into `/mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/15.2.0/include/limits.h`.  

The `$LFS/tools` directory is where the final build products are stored.  

That concludes section 5.3.  


## Installing Linux API Headers

- [Book Source: Chapter 5.4](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/chapter05/linux-headers.html)
    - Explanations of headers purposes can be found there.  

We need to install the Linux API Headers (in `linux-6.18.10.tar.xz`) expose the 
kernel's API for use by Glibc.

```bash
cd $LFS/sources
tar -xJvf linux-6.18.10.tar.xz
cd linux-6.18.10
```

Ensure no stale files exist in the package
```bash
make mrproper
```

> Now extract the user-visible kernel headers from the source. The recommended
> make target “headers_install” cannot be used, because it requires rsync,
> which may not be available. The headers are first placed in ./usr, then
> copied to the needed location.

```bash
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
```

## Installing Glibc

1. First, create a symbolic link for LSB compliance (from the $LFS root
   directory).
   ```bash
   cd $LFS
   case $(uname -m) in
       i?86)   
            ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
            ;;
       x86_64) 
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
            ;;
   esac
   ```

    - This checks CPU architecture and symlinks to different locations for i86
      and x86_64.  

    - I could not find these `.so` files on the host after building headers, however
      I found you can prematurely make a symlink to a file before it exists. This is
      just for LSB compliance reasons.  


2. Extract the glibc tarball:
   ```bash
   tar -xJvf ./glibc-2.43.tar.xz
   cd glibc-2.43
   ```

3. Some of the Glibc programs use the non-FHS-compliant `/var/db` directory to
   store their runtime data.
   We can use `patch` to apply the patch they have for this.  
   ```bash
   patch -Np1 -i ../glibc-fhs-1.patch
   ```

4. Make a build directory
   ```bash
   mkdir build
   cd build
   ```

5. Ensure that the `ldconfig` and `sln` utilities are installed into `/usr/sbin`.  
   ```bash
   echo "rootsbindir=/usr/sbin" > configparms
   ```

6. Run the `configure` script to prep for glibc compilation.  
   ```bash
   time ../configure                     \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib           \
      --enable-kernel=5.4
   #real    0m10.479s
   #user    0m6.139s
   #sys     0m4.273s
   ```

7. Compile glibc
   ```bash
   time make
   #real    2m47.189s
   #user    22m11.875s
   #sys     6m21.092s
   ```

8. Finally, `make install` it while setting the `DESTDIR` variable to `$LFS`.  
   ```bash
   make DESTDIR="$LFS" install
   ```
    - The `DESTDIR` make variable is used by almost all packages to define the
      location where the package should be installed.

9. Fix a hard coded path to the executable loader in the ldd script. 
   ```bash
   sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
   ```

The cross-toolchain is now set up, but now we need to make sure that compiling
and linking works as intended. 

Do a sanity check:
```bash
cd $LFS/sources
echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
```

- The output of the `readelf` command should not contain the value of `$LFS`.  

Look for important success messages in the dummy.log file.  
```bash
grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log
```

Expected output:
```text
/mnt/lfs/lib/../lib/Scrt1.o succeeded
/mnt/lfs/lib/../lib/crti.o succeeded
/mnt/lfs/lib/../lib/crtn.o succeeded
```

Verify that the compiler is looking in the right place for header files:
```bash
grep -B3 "^ $LFS/usr/include" dummy.log
```

Expected output:
```text
#include <...> search starts here:
 /mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/15.2.0/include
 /mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/15.2.0/include-fixed
 /mnt/lfs/usr/include
```

Then verify that the new linker is being used.  
```bash
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
```

Expected output:
```text
SEARCH_DIR("=/mnt/lfs/tools/x86_64-lfs-linux-gnu/lib64")
SEARCH_DIR("=/usr/local/lib64")
SEARCH_DIR("=/lib64")
SEARCH_DIR("=/usr/lib64")
SEARCH_DIR("=/mnt/lfs/tools/x86_64-lfs-linux-gnu/lib")
SEARCH_DIR("=/usr/local/lib")
SEARCH_DIR("=/lib")
SEARCH_DIR("=/usr/lib");
```

Ensure that we're using the correct libc:

```bash
grep "/lib.*/libc.so.6 " dummy.log
```

Expected output:
```text
attempt to open /mnt/lfs/usr/lib/libc.so.6 succeeded
```

Check that the correct linker is being used:  
```bash
grep found dummy.log
```

Expected output:
```text
found ld-linux-x86-64.so.2 at /mnt/lfs/usr/lib/ld-linux-x86-64.so.2
```

Then that part is done. We can remove the dummy test log.  
```bash
rm dummy.log
```

## Installing Libstdc++ (Libstdc++ from GCC-15.2.0)

- [Book Source: Chapter 5.6](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/chapter05/gcc-libstdc++.html)

> **Note**: Libstdc++ is part of the GCC sources. You should first unpack the GCC
> tarball and change to the gcc-15.2.0 directory.

We've already installed GCC at this point, so the `gcc-15.2.0` directory should
already be in `$LFS/sources`.  

1. Create a separate build dir for Libstdc++.  

```bash
cd $LFS/sources/gcc-15.2.0
mkdir build
cd build
../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0
make

make DESTDIR=$LFS install

# Remove the libtool archive files because they are harmful for cross-compilation:
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
```

## Chapter 6

- [Book Source: Chapter 6 Intro](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/chapter06/introduction.html)

This chapter shows how to cross-compile basic utilities using the just built cross-toolchain.

The tools will be built using the cross-toolchain that we have just finished setting up.  
We won't be able to use the utilities that we build here yet. They will be
usable once entering the `chroot` environment in chatper 7.  

Again, this all must be done as the `lfs` user.  

### M4-1.4.21

- [Book Source: Chapter 6.1](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/chapter06/m4.html)

M4 is most commonly used as a preprocessor for other programming languages and 
tools. It's a critical component in the GNU build system, particularly for 
Autoconf.  

```bash
cd $LFS/sources
tar -xJvf m4-1.4.21.tar.xz
cd m4-1.4.21
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
```

### Ncurses-6.6

- [Book Source: Chapter 6.2](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/chapter06/ncurses.html)

The ncurses package contains libraries for terminal-independent handling of 
character screens.
Basically, it handles the terminal display.  

Unpack the ncurses tarball.
```bash
cd $LFS/sources
tar -xzvf ncurses-6.6.tar.gz
cd ncurses-6.6
```

First, build the `tic` program on the build host.  
We install it in `$LFS/tools`, so that it is found in the `PATH` when needed:  
```bash
mkdir build
pushd build
../configure --prefix=$LFS/tools AWK=gawk
  make -C include
  make -C progs tic
  install progs/tic $LFS/tools/bin
popd
```

Then we can start setting up Ncurses for compilation:
```bash
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk

make
make DESTDIR="$LFS" install
# The libncurses.so liberary is needed for some builds coming up
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $LFS/usr/include/curses.h
```

The reason for the `sed` can be found on the book page.  

### Bash-5.3

- [Book Source: Chapter 6.4](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/chapter06/bash.html)

Finally compiling Bash. The lord's language.  

Prep Bash for compilation:
```bash
cd $LFS/sources
tar -xzvf bash-5.3.tar.gz
cd bash-5.3

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make 
make DESTDIR=$LFS install
# Make a link for the programs that use sh for a shell
ln -sv bash $LFS/bin/sh
```


### Coreutils

- [Book Source: Chapter 6.5](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/chapter06/coreutils.html)

Unarchive it:
```bash
cd $LFS/sources
tar -xJvf coreutils-9.10.tar.xz
cd coreutils-9.10
```

Configure and install:
```bash
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
make
make DESTDIR=$LFS install
```

---

Move programs to their final expected locations, because some programs hardcode executable locations.  
```bash
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8
```

### Diffutils-3.12

The Diffutils package contains programs that show the differences between files or directories.

```bash
cd $LFS/sources
tar -xJvf diffutils-3.12.tar.xz
cd diffutils-3.12
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$LFS install
```

### File-5.46

The File package contains a utility for determining the type of a given file or files.

The file command on the build host needs to be the same version as the one we 
are building in order to create the signature file.  

```bash
cd $LFS/sources
tar -xzvf file-5.46.tar.gz
cd file-5.46
```

Make a temporary copy of the file command:
```bash
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd
```

Prep File for compilation/installation:
```bash
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install

#Remove the libtool archive file because it is harmful for cross compilation:
rm -v $LFS/usr/lib/libmagic.la
```


### Findutils-4.10.0
Findutils provides the `find` command and also supplies the `xargs` program.  

```bash
tar -xJvf findutils-4.10.0.tar.xz
cd findutils-4.10.0

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

time make
time make DESTDIR="$LFS" install
```

### Gawk-5.3.2

GNU AWK.  

Extract and cd:
```bash
tar -xJvf gawk-5.3.2.tar.xz
cd gawk-5.3.2
```

First, ensure some unneeded files are not installed:
```bash
sed -i 's/extras//' Makefile.in
```

Prep for compilation:
```bash
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
time make
time make DESTDIR=$LFS install
```

### Grep-3.12

```bash
tar -xJvf grep-3.12.tar.xz
cd grep-3.12

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

time make
time make DESTDIR=$LFS install
```

### Gzip-1.14

```bash
tar -xJvf gzip-1.14.tar.xz
cd gzip-1.14

./configure --prefix=/usr --host=$LFS_TGT

time make
time make DESTDIR=$LFS install
```

### Make-4.4.1

```bash
tar -xzvf make-4.4.1.tar.gz
cd make-4.4.1

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

time make
time make DESTDIR=$LFS install
```

### Patch-2.8

- [Book Source: Chapter 6.11](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/patch.html)

Patch provides the `diff` utility.  
```bash
tar -xJvf patch-2.8.tar.xz
cd patch-2.8

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

time make
time make DESTDIR=$LFS install
```

### Sed-4.9

```bash
tar -xJvf sed-4.9.tar.xz
cd sed-4.9

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
time make
time make DESTDIR=$LFS install
```

### Tar-1.35

Prepare Tar for compilation:
```bash
tar -xJvf tar-1.35.tar.xz
cd tar-1.35

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
```

Compile the package:
```bash
time make
```
Install the package:
```bash
make DESTDIR=$LFS install
```

### Xz-5.8.2
The Xz package contains programs for compressing and decompressing files.
It provides capabilities for the lzma and the newer xz compression formats. 

Compressing text files with xz yields a better compression percentage than with 
the traditional `gzip` or `bzip2` commands.

```bash
tar -xJvf xz-5.8.2.tar.xz
cd xz-5.8.2

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.2

time make
time make DESTDIR=$LFS install

# Remove the libtool archive file because it is harmful for cross compilation:
rm -v $LFS/usr/lib/liblzma.la
```

### Binutils-2.46.0 - **Pass 2**

The Binutils package contains a linker, an assembler, and other tools for handling object files.

- [Book Source: Chapter 6.17](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/binutils-pass2.html)
  
Binutils building system relies on an shipped `libtool` copy to link against 
internal static libraries, but the `libiberty` and `zlib` copies shipped in the 
package do not use `libtool`

This inconsistency may cause produced binaries mistakenly linked against 
libraries from the host distro. Work around this issue by changing `ltmain.sh`

```bash
cd $LFS/sources/binutils-2.46.0
rm -rf ./build

sed '6031s/$add_dir//' -i ltmain.sh

#Create a separate build directory again:

mkdir -v build
cd       build

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu

time make
time make DESTDIR=$LFS install

```

Remove the libtool archive files because they are harmful for cross compilation, 
and remove unnecessary static libraries:
```bash
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
```


### GCC-15.2.0 - **Pass 2**

As in the first build of GCC, the GMP, MPFR, and MPC packages are required. 
Unpack the tarballs and move them into the required directories:
```bash
cd $LFS/sources/gcc-15.2.0
tar -xJvf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xJvf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xzvf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

# If building on x86_64, change default directory name for 64-bit libraries to "lib":

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
  ;;
esac

# Override the build rules of the libgcc and libstdc++ headers to allow building 
# these libraries with POSIX threads support:

sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

rm -rf ./build
mkdir -v build
cd       build

../configure                   \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --target=$LFS_TGT          \
    --prefix=/usr              \
    --with-build-sysroot=$LFS  \
    --enable-default-pie       \
    --enable-default-ssp       \
    --disable-nls              \
    --disable-multilib         \
    --disable-libatomic        \
    --disable-libgomp          \
    --disable-libquadmath      \
    --disable-libsanitizer     \
    --disable-libssp           \
    --disable-libvtv           \
    --enable-languages=c,c++   \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc

time make
time make DESTDIR=$LFS install

# Many programs and scripts run cc instead of gcc
ln -sv gcc $LFS/usr/bin/cc
```

## Chapter 7

### Entering Chroot and Building Additional Temporary Tools

- [Book Source: Chapter 7](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter07/chapter07.html)

> Now that all circular dependencies have been resolved, a “chroot” environment, 
> completely isolated from the host operating system (except for the running 
> kernel), can be used for the build.
>
> For proper operation of the isolated environment, some communication with the 
> running kernel must be established. This is done via the so-called Virtual 
> Kernel File Systems, which will be mounted before entering the chroot 
> environment. You may want to verify that they are mounted by issuing the 
> findmnt command.

!!! warning "Run as root!"

    Until Section 7.4, "Entering the Chroot Environment", the commands must be run 
    as `root`, with the `LFS` variable set. After entering chroot, all commands are 
    run as `root`.  


### Changing Ownership

- [Book Source: Chapter 7.1](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter07/changingowner.html)

Currently, the whole directory hierarchy in `$LFS` is owned by the user `lfs`.
This user only exists on the host system.  

If kept as they are, all files will be owned by a UID that doesn't exist in the 
chroot environment. That'll cause problems.  

Ownership of all files must be changed to `root` before entering the chroot 
environment.  
```bash
chown --from lfs -R root:root $LFS/{usr,var,etc,tools}
```
If in an `x86_64` system, also change ownership of the `lib64` directory:
```bash
case $(uname -m) in
    x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
esac
```

### Preparing Kernel Virtual File Systems

- [Book Source: 7.3](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter07/kernfs.html)


> Applications running in userspace utilize various file systems created by the kernel to communicate with the kernel itself. These file systems are virtual: no disk space is used for them. The content of these file systems resides in memory. These file systems must be mounted in the $LFS directory tree so the applications can find them in the chroot environment.

Begin by creating the directories on which these virtual file systems will be mounted:
```bash
mkdir -pv $LFS/{dev,proc,sys,run}
```

---

Some host kernels lack devtmpfs support (a kernel-mounted virtual fs); these 
host distros use different methods to create the content of /dev. So the only 
host-agnostic way to populate the $LFS/dev directory is by bind mounting the 
host system's /dev directory

```bash
mount -v --bind /dev $LFS/dev
```


Now mount the remaining virtual kernel file systems:

```bash
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
```


- `gid=5`: This ensures that all devpts-created device nodes are owned by group 
  ID 5. 
    - This is the ID we will use later on for the tty group. We use the group ID 
      instead of a name, since the host system might use a different ID for its tty 
      group.


In some host systems, `/dev/shm` is a symbolic link to a directory, typically `/run/shm`.
In other host systems `/dev/shm` is a mount point for a tmpfs.
```bash
if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi
```
On the Ubuntu host, it is not a symlink, so we mount a tmpfs on it.


### Entering the Chroot Environment
All the packages which are required to build the rest of the needed tools are 
on the system.  
It is time to enter the chroot environment and finish installing 
the temporary tools.  

This environment will also be used to install the final system.

As root user, run the following command to enter the environment that is, at 
the moment, populated with nothing but temporary tools:
```bash
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login
```

- `-i`: Wipes all env vars.
    - Only the HOME, TERM, PS1, and PATH variables are set

- `/tools/bin` is not in the PATH. This means that the cross toolchain will no 
  longer be used.

- The bash prompt will say "I have no name!", this is normal because the
  `/etc/passwd` file has not been created yet.


### Creating Directories

Create the full directory structure in the LFS file system.  

```bash
# root level directories
mkdir -pv /{boot,home,mnt,opt,srv}

# the required set of subdirectories below the root-level
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/lib/locale
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
```

> This directory tree is based on the Filesystem Hierarchy Standard (FHS). 
> The FHS does not mandate the existence of the directory `/usr/lib64`.  

### 7.6. - Creating Essential Files and Symlinks

- [Book Source: 7.6](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter07/createfiles.html)

Historically, Linux maintained a list of the mounted file systems in the file `/etc/mtab`.
Modern kernels maintain this list internally and expose it to the user via 
the `/proc` filesystem.

Create a symlink for compatibility reasons.  
```bash
ln -sv /proc/self/mounts /etc/mtab
```

Create a basic `/etc/hosts` file, required for some test suites.  
```bash
cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF
```

Add entries in `/etc/passwd` and `/etc/group` to allow the `root` user to
login.  
Also add the system users/groups required.  

- `/etc/passwd`:
  ```bash
  cat > /etc/passwd << "EOF"
  root:x:0:0:root:/root:/bin/bash
  bin:x:1:1:bin:/dev/null:/usr/bin/false
  daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
  messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
  systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false
  systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false
  systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false
  systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false
  systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false
  systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false
  systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false
  uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
  systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false
  nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
  EOF
  ```

The `root` password will be set later.  

- `/etc/group`
  ```bash
  cat > /etc/group << "EOF"
  root:x:0:
  bin:x:1:daemon
  sys:x:2:
  kmem:x:3:
  tape:x:4:
  tty:x:5:
  daemon:x:6:
  floppy:x:7:
  disk:x:8:
  lp:x:9:
  dialout:x:10:
  audio:x:11:
  video:x:12:
  utmp:x:13:
  clock:x:14:
  cdrom:x:15:
  adm:x:16:
  messagebus:x:18:
  systemd-journal:x:23:
  input:x:24:
  mail:x:34:
  kvm:x:61:
  systemd-journal-gateway:x:73:
  systemd-journal-remote:x:74:
  systemd-journal-upload:x:75:
  systemd-network:x:76:
  systemd-resolve:x:77:
  systemd-timesync:x:78:
  systemd-coredump:x:79:
  uuidd:x:80:
  systemd-oom:x:81:
  wheel:x:97:
  users:x:999:
  nogroup:x:65534:
  EOF
  ```

The ID 65534 is used by the kernel for NFS and separate user namespaces for 
unmapped users and groups (those exist on the NFS server or the parent user 
namespace, but "do not exist" on the local machine or in the separate namespace).

We assign nobody and nogroup to avoid an unnamed ID. But other distros may 
treat this ID differently, so any portable program should not depend on this 
assignment.

Some tests in Chapter 8 need a regular user
```bash
echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester
```

To remove the "I have no name!" prompt, start a new login shell.  
```bash
exec /usr/bin/bash -l
```



## Resources

- Basic Resources: <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter01/resources.html>
- FAQs: <https://www.linuxfromscratch.org/faq/>
- <https://systemd-by-example.com/>


