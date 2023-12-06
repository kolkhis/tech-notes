
# What does "Loosely Coupled Architectures" mean?  

Check out: [well-architected services](https://aws.amazon.com/architecture/well-architected)  

Task Statement 2.1: Design scalable and loosely  

Each component will be *least* affected by the existence of the other.  
* Insert something into the queue  
* Experience Component failure?  
* Another node can pick it up  
So, the architecture isn't so rigid that a component failure will break  
the service completely.  


### Immutable Infrastructure  
You don't want to store the state of the application on any ONE node.  
* If that node fails, you lose the state  


