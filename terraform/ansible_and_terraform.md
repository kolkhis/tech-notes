
# Terraform and Ansible

Terraform and Ansible are popular tools in the DevOps community, used for 
infrastructure as code (IaC) and automation tasks.  

They serve different, yet complementary purposes.


## Table of Contents
* [Terraform and Ansible](#terraform-and-ansible) 
* [Terraform](#terraform) 
    * [Terraform Examples](#terraform-examples) 
* [Ansible](#ansible) 
    * [Ansible Examples](#ansible-examples:) 
* [Relationship between Terraform and Ansible](#relationship-between-terraform-and-ansible) 
    * [Example Workflow](#example-workflow) 
    * [Integration Use Case](#integration-use-case) 
* [tl;dr](#tl;dr:) 



## Terraform

Terraform, developed by HashiCorp, is used for building, changing, and versioning 
infrastructure safely and efficiently.  


It supports a wide range of cloud providers (like AWS, Google Cloud, Azure) as well 
as on-prem resources.  

Terraform uses declarative configuration files to manage and provision the infrastructure.

### Terraform Examples
1. Provisioning a Virtual Machine on AWS:
   ```hcl
   resource "aws_instance" "example" {
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.micro"
   }
   ```
   This Terraform script creates a new EC2 instance of type t2.micro on AWS.

2. Creating a Network on Google Cloud:
   ```hcl
   resource "google_compute_network" "vpc_network" {
     name                    = "terraform-network"
     auto_create_subnetworks = "true"
   }
   ```
   This script provisions a new VPC network in Google Cloud with auto-created subnetworks.



## Ansible
 
Ansible, developed by Red Hat, is an open-source software provisioning,
configuration management, and application-deployment tool.  
 
What it does:
* Uses a procedural style for automation.  
* Deploys apps. 
* Manages systems and devices.  
 
Unlike Terraform, Ansible uses an agentless architecture. 
Ansible relies on SSH for communication to managed nodes.


### Ansible Examples:
1. Configuring a Web Server:
   ```yaml
   - name: Ensure Apache is at the latest version
     yum:
       name: httpd
       state: latest
   - name: Write the Apache config file
     template:
       src: /srv/httpd.j2
       dest: /etc/httpd.conf
   ```
   This Ansible playbook ensures that Apache (`httpd`) is installed at its latest version 
   and configures it using a template.


2. Adding a User to Multiple Servers:
   ```yaml
   - name: Add a new user
     user:
       name: username
       state: present
       groups: "wheel"
       append: yes
   ```
   This playbook adds a new user to the `wheel` group across all managed servers.


## Relationship between Terraform and Ansible

* Terraform is for setting up and tearing down entire infrastructures.
* Ansible is for the setting up the detailed configuration of the software *on* those 
  infrastructures.  

They can be used together in a workflow where Terraform provisions the hardware, and 
Ansible then configures the software. 


### Example Workflow
1. Terraform is used to provision a set of VMs and a load balancer in AWS.
2. Ansible takes over to install a web server on the VMs, deploy the application, and 
   ensure all configurations are correct.

### Integration Use Case
* After Terraform provisions new AWS EC2 instances, it outputs the IP addresses of 
  the new instances.
* Ansible uses those IP addresses (perhaps dynamically generated inventory) to 
  configure software, deploy applications, and ensure the servers are ready for traffic.

This approach leverages the strengths of both tools: Terraform's ability to manage 
infrastructure and Ansible's capability to configure and deploy applications onto 
that infrastructure.




## tl;dr:
* Terraform is for setting up and tearing down entire infrastructures.
* Ansible is for the setting up the detailed configuration of the software *on* those 
  infrastructures.  




