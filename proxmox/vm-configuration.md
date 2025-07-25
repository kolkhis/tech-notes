# PVE VM Configuration

Proxmox VMs each have their own configuration files.  

These config files are stored in the `/etc/pve/qemu-server/` directory on the Proxmox VE
host itself.  


## The Config Files

Each configuration file starts with the **current** settings for the VM.  

For example, `/etc/pve/qemu-server/100.conf`:
```conf
agent: enabled=1,fstrim_cloned_disks=1
boot: order=scsi0;ide2;net0
cores: 2
cpu: x86-64-v2-AES
ide2: local:iso/ubuntu-22.04.3-live-server-amd64.iso,media=cdrom,size=2083390K
memory: 6144
meta: creation-qemu=8.1.5,ctime=1732920261
name: desmond
net0: virtio=BC:23:10:23:6A:B4,bridge=vmbr0,firewall=1
numa: 0
ostype: l26
parent: pre-prometheus-with-grafana
scsi0: vmdata:vm-100-disk-0,iothread=1,size=80G
scsihw: virtio-scsi-single
smbios1: uuid=2c2407d3-f523-43a8-9da5-f4e4ffe961dd
sockets: 1
tags: vms;dev
vmgenid: e0d8d21b-4ac5-42f7-9db6-52c3a0af15b0
```

These are the **current active settings** for the VM.  


If you've made snapshots of the VM, it will contain INI-style sections containing the
VM's settings at the time the snapshot was taken.  

For example, if I made a snapshot called `pre-deployment`:
```conf
[pre-deployment]
boot: order=scsi0;ide2;net0
cores: 2
cpu: x86-64-v2-AES
..... etc
```

So, if you need to modify the settings of a snapshot, you can do so within these
files under the appropriate header.  




