
# Installing Hashicorp Terraform


## Table of Contents
* [Installing Hashicorp Terraform](#installing-hashicorp-terraform) 
* [Setup the hashicorp repositories](#setup-the-hashicorp-repositories) 
    * [Install dependencies](#install-dependencies) 
    * [Install the HashiCorp GPG key](#install-the-hashicorp-gpg-key) 
    * [Verify the key's fingerprint](#verify-the-key's-fingerprint) 
    * [Add the official HashiCorp repository to your system.](#add-the-official-hashicorp-repository-to-your-system) 
    * [Install Terraform from the Hashicorp Repository](#install-terraform-from-the-hashicorp-repository) 
* [Do some basic checks to see that it is correctly setup.](#do-some-basic-checks-to-see-that-it-is-correctly-setup) 



## Setup the hashicorp repositories

Your team has determined they need Terraform to test in their Dev environment.
Setup the Hashicorp repo on Ubuntu and then install Terraform.

Goals
1. Configure the Hashicorp repo.
2. Install Terraform on the server.  

Hint:  
* See [the docs](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


---

### Install dependencies:
* gnupg
* software-properties-common
* curl

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

### Install the HashiCorp GPG key:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

### Verify the key's fingerprint:
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

### Add the official HashiCorp repository to your system. 
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

Goals:
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

If you've gotten output back, you've installed Terraform and are ready to go with future labs.



