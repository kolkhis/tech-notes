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

### Deploy AWX
Now that k3s is set up and the AWX operator is installed, we can deploy AWX
itself.  

First, create a namespace for AWX.  
```bash
kubectl create ns awx
```
Then we create an AWX **Custom Resource (CR)** file named `awx.yaml`.  
```bash
touch awx.yaml
vi awx.yaml
```
Add the configuration:
```yaml
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
  namespace: awx
spec:
  service_type: nodeport
  replicas: 1
```

Then we can `apply` it.  
```bash
kubectl apply -f awx.yaml
```

Watch for it to come up.
```bash
kubectl get pods -n awx -w
```

It may take a couple minutes for it to fully come online.  

### Access the UI

Now that everything is set up, we can access the AWX Web UI.  
First, we need to know which port we need to use to access it via HTTP.  
```bash
kubectl get svc -n awx
```
This will show more info than we need, just look for the part that looks
something like `80:30080/TCP`. This is the NodePort mapping.  

Once we have the NodePort, we can access it in the browser via the host node's 
IP. This will be different in your own environment.  
```plaintext
http://192.168.1.200:30080
```

It will prompt a login. We can get the admin password with the following
command:
```bash
kubectl get secret awx-admin-password -n awx -o jsonpath="{.data.password}" | base64 -d
```
Then login with the username `admin` and the password from that command.  

Then we've got it working. That's a minimal setup of Ansible AWX using k3s.  

This process can get much more elaborate with full Kubernetes, adding ingress, 
TLS for certificate signing, webhooks, Vault integrations, LDAP/AD
authentication, etc.  

## Resources

- <https://spacelift.io/blog/ansible-awx>
- <https://www.raptorswithhats.com/2022-05-getting-started-with-awx/>
- <https://github.com/ansible/awx>


