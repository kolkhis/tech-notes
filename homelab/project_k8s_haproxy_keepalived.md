# Project - K8s Cluster using HAProxy Load Balancer and Keepalived

## Table of Contents
* [Set up the Environment](#set-up-the-environment) 
    * [Spin up VMs](#spin-up-vms) 
    * [Install K8s](#install-k8s) 
    * [Initialize k8s Cluster](#initialize-k8s-cluster) 
    * [Install a CNI plugin (flannel)](#install-a-cni-plugin-flannel) 
    * [Join the Worker Nodes](#join-the-worker-nodes) 
    * [Deploy a Test App](#deploy-a-test-app) 
    * [Check which NodePort was Assigned](#check-which-nodeport-was-assigned) 
* [Set up two HAProxy Nodes](#set-up-two-haproxy-nodes) 
    * [Configure HAProxy](#configure-haproxy) 
* [Set up Keepalived for a Virtual IP (VIP)](#set-up-keepalived-for-a-virtual-ip-vip) 
    * [Install Keepalived on the HAProxy Nodes](#install-keepalived-on-the-haproxy-nodes) 
    * [Configure Keepalived](#configure-keepalived) 
        * [First HAProxy Node's Keepalived Configuration](#first-haproxy-nodes-keepalived-configuration) 
        * [Second HAProxy Node's Keepalived Configuration](#second-haproxy-nodes-keepalived-configuration) 
    * [Start/Restart Keepalived](#startrestart-keepalived) 
* [Test the Virtual IP and Failover](#test-the-virtual-ip-and-failover) 
* [tl;dr](#tldr) 
* [Misc Notes](#misc-notes) 


Feats:
- Multi-node k8s cluster (1+ control, 2+ workers)
- HAProxy load balancer to distribute traffic to the k8s nodes
- Keepalived will run on both HAProxy VMs to manage a shared Virtual IP (VIP)
    - This will allow both HAProxy VMs to have the same IP

---

TODO:
- Add more Control Plane nodes (2 more?) for real HA
- Ingress controller 
    - `Traefix`, `Nginx`, `HAProxy Ingress`
- K8s API Server load balancing
    - HAProxy only balances traffic to worker nodes via NodePort
    - Set up HAProxy to handle PAI server traffic (`kube-apiserver`)
    - Add an HAproxy frontend for the k8s api server (`6443`) and point it to control nodes
- Add SSL termination
    - SSL certs with Let's Encrypt
- Add storage and Persistent Volumes (PVs) 
    - NFS storage (CSI driver for Synology)

Consider:
- Kube-VIP v. Keepalived?
- Cloudflare / Zero Trust

Deps:
- A container runtime interface (CRI)
    - Containerd
    - CRI-O


## Overview
Minimum of 5 VMs
- 1 k8s control node
- 2 k8s worker nodes
- 2 haproxy load balancer nodes (running a VIP with keepalived)


We'll need to install these tools on all of the nodes:
* `kubeadm`: the command to bootstrap the cluster.
* `kubelet`: the component that runs on all of the machines in your cluster and does 
  things like starting pods and containers.
* `kubectl`: the command line util to talk to your cluster.



## Set up the k8s Environment
### Spin up VMs
Three to start:
* `control-node1`
* `worker-node1`
* `worker-node2`

To scale, you'd just create more worker nodes.  

The HAProxy nodes are separate.  
* `haproxy-lb1`
* `haproxy-lb2`

Add more load balancers to scale if more redundancy is needed.  


---

In a prod-like HA setup, the load balancers (HAProxy) typically run on separate hosts from the worker nodes.  
If a worker node crashes or is busy, you don't want that to bring down the load balancer.  
Dedicated load balancer VMs are easier to manage/configure/reboot without affecting 
the worker pods.  
With Keepalived, you want 2 distinct machines to have a failover mechanism for HA.  

### Install K8s
We need `kubeadm`, `kubelet`, `kubectl` on each node.  

### K8s install with package managers
#### Install k8s on Rocky/RedHat-based
[docs](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)
```bash
# disable swap (required for k8s)
sudo swapoff -a
sed -i '/swap/d' /etc/fstab  # Permanently disable swap

# set selinux to permissive
if [[ $(getenforce | tr '[:upper:]' '[:lower:]') == enforcing ]]; then
    sudo setenforce 0
    sudo sed -i -E 's/^(SELINUX=)enforcing$/\1permissive/' /etc/selinux/config
fi


# make sure deps exist
sudo dnf install -y yum-utils device-mapper-persistent-data lvm2

# Add k8s repository
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF


# install k8s components
sudo dnf install -y kubelet kubeadm kubectl

# start the kubelet service
sudo systemctl enable --now kubelet

##################### Configuration ####################
# configure sysctl settings (kernel modules)  
# Add a file in /etc/modules-load.d/ that specifies what kernel modules k8s needs.
# the br_netfilter module allows the network bridge traffic to be passed through iptables.
# required by some CNIs (flannel) and others that rely on bridge networking
# also used when working with Kube-proxy
# The overlay module enables OverlayFS, which is used to manage container layers.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
overlay
EOF

# use modprobe to add the `br_netfilter` and `overlay` Linux Kernel Modules without needing a reboot
sudo modprobe br_netfilter
sudo modprobe overlay

# /etc/sysctl.d/ stores config files for persistent kernel settings.  
# This allows bridged ipv4 and ipv6 packets to be processed by iptables.  
# Required for CNIs that rely on Linux bridges. 
# Also enable IP forwarding
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# This modifies the kernel runtime parameters on the fly, and loads everything in the sysctl.d/*.conf files
sudo sysctl --system

# open necessary ports in firewalld
if [[ $(sudo systemctl is-active firewalld) == 'active' ]]; then
    printf "Opening necessary ports in firewalld.\n"
    case $(hostname) in 
        *control*|*master*)
            sudo firewall-cmd --permanent --add-port={6443,2379,2380,10250,10251,10252,10257,10259,179}/tcp
            sudo firewall-cmd --permanent --add-port=4789/udp
            sudo firewall-cmd --reload
            ;;
        *worker*)
            sudo firewall-cmd --permanent --add-port={179,10250,30000-32767}/tcp
            sudo firewall-cmd --permanent --add-port=4789/udp
            sudo firewall-cmd --reload
            ;;
        *)
    esac
fi

# Install containerd
printf "Adding the Docker-ce repository for containerd.\n"
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install -y containerd.io

```
##### Firewalld Rules
* Calico: Uses `BGP` (Port `179/tcp`)
* Flannel: Uses VXLAN (Port `4789/udp`)
    * Flannel can also use `8472/udp` for other backend modes (`host-gw`, `IPIP`),
      but VXLAN is the default.  

The ports being opened:
- Control Node Only
    - `6443/tcp`: Kubernetes API server (control plane)
    - `2379-2380/tcp`: `etcd` database communication
    - `10251/tcp`: KLube-scheduler
    - `10257/tcp`: `kube-apiserver` authentication webhook
    - `10259/tcp`: `kube-controller` authentication webhook
- Control+Worker
    - `179/tcp`: BGP (for Calico networking, not needed with Flannel) 
    - `4789/udp`: VXLAN (Overlay networking, used by Flannel and Calico)
    - `10250/tcp`: Kubelet API (for node communication)
* Worker Nodes Only
    - `30000-32767/tcp`: NodePort Services (worker nodes)

```
179/tcp
2379/tcp
2380/tcp
6443/tcp
10250/tcp
10251/tcp
10252/tcp
10257/tcp
10259/tcp
4789/udp
```

Masquerading:
* `firewall-cmd --add-masquerade --permanent`
    * Adds a `MASQUERADE` rule to `iptables` (used by firewalld)
    * Ensures that packets exiting the node can use the node's external IP.  

---

Verification:
```bash
# verify iptables rules allow inter-node traffic
sudo iptables -L -n -v | grep MASQUERADE
# if flannel isn't working, maybe try forwarding explicitly
sudo iptables -P FORWARD ACCEPT
```

#### Install k8s on Ubuntu/Debian-based
[docs](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)
```bash
# disable swap (required for k8s)
sudo swapoff -a
sed -i '/swap/d' /etc/fstab

# install deps
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg

# add k8s repo
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

# overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

# install k8s components
sudo apt update
sudo apt install -y kubelet kubeadm kubectl

# enable the kubelet service
sudo systemctl enable --now kubelet

# configure sysctl settings  
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
overlay
EOF

# add the `br_netfilter`/`overlay` Linux Kernel Modules
sudo modprobe br_netfilter
sudo modprobe overlay

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
```

#### Next Steps for both RedHat and Debian
Verify the installtion
```bash
kubeadm version
kubelet --version
kubectl version --client

# Generate bash completion script for kubectl 
kubectl completion bash
# enable kubectl autocompletion in .bashrc (requires `bash-completion`)
echo 'source <(kubectl completion bash)' >> ~/.bashrc

# if you have an alias for kubectl, you can extend the compltion to work with the alias
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
```



* Initialize the cluster (done later).  

### Set up `kubeconfig`
```bash
mkdir -p "$HOME/.kube"
sudo cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown $(id -u):$(id -g) "$HOME/.kube/config"
```




### Initialize k8s Cluster
Initialize the k8s cluster on `control-node1`.  
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

---
More info:  
When you run `kubeadm init`, you use the `--pod-network-cidr` flag to specify the IP
address range for pods in the cluster.  
* `10.244.0.0/16` defines a network range from `10.244.0.0` up to `10.244.255.255`
* Typically choose a private, non-routable IP range to avoid conflicts with external
  networks.  
`10.244.0.0/16` is a common default used by certain Container Network Interface (CNI)
plugins like Flannel.  
You can technically pick another private range but most Flannel docs uses `10.244.0.0/16`.  

---

### Install a CNI plugin (flannel)
The CNI needs to be installed on all of the nodes that are running kubernetes.  

```bash
kubectl apply -f \
    https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Or, if you want to use Calico:
```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

---
More info:  
A CNI plugin is in charge of setting up network interfaces in Linux containers and 
assigning IP addresses to those containers.  

In k8s, when pods come online the CNI plugin automatically creates network interfaces
and routes inside each node, and ensures that all pods can communicate with
each other (even across different k8s nodes) without needing NAT.  

Flannel is one of the CNI plugin options. Some others are Calico, Weave Net, Cilium, etc.  

It helps by providing the network overlay so that each pod gets its own unique IP
address within the `10.244.0.0/24` range.  
Without a CNI plugin, pods wouldn't be able to communicate across node boundaries seamlessly.  


### Join the Worker Nodes

SSH into each node and run the `kubeadm join` command that was generated by the 
control plane when the cluster was initialized with `kubeadm init`.  

Use `kubeadm join` to join the worker nodes.  
```bash
kubeadm join ...
```
* [next](#deploy-a-test-app)

---
More info:  
When initializing k8s with `kubeadm init`, near the end it prints join instructions.  

```bash
kubeadm join 192.168.4.50:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:abcdef123456789
```
* `kubeadm join <api-server-ip>:6443`: Points the worker node to the control plane's API server.  
* `--token`: Secret token that authorizes the worker to join.  
* `--discovery-token-ca-cert-hash`: Ensures the node is connecting to the right
  master by verifying the CA cert hash.  


---
* SSH into each node and run the `kubeadm join` command that was generated by the control plane. 
* The node will contact the master, authenticate with the token and CA hash, then
  pull down the cluster config.  
* After a minute or two, the node should appear in `kubectl get nodes` on the control plane.  



### Deploy a Test App
Deploy a test app for the cluster to serve.  
```bash
kubectl create deployment nginx-demo --image=nginx:stable
kubectl scale deployment nginx-demo --replicas=2
kubectl expose deployment nginx-demo --type=NodePort --port=80
```

---

What these commands are doing:
* `kubectl create deployment nginx-demo`: Creates a `deployment` resource in k8s
  named `nginx-demo`.  
    * By default it uses the `nginx` image from DockerHub unless you specify another
      `--image`.  
    * Add `--image=nginx:stable` to make sure it's the right container image.  
* `kubectl scale deployment nginx-demo --replicas=2` 
    * Tells k8s to run 2 `replicas` (or copies) of the Pods managed by the
      `nginx-demo` deployment.
    * This ensures that if one Pod fails or one node goes down, there's another to
      handle requests.  
* `kubectl expose deployment nginx-demo --type=NodePort --port=80`
    * Creates a `service` of the type `NodePort`.  
    * This service listens on port 80 ***internally*** (the target port on the
      container) and exposes it on a high port on each node (the NodePort).  
    * This allows you to access the `nginx-demo` Pods from outside the cluster.  



### Check which NodePort was Assigned
So, when using `--type=NodePort`, you need to check which one was assigned.  
```bash
kubectl get svc nginx-demo
```

* `kubectl get <resource>` shows the current state of resources (pods, deployments, services)
* `get svc` is shorthand for "get services".  
    * This will list all Services in the current namespace, along with their cluster IP,
      external IP, ports, etc.  

You'll see a high number port, e.g., `30080`
Then reach the app at `<node-ip>:30080` 

---

In k8s, a NodePort is one of the ways to expose a service externally.  
This means that you can access the service from any node's IP, on that port, and k8s
will route the traffic to the correct Pod/Pods.


## Set up two HAProxy Nodes
We'll have two VMs, `haproxy-lb1` and `haproxy-lb2`.  

On both nodes, install `haproxy` with the package manager.  
```bash
# Debian-based:
sudo apt-get update && sudo apt-get install haproxy -y
# RedHat-based:
sudo dnf install haproxy -y
```

### Configure HAProxy 
Give HAProxy a minimal configuration in `/etc/haproxy/haproxy.cfg`
```cfg
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    user haproxy
    group haproxy
    daemon

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5s
    timeout client 30s
    timeout server 30s

frontend http_front
    bind *:80
    default_backend k8s_backend

backend k8s_backend
    balance roundrobin
    # Point to k8s nodes using the NodePort
    server worker1 192.168.4.67:30080 check
    server worker2 192.168.4.68:30080 check
```
* `frontend`: Receives incoming requests on port 80.  
* `backend`: Sends the requests to the kubernetes nodes on the NodePort.  
(change IP addresses accordingly)  

Then restart HAProxy
```bash
sudo systemctl restart haproxy
sudo systemctl enable haproxy --now
```
* `--now` also tells it to `start` in addition to `enable`.  

At this point, each HAProxy node should be able to forward traffic independently to 
the k8s cluster.  

Now to set up Keepalived.  

## Set up Keepalived for a Virtual IP (VIP)
The goal here is to create a single IP address that automatically fails over between
the two HAProxy nodes (`haproxy-lb1` and `haproxy-lb2`).  

### Install Keepalived on the HAProxy Nodes
Install `keepalived` on both of the HAProxy nodes using the package manager.  
```bash
# Debian-based
sudo apt-get update && sudo apt-get install keepalived -y
# RedHat-based
sudo dnf install keepalived -y
```

### Configure Keepalived
The config file for keepalived is at `/etc/keepalived/keepalived.conf`.  

#### First HAProxy Node's Keepalived Configuration
```conf
vrrp_instance VI_1 {
    state MASTER            # MASTER on the primary node, BACKUP on the secondary
    interface ens18         # The network interface connected to the LAN (ip addr)
    virtual_router_id 51    # needs to be the same on both nodes
    priority 100            # Highest priority indicates the active MASTER node
    advert_int 1            # advertisement interval, in seconds
    authentication {
        auth_type PASS
        auth_pass secretpassword123
    }
    virtual_ipaddress {
        192.168.1.250/24   # adjust to match network
    }
}
```

* `state`: Set to `MASTER` on the primary node.  
* `interface`: The real network interface name (e.g., `eth0`, `ens3`, etc.).  
* `virtual_router_id`: Must match on both nodes. Can be any number between 0-255.  
* `priority`: The primary node should have a higher priority than the secondary node.  
* `virtual_ipaddress`: The actual virtual IP and subnet in CIDR notation.  
    * Pick an IP address that is in the same subnet as your network interface. 
        * e.g., `192.168.4.x/24`
    * This can't already be in use, and it should be reserved for this virtual IP.  
    * All the `keepalived` instances need to use the same IP in the config.  

#### Second HAProxy Node's Keepalived Configuration
Two things that need to be changed on the secondary node's configuration:  
* `state`: Needs to be `MASTER` on the primary node, `BACKUP` on the secondary node.  
* `priority`: Lower than the `MASTER`'s priority to make sure `MASTER` is active.  
Everything else should match the first node's config. Same `virtual_router_id`,
`auth_pass`, VIP.  
```conf
vrrp_instance VI_1 {
    state BACKUP            # MASTER on the primary node, BACKUP on the secondary
    interface ens18         # The network interface connected to the LAN (ip addr)
    virtual_router_id 51    # needs to be the same on both nodes
    priority 90             # Highest priority indicates the active MASTER node
    advert_int 1            # advertisement interval, in seconds
    authentication {
        auth_type PASS
        auth_pass secretpassword123
    }
    virtual_ipaddress {
        192.168.1.250/24   # adjust to match network
    }
}
```

### Start/Restart Keepalived
Hit `keepalived` with a `enable --now` on both of the HAProxy nodes to both enable
and start the service.  
```bash
sudo systemctl enable keepalived --now
```

---

At this point, the `haproxy-lb1` *should* hold the Virtual IP `192.168.1.250` (or whatever is specified in the `keepalived.conf` file).  

## Test the Virtual IP and Failover

* Ping the virtual IP to make sure it's responding.  
  ```bash
  ping -c 5 192.168.1.250
  ```

* Use `curl` on the VIP on port 80 to make sure it's responding.  
  ```bash
  curl http://192.168.1.250
  ```
    * This should show the nginx welcome page.  

* Simulate a failover by stopping `keepalived` on `haproxy-lb1`.  
  ```bash
  sudo systemctl stop keepalived
  ```
    * Wait a few seconds and then ping the IP again, and `curl` it again.  
    * The VIP should now move over to `haproxy-lb2`.  

* Fail back by restarting `keepalived` on the `haproxy-lb1` node.  
  ```bash
  sudo systemctl start keepalived
  ```
    * The VIP should fail back to the `haproxy-lb1` node since it has the 
      higher `priority` in its config.  


## tl;dr
1. Spin up a minimal Kubernetes cluster with 2–3 nodes.
2. Install HAProxy on two separate nodes/VMs. Configure each with the same backend servers pointing to your Kubernetes NodePorts.
3. Configure a VIP in `keepalived` (e.g., 192.168.1.250) so only the active (MASTER) HAProxy owns that IP at a time.
4. If the primary HAProxy goes down, Keepalived automatically assigns the VIP to the backup HAProxy, maintaining high availability.

## Misc Notes
* `SSL_ERROR_ZERO_RETURN`: The documentation specifies that `SSL_ERROR_ZERO_RETURN` is returned if
  the transport layer is closed normally

- In HAProxy you can enable the `stats` page to monitor traffic and do node healthchecks.  
- Make sure the NICs on HAProxy servers have static IP addresses so the VIP stays in
  the same subnet

* kubevip

* Cloudflare to get into cluster  
    * Cloudflare zero trust 
* Traefik proxy
* Authentik SSO (internal authentication)

---

* nfs storage (csi-driver for synology)

---

* `kubectl convert`: A plugin for kubectl which allows you to convert manifests
  between different api versions. 
    * Install with:
      ```bash
      # download the latest release
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert"

      # Optional: validate the binary
      # download the cksum
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert"
      # check it
      echo "$(cat kubectl-convert.sha256) kubectl-convert" | sha256sum --check

      # install kubectl-convert
      sudo install -o root -g root -m 0755 kubectl-convert /usr/local/bin/kubectl-convert
      # verify installation
      kubectl convert --help

      # clean up installation files
      rm kubectl-convert kubectl-convert.sha256
      ```

## Resources
* [Installing `kubeadm`](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
* [Installing `kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)
* [Installing all 3 `kube` tools](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)

