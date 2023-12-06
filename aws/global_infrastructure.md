

# AWS Global Infrastructure  

## AWS Global Infrastructure Components  
Amazon Cloud Computing resources are hosted in multiple worldwide locations.  

AWS Global Infrastructure consists of 4 Components.  
1. AWS Regions  
2. Availability Zones  
3. Data Centers  
4. Points of Presence

### AWS Regions  
These are referred to as **AWS Regions**  
Each AWS Region is a separate geographic area  
Each has multiple isolated locations 
These are known as **Availability Zones (AZ)**  

* 1 AWS Region has at least 2 Availability Zones 
* Most have 3 AZ  
* Some have as many as 6  
AZ are fully isolated, && many Km apart from each other for Complete Redundancy 

Each AZ consists of 1 or more discrete **Data Centers**  
Typically an AZ has 3 data centers.  
Each data center has redundant power, dedicated metro fiber connectivity  
and are housed in separate facilities  

Network  
Purpose built  
fully redundant  parallel 100 GbE metro fiber network  

**Points of Presence** - Consists of Edge locations and Regional edge cache servers  
with Amazon CloudFront, amazon operates the largest  
Content Delivery Network (CDN) 

Apps partitioned across multiple AZ are better protected against natural disasters
App running in 3 AZ, a **Load Balancer** is used to distribute traffic across them.  

If one AZ has an outage, traffic is routed to other AZ throught the load balancer 
(Elastic Load Balancer)






Expand operations from almost anywhere in the world.  



