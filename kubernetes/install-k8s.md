# Installing Kubernetes on Linux


Installing kubernetes minimally consists of 3 tools.  

We'll need to install these tools on all of the nodes:
* `kubeadm`: the command to bootstrap the cluster.
* `kubelet`: the component that runs on all of the machines in your cluster and does 
  things like starting pods and containers.
* `kubectl`: the command line util to talk to your cluster.

The `kubeadm` tool won't install or manage `kubelet`/`kubectl`.  
You need to make sure they match the version of the k8s control plane you want
`kubeadm` to install.  

The `apt.kubernetes.io` and `yum.kubernetes.io` repos are **deprecated**.  
The new repos are at `pkgs.k8s.io`.  

## Table of Contents
* [Manually Installing K8s Binaries](#manually-installing-k8s-binaries) 
    * [Download/Install `kubectl`](#downloadinstall-kubectl) 
* [K8s install with package managers](#k8s-install-with-package-managers) 
    * [Install k8s on Rocky/RedHat-based](#install-k8s-on-rockyredhat-based) 
    * [Install k8s on Ubuntu/Debian-based](#install-k8s-on-ubuntudebian-based) 
    * [Next Steps for both RedHat and Debian](#next-steps-for-both-redhat-and-debian) 
    * [Set up `kubeconfig`](#set-up-kubeconfig) 
* [Resources](#resources) 

## tl;dr
- Disable swap
- Install deps
    * `sudo apt install -y apt-transport-https ca-certificates curl gnupg`
    * `sudo dnf install -y yum-utils device-mapper-persistent-data lvm2`
- Add the `overlay` and `br_netfilter` kernel modules
    - `/etc/modules-load.d/k8s.conf`
    - Reload with `modprobe br_netfilter` and `modprobe overlay`
- Configure iptables to allow network bridging for both ipv4 and ipv6 as well as ip forwarding
    - `/etc/sysctl.d/k8s.conf`
    - Reload kernel modules with `sysctl --system`
- Add `apt` or `dnf` repositories
- Install `kubelet`, `kubectl`, `kubeadm`


## Manually Installing K8s Binaries

### Download/Install `kubectl`
* Download the binary with `curl`:
  ```bash
  # x86_64 architecture (amd64):
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  # replace the curl subshell with a specific version if you need:
  curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl
  ```
  Replace `amd64` with `arm64` if you need to use ARM64 architecture.  

* Optionally validate the binary with checksums:
  ```bash
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
  ```

* Install `kubectl` with the `install` command
  ```bash
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  ```
    * If you don't have root access:
      ```bash
      chmod 755 kubectl
      mkdir -p ~/.local/bin && mv ./kubectl ~/.local/bin/kubectl
      ```

* Verify installation:
  ```bash
  kubectl version --client
  kubectl version --client --output=yaml
  ```

---



## K8s install with package managers

### Install k8s on Rocky/RedHat-based
[docs](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)
```bash
# put SELinux into permissive mode if it's active
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive' /etc/selinux/config

# disable swap (required for k8s)
sudo swapoff -a
sed -i '/swap/d' /etc/fstab  # Permanently disable swap

# make sure deps exist
sudo dnf install -y yum-utils device-mapper-persistent-data lvm2

# Add k8s repository
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


# install k8s components
sudo dnf install -y kubelet kubeadm kubectl

# start the kubelet service
sudo systemctl enable --now kubelet

# configure sysctl settings
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
```

### Install k8s on Ubuntu/Debian-based

Also see the [docs](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management).  

This is for k8s v1.32.  

```bash
# disable swap (required for k8s)
sudo swapoff -a
# delete the line in /etc/fstab that contains 'swap'
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

# configure sysctl settings (kernel modules)  
# Add a file in /etc/modules-load.d/ that specifies what kernel modules k8s needs 
# the br_netfilter module allows the network bridge traffic to be passed through iptables.
# required by some CNIs (flannel) and others that rely on bridge networking
# also used when working with Kube-proxy
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

# add the `br_netfilter` Linux Kernel Module without needing a reboot
sudo modprobe br_netfilter

# /etc/sysctl.d/ stores config files for persistent kernel settings.  
# This allows bridged ipv4 and ipv6 packets to be processed by iptables.  
# Required for CNIs that rely on Linux bridges. 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
# This modifies the kernel runtime parameters on the fly, and loads everything in the sysctl.d/*.conf files
```

### Next Steps for both RedHat and Debian

- Verify the installtion
  ```bash
  kubeadm version
  kubelet --version
  kubectl version --client
  ```
  If you get version output for all 3 of those commands, the installation is
  verified.  

- Optionally, enable bash completion for `kubectl`
  ```bash
  # Generate bash completion script for kubectl (optional)
  kubectl completion bash
  # enable kubectl autocompletion in .bashrc (optional, requires `bash-completion`)
  printf "source <(kubectl completion bash)\n" >> ~/.bashrc

  # if you have an alias for kubectl, you can extend the compltion to work with the alias
  printf "alias k=kubectl\n" >> ~/.bashrc
  printf "complete -o default -F __start_kubectl k\n" >> ~/.bashrc

  # Or combine all of those into a heredoc
  cat << 'EOF' >> ~/.bashrc
  source <(kubectl completion bash)
  alias k=kubectl
  complete -o default -F __start_kubectl k
  EOF
  ```

- Initialize the cluster (done later).  


### Set up `kubeconfig`
```bash
mkdir -p "$HOME/.kube"
sudo cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown $(id -u):$(id -g) "$HOME/.kube/config"
```


## Resources
* [Installing `kubeadm`](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
* [Installing `kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)

