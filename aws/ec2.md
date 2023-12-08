
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




## What is an EC2 Instance?  
Short answer: a Virtual Machine.  
There are so many compute options. Tons of instance types. Great for raw compute.  
Challenge: There's not a great way to make it so the EC2 instance to make it so it's only  
run when needed.  

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

## Regions, 
AWS Region: Geographical location that implements it's operations and data centers.
- Region names are usually `region-direction-number` (`us-east-1`)
- In each region you have Availability Zones (AZ).
    - AZ are clusters of data centers
    - an AZ will be a subset of the region (`us-east-1a`, `us-east-1b`)
A VPC is a region-scope service.
VPC has subnets. So you can have a subnet in `us-east-1a`, and a subnet in `us-east-1b`.  

So if you launch a service in an AZ, you must also launch a mirror of it in another AZ.



Choosing region:
Compliance: If it contains data that is bound by local regulations, then select the appropriate
region.
Latency: Choosing an AWS Region with close proximity to your userbase location can achieve lower
network latency.
Cost: AWS services are priced differently from one Region to another. Some Regions have lower
costs than others, which can reult in a cost reduction for the same deployment

Services and features Availability: Newer services/features only exist in certain regions.

You can use multiple Regions for one application.


