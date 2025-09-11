# `kubectl`
`kubectl` is used to interact with the Kubernetes API Server.  

## Table of Contents
* [Essential `kubectl` Commands](#essential-kubectl-commands) 
    * [Basic Cluster Information](#basic-cluster-information) 
    * [Viewing Resources](#viewing-resources) 
    * [Managing Namespaces](#managing-namespaces) 
    * [Pod Management](#pod-management) 
    * [Service Management](#service-management) 
    * [Deployment Management](#deployment-management) 
    * [Resource Management](#resource-management) 
    * [Troubleshooting](#troubleshooting) 
    * [Custom and Utility Commands](#custom-and-utility-commands) 
    * [Getting Output in JSON/YAML Format](#getting-output-in-jsonyaml-format) 


## Essential `kubectl` Commands

### Basic Cluster Information
```bash
kubectl version             # Display the client and server version of Kubernetes
kubectl cluster-info        # Show cluster info and master node details
kubectl config view         # View the kubeconfig file details
kubectl config get-contexts # List all contexts in your kubeconfig file
kubectl config use-context 'context-name' # Switch to a specific context
```

---

### Viewing Resources
```bash
kubectl get nodes                        # List all nodes in the cluster
kubectl get pods                         # List all pods in the current namespace
kubectl get pods -A                      # List all pods across all namespaces
kubectl get services                     # List all services in the current namespace
kubectl get deployments                  # List all deployments in the current namespace
kubectl get replicasets                  # List all replica sets in the current namespace
kubectl get events                       # View events in the current namespace
kubectl get pods -o wide                 # Show additional information, such as node name
kubectl describe pod 'pod-name'          # Get detailed information about a specific pod
kubectl describe svc 'service-name'      # Describe a specific service
kubectl describe node 'node-name'        # View details about a specific node
```

---

### Managing Namespaces
```bash
kubectl get ns                           # List all namespaces
kubectl create namespace 'namespace-name' # Create a new namespace
kubectl delete namespace 'namespace-name' # Delete a namespace
kubectl get pods -n 'namespace-name'     # List pods in a specific namespace
kubectl get all -n 'namespace-name'      # Get all resources in a specific namespace
kubectl config set-context --current --namespace='namespace-name' # Set default namespace for context
```

---

### Pod Management
```bash
kubectl run nginx --image=nginx                         # Create a pod named "nginx" with an nginx container
kubectl delete pod 'pod-name'                           # Delete a specific pod
kubectl logs 'pod-name'                                 # View logs from a specific pod
kubectl logs 'pod-name' -c 'container-name'             # View logs of a specific container in a pod
kubectl exec -it 'pod-name' -- /bin/bash                # Open a shell inside a running pod
kubectl port-forward 'pod-name' 'local-port':'pod-port' # Forward a local port to a pod's port
kubectl cp 'local-file' 'pod-name':'container-path'     # Copy a file to a pod
kubectl cp 'pod-name':'container-path' 'local-file'     # Copy a file from a pod to local
kubectl top pod                                         # View resource usage (CPU/Memory) for pods
```

---

### Service Management
```bash
kubectl expose pod 'pod-name' --type=ClusterIP --port=80      # Expose a pod as a service with ClusterIP
kubectl expose pod 'pod-name' --type=NodePort --port=80       # Expose a pod as a service with NodePort
kubectl expose deployment 'deployment-name' --type=LoadBalancer --port=80 # Expose a deployment as LoadBalancer
kubectl get svc                                              # List all services in the namespace
kubectl delete svc 'service-name'                            # Delete a specific service
```

---

### Deployment Management
```bash
kubectl create deployment 'deployment-name' --image='image-name'      # Create a new deployment
kubectl scale deployment 'deployment-name' --replicas='number'        # Scale deployment to a specific number of replicas
kubectl rollout status deployment 'deployment-name'                   # Check rollout status of a deployment
kubectl rollout history deployment 'deployment-name'                  # View rollout history of a deployment
kubectl set image deployment/'deployment-name' 'container-name'='new-image' # Update container image
kubectl delete deployment 'deployment-name'                           # Delete a specific deployment
```

---

### Resource Management
```bash
kubectl apply -f 'file.yaml'            # Apply a configuration file to create or update resources
kubectl delete -f 'file.yaml'           # Delete resources defined in a configuration file
kubectl edit 'resource-type'/'name'     # Edit an existing resource in place
kubectl patch 'resource-type'/'name' -p ''patch-data'' # Apply a JSON patch to a resource
kubectl replace -f 'file.yaml'          # Replace an existing resource with a new configuration
kubectl diff -f 'file.yaml'             # Preview differences between current and updated configurations
```

---

### Troubleshooting
```bash
kubectl describe 'resource-type' 'name'   # Show detailed information about a resource
kubectl logs 'pod-name'                   # Get logs for a pod
kubectl logs -f 'pod-name'                # Follow logs in real time
kubectl debug 'pod-name' --image='image'  # Debug a pod using a different container image
kubectl get events                        # Check recent events for issues
kubectl get pods --field-selector=status.phase!=Running # List non-running pods
kubectl exec -it 'pod-name' -- /bin/bash  # Access a shell in a running pod
```

---

### Custom and Utility Commands
```bash
kubectl apply -k 'directory'            # Apply Kustomize directory configurations
kubectl get all                         # Get all resource types in the namespace
kubectl explain 'resource-type'         # Get documentation for a specific resource type
kubectl label pod 'pod-name' 'key'='value'    # Add a label to a pod
kubectl annotate pod 'pod-name' 'key'='value' # Add an annotation to a pod
kubectl config view --minify            # View minimal active configuration details
kubectl drain 'node-name'               # Safely evict all pods from a node
kubectl cordon 'node-name'              # Mark a node as unschedulable
kubectl uncordon 'node-name'            # Mark a node as schedulable
kubectl taint nodes 'node-name' key=value:NoSchedule # Taint a node
kubectl untaint nodes 'node-name' key=value:NoSchedule # Remove a taint from a node
```

---

### Getting Output in JSON/YAML Format 

* Use `-o yaml` or `-o json` to view resources in YAML or JSON format.  
  This converts the `-o`utput to a specific format.  
  ```bash
  kubectl get pods -o json
  kubectl get pods -o yaml
  kubectl get deployments -o json
  kubectl get svc -o json
  kubectl get nodes -o json
  kubectl get all -o yaml
  ```
* `kubectl describe` doesn't support the `-o` flag.  
  You can use `get pod` for the `yaml`/`json` output of resource details instead.  
  ```bash
  # Instead of 'kubectl describe', use 
  kubectl get pod 'pod-name' -o yaml
  ```
* Use `--watch` with `kubectl get` commands to observe real-time updates.


## Get the Main PID (Process ID) for `k3s` or `k8s`
Running `systemctl status` on the service will show the main PID for the service.  
```bash
systemctl status k3s | grep -i 'Main PID'
```
Then you can use that PID in other commands.
```bash
ss -ntulp | grep PID
lsof -p PID
```

## Quickly Looking at the Environment
```bash
kubectl version
kubectl get nodes
kubectl get pods -A
kubectl get namespaces
kubectl get configmaps -A
kubectl get secrets -A
```

