
# EC2 Pricing Plans  

## EC2 On-Demand Pricing  
Billing by the hour or second, with modifiable compute capacity.  

Workload Types  
* Short term / fluctuating  
* Uninterrupted run times  
* Development and test environments  

Least Commitment - On-Demand  
* Low cost/flexible  
* Only pay per hour  
* Short-term, spiky, unpredictable workloads  
* Cannot be interrupted  
* For first time apps  


## EC2 Reserved Instances Pricing  
Up to 72% less than on-demand pricing; instances available as-needed.  
They are available as-needed because you *reserved* them.  
- Based on "ability to commit" to using the instance  
(Customer able to commit to 1-yr to 3-yr term).  

Can resell unused reserved instances (when your business makes a change).  

Workload Types:  
* Steady-state applications  
* Predictable usage  

## EC2 Spot Instances Pricing  
Steep discounts, run continuously for a set duration at lower price points.  

AWS has all that compute capacity (specific region, specific instance type), and  
it's not *all* in use *all* the time. That's where Spot Instances come in.  
Depending on certain workloads/use cases, e.g., batch processing job 1/week  
Whenever AWS has UNUSED/SPARE compute capacity, I'm willing to pay this amount 
for that EC2 instance type.  
It will sit there ready to run until AWS has an instance available that meet the 
instance type, price point, etc  
It can handle interruptions.  
Your spot instance is not guaranteed.  
Once you start using it, it can be taken away from you (person is willing to pay
full price for it)  
- You get a 2 minute warning when this happens  
- Your application should be able to pause, wait for another spot instance to become available, and then continue where it left off.  
- Good for programs that can be resumed without negative impact.  

The bidding process on spot instances:  
There's a general "market price". You say "I'm willing to pay {x} amount for a spot instance."  
As long as the "market price" stays below your bid, you'll keep it.  
When the "market price" goes up, you lose that spot instance.  
Up to 90% discount.  

Savings Plan vs Spot Instances Plan  
* Savings plans: Agnostic to location. Discount for a SET level of compute usage, and it's GLOBAL.  
    - You commit to a usage level  
    - You can use savings plans beyond EC2 instances.  
* Spot Instances: Set to a specific instance family, in a specific AWS location.  

## Dedicated Hosts Pricing  
Physical EC2 server fully dedicated to your use (Single Tenant Environment)  

Normally, an EC2 instance would partition components of the same underlying hardware for  
you to share with another user, although it's isolated - the other user will not have  
access to your data.  

But if you're, for instance, a government entity and need the promise of exclusive use of  
hardware, you'll want a dedicated host.  

When you need a guarantee of isolated hardware,
dedicated hosts is the pricing model you'll follow.  
