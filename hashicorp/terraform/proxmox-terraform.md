# Proxmox and Terraform

These are my notes on using Terraform to provision VMs in Proxmox.

## Hashicorp Language (HCL)

Terraform uses Hashicorp Language (HCL) to define Infrastructure as Code (IaC).  

There are a decent number of other tools that also use HCL:

| Tool      | Main Use of HCL                    
| --------- | -----------------------------------
| Terraform | Infrastructure as code (mainstream)
| Packer    | Machine image build templates      
| Vault     | Secrets access policy management   
| Nomad     | Job and workload scheduling        
| Consul    | Service network configuration      
| Boundary  | Secure remote access configuration 
| OpenTofu  | Terraform-compatible IaC           

So HCL is definitely a good thing to learn, since it's portable across all these
different tools.  


## Terraform Setup

Quick install of Terraform on my main Proxmox node (`home-pve`).  

Recommended installation method from the [Terraform installation guide](https://developer.hashicorp.com/terraform/install):
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

I wrote my own [custom installer script](https://github.com/kolkhis/.dotfiles/blob/main/install/install/install-terraform)
for portability, to work on both Debian-based and RedHat-based systems -- mainly
Debian/Ubuntu Server and distros that are binary-compatible with RHEL (Rocky, Alma).  

## Terraform Authetication on Proxmox

Terraform will need root access to the Proxmox server.  

Assuming the Proxmox server is already set up, We can set up 
authentication for the Terraform user in two ways:

1. Username/password auth:
    - Use the `root` user's username/password.  
2. API key auth:
    - Use a separate username with an API key.  

If we want to use API keys, we can set up a separate Terraform user and give it
permissions to create VMs using the Proxmox API. 

### API Key Auth

To use an API key for authentication with a dedicated user account, we'll need
to create a new user, then generate an API key associated with the new user
account.  

### Create a New User

We're opting for the API authentication method here.  

There are two main ways to create a new user and generate an API key.  

1. Using the Proxmox Web UI
2. Using the command line with `pveum` (Proxmox VE user management tool)

#### Using the Web UI
In order to set up a new user account and gnerate an API token, we can go
through the Proxmox Web UI.  
That will be the IP of your Proxmox server at port 8006 (e.g.,
`http://192.168.1.49:8006`).  

Once there, navigate to the "Datacenter" tab on the left, then find the
"Permissions" dropdown on the left.  

From there, create a user:  

- "Users" tab
    - Add (top left of center panel)
        - Create the user account (e.g., `terraform`)

Once the user is created, go to the "API Tokens" tab and generate a new API key:  

- "API Tokens" tab
    - Add (top left of the center panel)
        - Generate an API key linked to the new user `terraform`  
        
Save that API key in a secure place, as it will be used in the Terraform files.  

#### Using the CLI

I prefer to do things from the CLI, so this is the approach I took.  

We can utilize the `pveum` (Proxmox VE User Management) tool to create a new
user and assign it a new API key.  

1. Create the new user (in the PVE realm, for API key compatibility).  
   ```bash
   pveum user add terraform@pve
   ```
    - We can also verify the realm name before adding if we want:
      ```bash
      pveum realm list
      ```
      We don't use the `pam` realm because we can't create API tokens for the user. 
      PAM is password-based auth only, so it's not ideal for automation and app
      integrations. `pam` can be used with username/password rather than
      username/API key.  

2. Verify that the user account has been created.  
   ```bash
   pveum user list
   ```

3. Set a password for the user.  
   ```bash
   pveuser passwd terraform@pve
   ```
    - This can be done with the `--password` option in `pveum user add`,
      however I don't encourage people to pass passwords as command line
      arguments. Those arguments live in shell history.  

4. Generate an API token (decide on privilege separation or not).  
   ```bash
   pveum user token add terraform@pve TOKEN_ID
   # or
   pveum user token add terraform@pve TOKEN_ID --privsep 0
   ```
   The `<TOKEN_ID>` is going to be a user-specified token identifier.  
   This ID is basically just a name for your API key.  
   I'll name mine `tf-token`.  
   ```bash
   pveum user token add terraform@pve tf-token
   ```
    - This will output a table containing the `full-tokenid`, info, and
      the value (the token itself). The `full-tokenid` follows the pattern
      `user@realm!token-id`, so in my case `terraform@pve!tf-token`.  
    - Privilege separation will require us to configure the ACL by adding a
      role to the token itself. If it's on (default), the token will inherit
      the privileges of the user it belongs to.  

5. Verify the token has been created.  
   ```bash
   pveum user token list terraform@pve
   ```

Once the user account is created and has an API key, we can move forward to
configuring the Terraform Proxmox provider.  

### Configure ACL
In order for the token and user to have permissions, we need to add some roles
via the ACL.  

The easiest way to do this is to grant the `Administrator` role to the user/API
key.  

We can add a role with `pveum acl modify`.  
```bash
sudo pveum acl modify / -user terraform@pve -role Administrator
```

If privilege separation is **enabled** on the API token generated earlier, we must
also add the role to the token.  
```bash
sudo pveum acl modify / -token terraform@pve!tf-token -role Administrator
```

### Configure Terraform Provider

Terraform has this concept of "providers," which are essentially plugins that 
allow Terraform talk to an external system, usually via that system's API.  

Each provider is programmed to interact with specific APIs (e.g., AWS, Proxmox), 
and exposes **Terraform resources** that correspond to that system.  

Providers are downloaded from the [Terraform registry](https://registry.terraform.io/) 
when running `terraform init`.  

??? info "How Terraform providers work"

    When we run `terraform init`, it reads the `.tf` files and detects which
    providers are being used, then downloads and installs them into
    the `.terraform/providers` directory.  

    Then, when we run `terraform plan` or `terraform apply`, it will load each
    provider's plugin binary, passes in the config (via RPC), and the **provider** 
    makes the appropriate calls to the API. The provider will report back what
    changed (or what will change).  

All that to say, Terraform has a [Proxmox
provider](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs).  

So, we'd create a directory for our Terraform project.  
```bash
mkdir pve-tf && cd pve-tf
```
Then we'd make a `main.tf` file to define the provider we want to use.  
```bash
touch main.tf
vi main.tf
```

Inside the `main.tf` file, we'd add:
```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}
```
This specifies the provider we want to use. We also specify a `version`
alongside the `source` to use a specific version of the provider.  

Next, we configure the provider.  
```hcl
provider "proxmox" {
  pm_api_url          = "https://192.168.1.49:8006/api2/json"
  pm_user             = "terraform@pve"
  pm_api_token_id     = "terraform@pve!tf-token"
  pm_api_token_secret = "API_KEY_GOES_HERE"
  pm_tls_insecure = true
}
```
This configures the Proxmox provider (`Telmate/proxmox`), and specifies the 
necessary information for Terraform to interact with the Proxmox API.  

These four things are required:

2. `pm_user`: The Proxmox user we created earlier  
1. `pm_api_url`: The PVE API endpoint  
2. `pm_api_token_id`: The Proxmox user's API key ID (`user@realm!token-name`)
2. `pm_api_token_secret`: The Proxmox user's API key  

!!! note "Setting user and password as environment variables"

    Some of the entries can be left out of the `provider` definition as
    long as these are set as environment variables:
    ```bash
    export PM_USER="terraform@pve"
    export PM_PASS="password" # If using PAM (username/password auth)
    export PM_API_TOKEN_ID="terraform@pve!tf-token"
    export PM_API_TOKEN_SECRET="API_KEY_GOES_HERE"
    export PM_API_URL="http://192.168.1.49:8006/api2/json"
    ```

Once the provider is configured, we'd add the new **resource** that we want to create, also in `main.tf`.  
```hcl
resource "proxmox_vm_qemu" "new_vm" {
  name        = "new_vm"
  target_node = "home-pve"
  clone       = "ubuntu-template"
  storage     = "vmdata"
  cores       = 2
  memory      = 2048
}
```

This specifies a **single VM to create**. In this case, a clone of a
pre-existing VM or template named `ubuntu-template`.  
Any additional VMs would be another `resource` entry, all with their own
configurations.  

Here, we're using a [`proxmox_vm_qemu` resource](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu),
which will create a new VM by either cloning an existing VM/template, or by
creating a new one from an ISO file.  

Using a clone or ISO is less granular than using 
[CloudInit](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud_init).  
CloudInit will allow us to configure the hostname, set up SSH keys, and perform
other system configurations that need to be done before the VM is ready for
general use.  

---

Once we have the `provider` and our `resource` blocks set up in `main.tf`, we 
can go ahead and do `terraform fmt` to format our file, then `terraform init` 
to intialize the provider.  
```bash
terraform fmt
terraform init
```

We can make sure our config is valid with `validate`.
```bash
terraform validate
```

Then, we can do a `plan` to see the changes that will be made (like a dry run).  
```bash
terraform plan
```

Finally, we `apply` to actually do the magic.  
```bash
terraform apply
```

Then we're good to go!  

## Hiding the API Key

So, storing API keys in plain text is usually not great practice.  

We can obfuscate them in Terraform a number of different ways.  

### Using Environment Variables
One very common method of avoiding plaintext secrets is using environment variables.  

#### Using Boilerplate Environment Variables

Terraform will look for these variables when utilizing the `proxmox` provider
without a `pm_user` and `pm_password` set in the provider definition:

- `PM_USER`
- `PM_PASS`
- `PM_API_TOKEN_ID`
- `PM_API_TOKEN_SECRET`

Set these as environment variables in either `.bashrc`, or in a `.env` file and
then run `source .env` to make sure they're in your current shell environment.  

This way, the API key can be set in a separate file without specifying the
username and password in the `main.tf`.  

```bash
export PM_USER='terraform@pve'
export PM_PASS='password-here'
export PM_API_TOKEN_ID='terraform@pve!tf-token'
export PM_API_TOKEN_SECRET="afcd8f45-acc1-4d0f-bb12-a70b0777ec11"
```




#### Using Custom Variables
We can define variables in a `variables.tf` file (or just in `main.tf`).  
We'll make a variable for the API endpoint, the token ID (name), as well as the
API key itself.  
```hcl title="variables.tf"
variable "proxmox_api_url" {
    description = "Proxmox API endpoint"
    type        = string
}

variable "proxmox_api_token_id" {
    description = "Proxmox API token ID"
    type        = string
}

variable "proxmox_api_token_secret" {
    description = "Proxmox API token secret (API key itself)"
    type        = string
    sensitive   = true
}
```

Then, we'd reference these variables inside the `provider` block.  

We access variables by simply using `var.<VAR_NAME>`.  
```hcl
provider "proxmox" {
    pm_api_url          = var.proxmox_api_url
    pm_api_token_id     = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret
    pm_tls_insecure     = true
}
```

Finally, we'd need to set the environment variables.  
Any environment variable that is prepended with `TF_VAR_` is automatically
picked up by Terraform.  

```bash
export TF_VAR_promox_api_url="https://192.168.1.49:8006/api2/json"
export TF_VAR_promox_api_token_id="terraform@pve!tf-token"
export TF_VAR_promox_api_token_secret="SECRET_TOKEN"
```
We can set this in our `.bashrc`, or source it from some other environment file 
(e.g., in a `.env` file).  

Once those are set and sourced, we're all set with setting up the environment
variables for our secrets.  

### Using Vault

Hashicorp Vault is the gold standard for hiding secrets used with Terraform.  

!!! info

    The following assumes a Vault dev server is already set up in the environment.  
    Quick overview:

    - Install via the [Hashicorp Vault Installation Guide](https://developer.hashicorp.com/vault/install)
    - Start a vault server and set the necessary variables  
      ```bash
      vault server -dev & # Start dev server and run in background
      export VAULT_ADDR='http://127.0.0.1:8200'
      export VAULT_TOKEN='<ROOT_TOKEN_HERE>' # root token from
      ```

With the Vault server running, you'd set the secrets:
```bash
vault kv put secret/proxmox/terraform \
    url="https://192.168.1.49:8006/api2/json" \
    token_id="terraform@pve!tf-token" \
    token_secret="TOKEN_SECRET"
```

Then, we'd need to specify the `vault` provider in our `main.tf`.  
```hcl
provider "vault" {
    address = "https://vault.example.com"
    token   = "your-root-or-app-token"
}
```
If we already set the `VAULT_ADDR` and `VAULT_TOKEN` environment variables, we
can omit them in the provider.  
```hcl
provider "vault" {}
```

After specifying the `vault` provider, we can then access the data stored
inside.  

```hcl
data "vault_kv_secret_v2" "pve_data" {
  mount = "secret"
  name  = "proxmox/terraform"
}

provider "proxmox" {
  pm_api_url          = data.vault_kv_secret_v2.pve_data.data["url"]
  pm_api_token_id     = data.vault_kv_secret_v2.pve_data.data["token_id"]
  pm_api_token_secret = data.vault_kv_secret_v2.pve_data.data["token_secret"]
  pm_tls_insecure     = true
}
```

We specify a `data` entry, then we can scope into each of the keys that we set
earlier with `vault kv put`.  

---

So, once it's all set up, the `main.tf` should look something like this:
```hcl
provider "vault" {}

data "vault_kv_secret_v2" "pve_data" {
  mount = "secret"
  name  = "proxmox/terraform"
}

provider "proxmox" {
  pm_api_url          = data.vault_kv_secret_v2.pve_data.data["url"]
  pm_api_token_id     = data.vault_kv_secret_v2.pve_data.data["token_id"]
  pm_api_token_secret = data.vault_kv_secret_v2.pve_data.data["token_secret"]
  pm_tls_insecure     = true
}
```

## Using CloudInit
Using CloudInit images with Proxmox offers extended levels of configuration and 
customization when provisioning VMs with Terraform.  

In order to use Cloud-Init for Terraform, we typically need a VM built with a
cloud image image that comes with Cloud-Init preinstalled. These are available 
for download for most major distributions (e.g., for [Ubuntu Server](https://cloud-images.ubuntu.com/). 

We would:

1. Make a VM with a CloudInit drive (e.g., using `qm`).  
2. Turn it into a Proxmox template (this will be our golden image).  
3. Use Terraform to clone it and do the initial configuration.  

In order to use CloudInit, we need to create a CloudInit drive.  

The CloudInit drive is a special virtual disk, which is created automatically
when we run:
```bash
qm set VMID --ide2 vmdata:cloudinit
```
This can be done using whatever storage you want, as long as you append
`:cloudinit` to the end.  

### Creating a CloudInit Drive

We can create a CloudInit Drive by using the [`qm` command line
tool](https://pve.proxmox.com/pve-docs/qm.1.html).  

We'd start the same way as making a normal VM.  
```bash
qm create 1400 --name 'rocky9-gencloud-template' \
    --memory 2048 \
    --net0 virtio,bridge=vmbr0 \
    --cores 1 \
    --sockets 1 \
    --cpu x86-64-v2-AES \
    --storage vmdata

qm importdisk 1400 /var/lib/vz/template/qcow/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 vmdata:vm-1400-disk-0
qm set 1400 --virtio0 vmdata:vm-1400-disk-0
qm set 1400 --boot c --bootdisk virtio0
qm set 1400 --ide2 vmdata:cloudinit
qm set 1400 --ciuser luser --cipassword luser
qm set 1400 --agent 1
qm template 1400
```

These are the command broken down:

- `qm create`: This creates a new VM called `rocky9-gencloud-template`, and 
  configures the network, memory, and CPU.  

- `qm importdisk`: Imports the downloaded Rocky Linux **cloud image** into the
  storage pool `vmdata`.  
    - Pulls **from**
      `/var/lib/vz/template/qcow/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2`
      and puts it **into** `vmdata:vm-1400-disk-0`.  

- `qm set 1400 ...`: Setting configuration values for the new VM with ID 1400.  

    - `--virtio0 vmdata:vm-1400-disk-0`: Attaches the imported disk as
      the VM's main boot disk using the VirtIO network interface.  

    - `--boot c --bootdisk virtio0`: Sets the boot order from the first
      hard disk (`virtio0`) .  

    - `--ide2 vmdata:cloudinit`: This adds a special **CloudInit drive** to IDE slot 2.  
        - This disk acts as a metadata provider. CloudInit inside the guest reads
          from it during boot.  
        - It's essentially a virtual drive that contains instructions for the VM's
          first boot configuration.  

    - `--ciuser luser --cipassword luser`: This defines the **default
      CloudInit user credentials** for the template (user: `luser`, pass: `luser`).  
        - These values will be used if we don't override them later in Terraform.  

    - `--agent 1`: Enable the QEMU guest agent.  

- `qm template 1400`: Convert the new VM into a template.  

### Cloud-Init Snippets

Once the template is created, we can create **snippets**, which are used to
pass additional configuration to the Cloud-Init package.  

!!! note

    Before wae can create a snippet, we need a place to store it. Best practice
    is to store snippets in the same location as the template.  
    Cloned VMs can't start if the snippet is not accessible.  


Create a snippet directory:
```bash
mkdir /var/lib/vz/snippets
```

Create a snippet (this one will be used to ensure `qemu-guest-agent` is
installed):
```bash
touch /var/lib/vz/snippets/qemu-guest-agent.yml
vi /var/lib/vz/snippets/qemu-guest-agent.yml
```

The file should be formatted as follows:
```yaml
#cloud-config
runcmd:
  - apt-get update
  - apt-get install -y qemu-guest-agent
  - systemctl enable --now qemu-guest-agent
```

The `qemu-guest-agent` package will be installed and the daemon started.  

## Proxmox VM Qemu Resource

This is the resource that will be used to provision VMs on Proxmox.  

There are several blocks that need to be specified on the later versions on
the `Telmate/proxmox` provider.  

- [Top Level Block](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#top-level-block)
- [CPU Block](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#cpu-block)
- [Network Block](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#network-block)
- [Disk Block](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#disk-block)
    - This block in particular has many sub-blocks that can be specified to
      further configure disk devices.  

### Without Using Cloud-Init

An example entry for this type of resource, a basic clone of a Proxmox VM 
template (no cloud-init):  
```hcl
resource "proxmox_vm_qemu" "test-tf-vm" {
  name        = "test-tf-vm"
  agent       = 1
  boot        = "order=scsi0"
  target_node = "home-pve"
  clone       = "ubuntu-22.04-template"
  disk {
    storage = "vmdata"
    size    = "16G"
    type    = "disk"
    slot    = "scsi0"
  }
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }
  cpu {
    cores = 1
  }
  memory = 4096
}
```

### Using Cloud-Init

Some official examples of using the `Telmate/proxmox` provider with Cloud-Init can be
found on [the Telmate/proxmox GitHub](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/examples/cloudinit_example.tf) and 
on the [Terraform registry docs](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/cloud_init_disk).  

Steps taken:
```bash
# Pull down the qcow2 cloud init image into the appropriate directory
# Create directory and switch
mkdir /var/lib/vz/template/qcow && cd /var/lib/vz/template/qcow
# Download the image (can use wget too if you want)
curl -LO https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2

# Create the VM
qm create 9030 \
    --name "rocky-10-cloudinit-template" \
    --memory 2048 \
    --cpu "host" \
    --cores 1 \
    --sockets 1 \
    --storage "vmdata" \
    --net0 virtio,bridge=vmbr0 \
    --machine q35 \
    --bios ovmf 

# Import the Cloud-Init image to the VM's disk 
qm disk import 9030 "rocky-10-cloudinit-template" "vmdata"

# Basic disk configuration
qm set 9030 --scsihw virtio-scsi-pci --scsi0 "vmdata:vm-9030-disk-0"
qm set 9030 --efidisk0 "vmdata:0,format=raw,efitype=4m"
qm set 9030 --ide2 "vmdata:cloudinit"
qm set 9030 --agent enabled=1
qm set 9030 --boot order=scsi0

# Convert to template
qm template 9030
```
Here, we use `host` as the CPU type. Using `x86-64-v2-AES` with Rocky Linux was
causing a kernel panic on boot in my environment.  


Example Terraform config for a VM using Cloud-Init, using the Rocky 10 base image:
```hcl
resource "proxmox_vm_qemu" "cloudinit-test" {
  vmid        = 1400
  name        = "rocky-cloudinit-test-vm"
  clone       = "rocky-10-cloudinit-template" # The name of the template
  target_node = "home-pve"
  vm_state    = "running"
  agent       = 1
  memory      = 2048
  cpu {
    cores     = 1
    sockets   = 1
    type      = "host"
  }

  scsihw = "virtio-scsi-pci"
  bios   = "ovmf"
  efidisk {
    storage = "vmdata"
    efitype = "4m"
  }

  boot        = "order=scsi0" # has to be the same as the OS disk of the template
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=192.168.1.10/24,gw=192.168.1.1,ip6=dhcp"
  skip_ipv6  = true
  ciuser     = "luser"
  cipassword = "luser"
  sshkeys    = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGjGGUL4ld+JmvbDmQFu2XZrxEQio3IN7Yhgcir377t example@example
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAQdazsCyvNGrXGT+zEc6l5X/JILWouFlnPchYsCeFZk example@example
EOF

  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = "local-lvm"
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size    = "10G" 
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide1 {
        cloudinit {
          storage = "vmdata"
        }
      }
    }
  }

  network {
    id = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
}
```

The custom Cloud-Init configurations are as follows:
```hcl
 # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=dhcp"
  #ipconfig0  = "ip=192.168.1.10/24,gw=192.168.1.1,ip6=dhcp"
  skip_ipv6  = true
  ciuser     = "root"
  cipassword = "Enter123!"
  sshkeys    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/Pjg7YXZ8Yau9heCc4YWxFlzhThnI+IhUx2hLJRxYE Cloud-Init@Terraform"
```


We can specify multiple SSH keys to add by using a heredoc:
```hcl
  sshkeys    = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/Pjg7YXZ8Yau9heCc4YWxFlzhThnI+IhUx2hLJRxYE example
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/Pjg7YXZ8Yau9heCc4YWxFlzhThnI+IhUx2hLJRxYE example
EOF
```

The `ciuser` and `cipass` can be pre-configured when creating the template:
```bash
qm set 1400 --ciuser "luser" --cipassword "luser"
```

## Troubleshooting

When running `terraform plan`, if we get some sort of error, we will need to
troubleshoot.  

### Token Privilege Error
For instance, I received this error:
```plaintext
│ Error: user terraform@pve has valid credentials but cannot retrieve user list, check privilege separation of api token
│
│   with provider["registry.terraform.io/telmate/proxmox"],
│   on main.tf line 9, in provider "proxmox":
│    9: provider "proxmox" {
```
This suggests that the API key that I'm using is improperly configured.  

The privilege separation setting was enabled from that token, shown by the
command:
```bash
sudo pveum user token list terraform@pve
```

There seems to be two options for fixing this problem:

1. Recreate the token with privilege separation disabled and give the user
   itself the permissions.  
   ```bash
   sudo pveum user token add terraform@pve TOKEN_ID --privsep 0
   ```

2. Configure ACLs for API tokens with privilege separation enabled.  
   ```bash
   sudo pveum acl modify / -token 'terraform@pve!tf-token' -role Administrator
   # Verify:
   sudo pveum acl list
   ```

I went for option 2.  

The `Administrator` role seems to be required for provisioning VMs. I tried
using the `PVEAdmin` role but that lacked the necessary `Sys.Modify`
permission.  


I had privilege separation enabled for my token, added the `Administrator`
role, 

When using privilege separation, the `Administrator` role needs to be added
to **both the user *and* the token**.  

If the user lacks the necessary privileges, the token privileges will not be enough.  

### VM Can't Boot into OS (Cloud-Init)

I created a template with the following commands:
```bash
qm create 9030 --name "rocky-10-cloudinit-template" \
    --memory 4096 \
    --net0 virtio,bridge=vmbr0 \
    --cores 1 \
    --sockets 1 \
    --cpu "x86-64-v2-AES" \
    --storage vmdata

# Create config file if it doesn't exist
touch "/etc/pve/qemu-server/9030.conf"

qm importdisk 9030 /var/lib/vz/template/qcow/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 vmdata
qm set 9030 --virtio0 "vmdata:vm-9030-disk-0"
qm set 9030 --boot c --bootdisk virtio0
qm set 9030 --ide2 "vmdata:cloudinit"
qm set 9030 --ciuser "luser" --cipassword "luser"
qm set 9030 --agent 1
qm template 9030
```

The resource provisioned in `main.tf` is as follows:
```hcl
resource "proxmox_vm_qemu" "test-tf-vm" {
  name        = "test-rocky10-cloudinit-vm"
  vmid        = 7000
  agent       = 1
  boot        = "order=scsi0"
  target_node = "home-pve"
  clone       = "rocky-10-cloudinit-template"
  # full_clone  = false
  memory = 4096
  cpu {
    cores   = 1
    sockets = 1
    type    = "x86-64-v2-AES"
  }
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "vmdata"
          size    = "10G"
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide0 {
        cloudinit {
          storage = "vmdata"
        }
      }
    }
  }

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  # ipconfig0  = "ip=192.168.4.100/24,gw=192.168.4.1,ip6=dhcp"
  ipconfig0  = "ip=dhcp"
  skip_ipv6  = true
  ciuser     = "luser"
  cipassword = "luser"
  sshkeys    = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGjGGUL4ld+JmvbDmQFu2XZrxEQio3IN7Yhgcir377t Optiplex Homelab key
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAQdazsCyvNGrXGT+zEc6l5X/JILWouFlnPchYsCeFZk kolkhis@home-pve
EOF
}
```
The `terraform apply` runs successfully, and the VM is created.  
The error that I'm running into is that the VM only boots up to BIOS, it does
not boot into the actual operating system.  

It boots into SeaBIOS and displays the text:
```plaintext
SeaBIOS (version rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org)
Machine UUID 70539c11-3f6a-4bd0-9c97-44eb8ef0696c
Booting from Hard Disk...
GRUB loading.......
Welcome to GRUB!

Probing EDD (edd=off to disable)... ok
_
```

---

Doing further research, it appears it's possible that SeaBIOS won't be able to boot a Rocky
image.  

It seems I have two options.  

1. Modify the Template In-Place
   I may be able to fix this by modifying the template's boot format to use UEFI
   instead of BIOS. I'll also have to set an EFI disk partition for the template.    
   ```bash
   qm set 9030 --bios ovmf --machine q35
   qm set 9030 --efidisk0 "vmdata:0,format=raw,efitype=4m"
   qm set 9030 --boot order=virtio0
   ```

2. Full Re-create of Template
   ```bash
   qm create 9030 \
       --name rocky10-cloudinit-template \
       --memory 2048 \
       --cores 1 \
       --net0 virtio,bridge=vmbr0 \
       --cpu x86-64-v2-AES \
       --machine q35 \
       --bios ovmf
   
   qm importdisk 9030 /var/lib/vz/template/qcow/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 vmdata
   qm set 9030 --scsihw virtio-scsi-pci --scsi0 vmdata:vm-9030-disk-0
   qm set 9030 --efidisk0 vmdata:0,format=raw,efitype=4m
   qm set 9030 --ide2 vmdata:cloudinit
   qm set 9030 --agent enabled=1
   qm set 9030 --boot order=scsi0
   qm template 9030
   ```

---

Both of those solutions failed. The cloned image still boots into GRUB but
never reaches the OS.  

I will enable logging within the Proxmox provider:
```hcl
provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_user             = var.pm_user
  pm_api_token_secret = var.pm_api_token_secret
  pm_api_token_id     = var.pm_api_token_id
  pm_tls_insecure     = true
  pm_log_enable       = true
  pm_log_file         = "tf-pve-plugin.log"
  pm_debug            = true
  pm_log_levels = {
    _default = "debug"
  }
}
```
Then I'll run again to see if I can gain insight into what's going wrong.  

---

The debug logs did not show any helpful errors. Since Terraform was 
successfully running without errors, this does make sense. The problem lies in 
the configuration itself.  

#### Fix

The error seemed to be that Rocky Linux requires UEFI boot, but the host was
booting via SeaBIOS. This seemed strange, as during the template setup I
specified UEFI as the `bios` configuration setting.  

The fix for this was to create a few entries in the `main.tf` file.  
```hcl
  scsihw = "virtio-scsi-pci"
  bios   = "ovmf"
  efidisk {
    storage = "vmdata"
    efitype = "4m"
  }
```
Here we explicitly set the `scsihw` and `bios` settings, as well as specify the
`efidisk` block.  

These settings were apparently not being set from the template clone itself.  

With a Rocky Linux image, it's also important to set the CPU type to `host` if
you're booting into a kernel panic.  
```hcl
  cpu {
    core    = 1
    sockets = 1
    type    = "host"
  }
```




## Resources
- <https://developer.hashicorp.com/terraform/install>
- <https://pve.proxmox.com/pve-docs/pveum-plain.html>
- <https://pve.proxmox.com/wiki/User_Management#pveum_authentication_realms>
- <https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu>
- <https://developer.hashicorp.com/terraform/tutorials/secrets/secrets-vault>
- <https://developer.hashicorp.com/terraform/enterprise/workspaces/dynamic-provider-credentials/vault-configuration>

Cloud-Init resources:

- <https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud-init%2520getting%2520started>
- <https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud_init>
- <https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/guides/cloud-init%20getting%20started.md>
- <https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/guides/cloud_init.md>
- <https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/examples/cloudinit_example.tf>

Cloud-Init images:

- <https://cloud-images.ubuntu.com/>
- <https://dl.rockylinux.org/pub/rocky/10/images/x86_64/>

- [Download: Latest Rocky Linux 10 Cloud Image (qcow)](https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2)

- [Download: Debian 12 Cloud Image (qcow)](https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2)

