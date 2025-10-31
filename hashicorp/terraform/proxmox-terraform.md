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
distros that are binary-compatible with RHEL (Rocky, Alma).  

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
      integrations.  

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

4. Generate an API token.  
   ```bash
   pveum user token add terraform@pve <TOKEN_ID>
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

5. Verify the token has been created.  
   ```bash
   pveum user token list terraform@pve
   ```

Once the user account is created and has an API key, we can move forward to
configuring the Terraform Proxmox provider.  

### Configure Terraform Provider

Terraform has this concept of "providers."  

Providers are essentially plugins that allow Terraform talk to an external
system, usually via that system's API.  

Each provider is programmed to interact with specific APIs (e.g., AWS, Proxmox), 
and exposes **Terraform resources** that correspond to that system.  

Providers are downloaded from the [Terraform registry](https://registry.terraform.io/)

!!! info "How Terraform providers work"

    When we run `terraform init`, it reads the `.tf` files and detects which
    providers are being used, then downloads and installs them into
    the `.terraform/providers` directory.  

    Then, when we run `terraform plan` or `terraform apply`, it will load each
    provider's plugin binary, passes in the config (via RPC), and the **provider** 
    makes the appropriate calls to the API. The provider will report back what
    changed (or what will change).  

All that to say, Terraform has a Proxmox provider.  

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
provider "proxmox" {
    pm_api_url  = "https://192.168.1.49:8006/api2/json"
    pm_user     = "terraform"
    pm_password = "api-key-goes-here"
    pm_tls_insecure = true
}
```
This configures the Proxmox provider, and specifies the necessary information 
for Terraform to interact with the Proxmox API.  

Then, also in `main.tf`, we'd add the new **resource** that we want to create.  
```hcl
resource "proxmox_vm_qemu" "new_vm" {
    name        = "new_vm"
    target_node = "home-pve"
    clone       = "ubuntu-template"
    storage     = "vmdata"
    # storage     = "local-lvm"
    cores       = 2
    memory      = 2048
}
```

This specifies a **single VM to create**.  
Any additional VMs would be another `resource` entry, all with their own
configurations.  

---

Once we have the `provider` and our `resource` set up in `main.tf`, we can go
ahead and do `terraform init` to intialize the provider.  
```bash
terraform init
```

Then, we can do a `plan` to see the changes that will be made.  
```bash
terraform plan
```

Finally, we `apply` to actually do the magic.  
```bash
terraform apply
```

## Resources
- <https://developer.hashicorp.com/terraform/install>
- <https://pve.proxmox.com/pve-docs/pveum-plain.html>
- <https://pve.proxmox.com/wiki/User_Management#pveum_authentication_realms>
- <https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu>
- <https://registry.terraform.io/>
