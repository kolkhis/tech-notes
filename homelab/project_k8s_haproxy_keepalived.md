# Project - K8s Cluster using HAProxy Load Balancer and Keepalived


Feats:
- Multi-node k8s cluster (1+ control, 2+ workers)
- HAProxy load balancer to distribute traffic to the k8s nodes
- Keepalived will run on both HAProxy VMs to manage a shared Virtual IP (VIP)
    - This will allow both HAProxy VMs to have the same IP



## Spin up VMs
Three to start:
* `control-node1`
* `worker-node1`
* `worker-node2`

Initialize k8s cluster on `control-node1`



## Misc Notes
* `SSL_ERROR_ZERO_RETURN`: The documentation specifies that `SSL_ERROR_ZERO_RETURN` is returned if
  the transport layer is closed normally

