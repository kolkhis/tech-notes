
# Misc Kubernetes/Podman/Container Notes
* [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

## Security Practices with Containers

* Using a smaller base image to run the application can be more secure.
    * This is because 


## Limitations of Containers

* Containers share the same kernel as the host machine.  
    * This means that you cannot run a Windows container on a Linux host, and visa
      versa, without some sort of virtualization.  


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


