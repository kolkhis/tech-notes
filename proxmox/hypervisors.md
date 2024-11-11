# Hypervisors


## Types of Hypervisors
Type 1 hypervisors are used directly on the hardware instead of installing an OS.  
Some type 1 hypervisors:
* Proxmox
* XC-PNG
* etc. 


Type 2 hypervisors are installed on top of an OS. They're usually used to run virtual
machines.
Some type 2 hypervisors:
* VMware ESXi
* VirtualBox
* KVM
* Hyper-V
* QEMU
* etc.


Containerization is similar to a type 2 hypervisor, but it's very lightweight.  
It's *just* the packages and libraries that are needed to run the application.  
That is a fix to the problem of having to install a whole VM with an OS on a machine
to run an application.  


Virtualization is still the practice of jailing, as is containerization. 

Hardware-assisted Virtualization (HAV) is turned on in motherboard UEFI/BIOS to
enable virtualization. It allows virtual machines access to the host's hardware.  


## Virtual Connectors

* Virtual NIC (vNIC): A logically defined network interface that can be connected to virtual machines
    * These interfaces are used in the guest VM that connects to the vSwitch.
    * These are needed because virtual machines don't have physical Network Interface Cards (NICs).  

* Virtual Switch (vSwitch) is in the host's hypervisor that connects the vNICs to a
network

The vNIC and vSwitch are the two components that connect a VM to the network.  

* vCPU: Logical thread of processing power allotted to a VM.  
* vRAM: Logical allocation of RAM to a VM.  



### 



Typically, you'll probably want 2 gigs of RAM for every 1 processor.  


### Overcommitment
Even inside VMs, we have unused resources. Overcommitment is the idea that we can
allocate more than we actually have.  Some people don't do more than a 3:1 ratio.  



