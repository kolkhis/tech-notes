
# Amazon EC2 (Elastic Compute Cloud)

## What is an EC2 Instance?  
Short answer: a Virtual Machine.  
There are so many compute options. Tons of instance types. Great for raw compute.  


EC2 is compute capacity.  
It's designed to be able to scale. 
Provides secure, resizable compute capacity in the cloud.  
Designed to make web-scale cloud computing easier for developers.  

GDPR: Europe's data regulations (how and where its stored, and how its used. Privacy regulatory matters.)  


## Pricing Models  

Five pricing models to pay for EC2 instances:  
* on-demand  
* savings,
* plans,
* Dedicated Hosts,
* spot instances  
* reserved instances  

They're as follows:

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




## What is an EC2 Instance?  
Short answer: a Virtual Machine.  
There are so many compute options. Tons of instance types. Great for raw compute.  
Challenge: There's not a great way to make it so the EC2 instance is only run when needed.  

So, Lambda is better for those types of situations.  
It's serverless - you don't need to *manage* the underlying server.  
If you start sending more requests to that lambda function, it'll scale itself automatically.  
It scales up, and scales down, when appropriate. 
So, you *can* assign resources to a lambda function (scaling vertically).  
* Can give it more RAM, etc.  
It's very good at scaling horizontally (spinning up more instances of that lambda.)  
* It automatically scales when you send traffic to it.  
* they can scale horizontally with a concurrency limit of 1000  

---  

Disaster Recovery (DR) Architecture.  
Recovery Time Objective (RTO)  


## EC2 Instance Types  

The instance types are broken up into "families."  


The instance families:

- General Purpose
    - Provide good balance of compute, memory, and networking resources.
    - Good for lots of diverse workloads (web services, code repos)
    - Also a good starting point if you don't know how your workload will perform
- Compute Optimized
    - For compute-intensive tasks (gaming servers, HPC, ML tasks, etc)
- Memory Optimized
    - For memory-intensive tasks
    - Deliver fast perf for workloads that process large datasets in memory
- Accelerated Computing
    - Good for floating point number calculations, graphics process, or data pattern matching.  
    - These use hardware accelerators.
        - Co-processors that perform functions more efficiently than is possible in
          software running on CPUs
- Storage Optimized
    - For workloads that require high performance for locally stored data.  


### General Purpose Instance Types  
Balance of compute, memory, and networking resources.  

Use cases:  
Broad range of applicable use cases.  
* Business critical applications  
* Small/Mid-sized Databases  

### Database Optimized Instance Types  
Low latency and high Input/Output per Second (IOPS)  

Offers low latency  
Use cases:  
* NoSQL Databases  
* Data Warehousing  
* Distributed File Systems  


### Compute Optimized Instance Types:  
Compute - CPU intensive apps and DBs  
Suitable for workloads like:  
* HPC  
* Batch Processing  
* Video Encoding  

### Accelerated Computing Instance Types  
(P2 G3 F1)  
Use cases:  
* Machine Learning  
* Graphics workloads  
* Game and Application Streaming  

Uses hardware accelerators to expedite data processing.  



### Memory Optimized Instance Types  
Delivers fast performance for memory-intensive workloads.  

Use Cases:  
* High-performance databases  
* Real-time big data analytics  


---

## Regions
AWS Regions are geographical location that AWS implements its operations and data centers.

- Region names are usually `region-direction-number` (`us-east-1`)
- In each region you have at least three Availability Zones (AZ).
    - AZ are clusters of data centers
    - An AZ will be a subset of the region denoted by a letter (`us-east-1a`, `us-east-1b`)

A VPC is a region-scope service.

A VPC has subnets. So you can have a subnet in `us-east-1a`, and a subnet in `us-east-1b`.  

So if you launch a service in an AZ, you must also launch a mirror of it in another 
AZ to ensure high availability.


There are several factors to consider when choosing a region:

* Compliance: If it contains data that is bound by local regulations, then select the 
  appropriate region.
* Latency: Choosing an AWS Region with close proximity to your userbase location can 
  achieve lower network latency.
* Cost: AWS services are priced differently from one Region to another. Some Regions 
  have lower costs than others, which can result in a cost reduction for the same 
  deployment.  

Services and features Availability: Newer services/features only exist in certain regions.

You can use multiple Regions for one application.

## Creating an EC2 Instance

Creating an EC2 instance from the web UI:

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

- If you need certain programs installed by default:
    - Go to "Advanced"
    - Go down to "User Data"
    - Paste in a Bash script
      ```bash
      #!/bin/bash
      yum install -y nginx
      systemctl enable --now nginx
      ```

- When everything looks good, click "Launch Instance" (bottom right)

## EC2 Auto Scaling

EC2 Auto Scaling adds instances based on demand and key scaling metrics, then
decommissions instances when that demand goes down.  

You need to be collecting data about the performance of instances, or possibly data 
around latency and other app metrics. You'd use Amazon CloudWatch to collect and 
monitor these metrics.  
This data is used to determine when scaling needs to happen. Then scaling happens automatically when needed.  

---

EC2 Auto Scaling adjusts the number of EC2 instances based on demand.  
There are two approaches:

1. Dynamic scaling: Adjusts in real time to fluctuations in demand
2. Predective scaling: Preemptively schedules the right number of instances based on
  anticipated demand.  

With EC2 Auto Scaling, you maintin the desired amount of compute capacity for your
apps by dynamically adjusting the number of EC2 instances based on demand.  

You can create Auto Scaling groups, which are collections of EC2 instances that can
scale in or out to meet demand.  


An auto scaling group is configured with three key settings.  
1. Minimum Capacity
    - This defines the **least** number of EC2 instances required to keep the
      application running.  
    - Makes sure that the system never scales below this threshold.  
    - This is the number of EC2 instances that launch immediately after you create
      the Auto Scaling group.  
2. Desired Capacity
    - The ideal number of instances needed to handle the current workload (which Auto
      Scaling aims to maintain).  
    - If not specified, the desired capacity defaults to the minimum capacity.  
3. Maximum Capacity
    - This is the upper limit on the number of instances that can be launched.  
    - Prevents over-scaling and controls costs.  


## EC2 Instance Naming Convention

<https://docs.aws.amazon.com/ec2/latest/instancetypes/instance-type-names.html>



