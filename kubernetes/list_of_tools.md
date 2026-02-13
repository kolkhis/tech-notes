# Tools related to Containers and K8s

Just a list of tools with brief descriptions.  

## Container Runtime Tools
* Podman/Docker - container runtimes
* containerd: Lightweight, industry standard container runtime.  
* CRI-O: Kubernetes-specific container runtime optimized for k8s worklaods.  
* runc: Low-level runtime that implements the OCI specification.  
    * OCI: Open Container Initiative

## Networking Tools
* CNI (Container Network Interface): Standard for configuring container networking.  
* Calico: Networking and network security for containers and k8s.  
* Weave: Easy to use container networking solution.  
* Flannel: Simple, lightweight k8s networking tool.  
* Cilium: Container networking and observability, powered by eBPF.  
* Istio: Service mesh for managing microservice traffic, security, and observability.  
* Linkerd: Lightweight, high-perf service mesh for k8s.  
* MetalLB: Load balancer for k8s clusters running on bare-metal environments.  
* Traefik: Modern reverse proxy and load balancer for containers and k8s.  
* nginx-ingress: Ingress controller for routing traffic into k8s clusters.  


## Debugging and Troubleshooting Tools
* nikolaka/netshoot: Container with common networking tools (`tcpdump`, `ping`, etc)
* K9s: Terminal based UI (TUI) for interacting with k8s clusters.  
* kubectl-debug: Debugging tool for pods using ephemeral containers.  
* stern: Multi-pod and multi-container log tailing for k8s.  
* kube-ops-view: Dashboard for visualizing operational status of k8s clusters.  
* Kubernetes Lens: IDE for managing and troubleshooting k8s.  
* kubectl-trace: Tracing k8s workloads using BPF-based tools.  
* cadvisor: Container resource usage metrics (like node_exporter for containers).  
* kubectl tree: Plugin to display k8s object hierarchies.  

## Monitoring and Observability
* Prometheus: TSDB for metrics and alerts.  
* Grafana: Visualization and dashboarding tool that works well with Prometheus.  
* Kube-state-metrics: Exposes cluster state metrics for Prometheus.  
* Thanos: Highly available, long term storage for Prometheus metrics.  
* Jaeger: Distributed tracing for microservices.  
* OpenTelemetry: Unified observaility framework for metrics, traces, and logs.  
* ELK Stack (Elasticsearch, Logstash, Kibana): Logging and visualization stack.  
* Fluentd/Fluent Bit: Log aggregation and forwarding.  
* Loki: Log aggregation optimized for Grafana.  


## Container Security
* Trivy: Vulnerability scanner for containers and k8s
* Falso: Runtime security for k8s (detects unexpected behavior)
    * This is a HIDS.
* Anchore: Image security and policy enforcement tool.  
* Kube-bench: CIS k8s benchmark compliance testing.  
* Kube-hunter: Tool for discovering security vulnerabilities in k8s clusters.  
* OPA (Open Policy Agent): Policy engine for k8s (used in Gatekeeper)
* Kubernetes Network Policies: Builtin security rules to control pod communications.  
* Sealed Secrets: Encrypts k8s secrets for safer storage in Git.  
* AppArmor/SELinux: Kernel-based MAC (mandatory access control) for container security.  


## Cluster Management
* k3s: Lightweight Kubernetes distro optimized for edge and IoT.  
* k0s: Minimal Kubernetes distro.  
* MicroK8s: Zero-ops Kubernetes installation for local development.  
* kind (Kubernetes in Docker): Tool for running k8s clusters in Docker containers.  
* minikube: Local k8s cluster for development and testing.  
* Rancher: Multi-cluster k8s management platform.  
* kOps (Kubernetes Operations): Tool for managing k8s clusters in the cloud.  
* kubectl: CLI tool for managing Kubernetes clusters.  


## CI/CD for Kubernetes
* Helm: Package manager for Kubernetes applications
* Kustomize: Tool for managing Kubernetes manifests with overlays.  
* ArgoCD: Declarative GitOps continuous delivery tool for Kubernetes.  
* FluxCD: Continuous delivery tool using GitOps principles
* Tekton: Kubernetes-native CI/CD pipeline framework.  
* Jenkins X: CI/CD automation tailored for kubernetes and microservices.  
* GitLab CI: Builtin k8s deployment and integration pipelines.  


## Storage Tools
* Rook: k8s storage orchestration for Ceph, EdgeFS, and other storage systems.  
* Longhorn: Cloud-native distributed block storage for kubernetes.  
* OpenEBS: Container-attached storage for kubernetes.  
* Portworx: Software-defined storage for kubernetes.  
* CSI (Container Storage Interface): Standard API for container orchestrators to expose storage.  

## Testing and Development Tools
* Skaffold: CLI tools for continuous development of Kubernetes applications.  
* Telepresence: Debug services in k8s without redeploying them
* Tilt: Tool for improving k8s development workflows
* DevSpace: Kubernetes development tool for building, deploying, and debugging.  

## Backup and Disaster Recovery Tools
* Velero: Backup, restore, and migrate Kubernetes workloads.  
* Krasten K10: Kubernetes-native backup and disaster recovery.  
* etcd snapshots: Builtin backup mechanism for Kubernetes `etcd` data.  

## Infrastructure as Code (IaC)
* Terraform: Infrastructure provisioning, including k8s clusters.  
* Pulumi: Multi-language IaC tool with k8s support
* Crossplane: Kubernetes-native control plane for managing cloud resources.  


## Policy and Configuration Management
* Kyverno: Kubernetes-native policy management engine
* Gatekeeper (OPA): Policy enforcement for k8s resources
* etcd: Key-value store used by k8s as its backing database
* ConfigMaps and Secrets: Kubernetes-native mechanism for managing application configs and credentials.  







