
# Misc. AWS Notes



## SQS: Queueing Service
SQS is a queueing service:
* AWS Transfer Family
* Amazon Simple Queue Service.
* The concept of "stateless" workloads compared with "stateful" workloads



## Scaling in AWS

* Horizontal scaling:
    * Essentially, more instances of existing services.
    * Adding additional compute loads
    * Fanning out left to right
 
* Vertical scaling:
    * Adding horsepower: vCPU and compute power
    
 
## Service quotas and throttling:
You have certain quotas for AWS products.
If you don't have your proper service quotas set when scaling, it could cause a resiliency issue.


## Edge accelerators
Parallelize 
* Learn how to apporopraitely use edge accelerators (e.g., content delivery network (CDN))


## Misc
Choosing the right storage type for the use-case.
Prob don't wanna run a DB on S3 (might wanna use \*Block)
