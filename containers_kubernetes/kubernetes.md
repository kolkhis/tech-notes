# Kubernetes
Kubernetes (or "k8s") is a container orchestration system for automating application 
deployment, scaling, and management.

It solves many problems that arise from managing containerized applications at scale.  


## k3s
k3s is a fully compliant Kubernetes distribution designed to be extremely lightweight.  
It ships as a single binary and it's incredibly easy to install on most platforms.  

With k3s, you sacrifice the deep granularity and control that you get from k8s.  

---

To install `k3s`:
```bash
curl -sFL https://get.k3s.io | sh -  # Install k3s
# or, if that doesn't work
curl -sL https://get.k3s.io | sh -  # Install k3s
```
* `-s`: Silent mode.  
* `-F`: Emulates pressing `Submit` on a filled-in form.  
* `-L`: Follows redirects.  


## `kubectl`
`kubectl` is the command-line interface for interacting with Kubernetes clusters.  

```bash
kubectl version
kubectl get nodes
kubectl get pods -A  # Get all pods from all namespaces
kubectl get ns       # Show all the namespaces
kubectl get pods -n kube-system # scope down to the kube-system namespace
kubectl get pods -n kube-system -o wide # scope down to the kube-system namespace
kubectl get pods -n kube-system -o wide --show-labels # scope down to the kube-system namespace
```


## Shameful 
k8s had an `uwu` version: Kubernetes v1.30: Uwubernetes

