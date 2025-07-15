# Certified Cloud Practitioner

These are notes from the Cloud Practitioner Essentials course on the [AWS Skillbuilder
Site](https://skillbuilder.aws/learn).  


## Module 1: Intro to Cloud


### Part 1

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

### Part 2
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

### Part 3
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

### Part 4
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

### Part 5
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



## Misc

Services available:
* compute
* gen ai
* db & storage
* content delivery
* specialized services


