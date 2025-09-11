# Deployment Strategies

There are several different deployment strategies used in all applications running
across multiple nodes.  

These are an integral part of understanding how system administration and cluster
administration works.  

## Rolling Updates/Deployments
Rolling updates are when you apply an update to one node at a time.  

## Blue Green Deployment
<img src="https://storage.googleapis.com/killercoda-prod-europe1/repositories/het-tanis/Kubernetes-Labs/blue-green-deployments/assets/blue_green.png"/>

* Blue/Green Deployments are when you 
* Blue is the version of the app running in prod. You cut over 100% of traffic into a 
  Green (new version of Blue) deployment.  
* Allows you to seamlessly switch over to a new version of an application without any downtime.  

* [het's lab on blue/green deployments](https://killercoda.com/het-tanis/course/Kubernetes-Labs/blue-green-deployments)  


## Canary Deployment 
* Similar to blue/green deployment, but allows you to roll out a new version of your 
  application to a subset of users before rolling it out to everyone.  
* An example of this:
    - 80% of the users will be sent to version 1  
    - 20% of users will be sent to version 2 
- This allows you to test on a smaller number of users before rolling an update
  out to everyone.  

* [het's lab on canary deployments](https://killercoda.com/het-tanis/course/Kubernetes-Labs/canary-deployments)
