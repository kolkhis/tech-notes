# Secure Boot - Getting to Know Your Frenemy
## Presented by Michael L. Young -- Principal Systems Engineer (CIQ)
Mintains DisplayLink driver RPM packages. contributor to open source (Asterisk,
Rocky Linux, Warewulf).  

---

Secure boot was introduced with the UEFI specification in 2006.  
It's typically turned off on most Linux systems by default.  

It's becoming more and more common for environments to require secure boot to
be enabled.  

Secure boot tends to limit the kernel modules that can be enabled by the
administrator. 


## Intro

Why is secure boot the frenemy?  

Many people turn it off because it's a pain in the ass. It's becoming a
requirement in many environments.  

Cloud is even starting to support SB as well.  

SB was not available with first release of Rocky Linux.  
Some people needed secure boot (community) so they put into getting it into the
system.  

---

Ciq help support Rocky Linux. What they provide requires to rebuild kernel or
provider driver.That could cause Secure Boot to break.  

Some people are just required to work with it.  

---

## What is Secure Boot?

In the 1970s we had BIOS:
- Bootloader stored in MBR
- Unable to validate trustworthiness

As coputers advanced, BIOS starting having limitations.  

Early 2000s, uefi (Unified Extnsible Firmware Interface) was introduced. they
added Secure Boot in 2006. Its goal was to try to prevent untrusted code from
loading at runtime.  
Uses digital signatures to validate auth, integ, etc of the code being loaded.

- **prevent malicious code from running at runtime**



## How Secure Boot Works

Every server/machine has the firmware loaded in the system already. 
- Platform Key (PK)
- Key enrollment key (KEK)
- Dtabases (DB, DBX)
    - DB: Good
    - DBX: Do not allow to run (certs, firmware)

This is done before even getting to the bootloader.  

Calculates and compares bootchain artifacts. 

Simple terms:
1. OEM Key (PK key)
2. Microsoft KEy (KEK)
3. Keys allowed (DB), Keys not allowed (DBX)

Microsoft required their key enabled and secure boot enabled.  
People were not happy. 

It was clarified afterwards that systems that were certified needed to have a
custom key or MS.  


## How Secure Boot Works with Linux

Same setup.

Every server/machine has the firmware loaded in the system already. 
- Platform Key (PK)
- Key enrollment key (KEK)
- Dtabases (DB, DBX)
    - DB: Good
    - DBX: Do not allow to run (certs, firmware)

We're not gona have a bootloader signed by MS tho. So it won't pass that chain
of trust.

So what we have is a `SHIM` -- a binary, small pece of code. That SHIM gets
signed by microsoft.  
Inside that SHIM, there's a cert of authoirty. Anything that's been signed by
the CA in the SHIM (e.g., the bootloader), it's able to run.  [:w
o
- GRUB Bootloader
- Firmware 

Signed by rocky's CA. 

Needs SHIM to be able to keep secure boot enabled.  




## What is a SHIM, and when does a vendor need one?

On an individual basis, you can prob do a self signed cert.  
You can load your own self-signed key (custom mode).  

Tryna convince a customer to do that across their fleet, doesn't work
When you need to distribute, you need to have a SHIM so you can keep SB on.  

---

## How do you get a SHIM signed by MS???

-  Microsoft Hardware Program (MHP) -- must sign up first
    - Add EV code signing cert.  
- SHIM review
    - <https://github.com/rhboot/SHIM-review>
    - This committee can approve SHIMs.  
    - They ask a lot of questions about key storage and key signing.  
    - This process can take months (it's just volunteers, but you need someone
      to do the final signoff).  
    pain points:
    - It's deendent on MS
    - Hard review process

- Once SHIM is aporved by the committee, submit to MS for signing
    - Cab file that contains the unsigned SHIM
- Get back a signed SHIM

### out of tree modules (drivers)

- if not signed by trusted CA in DB of keys, it will not be loaded.

- If you have secure boot on, it may not load
    - then create your own signing me
    - MO (Machine Owner) key
        - Lives in NVRAM
    - Or get your vendor to provide drivers that have been signed.
    - Enroll using MOK Manager
    - Use this key for signing your kernel drivers
- Gotchas:
    - If you update your kernel/drivers and don't re-sign it, you won't load
      again.
    - You **must** manually resign module after kernel of driver updates

- DKMS - Creates a self signing key (still need to enroll though)
    - can use the same signing key you created yourself and has been enrolled
      (MOK)

## Demo Notes

Can do testing on VMs with secure boot  

Cockpit for VMs

When setting up the VM, don't start it right away.  
Go into settings before starting. Switch from BIOS to UEFI.  

- Works on KVM as well (QEMU)

On mac, using UTM, create new machine.
- Create new VM
- Select ISO
- Check "Open VM Settings" box
- Turn on TPM 2.0 
    - they're not dependent on each other but work together well. Required to
      turn on module with UTM on mac.  

Play around:

Show secure boot state:

```bash
mokutil --sb-state
```

View keys

```bash
mokutil --kek
mokutil --db
mokutil --list-enroll # See who signed
```


## Trends

- Req in the enterprise to keep SB enabled
    - doesn't pass compliance with security
- Customers in highly regulated industries req SB to be enabled
- Cloud compute instances are adding support for Secure Boot
- Confidential Computing
    - Something that's actively being worked on and supported.
    - Very new.  
    - Hardware based TEE (Trusted Execution Environment).  
    - Uses a unified kernel image.  
    
## Takeaways

- Frenemy? Yes.......... Some need to use it, understand, and support it.
 better way? prob

- What is it? Dunno yet. 
    - Needs to simplify management and not allow **one
      entity** to control it all.  


## How does secure boo ffect building out of tree kernel modules?
## How to add kernel modules while keeping secure boot enabled








