# Security in Kubernetes
##### [Source: k8s docs](https://kubernetes.io/docs/concepts/security/)
Kubernetes is based on a cloud-native architecture. 
It draws on advice from the Cloud Native Computing Foundation (CNCF) for best
practices for cloud native information security.  

## Table of Contents
* [Builtin Security Mechanisms](#builtin-security-mechanisms) 
    * [Control Plane Protection](#control-plane-protection) 
    * [TLS Certificate API](#tls-certificate-api) 
    * [Secrets API](#secrets-api) 
    * [Pod Security Standards](#pod-security-standards) 

## Builtin Security Mechanisms

Kubernetes has several APIs and security controls.  
There are also ways to define security policies that can change how you manage security.  

### Control Plane Protection
Controlling access to the Kubernetes API is an important security mechanism for any
k8s cluster.  


### TLS Certificate API
K8s expects you to configure data encryption in transit using TLS in the control plane and
between the control plane and its worker nodes/clients.  
This requires managing TLS certificates in a cluster, using the `certificates.k8s.io`
API. 
* [k8s docs: Managing cluster TLS certs](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)

### Secrets API
The `Secret` API provides basic protection for config values that store sensitive
data, like API keys or other sensitive information.

`Secret`s are objects that contain a small amount of sensitive data.
E.g., password, token, or key.
These `secret` objects can be created independently of the Pods that use them.  

A `Secret` is similar to a `ConfigMap`, but it's intended to only store confidential
data.  
* [k8s docs: Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)


### Pod Security Standards
The "Pod Security Standards" define three different `policies` to cover the security
specreum.  
These policies are **cumulative**.
They range from highly-permissive to highly-restrictive.  

* Privileged policy: Open and unrestricted. Aimed at system-level and
  infrastructure-level workloads managed by trusted users.  
    * Defined by an absence of restrictions.   
    * Pods using a Privileged policy are able to bypass typical container isolation
      mechanisms.  
        * E.g., Defining a Pod that has access to the node's host network.  

* Baseline policy: Aimed at ease of adoption for common containerized workloads while
  preventing known privilege escalations.  
    * Targeted at application operators and developers of non-critical applications.  
---
* [k8s docs: Pod Security standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)






