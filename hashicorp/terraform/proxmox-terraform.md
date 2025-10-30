# Proxmox and Terraform

These are my notes on using Terraform to provision VMs in Proxmox.

## Setup

Quick install of Terraform on my main Proxmox node (`home-pve`).  

Recommended installation method from the [Terraform installation guide](https://developer.hashicorp.com/terraform/install):
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

I wrote my own [custom installer script](https://github.com/kolkhis/.dotfiles/blob/main/install/install/install-terraform) for portability, to work on both
Debian-based and RedHat-based systems -- mainly distros that are binary-compatible
with RHEL (Rocky, Alma).  

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




## Resources
- <https://developer.hashicorp.com/terraform/install>

