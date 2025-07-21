# QEMU Guest Agent

The QEMU guest agent is a daemon that allows the hypervisor host (e.g., Proxmox/PVE)
to perform tasks inside the guest hosts (VMs).  

The QEMU guest agent needs to be installed inside the VMs themselves.  

## Setting Up the Agent

### Install/Enable on Guest Host
To enable the QEMU guest agent inside a VM on Proxmox, first install the
`qemu-guest-agent` package in the VM.  
```bash
# on Debian-based distros
sudo apt-get update
sudo apt-get install -y qemu-guest-agent
# on RedHat-based distros
sudo dnf install -y qemu-guest-agent
```

Once the package is installed, enable the `qemu-guest-agent` daemon.  
```bash
sudo systemctl enable --now qemu-guest-agent
```

### Enable on Proxmox

Once the software is installed on the VMs, the guest hosts need to be configured
within Proxmox to use the QEMU guest agent.  

This can either be done through the Proxmox web UI (e.g., `http://pve-ip:8006`), or
it can be done using the `qm` tool on the Proxmox host.  






