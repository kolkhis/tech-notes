# Installing Hashicorp Terraform


## Terraform Installation

Terraform can be installed via package manager on most Linux distros.  
The Hashicorp repository must be added to install via package manager.  

### Debian-based Install

#### Quick setup:

```bash
wget -O - https://apt.releases.hashicorp.com/gpg |
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

The repository can alternatively be added by using `apt-key add` and `apt-add-repository`:
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install terraform
```

#### Setup the hashicorp repositories (Debian-based)

* Also see [the official installation guide](https://developer.hashicorp.com/terraform/install)

Add the apt repository by downloading the GPG key, adding it to the keyring,
then adding the appropriate repo.  

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
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | 
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

### RedHat-based Install
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
curl https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo |
    sudo tee /etc/yum.repos.d/hashicorp.repo
sudo dnf install -y terraform
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
- [het_tanis' Killercoda lab](https://killercoda.com/het-tanis/course/Hashicorp-Labs)
- [Hashicorp Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).  
- [Official Packaging Guide](https://www.hashicorp.com/en/official-packaging-guide)
- [AWS Terraform CLI Tutorial](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

