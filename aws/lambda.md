
## Help for AWS: 
## SprintTrainingHelp@amazon.com  
## Whitepages  
## FAQs  

# What is AWS Lambda?  
Serverless compute.  

Allows you to run code without managing servers.  

No server to manage.  

Provides compute by running code in response to an event.  

When an event happens, that event will trigger a lambda function.  
The lambda function will run a function in response to that event.  


---  

AWS Lambda is a serverless, event-driven compute service that lets you run code  
for virtually any type of application or backend service 
without provisioning/managing servers.  

You can trigger lambda from over 200 AWS services and software as a service (SaaS) applications,
and only pay for what you use.  
Only need to pay for the time when the code is running.  


## Use Case  
AWS Lambda is best for those types of situations when you need to run code  
when any type of event happens.  

* It's serverless - you don't need to *manage* the underlying server.  
* If you start sending more requests to that lambda function, it'll scale itself automatically.  
    * It automatically scales up and down, based on the traffic going into it.  

Lambda functions can run for up to 15 minutes, and if something is required to run randomly  
based on conditions, severless functions may be the way to go.  
Up to 1000 AWS Lambda instances may be spawned at once.  

## Scaling with Lambda  

There are two types of scaling: Horizontal and Vertical.  
* Horizontal scaling:  
    * Adding more instances of existing services.  
    * Adding additional compute *loads* (more requests can be handled simultaneously).  
    * Fanning out left to right: horizontal scaling.  

* Vertical scaling:  
    * Giving the service more horsepower: vCPU and compute power.  
    * Adding additional compute power is vertical scaling.  


So, you *can* assign resources to a lambda function (scaling vertically).  
i.e., assigning it more RAM, etc.  
It's very good at scaling horizontally (spinning up more instances of that lambda.)  
* It automatically scales when you send traffic to it.  
* Lambda Functions can scale horizontally with a concurrency limit of 1000  



---  


