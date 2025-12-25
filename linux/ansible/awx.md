# AWX

AWX is an open-source project that provides a web UI for Ansible automation. 
AWX also provides a REST API that can be accessed programmatically.

It is considered a free and open-source alternative to Ansible Automation Platform
(AAP) which is a paid software from RedHat. In fact, AAP is downstream from the AWX
project.  


## Getting Started

Typically, AWX is installed within a Kuberenetes cluster.  

Previously, it was a viable option to use Docker-compose rather than k8s, but 
this has been deprecated in favor of Kubernetes.  

This can be done with k3s instead of full blown Kubernetes. For simplicity's
sake, I'll use that in this writeup. 

### Install K3s
The nice thing about k3s is that it's a single-line installation process.  
```bash
curl -fsSL https://get.k3s.io | sh -
```

This downloads k3s, installs the systemd service, and sets up containerd (so
there's no dependency on Docker).  

Verify with:
```bash
kubectl --version
kubectl get nodes
```

### Install AWX Operator
AWX is deployed via an **Operator**, which is a Kubernetes controller.  
It can be cloned directly from Github:  
```bash
git clone https://github.com/ansible/awx-operator.git
cd awx-operator
```
Then we can deploy it.  
```bash
make deploy
```

This installs the Custom Resource Definitions (CRDs), and the operator pod
starts watching for AWX resources.  

## Resources

- <https://spacelift.io/blog/ansible-awx>
- <https://www.raptorswithhats.com/2022-05-getting-started-with-awx/>
- <https://github.com/ansible/awx>


