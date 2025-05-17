# Terraform Project Structure

## Standard Terraform Project Structure
Below is a visual representation of a well-structured terraform project layout:
```plaintext
terraform-project/
│── modules/                # Reusable modules (optional, if using modules)
│   ├── network/            # Module for networking (VPC, subnets, etc.)
│   │   ├── main.tf         # Main Terraform configuration for networking
│   │   ├── variables.tf    # Variables specific to networking
│   │   ├── outputs.tf      # Outputs from this module
│   │   ├── provider.tf     # (Optional) Provider config
│   │   ├── versions.tf     # (Optional) Terraform version constraints
│   │   └── README.md       # Documentation for this module
│   ├── compute/            # Module for compute resources (e.g., EC2, VM, Kubernetes)
│   └── storage/            # Module for storage (S3, EBS, etc.)
│
│── envs/                   # Environment-specific configurations
│   ├── dev/                # Development environment
│   │   ├── main.tf         # Calls modules and sets environment-specific settings
│   │   ├── variables.tf    # Environment-specific variables
│   │   ├── backend.tf      # (Optional) Remote state configuration
│   │   ├── outputs.tf      # Outputs for this environment
│   │   ├── terraform.tfvars # Variable values for this environment
│   │   └── README.md       # Documentation
│   ├── staging/            # Staging environment
│   └── production/         # Production environment
│
│── scripts/                # Automation scripts (e.g., Terraform wrapper scripts)
│   ├── init.sh             # Bootstrap script
│   ├── plan.sh             # Wrapper script for terraform plan
│   ├── apply.sh            # Wrapper script for terraform apply
│   └── destroy.sh          # Wrapper script for terraform destroy
│
│── .terraform/             # Terraform working directory (ignore in VCS)
│── .terraform.lock.hcl     # Terraform provider lock file
│── .gitignore              # Ignore unnecessary Terraform files
│── provider.tf             # Global provider configuration (if not in modules)
│── terraform.tfvars        # Global variables (avoid sensitive info here)
│── versions.tf             # Required provider and Terraform versions
│── main.tf                 # Root Terraform configuration
│── variables.tf            # Root-level variables
│── outputs.tf              # Root-level outputs
└── README.md               # Documentation
```

### `modules/`
This is where Terraform modules are defined.  
This directory keeps reusable components separated.  

Each module has;
- `main.tf`: Defines Terraform resources (e.g., VPCs, EC2 instances, security groups).
- `variables.tf`: Input variables used in `main.tf`.
- `outputs.tf`: Defines outputs (e.g., IDs, URLs, IPs, etc.). 
    - Example `outputs.tf`:
      ```hcl
      output "vpc_id" {
          value = aws_vpc.main.id
      }
      ```
- `README.md`: The documentation for the module.  


#### Example Module called `network`
- `main.tf`:
  ```hcl
  # modules/network/main.tf
  resource "aws_vpc" "main" {
      cidr_block = var.cidr_block
      enable_dns_support = true
  }
  ```

- `variables.tf`:
  ```hcl
  # modules/network/variables.tf
  variable "cidr_block" {
      description  = "CIDR block for VPC"
      type = string
  }
  ```

- `outputs.tf`
  ```hcl
  # modules/network/outputs.tf
  output "vpc_id" {
      value = aws_vpc.main.id
  }
  ```


### `envs/`
This directory holds the environment-specific configuration for the environments that
the project will run in (e.g., dev, staging, prod).  

This helps to organize the per-environment configurations for each environment.  

Each environment has:
- `main.tf`: Calls modules and defines resources.  
    - Example `main.tf`:
      ```hcl
      # envs/dev/main.tf
      module "network" {
          source = "../modules/network"
          cidr_block = "10.0.0.0/16"
      }
      ```

- `terraform.tfvars`: Contains variables for that specific environment.  
    - Example `terraform.tfvars`:
      ```hcl
      # envs/dev/terraform.tfvars
      instance_type = "t3.micro"
      region = "us-west-2"
      ```

- `backend.tf`: Defines the Terraform backend for remote state management.  
    - Example `backend.tf` (using an S3 backend in AWS):
      ```hcl
      # envs/dev/backend.tf
      terraform {
          backend "s3" {
              bucket = "my-terraform-state"
              key    = "dev/terraform.tfstate"
              region = "us-west-2"
          }
      }
      ```


### `scripts/`
This directory is for automation.  
It contains helper scripts for common terraform operations.  

E.g.:
```bash
# plan.sh
# Runs terraform plan for a given environment 
terraform init
terraform plan -var-file="terraform.tfvars"
```
- `terraform plan`: Dry run. Shows what Terraform would change without applying.  

Any shell script can go here.  


### `provider.tf`
This file defines cloud provider settings (e.g., AWS, Azure, GCP, etc.).  

E.g., using an AWS provider:
```hcl
provider "aws" {
    region = var.aws_region
}
```

### `versions.tf`
This file locks the Terraform and provider versions.  

E.g.:
```hcl
terraform {
    required_version = ">= 1.3.0"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}
```
- `~> 5.0`: Tells terraform to use version `5.x` but not `6.0` or higher.  
    - E.g., `5.0`, `5.1`, and `5.9` are all valid, but `6.0` is invalid.  
    - This ensures compatibility while allowing minor version updates.  






