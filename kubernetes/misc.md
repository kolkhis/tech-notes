# Misc K8s/Podman/Container Notes
* [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

## Security Practices with Containers

* Using a smaller base image to run the application can be more secure.
    * This is because 


## Limitations of Containers

* Containers share the same kernel as the host machine.  
    * This means that you cannot run a Windows container on a Linux host, and visa
      versa, without some sort of virtualization.  


<!-- difference between containers and pods -->
## Pods vs. Containers
Containers and pods are two different concepts.  

Containers are individual instances of an application, focused on running a single
process or service.  

Pods are essentially a layer of abstraction on top of containers, used to group
containers that work together closely and share their network and storage.  


### Containers
Containers are single, isolated application instances.  

A container is an isolated instance of an application with its own filesystem, 
network stack, and process space.  
It runs a single process or service (though it can technically run multiple
processes).  

Containers package an application and its dependencies, making it portable and 
consistent across environemtns.  

Containers are the basic unit of deployment.
They're intended to run a single microservice or an application process.  

---


### Pods


A pod is collection of one or more containers that are tightly coupled and share the
same network and storage resources. 
Containers within a pod can communicate with each other via `localhost` and share volumes.  

All containers within a pod share the same contexts.
This means they share an IP address, network namespace, and storage volumes. 
This enables them to work closely together as parts of a single service.  

In Kubernetes, a pod is the smallest deployable unit. Not a container. 
Even if there is only one container, it will still be part of a pod.  
Pods enable better organization and scaling of applications by allowing multiple
containers to function as a single unit.  

---

### Operators

An operator is a piece of software that turns a complex application into a 
native K8s **object** that can be controlled with yaml.  

A Custom Resource (CR) is used to interact with the operator.  


## Things to Look Up

* Blue Green Deployment
  <img src="https://storage.googleapis.com/killercoda-prod-europe1/repositories/het-tanis/Kubernetes-Labs/blue-green-deployments/assets/blue_green.png"/>
    * Blue is the version of the app running in prod. You cut over 100% of traffic into a Green (new version of Blue) deployment.  
    * Allows you to seamlessly switch over to a new version of an application without any downtime.  
    * [het's lab on blue/green deployments](https://killercoda.com/het-tanis/course/Kubernetes-Labs/blue-green-deployments)  


* Canary Deployment 
    * Similar to blue/green deployment, but allows you to roll out a new version of your application to a subset of users before rolling it out.  
    * 80% of the users will be sent to version 1, 20% of users will be sent to version 2.  
    * [het's lab on canary deployments](https://killercoda.com/het-tanis/course/Kubernetes-Labs/canary-deployments)


