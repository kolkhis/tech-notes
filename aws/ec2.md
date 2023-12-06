
# Amazon EC2

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





