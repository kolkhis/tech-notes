# Cloud-Init with Terraform on Proxmox
This is a sample guide for using the `cloud-init` command with Terraform to deploy new VMs.  


## Table of Contents
* [1. Install `cloud-init` (If Not Already Installed)](#1-install-cloud-init-if-not-already-installed) 
* [2. Create a Cloud-Init Image Using the `cloud-localds` Command](#2-create-a-cloud-init-image-using-the-cloud-localds-command) 
    * [Create a `meta-data` file](#create-a-meta-data-file) 
    * [Create a `user-data` file](#create-a-user-data-file) 
    * [Generate a Cloud-Init Image](#generate-a-cloud-init-image) 
* [3. Convert a Base VM into a Cloud-Init Template](#3-convert-a-base-vm-into-a-cloud-init-template) 
    * [Install Dependencies on the Base VM](#install-dependencies-on-the-base-vm) 
    * [Clean Up the Base VM for Cloning](#clean-up-the-base-vm-for-cloning) 
* [4. Convert the VM into a Proxmox Cloud-Init Template](#4-convert-the-vm-into-a-proxmox-cloud-init-template) 
    * [Convert the VM to a Template](#convert-the-vm-to-a-template) 
* [5. Use Terraform to Deploy the Cloud-Init Image](#5-use-terraform-to-deploy-the-cloud-init-image) 
    * [Terraform Configuration](#terraform-configuration) 
* [6. Deploy the Terraform Configuration](#6-deploy-the-terraform-configuration) 
* [7. Verify the Cloud-Init VM](#7-verify-the-cloud-init-vm) 
* [Conclusion](#conclusion) 

---

## 1. Install `cloud-init` (If Not Already Installed)
Ensure `cloud-init` is installed on your base VM before creating an image.

```bash
sudo dnf install cloud-init  # For Rocky Linux
sudo apt install cloud-init  # For Ubuntu/Debian
```

Verify installation:
```bash
cloud-init --version
```

---

## 2. Create a Cloud-Init Image Using the `cloud-localds` Command
Use `cloud-localds` to create a cloud-init disk with a user-defined configuration.

### Create a `meta-data` file
This file provides instance-specific information, such as instance ID.

```bash
cat <<EOF > meta-data
instance-id: cloud-vm-001
local-hostname: my-cloud-init-vm
EOF
```

### Create a `user-data` file
This file contains initial setup, such as users, passwords, SSH keys, and packages.

```bash
cat <<EOF > user-data
#cloud-config
users:
  - name: kolkhis
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3...your-public-ssh-key...
package_update: true
packages:
  - qemu-guest-agent
  - htop
runcmd:
  - echo "Cloud-init configured successfully!" > /etc/motd
EOF
```

### Generate a Cloud-Init Image
Create a `cloud-init` seed image:
```bash
cloud-localds cloud-init.img user-data meta-data
```

This creates a `cloud-init.img` file, which can be used to initialize VMs.

---

## 3. Convert a Base VM into a Cloud-Init Template
Now, take a clean base VM, install necessary dependencies, and configure it for cloud-init.


### Install Dependencies on the Base VM
```bash
sudo dnf install cloud-init cloud-utils-growpart qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

###  Clean Up the Base VM for Cloning
Before turning this VM into a template, clean up persistent machine-specific settings:

```bash
sudo cloud-init clean
sudo rm -rf /etc/machine-id
sudo touch /etc/machine-id
```

Shut down the VM:
```bash
sudo poweroff
```

---

## 4. Convert the VM into a Proxmox Cloud-Init Template
If you're using Proxmox, create a template for future Terraform use.

###  Convert the VM to a Template
1. Locate the VM ID:
   ```bash
   qm list
   ```

2. Convert it to a Template:
   ```bash
   qm template <VM_ID>
   ```

3. Create a Cloud-Init Disk:
   ```bash
   qm set <VM_ID> --ide2 local-lvm:cloud-init
   ```

4. Configure Boot Options for Cloud-Init:
   ```bash
   qm set <VM_ID> --boot c --bootdisk scsi0
   ```

5. Resize the Disk (If Needed):
   ```bash
   qm resize <VM_ID> scsi0 +10G
   ```

---

## 5. Use Terraform to Deploy the Cloud-Init Image
After setting up the cloud-init template, you can use Terraform to deploy VM instances.

### Terraform Configuration
```hcl
provider "proxmox" {
  pm_api_url      = "https://192.168.1.10:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = "password"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "cloud_vm" {
  name        = "cloud-vm-1"
  target_node = "proxmox-node"
  clone       = "cloud-init-template"

  disks {
    scsi {
      disk {
        size    = "10G"
        storage = "local-lvm"
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  os_type = "cloud-init"
  ciuser  = "kolkhis"
  cipassword = "your-password"
  sshkeys = <<EOT
ssh-rsa AAAAB3...your-public-ssh-key...
EOT
}
```

---

## 6. Deploy the Terraform Configuration
Run the following Terraform commands to deploy your VM.

```bash
terraform init
terraform apply -auto-approve
```

---

## 7. Verify the Cloud-Init VM
Once Terraform has created the VM, verify that cloud-init applied the settings.

```bash
ssh kolkhis@<VM_IP>
```
Check logs:
```bash
sudo cloud-init status
sudo cloud-init analyze
```


## tl;dr
* `cloud-init` automates VM initialization for Terraform in Proxmox.
* Using `cloud-localds`, you preconfigure VM settings (users, SSH keys, packages).
* Converting a base VM to a Proxmox Cloud-Init template allows dynamic deployment via Terraform.

