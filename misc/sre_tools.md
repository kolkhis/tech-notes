# Tools for SREs and DevOps Roles


## Table of Contents
* [Top Tools Used by DevOps and SREs](#top-tools-used-by-devops-and-sres) 
    * [Containerization and Orchestration](#containerization-and-orchestration) 
    * [CI/CD Tools (Continuous Integration / Continuous Delivery)](#cicd-tools-continuous-integration--continuous-delivery) 
    * [Infrastructure as Code (IaC)](#infrastructure-as-code-iac) 
    * [Monitoring and Observability](#monitoring-and-observability) 
    * [Version Control & Collaboration](#version-control--collaboration) 
    * [Security and Compliance](#security-and-compliance) 
    * [Cloud and Hybrid Tools](#cloud-and-hybrid-tools) 
    * [Automation and Scripting](#automation-and-scripting) 
    * [Key Tools to Start With](#key-tools-to-start-with) 
* [Practice](#practice) 

## Top Tools Used by DevOps and SREs


### Containerization and Orchestration
These are essential.  
Almost every DevOps/SRE job will require experience with these.

* `Docker`: Core tool for building, running, and managing containers.  
* `Kubernetes` (K8s): The industry standard for container orchestration.  
    * Learn kubectl well.  
* `Helm`: Kubernetes package manager for deploying and managing K8s apps.  
* `Podman`: A Docker alternative, increasingly popular in enterprise environments.  
* `kind` (Kubernetes-in-Docker) or Minikube: For running Kubernetes locally in development environments.

---

### CI/CD Tools (Continuous Integration / Continuous Delivery)
CI/CD experience is critical for automating deployment pipelines.

* `Jenkins`: The most popular CI/CD tool, though heavy.  
* `GitLab` CI/CD: Integrated pipelines in GitLab.  
* `ArgoCD`: GitOps-based continuous delivery for Kubernetes.  
* `FluxCD`: Lightweight GitOps alternative to ArgoCD.  
* `GitHub` Actions: Great for automating workflows directly in GitHub.  
* `Tekton`: Kubernetes-native CI/CD framework.

---

### Infrastructure as Code (IaC)
IaC is a core skill for DevOps engineers to manage infrastructure reliably.

* `Terraform`: The most popular tool for provisioning and managing infrastructure.  
* `Pulumi`: IaC using modern programming languages (Python, Go, etc.).  
* `Ansible`: Configuration management and orchestration tool for automating system setup.  
* `Helm`: Kubernetes-focused "IaC" for packaging apps.  
* `CloudFormation`: AWS-native IaC tool.  

---

### Monitoring and Observability
Understanding metrics, logging, and tracing is a must for SREs.

* `Prometheus`: Leading tool for monitoring and alerting.  
* `Grafana`: Visualizes Prometheus metrics with dashboards.  
* `ELK` Stack (Elasticsearch, Logstash, Kibana): Used for centralized logging.  
* `Loki`: Grafana's lightweight log aggregation tool.  
* `Jaeger` or `OpenTelemetry`: Distributed tracing for debugging microservices.  
* `Datadog` / `New Relic`: Paid all-in-one monitoring tools often used in larger orgs.  

---

### Version Control & Collaboration
* `Git`: Essential for source control (GitHub, GitLab, Bitbucket).  
* `GitOps`: Modern approach to infrastructure management using Git as a single source of truth.  
* `Slack` or `MS Teams`: DevOps/SREs use these for communication and incident alerts.  

---

### Security and Compliance
DevSecOps is a growing requirement.

* `Trivy`: Container image vulnerability scanner.  
* `Falco`: Runtime security for Kubernetes.  
* `Kube-hunter`: Identifies security issues in Kubernetes clusters.  
* `OpenSCAP`: Security compliance scanning for Linux systems.  
* `Vault` (HashiCorp): Secure secrets and credentials management.

---

### Cloud and Hybrid Tools
Cloud platforms dominate DevOps/SRE roles.  
Get familiar with at least one.

* `AWS`, `GCP`, or `Azure`: Cloud providers that host infrastructure and services.  
* `AWS CLI`, `az cli` (Azure), `gcloud CLI` (GCP): Learn how to interact with cloud APIs.  
* `K3s`: Lightweight Kubernetes for edge computing and small clusters.

---

### Automation and Scripting
* `Bash`: Essential for Linux automation scripts.  
* `Python`: Most DevOps tools use Python for automation, APIs, or tooling.  
* `Go`: Increasingly important for building reliable tooling, especially Kubernetes tools.

---

### Key Tools to Start With
If you're just starting out, focus on these essentials first:

1. `Docker` - Containerize applications.  
2. `Kubernetes` - Orchestrate and manage those containers.  
3. `Terraform` - Provision infrastructure.  
4. `Ansible` - Automate system configuration.  
5. `Prometheus` & `Grafana` - Monitor your systems.  
6. `Git` & `GitHub Actions` - For version control and automation workflows.  
7. `Bash` & `Python` - Write automation scripts.

---

## Practice
* Practice in Your Homelab: Use your Proxmox setup to spin up VMs, deploy Kubernetes (K3s), and practice these tools.  
* Build CI/CD Pipelines: Use GitHub Actions or Jenkins to automate builds and deployments.  
* Set Up Monitoring: Integrate Prometheus and Grafana for cluster monitoring.  
* Learn Terraform: Provision cloud infrastructure or virtual machines on your homelab with Terraform.  
* Containerize Everything: Start converting scripts, services, and apps into Docker containers.




