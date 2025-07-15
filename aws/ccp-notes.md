# Certified Cloud Practitioner

These are notes from the Cloud Practitioner Essentials course on the [AWS Skillbuilder
Site](https://skillbuilder.aws/learn).  


## Module 1: Intro to Cloud


### M1 Part 1

---

- Client-server model.  

Coffee shop metaphor.  

Barista = server
Buyer = client

The request starts from the client. The server responds to that request (with perms).  

User makes request to server, server validates request is legit, and returns a
response.  

---

- Pay for what you use.  

Employees are only paid for the actual hours they work in a coffee shop. If they
don't work any hours, they don't get paid.  

The store owner decides how many employees they need for any given day.  

With AWS, you just provision more resources (employees) if they're not working, and 
you can de-provision them when you don't need them.    


---

### M1 Part 2
Goals:
- Define Cloud computing
- Describe and differentiate between cloud deployment types

---

- What is cloud computing?
    - Cloud Computing: The on-demand delivery of IT resources over the internet with pay-as-you-go pricing.  

Removes the need for investments into hardware. Allows people to rent compute and
storage, etc.

S3 - Simple Storage Service
EC2 - Elastic Cloud Compute

There are 3 cloud deployment types:
Cloud, on-prem, and hybrid.
- Cloud: All things done in the cloud
- On-prem: All things done on premesis
- Hybrid: On-prem infrastracture and cloud resources work together.

### M1 Part 3
Goals:
- Six benefits of AWS

1. Trade fixed expense for variable expense (pay-as-you-go)
2. Benefit from massive economies of scale
    - AWS has datacenters all over the world. The buy a lot of hardware (at a lower
      price) and pass on that lower price to the customer.  
3. Stop guessing capacity
    - You'd purchase hardware based on expected usage.
    - With AWS, you won't eat sunk costs if you overestimate or underestimate
      the resources you'd need.  
    - You use scaling mechanisms to scale your resources up or down based on demand.  
4. Increased speed and agility
    - More bandwidth to test new things (test envs, etc)
5. Stop spending money running and maintaining data centers
    - The fixed cost of building, AWS eases the cost of running and maintaining
      servers (racking, stacking, etc)
6. Go global in minutes
    - US-based company expanding to india: You just deploy apps to AWS region in India.  

### M1 Part 4
Goals:
- Define AWS regions and availability zones
- Explain the benefits of HA and fault tolerance

AWS has data centers all over the world.  

High availability:
> Hire new employee, they're doing awesome, but then they spill a
> latte on the register.  The register is fried now and we gotta close shop.  
> HA: We have multiple shops at different locations. So the service is still
> available.    

- HA: Making sure apps stay accessible with minimal downtime.  
- Fault Tolerance: Designing a system to continue to operate even if multiple components fail.  

To that end, AWS has datacenters in regions all over the world. Within each of these
regions, there are subregions called Availability Zones (AZ).  
There are 3 or more AZs in a region for redundancy.  

Within each AZ there is 1 or more discrete datacenter.  

This is why it's common for businesses to operate over multiple regions/AZs.  

> It's recommended to distribute your resources across multiple AZs

### M1 Part 5
Shared responsibility
Goals:
- Describe and differentiate between customer responsibilities, AWS responsibilities,
  and shared responsibilities in AWS cloud.  
- Describe the components of the AWS Shared Responsibility Model

---

Who's ultimately responsible for security? AWS **and** you. 

AWS is responsible for security **of** the cloud.  
Client is responsible for security **in** the cloud.  

- Customer responsibility
    - Customer Data
    - Client-side data encryption
- Customer **or** AWS responsibility (varies by service)
    - Serverside encryption
    - Network traffic protection
    - Platform and app management
    - OS, network, firewall config
- AWS responsibility
    - Software for compute, storage, db, networking
    - hardware, AWS global infra

## Module 2: Compute in the Cloud

### M2 Part 1
Intro to EC2
Goals:
- Describe how compute resources are provisioned/managed in cloud
- Compare benefits/challenges of using virtual servers to managing physical servers
  on-prem
- Identify the concept of multi-tenancy in EC2

---

EC2: Elastic Compute Cloud

Coffee shop: same idea applies to other businesses. They also use this model to
deliver products, resources, or data to users.  

You need raw compute capacity to host your apps.  
In AWS, those servers are called EC2 instances.  
EC2 is flexible, cost effective, and quick.  

> You only pay for running instances. Not stopped or terminated instances.  

EC2 instances are VMs, which share an underlying physical host machine with multiple
other instances (a concept called multi-tenancy).  

In multi-tenant env, you need to make sure that each VM is isolated from each other
but still able to share resources provided by the host.  

Resource sharing and isolation is done by a hypervisor.  

In EC2, you choose the OS (based on either Windows or Linux).  

EC2 instances are resizable. You can give it more memory and CPU (vertical scaling). 

Networking is also configurable.  

> Users or administrators can connect using SSH for Linux instances or Remote Desktop Protocol (RDP) for Windows instances.  
> AWS services like AWS Systems Manager offer a secure and simplified method for accessing instances.






### M2 Part 2
EC2 Instance Types
How to privision AWS Resources
EC2 pricing

Goals:
- Explain different EC2 instance types and characteristics
- Identify appropriate use cases for each EC2 instance type

---



There are different types of instances that serve different purposes in your AWS env.  
They're grouped under instance families, which offer varying combinations of cpu,
mem, storage, and networking capacity.  

Instance families:
- General purpose
    - Provide good balance of compute, memory, and networking resources.
    - Good for lots of diverse workloads (web services, code repos)
    - Also a good starting point if you don't know how your workload will perform
- Compute optimized
    - For compute-intensive tasks (gaming servers, HPC, ML tasks, etc)
- Memory optimized
    - For memory-intensive tasks
    - Deliver fast perf for workloads that process large datasets in memory
- Accelerated computing
    - Good for floating point number calculations, graphics process, or data pattern matching.  
    - These use hardware accelerators.
        - Co-processors that perform functions more efficiently than is possible in
          software running on CPUs
- Storage optimized
    - For workloads that require high performance for locally stored data.  

Choose instance type, then choose instance size.  
Keep cost in mind here.  
Bigger instances cost more.  

You can always scale later if you need.  

> Instance types are named based on their instance family and instance size.
> See [EC2 instance naming convention](https://docs.aws.amazon.com/ec2/latest/instancetypes/instance-type-names.html)


### M2 Part 3

Goals:
- Explain how to use the AWS Management Console, the AWS Command Line Interface, and
  the AWS Software Dev Kit (SDK) to interact with AWS services
- Describe the customer and AWS responsibilities regarding VMs
- Explain differences between managed vs unmanaged services


---

Launching an EC2 instance, stopping an instance, or modifying instance settings are done through API requests

APIs privide predefined methods to manage/configure AWS resources efficiently.  


There are three main ways to call AWS APIs.  
- AWS Management Console
- AWS CLI
- AWS SDK

AWS Management Console: 
- Web GUI.
- You manage your resources visually. 
- Good for getting started and building knowledge of the services.  
- Helpful for setting up test envs, viewing AWS bills, monitoring resources, and
  managing non-technical tasks.  

If you're up and running in a prod env, you don't want to rely on point-and-click GUI
stuff. Too much time, too manual. Too prone to human error.  

AWS CLI:
- Invoke AWS APIs using a terminal.  
- Allows you to interact with AWS services through commands.  
- Makes automation through scripting possible.  

- You can run commands using AWS CloudShell -- a cloud-based terminal that has the
  AWS CLI already installed in a managed env.  

- Two basic examples:
    - Create an EC2 instance programmatically with the command:
      ```bash
      aws ec2 run-instances
      ```

    - If you wanted to list all the AZs in the current Region:
      ```bash
      aws ec2 describe-availability-zones
      ```

AWS SDK:
- Makes it possible to interact with AWS resources through programming languages
  (e.g., python).  
- An example script:
  ```python
  #!/usr/bin/env python3
  import boto3

  def list_ec2_instances():
      ec2 = boto3.client('ec2') # create ec2 client
      response = ec2.describe_instances()  # describe instances
      # print instance details
      for reservation in response['Reservations']:
          for instance in reservation['Instances']:
              print(f"Instance ID: {instance['InstanceId']}")
              print(f"Instance Type: {instance['InstanceType']}")
              print(f"Instance State: {instance['InstanceState']['Name']}")
              print(f"--------------------------------")
  if __name__ == '__main__':
      list_ec2_instances()
  ```

---

AWS Shared Responsibility Model for Unamanged Services:
- Customer:
    - Customer data
    - Clientside data encryption
    - Serverside encryption
    - Network traffic protection
    - Platform and app managment
    - OS, network, firewall config
- AWS:
    - Software for compute,storage, db, networking
    - Hardware, AWS global infra

---

### M2 Part 4

Goals:
- Identify key configs needed when setting up an EC2 instance
- Explain how AMI maintains consistency and efficiency when scaling apps

---

Creating an EC2 instance (web UI):
- Go to the AWS Management Console
- Go to `EC2` Console (search `EC2)`
- Click "Launch Instance"
- Name it
- Choose OS image (called **Amazon Machine Image**, or **AMI**)
- Choose instance type (compute power)
    - E.g., `t2.micro`
- Choose/create a key pair. Controls SSH ingress.  
- Configure network settings (allow SSH traffic, HTTP traffic, etc)
- Configure amount of storage

- If you need things installed by default:
    - Go to "Advanced"
    - Go down to "User Data"
    - Paste in a Bash script
      ```bash
      #!/bin/bash
      yum install -y nginx
      systemctl enable --now nginx
      ```
- When everything looks good, click "Launch Instance" (bottom right)

---

AMIs (Amazon Machine Images) are pre-built VM images that have the basic components
for starting an instance.  

AMIs include the OS, storage setup, architecture type, perms for launching, and any
extra software that is already installed.  

You can use one AMI to launch several EC2 instances that all have the same setup.  

---

AMIs can be used in 3 ways.  
1. Create your own AMI
2. Use a pre-configured AWS AMI
3. Purchase AMIs from the AWS Marketplace


### M2 Part 5
Goals:
- Explain available EC2 pricing options
- Descirbe when to use each pricing option based on use bases
- Describe EC2 Capacity Reservations and Reserved Instance (RI) flexibility

---

There are multiple billing options for EC2.

- "On-Demand": The most well known option.  
    - You only pay for the duration that your instance runs (per hour, per second).  
    - No long-term commitments or upfront cost.  
    - Best for spinning up servers, playing around, testing workloads
- "Savings Plan": Lower EC2 prices for a commitment to a consistent amount of usage.  
    - Measured in dollars per hour for one-year or three-year term.  
    - Can provide savings up to 72%.  
    - Can lower prices regardless of instance family, size, OS, tenancy, or Region.  
    - Applies to AWS Fargate and AWS Lambda usage (serverless compute options).  
- "Reserved Instances" (RIs): Good for steady-state workloads or ones with
  predictable usage.  
    - Offers up to a 75% discount compared to on-demand pricing.  
    - Qualify for a discount after committing to one-year or three-year term.  
    - Three payment options for RIs:
        - All Upfront: Pay in full when you commit.
        - Partial Upfront: pay for a portion when you commit.  
        - No Upfront: don't pay anything at the beginning. 
- "Spot Instances": Make it possible to request spare EC2 capacity for up to 90% off
  the on-demand price.  
    - You bid on spare compute.  
    - The catch: AWS can reclaim the instance at any time.  
    - You receive a two minute warning so you can save your progress or resume later
      if needed.  
    - Make sure your workloads can tolerate being interrupted.  
- "Dedicated Hosts": Actual physical servers that customers can reserve for exclusive use.  
    - No other customers workloads can share the server.  
    - Ideal for security-sensitive or licensing-specific workloads (e.g., Windows or SQL Server).
    - Helps with meeting certain compliance/regulatory needs.  





## Misc

Services available:
* compute
* gen ai
* db & storage
* content delivery
* specialized services


