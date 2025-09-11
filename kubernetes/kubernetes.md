# Kubernetes

Kubernetes (or "k8s") is a container orchestration system for automating application 
deployment, scaling, and management.

It solves many problems that arise from managing containerized applications at scale.  


## Table of Contents
* [k3s](#k3s) 
* [`kubectl`](#kubectl) 
* [k3s Exercise: Setting up a Small Cluster](#k3s-exercise-setting-up-a-small-cluster) 
* [Helm](#helm) 


## k3s
k3s is a fully compliant Kubernetes distribution designed to be extremely lightweight.  
It ships as a single binary and it's incredibly easy to install on most platforms.  

With k3s, you sacrifice the deep granularity and control that you get from k8s.  

---

To install `k3s`:
```bash
curl -sFL https://get.k3s.io | sh -  # Install k3s
# or, if that doesn't work
curl -sL https://get.k3s.io | sh -   # Install k3s
```

* `-s`: Silent mode.  
* `-F`: Emulates pressing `Submit` on a filled-in form.  
* `-L`: Follows redirects.  


## `kubectl`
`kubectl` (Kube Control) is the command-line interface for interacting with Kubernetes clusters.  

> Also see [kubectl commands](./kubectl.md)

```bash
kubectl version
kubectl get nodes
kubectl get pods -A  # Get all pods from all namespaces
kubectl get ns       # Show all the namespaces
kubectl get pods -n kube-system # scope down to the kube-system namespace
kubectl get pods -n kube-system -o wide # scope down to the kube-system namespace
kubectl get pods -n kube-system -o wide --show-labels # scope down to the kube-system namespace
```




## k3s Exercise: Setting up a Small Cluster

* Create a pod named 'webpage' with the image 'nginx'
  ```bash
  kubectl run webpage --image=nginx  
  ```

* Create a pod named `database` with the `redis` image, and set to `tier=database`.  
  ```bash
  kubectl run database --image=redis --labels=tier=database
  ```

* Create a service wit hthe name `redis-service` to expose the database pod within
  the cluster on port `6379`, which is the default `redis` port.
  ```bash
  kubectl expose pod database --port=6379 --name=redis-service --type=ClusterIP
  ```

* Create a deployment called `web-deployment` using the image `nginx` that has 3
  replicas.  
  ```bash
  kubectl create deployment web-deployment --image=nginx --replicas=3
  ```

* Verify that the pods are created
  ```bash
  kubectl get deployments
  kubectl get pods
  ```

* Create a new namespace called `webns`
  ```bash
  kubectl create namespace webns
  ```

* Create a new deployment called `redis-deploy` with the image `redis` in the `webns`
  namespace with 2 replicas.  
  ```bash
  kubectl create deployment redis-deploy --image=redis -n webns --replicas=2
  ```


## Helm
Helm is a package manager for Kubernetes. 
Helm uses what they call "Helm Charts."  

Helm charts are a way to define/simplify deployment and management of applications with Kubernetes. 

A helm chart is a package that contains three main components:

* Templates: YAML files for Kubernetes manifests, which can be deployments, services, configMaps, secrets, etc. 
* Values: Config files that allow for customization without modifying the templates themselves 
* Metadata: Info about the chart (version, app name, etc.) 


---

Bit of history: k8s had an `uwu` version: Kubernetes v1.30: Uwubernetes

