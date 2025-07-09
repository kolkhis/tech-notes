# `certtool`

`certtool` is a tool for managing TLS certificates.  



## Encrypting Logs with TLS
```bash
apt install gnutls-bin rsyslog-gnutls
```

---

### Manually Generating and Signing a CSR

1. Generate key
   ```bash
   certtool --generate-privkey --outfile ca-key.pem
   ```

2. Generate self-signed certificate
   ```bash
   certtool --generate-self-signed --load-privkey ca-key.pem --outfile ca.pem
   ```

3. Generate a new private key
   ```bash
   certtool --generate-privkey --outfile key.pem
   ```

4. Generate a request
   ```bash
   certtool --generate-request --load-privkey key.pem --outfile request.pem
   ```

5. Sign the certificate request
   ```bash
   certtool --generate-certificate --load-request request.pem --outfile cert.pem --load-ca-certificate ca.pem --load-ca-privkey ca-key.pem
   ```

6. Validate
   ```bash
   certtool --certificate-info --infile cert.pem 
   ```



---


## Certificate Terminology

Daisy-chaining CAs:
- Delegation
- Parent CA signs lower-order CA's cert, authorizing it to issue certificates.  
- The highest-order CA is known as the root CA and must have a well-known certificate
* Every other CA in the chain is known as an intermediate CA


New identity issuance:

* Client generates an X.509 document called a Certificate Signing Request (CSR), which is created with a corresponding private key.
* Next, the Certificate Authority checks every detail of the CSR against the service that requested the certificate

* Once satisfied, the Certificate Authority attaches its digital signature to
  the CSR, turning it into a fully-fledged certificate.
* CA sends the certificate back to the service.
- Along with the private key that it generated earlier, the service can securely identify itself to the world.


Certificate Revocation:

* The Certificate Authority maintains a file called the Certificate Revocation List with the unique IDs of the revoked certificates and distributes a signed copy of the file to anyone who asks

* Online Certificate Status Protocol (OCSP).


Certificate expiration:
* Every certificate has a built-in expiration date.

* the longer a certificate is valid, the greater the risk that the private key for its certificate or any certificate leading to the root could be stolen.
- Always expire your certs.

Frequent certificate renewal:

If the certificate lifetime is very short
(perhaps only a few hours), then the CA can frequently re-perform any
checks that it originally made. 

---

SSH Key pair

Check for cryptographic similarity
```bash
# private key
ssh-keygen -y -e -f private-keyfile
ssh-keygen -l -f private-keyfile

# public key
ssh-keygen -y -e -f key.pub
ssh-keygen -l -f key.pub
```

Generate a new public key from the private one.
```bash
ssh-keygen -f ProLUG -y > ProLUG.pub
```


