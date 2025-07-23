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

This can be done through the Proxmox web UI (e.g., `http://pve-ip:8006`), or
it can be done using the `qm` tool on the Proxmox host, or it can be enabled in the
config files for the VMs themselves (under `/etc/pve/qemu-server/`).  

---

#### Enable Using the Web UI
- To enable it through the web UI, naviagate to a VM, go to "Options", and then double
  click on the "QEMU Guest Agent" value field. Check the "Use QEMU Guest Agent" box,
  then save.  

#### Enable Using `qm`
To enable it using the `qm` tool, you'll need to know the ID of the VM. Then you'll
configure the settings for that VM with the `--agent` argument.  
```bash
qm set 100 --agent enabled=1
```

- `qm set`: Specify that we're setting a value.  
- `100`: The VMID of the virtual machine we're enabling the agent on.  
- `--agent`: Tell `qm` that we're setting the `agent` property.  
- `enabled=1`: Enable the qemu guest agent.  

If you want an automatic `guest-fs-freeze` when taking snapshots, also set the
`fstrim_cloned_disks` setting.  
```bash
qm set 100 --agent enabled=1,fstrim_cloned_disks=1
```

This setting automatically discards unused blocks on a disk when a VM is
cloned/snapshotted (via `fstrim`).  

This is great for storage optimization. Reclaims storage on thin-provisioned disks.

---

Once that's done, you can confirm the setting by checking the config file in
`/etc/pve/qemu-server/100.conf` (replace the number with the VMID).  
There should now be a line that reads:
```plaintext
agent: enabled=1
```

#### Enable in VM Config File

The configuration files that store the VM settings live in your `/etc/pve/qemu-server` 
directory.  

Each VM has its own config file here.  

An entry can be added to these files to enable the QEMU guest agent.  
```bash
printf "agent: enabled=1\n" >> /etc/pve/qemu-server/100.conf
# or, check if it's there before adding:
grep -qi '^agent:' /etc/pve/qemu-server/100.conf || printf "agent: enabled=1\n" >> /etc/pve/qemu-server/100.conf
```


---

### Verify the Agent is Running

You can verify that the guest agent is both running and communicating with the guest
hosts by running a command against the guest host.  
```bash
qm guest cmd 100 get-osinfo
```


### Enable with a Script
To script the process of enabling the QEMU guest agent in your VMs, the `qemu-guest-
agent` package must be installed on each guest host first. This can be done with a 
simple Ansible playbook.  

E.g., `install_qemu.yml`:
```yaml
---
- name: Install the qemu-guest-agent package
  hosts: all
  become: true
  tasks:
    - name: Install the qemu-guest-agent package using the package manager
      ansible.builtin.package:
        name: qemu-guest-agent
        state: present
```

Then run `ansible-playbook -i <your_inventory> ./install_qemu.yml`, then you should
be good. Of course, this requires you to have an inventory set up.  

---

Then, you'll need to get the list of VMIDs.  

This can be done a few different ways, but the "correct" way to do it is by 
using `qm list`.  
```bash
sudo qm list
```
This will output the VMs' IDs, names, states, resource allocations, and their PIDs.  
We just need the VMID from this output (first column).  

We can use `awk` to extract it:
```bash
sudo qm list | awk '{print $1}'
```
But this will also output the `VMID` header. We *could* use a `FNR > 1` condition.  
```bash
sudo qm list | awk 'FNR>1 {print $1}'
```

Or we could use Perl.  

```bash
sudo qm list | perl -ne 'print "$1\n" if m/^\s*(\d{1,})\s/'
```

---

Now we loop over the VMIDs and enable the agent in the settings using `qm set`.  
```bash
while IFS= read -r vmid; do
    printf "Enabling qemu-guest-agent for VMID: %s\n" "$vmid";
    sudo qm set "$vmid" --agent enabled=1
done < <(sudo qm list | perl -ne 'print "$1\n" if m/^\s*(\d{1,})\s/') 
```

## Getting VM IP Addresses

With the QEMU Guest Agent installed and enabled on all the VMs, we can leverage the
`qm` tool to get the IP addresses of all the VMs in the environment.  

The information we extract with `qm` usually comes in JSON format.  
In order to parse this effectively, we can use [the `jq` tool](../linux/tools/jq.md).  

Jump to [IP tl;dr](#ip-tldr) for just the commands you need.  

---

The command we want to use to extract the IPs from our VMs is
`network-get-interfaces`.  
```bash
qm guest cmd 100 network-get-interfaces
```
We'll see some json output. Pipe it through `jq` to make it pretty.  
```bash
qm guest cmd 100 network-get-interfaces | jq
```

This outputs information about the network interfaces on the VM, similar to the info 
we'd get with `ip a`.    

But, we just want to extract the IP addresses from this.  

Let's narrow down the output with a `jq` query.  
```bash
qm guest cmd 100 network-get-interfaces | jq '.[]."ip-addresses"[]."ip-address"'
```
This prints out our IP addresses. But it also includes the localhost (`127.0.0.1`) 
and IPv6 addresses.  

We can trim the IPv6 by just grabbing the first element from the `"ip-addresses"`
list, since the first element holds the IPv4 address we want.  

```bash
qm guest cmd 101 network-get-interfaces | jq '.[]."ip-addresses"[0]."ip-address"'
```

This is still outputting the localhost IPv4 address `127.0.0.1`.  
If we know that it's the second network interface in the list that is connected to
the local area network, we can just pull the second element in the list (the second
network interface).  

```bash
qm guest cmd 101 network-get-interfaces | jq '.[1]."ip-addresses"[0]."ip-address"'
```


---

### Using `grep` Instead of `jq`

If you don't want to rely on `jq`, you can use `grep` with a regular expression.  
Here I'll use Perl regex (PCRE) with `grep -P`.  
```bash
qm guest cmd 101 network-get-interfaces | grep -o -P '^\s*"ip-address"\s*:\s*"\K[0-9.]+'
```

- The `\K` there discards everything to the left of it in the output.  
    - In Perl, it would simply not include the pattern to the left of it in the `$&`
      variable, which holds the entire string matched by the regex.  

### IP tl;dr
Extract the IP of a host with `jq`:  
```bash
qm guest cmd 101 network-get-interfaces | jq '.[1]."ip-addresses"[0]."ip-address"'
```

Extract the IP of a host with `grep`:  
```bash
qm guest cmd 101 network-get-interfaces | grep -o -P '^\s*"ip-address"\s*:\s*"\K[0-9.]+'
```



## Troubleshooting

If you get an error while trying to enable the `qemu-guest-agent` service, you may
need to restart the VM before it can be used.  

Try restarting the VM from the PVE host:  
```bash
sudo qm shutdown 100
sudo qm start 100
```




## Resources

* <https://pve.proxmox.com/wiki/Qemu-guest-agent>
