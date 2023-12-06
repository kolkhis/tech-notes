# Learning Objectives  

For each assignment, you will receive an automated account to build a new solution on the AWS console.  

Solution Lab assignments in the game!  
* [Cloud Computing Essentials](#Cloud-Computing-Essentials)  
    * Skills Used:
        * Amazon S3
* [Cloud First Steps](#Cloud-First-Steps)  
    * Skills Used:
        * AWS
        * Amazon EC2 
* [Computing Solutions](#Computing-Solutions)  
    * Skills Used:
        * Amazon EC2 
* [Cloud Economics](#Cloud-Economics)  
    * Skills Used:
        * AWS Pricing Calculator
        * Amazon EC2 
* [Networking Concepts](#Networking-Concepts)  
    * Skills Used:
        * Amazon VPC
        * Amazon EC2
* [Connecting VPCs](#Connecting-VPCs)  
    * Skills Used:
        * Amazon EC2
        * Amazon VPC  
* [First NoSQL Database](#First-NoSQL-Database)  
    * Skills Used:
        * Amazon DynamoDB  
* [Core Security Concepts](#Core-Security-Concepts)  
    * Skills Used:
        * Amazon EC2
        * Amazon Relational Database Service (RDS)
        * AWS Identity and Access Management (IAM)  
* [File Systems in the Cloud](#File-Systems-in-the-Cloud)  
    * Skills Used:
        * Amazon EC2
        * Amazon Elastic File System  
* [Auto-healing and Scaling Applications](#Auto-healing-and-Scaling-Applications)  
    * Skills Used:
        * Amazon EC2
        * Amazon EC2 Auto Scaling  
* [Highly Available Web Applications](#Highly-Available-Web-Applications)  
    * Skills Used:
        * Amazon S3
        * Amazon EC2
        * Amazon EC2 Auto Scaling
        * Elastic Load Balancing (ELB)  

**Solution Center Steps**
1. Learn
    - Watch vids, see diagrams
2. Plan
    - Review a breakdown of building tasks
3. Practice
    - Build a portion of the solution using a step-by-step guide
    - Review important concepts related to each guided step
4. DIY
    - Complete the solution independently to reinforce what you learned.
    - Validate your completed solution.


##  Cloud Computing Essentials 

### Quest  
* The city's web portal needs to migrate the beach wave size prediction  
page to AWS to improve reliability.  
    * Articulate the characteristics of the AWS cloud computing platform. 
    * Describe the core benefits of using AWS products and services.  
    * Compare and contrast AWS cloud services to On-Premises infrastructure.  
    * Implement hosting a static web page using Amazon S3.  
Everyone on the island goes to customer portal to view 
current wave size projections at the beach
surfers check this webpage for big waves
families wnat to know when waves are lower fo family reasons


Cloud computing on AWS provides access to tech services:
* compute power
* storage
* databases

Can deploy resources, such as servers, in minutes, good price

Get a server running quickly to bring back wave size webpage
Website should be more resilient to hardware failures


Webpages that require scripts to run on the web server: Server-side scripts
No server-side scripts = static website

Static site can be on Amazon S3 bucket and use static webiste hosting feature.

- Create a new S3 bucket to hold webpage content
Don't we need a web server?
- With Amazon S3, can store any type/amount of data and retrieve it from anywhere
- After uploading data into S3 bucket, we can enable the static webiste hosting
  feature on the bucket
- S3 is a fully managed service. no need to deploy or manage servers
- S3 buckets are automatically replicated across multiple AWS data centers
    - Any site hosted in an S3 bucket can auto-scale to handle thousands of concurrent requests

### Solutions Center - Learn
1. **Amazon Simple Storage (Amazon S3)**
    - Store and retrieve any amount of data from anywhere.
    - Store any type of data.
To store data in S3, you work with resources called "buckets" and "objects."
* **Buckets**: A bucket is a container for objects.  
* **Objects**: An object is any type of file and any metadata that describes that file.  

The solution uses an Amazon S3 bucket to host a static website.  
No need to manage any web servers.  

Client-side scripts and CSS are uploaded into the bucket with an HTML file.  
Can configure any of your S3 buckets as a static website.  


## Cloud First Steps 

### Quest  
* The island's stabilization system is failing and needs increased  
reliability and availability for its computational modules. 
    * Summarize AWS Infrastructure benefits.  
    * Describe AWS Regions and Availability Zones.  
    * Deploy Amazon EC2 instances into multiple Availability Zones.  

## Computing Solutions  

### Quest  
* The school server that runs the scheduling solution needs more memory.  
Assist with vertically scaling their Amazon EC2 instance.  
    * Describe Amazon EC2 instance families and instance types.  
    * Describe horizontal and vertical scaling.  
    * Recognize options for connecting to Amazon EC2 instances.  

## Networking Concepts  

### Quest  
* Help the bank setup a secure networking environment which  
allows communication between resources and the internet.  
    * Define key features of VPCs, subnets, internet gateways and route tables.  
    * Describe the benefits of using Amazon VPCs.  
    * State the basics of CIDR block notation and IP addressing.  
    * Explain how VPC traffic is routed and secured using gateways,
    network access control lists, and security groups.  

## Databases in Practice  

### Quest  
* Improve the insurance company's relational database operations,
performance, and availability.  
    * Review the features, benefits and database types available with Amazon RDS.  
    * Describe vertical and horizontal scaling on Amazon RDS.  
    * Use Amazon RDS read replicas to increase database performance.  
    * Implement multi-AZ deployments of Amazon RDS to increase availability.  

## Connecting VPCs  

### Quest  
* The city's marketing team wants separate Amazon VPCs for each  
department that allows communication between Amazon VPCs.  
    * Summarize how VPC peering works with Amazon VPC.  
    * Explain the steps for establishing a VPC peering connection.  
    * Create a peering connection between two Amazon VPCs.  
    * Establish a peering connection between Amazon VPCs using a specific subnet.  

## First NoSQL Database  

### Quest  
* Help the island's streaming entertainment service implement a NoSQL database  
to develop new features.  
    * Summarize the different uses of common purpose-built databases.  
    * Describe the features and benefits of Amazon DynamoDB.  
    * Interact with the elements and attributes of an Amazon DynamoDB database.  
    * Set Up a NoSQL database with Amazon DynamoDB.  

## File Systems in the Cloud  

### Quest  
* Help the city's pet modeling agency share file data without provisioning 
or managing storage.  
    * Summarize the different storage options available on AWS.  
    * Summarize the key features and benefits of Amazon EFS.  
    * Identify business use cases for Amazon EFS.  
    * Configure Amazon EFS endpoints to access centralized storage.  

## Auto-healing and Scaling Applications  

### Quest  
* Assist the city's gaming cafe with implementing auto healing servers  
while restricting patrons to a specific provisioning capacity.  
    * Describe the auto healing and scaling capabilities offered by Auto Scaling groups.  
    * Create an Auto Scaling group with strict resource boundaries.  
    * Configure an Auto Scaling group to respond to a time-based event.  

## Highly Available Web Applications  

### Quest  
* Help the travel agency create a highly available web 
application architecture.  
    * Describe the principles for architecting highly available applications.  
    * Summarize the benefits of using an AWS Application Load Balancer (ALB).  
    * Use Auto Scaling groups with load balancing and health monitoring.  


## Core Security Concepts  

### Quest  
* Help improve security at the city's stock exchange by ensuring that  
support engineers can only perform authorized actions.  
    * Describe the creation process and differences between AWS IAM users, roles, and groups.  
    * Review the structure and components of AWS IAM Policies.  
    * Summarize the AWS Shared Responsibility Model and compliance programs.  


## Cloud Economics  

### Quest  
* The city's surf board shop needs a cost estimation of an architecture  
with variable resource usage.  
    * Describe how pricing estimates are obtained.  
    * Use the AWS Pricing Calculator to estimate the price of an AWS architecture.  




