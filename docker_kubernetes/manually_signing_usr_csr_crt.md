
# User Management and Authentication in Kubernetes  

## Table of Contents
* [Acronyms](#acronyms) 
* [CertificateSigningRequests - Signing Manually](#certificatesigningrequests---signing-manually) 
* [User Management in K8s](#user-management-in-k8s) 
* [Create a KEY and CSR](#create-a-key-and-csr) 
    * [Creating the Key and CSR with OpenSSL](#creating-the-key-and-csr-with-openssl) 
    * [Manually Signing the CertificateSigningRequest (CSR)](#manually-signing-the-certificatesigningrequest-csr) 
    * [Manually sign the CSR file with the K8s CA file to generate the CRT file.](#manually-sign-the-csr-file-with-the-k8s-ca-file-to-generate-the-crt-file) 
    * [Create a new context with `kubectl` for the user.](#create-a-new-context-with-kubectl-for-the-user) 
        * [`kubectl` Commands One by One (and their output)](#kubectl-commands-one-by-one-and-their-output) 
* [Broken Down: Manually Creating and Managing User Certificates](#broken-down-manually-creating-and-managing-user-certificates) 
    * [Step 1: Generate a Private Key](#step-1-generate-a-private-key) 
    * [Step 2: Generate a CSR](#step-2-generate-a-csr) 
    * [Step 3: Sign the CSR with the Kubernetes CA](#step-3-sign-the-csr-with-the-kubernetes-ca) 
    * [Step 4: Configure `kubectl` to Use the New Certificate](#step-4-configure-kubectl-to-use-the-new-certificate) 
    * [Verifying Access](#verifying-access) 
* [Additional Notes](#additional-notes) 


## Acronyms
* CRT: Certificate (`.crt` file)
* CSR: Certificate Signing Request (`.csr` file)
* CN: CommonName 
    * This is a field inside of the certificate that is used to identify its owner.  
* CA: Certificate Authority (`ca.crt` file)
    * The cluster's CA lives inside `/etc/kubernetes/pki/ca.crt`

## CertificateSigningRequests - Signing Manually  


## User Management in K8s  

Users in K8s are managed via CRTs (`CertificateSigningRequests`) and 
the `CN/CommonName` field in them.  

The cluster's CA (Certificate Authority) needs to sign these CRTs.  

This process involves creating and signing Certificate Signing Requests (CSRs) using 
the cluster's Certificate Authority (CA) through OpenSSL.  

This can be achieved with the following procedure:  

1. Create a KEY (Private Key) file.  
2. Create a CSR (CertificateSigningRequest) file for that KEY.  
3. Create a CRT (Certificate) by signing the CSR. 
    * This is done using the cluster's CA (Certificate Authority).  




## Create a KEY and CSR  

In the first step we'll create a CSR and in the second step we'll manually sign the 
CSR with the Kubernetes cluster's CA (Certificate Authority) file.  

The idea here is to create a new "user" that can communicate with K8s.  

For this:  
1. Create a new KEY at `/root/60099.key` for user named `60099@internal.users`
2. Create a CSR at `/root/60099.csr` for the KEY  


### Creating the Key and CSR with OpenSSL  

```bash  
openssl genrsa -out /path/for/private_key 2048  
openssl req -new -key /path/to/private_key -out /path/for/csr
```

* The `openssl genrsa` command creates a new RSA privake key file (bit length of `2048`).  
    * `genrsa` is the command to generate an RSA key.  
    * `-out /path/for/private_key` specifies the output path and filename for the KEY file.  
        * ```bash  
          openssl genrsa -out /root/60099.key  
          ```
        <!-- * `-out /etc/kubernetes/pki/users/60099.key` -->  
* The `openssl req` command creates the new CSR (Certificate Signing Request) file.  
    * `req` is the command to create and process certificate requests (CSRs) in  
      PKCS#10 format.  
    * `-new` creates a new CSR  
    * `-key /path/to/private_key` specifies the key file to use  
    * `-out /path/for/csr` specifies the output path and filename for the CSR file.  
    * ```bash  
      openssl genrsa -out /root/60099.key  
      ```
    * This will take you through a series of questions.  
        * To specify a user (`60099@internal.users`), enter that name when prompted  
          for a `Common Name`.  


```bash  
openssl genrsa -out 60099.key 2048  
 
openssl req -new -key 60099.key -out 60099.csr  
# set Common Name = 60099@internal.users  
```


### Manually Signing the CertificateSigningRequest (CSR)

1. Manually sign the CSR with the K8s CA file to generate the CRT at `/root/60099.crt`. 

2. Create a new context for `kubectl` named `60099@internal.users` which uses this 
   CRT to connect to K8s.  


### Manually sign the CSR file with the K8s CA file to generate the CRT file. 
To generate the certificate file (`.crt`), we'll use the `openssl x509` command.  
```bash  
openssl x509 -req -in 60099.csr -CA /etc/kubernetes/pki/ca.crt -CAkey \
/etc/kubernetes/pki/ca.key -CAcreateserial -out 60099.crt -days 500  
```
* `openssl x509`: The command used for dealing with `X.509` certificates.  
    * `X.509` certificates are widely used in public key infrastructure (PKI).  
* `-req`: Tells `openssl` that the input will be a CSR file (Certificate Signing Request).  
* `-in 60099.csr`: Specifies in the input file (CSR) to use for requesting signing from the CA.
* `-CA /etc/kubernetes/pki/ca.crt`: Specifies the CA (Certificate Authority) file to use for signing.  
* `-CAkey /etc/kubernetes/pki/ca.key`: Specifies the private key (`ca.key`) associated with the CA certificate.
    * The private key is necessary for signing the CSR; it confirms that the CA authorizes the request.
* `-CAcreateserial`: Tells `openssl` to create a serial file (`.srl`) if it doesn't already exist.
    * The serial number is required for the certificate and helps ensure each generated 
      certificate is unique.  
* `-out 60099.crt`: Specifies the output file for the certificate (CRT).  
* `-days 500`: Sets the number of days the certificate will be valid. After 500 days,
  the certificate will expire.  


### Create a new context with `kubectl` for the user.  
Create a new context with `kubectl` for the user named 60099@internal.users which uses this CRT to connect to K8s.  

```bash  
k config set-credentials 60099@internal.users --client-key=60099.key --client-certificate=60099.crt  
k config set-context 60099@internal.users --cluster=kubernetes --user=60099@internal.users  
k config get-contexts  
k config use-context 60099@internal.users  
k get ns # fails because no permissions, but shows the correct username returned  
```

---  

#### `kubectl` Commands One by One (and their output):  

```bash  
kubectl config set-credentials 60099@internal.users --client-key=60099.key --client-certificate=60099.crt 
# User "60099@internal.users" set.  
 
kubectl config set-context 60099@internal.users --cluster=kubernetes --user=60099@internal.users  
# Context "60099@internal.users" created.  
 
kubectl config get-contexts 
# CURRENT   NAME                          CLUSTER      AUTHINFO               NAMESPACE  
#           60099@internal.users          kubernetes   60099@internal.users   
# *         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin  
 
kubectl config use-context 60099@internal.users 
# Switched to context "60099@internal.users".  
 
kubectl get ns  
# Error from server (Forbidden): namespaces is forbidden: User "60099@internal.users" cannot list resource "namespaces" in API group "" at the cluster scope  
```
* The last command fails because no permissions, but shows the correct username returned  




## Broken Down: Manually Creating and Managing User Certificates

### Step 1: Generate a Private Key  

Generate a private key for the user.  
This key will be used to generate a Certificate Signing Request (CSR).  

```bash  
openssl genrsa -out /root/60099.key 2048  
```
* `openssl genrsa` generates an RSA private key.  
* `-out /root/60099.key` specifies the output file for the key.  
* `2048` sets the key length to 2048 bits, a common choice for good security.  

---  

### Step 2: Generate a CSR  

Generate a CertificateSigningRequest (`.csr`) using the private key (`.key`).  
 
This command will request the user's identifiable information.  
Most importantly, the Common Name (CN), is what Kubernetes uses as the username.  

```bash  
openssl req -new -key /root/60099.key -out /root/60099.csr  
```
* Follow the interactive prompt and enter `60099@internal.users` for Common Name.  


Alternatively, to avoid the interactive prompt, use `-subj`:  
``` bash  
openssl req -new -key /root/60099.key -out /root/60099.csr -subj "/CN=60099@internal.users"  
```

* `-new` indicates the creation of a new CSR.  
* `-key /root/60099.key` specifies the private key file.  
* `-out /root/60099.csr` defines the output file for the CSR.  
* `-subj "/CN=60099@internal.users"` directly sets the subject of the CSR, avoiding 
  the interactive prompt.  
    * The CN is used by Kubernetes as the username.  

---  

### Step 3: Sign the CSR with the Kubernetes CA  

To authenticate the user with the Kubernetes cluster, their CSR must 
be signed by the cluster's CA.  

```bash  
openssl x509 -req -in /root/60099.csr -CA /etc/kubernetes/pki/ca.crt -CAkey \
/etc/kubernetes/pki/ca.key -CAcreateserial -out /root/60099.crt -days 500  
```
* `openssl x509` is used for certificate signing.  
* `-req -in /root/60099.csr` specifies the input CSR.  
* `-CA /etc/kubernetes/pki/ca.crt` and `-CAkey /etc/kubernetes/pki/ca.key` provide 
  the cluster CA certificate and key.  
* `-CAcreateserial` generates a serial number file if it does not exist.  
* `-out /root/60099.crt` outputs the signed certificate.  
* `-days 500` sets the certificate validity period.  


### Step 4: Configure `kubectl` to Use the New Certificate  

After signing, configure `kubectl` to use the new user certificate (`.crt`) for authentication.  

```bash  
kubectl config set-credentials 60099@internal.users --client-key=/root/60099.key --client-certificate=/root/60099.crt  
kubectl config set-context 60099@internal.users --cluster=kubernetes --user=60099@internal.users  
kubectl config use-context 60099@internal.users  
```

* These commands configure `kubectl` with the new credentials and set a `context` 
  that uses them.  

### Verifying Access  

Attempting to access the cluster with the new user credentials will verify if the 
setup is correct.  

```bash  
kubectl get ns  
```

* If permissions are not set, this command will fail due to lack of access rights, but it should correctly identify the user, proving the authentication mechanism works.  

## Additional Notes  

* Role-Based Access Control (RBAC): To grant permissions to users, Kubernetes uses RBAC.  
    * After creating and signing a user's certificate, you must define roles and role bindings to specify what resources the user can access.  

* Automating CSR Signing: 
In a production environment, automating CSR approval through 
Kubernetes CertificateSigningRequest resources can streamline user management.  


```bash  
chown root:root /etc/kubernetes/pki -R  
```
