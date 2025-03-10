
# Installing Hashicorp Terraform

## Table of Contents
* [Terraform Installation](#terraform-installation) 
    * [Debian-based Install](#debian-based-install) 
        * [Setup the hashicorp repositories (debian-based)](#setup-the-hashicorp-repositories-debian-based) 
        * [Install dependencies](#install-dependencies) 
        * [Install the HashiCorp GPG key](#install-the-hashicorp-gpg-key) 
        * [Verify the key's fingerprint](#verify-the-keys-fingerprint) 
        * [Add the official HashiCorp repository to your system.](#add-the-official-hashicorp-repository-to-your-system) 
    * [Install Terraform from the Hashicorp Repository](#install-terraform-from-the-hashicorp-repository) 
* [Do some basic checks to see that it is correctly setup.](#do-some-basic-checks-to-see-that-it-is-correctly-setup) 
    * [RHEL-based install](#rhel-based-install) 
        * [Using Yum](#using-yum) 
        * [Using DNF](#using-dnf) 
* [tl;dr](#tldr) 
    * [Debian](#debian) 
* [Resources](#resources) 


## Terraform Installation

### Debian-based Install
#### Setup the hashicorp repositories (debian-based)

Your team has determined they need Terraform to test in their Dev environment.
Setup the Hashicorp repo on Ubuntu and then install Terraform.

Goals
1. Configure the Hashicorp repo.
2. Install Terraform on the server.  

Hint:  
* See [the docs](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


---

#### Install dependencies:
* `gnupg`
* `software-properties-common`
* `curl`

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

#### Install the HashiCorp GPG key:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

#### Verify the key's fingerprint:
```bash
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```

The `gpg` command will report the key fingerprint:
```plaintext
/usr/share/keyrings/hashicorp-archive-keyring.gpg
-------------------------------------------------
pub   rsa4096 XXXX-XX-XX [SC]
AAAA AAAA AAAA AAAA
uid           [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
sub   rsa4096 XXXX-XX-XX [E]
```

---

#### Add the official HashiCorp repository to your system. 
Add the official HashiCorp repository to your system:
```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```

### Install Terraform from the Hashicorp Repository
Download the package information from HashiCorp.
```bash
sudo apt update
```

Install Terraform from the new repository.
```bash
sudo apt-get install terraform
```



---

## Do some basic checks to see that it is correctly setup.

1. Check where the system installed Terraform.  
2. Check Terraform functionality.  


* Check where the system put Terraform binary.
```bash
which terraform
```

* Verify Terraform functionality.
```bash
terraform -help
```
Make sure you look at some of the capabilities you have with Terraform.

* Check Terraform subcommands
```bash
terraform -help plan
```

### RHEL-based install
#### Using Yum
Install dependencies:
```bash
sudo yum install -y yum-utils
```

Add the yum repository:
```bash
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
```

Install terraform:
```bash
sudo yum -y install terraform
```

#### Using DNF

```bash
curl https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo | sudo tee /etc/yum.repos.d/hashicorp.repo
```

## tl;dr:
### Debian
```bash
# make sure gpg is present
sudo apt update && sudo apt install gpg

# add repository gpg key
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# verify key's fingerprint
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

# add hashicorp repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release | lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

## Resources
- [Official Packaging Guide](https://www.hashicorp.com/en/official-packaging-guide)

