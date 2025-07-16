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


### M2 Part 5: EC2 Pricing
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


### M2 Part 6: Scaling EC2
Scaling EC2

Goals:
- Recognize concepts of scalability and elasticity as they apply to AWS
- Describe how AWS can help businesses adjust compute capacity based on varying demand


---

We might known on average what amount of capacity is needed for a company as it
grows. But the average can include cyclical traffic with busy and quiet seasons.  

So if peak is only an hour a day, we don't need to provision peak-level resources all
day.  

We can provision your workload to the exact demand.  

> Coffee shop metaphor:
> Barista is behind counter taking orders. But not doing all the work there.
> Someone's baking the drinks. If we lost the order-taking instance (barista) we'd be
> out of business until we get another person (or instance) up and running

Using the same programmatic method used to create the original barista, we create a
second copy of the barista.  

If one fails, there's another one already taking orders. Customers don't lose
service.  

The backend needs redundancy too, someone needs to keep making drinks.  

---

So, to create a HA system with no SPOF (single point of failure), set up redundant
EC2 instances across multiple AZs in a Region. So if there are issues in one place,
the instances deployed in the other AZ can pick up the slack.  

As long as the number of customers in line stays the same we're good. But that will
change. So let's see what happens when we have an increase in demand/traffic.  

---

Two ways to handle growing demands.  
1. Scale out (horizontal scaling): Add more resources to the pool so you can get more
   work done in parallel.  
    - E.g., spinning up more EC2 instances
2. Scale up (vertical scaling): Add more power to the machines that are running.  
    - So the individual machine has more power to do the work.  
    - Can give more power per instance, but not always what you need.

>Coffee shop metaphor:
> For an increase in customers/requests, a bigger instance won't let you process
> orders/requests any faster.  
> 
> You'd need more instances to handle more customers in parallel.  
>  
> But, you're taking more requests, but the drinks are still being made at the
> same speed. So you need to scale the processing instances as well.   

Why are there more order-taking instances than order-making instances?  

The amount of work getting done is still more than the order-taking instances can 
send to back-of-house.  
There isn't a backlog of orders, so there's no reason to add more worker instances.  
So you can end up with exactly the amount of compute you need to serve all your
customers.  

Once that rush is cleared, you have extra workers that are idle.  
If we don't need them, send them home or stop the instances.  
This is how **Amazon EC2 Auto Scaling** works.  

---

EC2 Auto Scaling adds instances based on demand and key scaling metrics, then
decommissions instances when that demand goes down.  

You need to be collecting data about the performance of instances, or data around latency
and other app metrics. You'd use Amazon CloudWatch to collect and monitor these
metrics. This data is used to determine when scaling needs to happen. Then it happens
automatically when needed.  

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

---

### M2 Part 7: Elastic Load Balancing (ELB)
Goals:
- Describe the challenge of traffic distribution and scalability in AWS envs
- Recognize the benefits of Elastic Load Balancing (ELB) in AWS
- Explain the relationship between Amazon EC2 Auto Scaling and ELB in managing AWS resources


---

Even if we scale out, we still need to direct traffic to the new instances.  
We want to distribute the traffic to each of the instances evenly.  


> Coffee shop metaphor:
> Adding cashiers helps, but if people keep getting in the same line and aren't going
> to the new cashiers that we added, that's a problem. We can add a host to the
> coffee shop that keeps an eye on the lines and directs people to the cashiers so
> that the customers are evenly distributed.  

This is what Elastic Load Balancer (ELB) does. It balances the load.  
The load balancer takes in requests and routes them to instances.  

Now, you can definitely bring your own load balancer. Using ELB isn't required for 
load balancing an application hosted on EC2. But you'll have to manage/patch/upgrade
the load balancer on your own.  

---

AWS will handle all of it with ELB. You just configure it once. It distributes
network traffic. Elastic means it's able to scale up and down based on traffic without adding to hourly costs.  

---

ELB can handle both internal and external traffic to AWS. 
It also handles linking backend instances to frontend instances.  
Since it's regional, it's a single URL that each frontend instance uses to direct to 
the backend instances.  

If the backend needs to scale, it spins up a new instance. When it's ready, it tells
the ELB that it's ready.  

The frontend doesn't need to know what's happening. It's done automatically. It
essentially decouples the architecture.  

---

ELB can distribute traffic across multiple resources, not just EC2.  

ELB and EC2 Auto Scaling work in tandem to enhance perf and ensure HA.  

---

ELB handles maintenance, updates, and failover to reduce operational overhead.  

---

ELB uses several routing methods:
- "Round Robin": Distributes traffic evenly across all available servers in a cyclical manner.
- "Least Connections": Routes traffic to the server with the fewest active 
                       connections, maintaining a balanced workload
- "IP Hash": Uses the client's IP addr to consistently route traffic to the same server
- "Least Response Time": Directs traffic to the server with the fastest response time, minimizing latency


## M2 Part 8: Messaging and Queueing
Goals:
- Describe how Amazon Simple Queue Service (SQS) facilitates message queueing.  
- Explain how Amazon Simple Notification SErvice (SNS) uses a publish-subscribe model
  to distribute messages
- Identify the difference between tightly coupled and loosely coupled architectures
- Explain how message queues help improve communications between components
















## Misc

Services available:
* compute
* gen ai
* db & storage
* content delivery
* specialized services


