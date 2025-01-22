# Project - K8s Cluster using HAProxy Load Balancer and Keepalived


Feats:
- Multi-node k8s cluster (1+ control, 2+ workers)
- HAProxy load balancer to distribute traffic to the k8s nodes
- Keepalived will run on both HAProxy VMs to manage a shared Virtual IP (VIP)
    - This will allow both HAProxy VMs to have the same IP


## Set up the Environment
### Spin up VMs
Three to start:
* `control-node1`
* `worker-node1`
* `worker-node2`

### Install K8s
We need `kubeadm`, `kubelet`, `kubectl` on each node.  




### Initialize k8s Cluster
Initialize the k8s cluster on `control-node1`.  
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```
<!-- TODO: Where are we getting this IP from? -->

### Install a CNI plugin (flannel)
<!-- TODO: What is a CNI plugin? What is it used for? How does it help in this case? -->

```bash
kubectl apply -f \
    https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

### Join the Worker Nodes
Use `kubeadm join` to join the worker nodes.  
```bash
kubeadm join ...
```
<!-- TODO: How do I do this? What does joining worker nodes do? Please break down this command -->


### Deploy a Test App
Deploy a test app for the cluster to serve.  
```bash
kubectl create deployment nginx-demo
kubectl scale deployment nginx-demo --replicas=2
kubectl expose deployment nginx-demo --type=NodePort --port=80
```
<!-- TODO: What is this doing? Please break down each of these commands. -->  

### Check which NodePort was Assigned
When using `--type=NodePort`, you need to check which one was assigned.  
<!-- TODO: What is a node port? Explain this to me in depth, I don't know anything about this. -->  
```bash
kubectl get svc nginx-demo
```
<!-- TODO: What is 'get svc'? -->
You'll see a port, for example `30080`
Then reach the app at `<node-ip>:30080` 


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
<!-- TODO: How do I determine what I should put in the `virtual_ip_address` field? -->
* `state`: Set to `MASTER` on the primary node.  
* `interface`: The real network interface name (e.g., `eth0`, `ens3`, etc.).  
* `virtual_router_id`: Must match on both nodes. Can be any number between 0-255.  
* `priority`: The primary node should have a higher priority than the secondary node.  
* `virtual_ipaddress`: The actual virtual IP and subnet in CIDR notation.  
<!-- TODO: Do I get to pick what the virtual IP is going to be? I don't get how this works. -->  

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
Hit `keepalived` with a `enable --now` on both of the HAProxy nodes.  
```bash
sudo systemctl enable keepalived --now
```
<!-- TODO: Does adding `--now` also triggers `systemctl start`? Or am I wrong about this? -->

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


## Misc Notes
* `SSL_ERROR_ZERO_RETURN`: The documentation specifies that `SSL_ERROR_ZERO_RETURN` is returned if
  the transport layer is closed normally

