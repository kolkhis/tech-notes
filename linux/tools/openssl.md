# `openssl`

OpenSSL is an open-source toolkit that implements the Secure Socket Layer (SSL)
and Transport Layer Security (TLS) protocols. 

It provides a set of cryptographic functions and utilities for secure communication over networks.

The `openssl` command line tool is robust and versatile, allowing the user to perform various functions.    

## Usage

The basic syntax for using the `openssl` command is as follows:

```bash
openssl <command> [options] [arguments]
```

There are a ton of `<command>` options available, each serving a specific
purpose.  


### Common Commands

- `openssl version`: Displays the version of OpenSSL installed on the system.
  ```bash
  openssl version
  ```

- `openssl dgst`: Computes message digests (hashes) of files or data.
  ```bash
  openssl dgst -sha256 file.txt
  ```

- `openssl enc`: Encrypts or decrypts data using various algorithms.
  ```bash
  openssl enc -aes-256-cbc -in plaintext.txt -out encrypted.txt
  ```
    - `openssl enc -d`: Decrypts the data.

- `openssl genpkey`: Generates a private key.
  ```bash
  openssl genpkey -algorithm RSA -out private_key.pem
  ```
    - `-algorithm`: Specifies the algorithm to use (e.g., RSA, EC, etc.).  
    - `-out`: Specifies the output file for the generated private key.  
    - For a list of supported algorithms, you can run `openssl list -public-key-algorithms`.

- `openssl req`: Creates and processes certificate requests in PKCS#10 format.
  ```bash
  openssl req -new -key private_key.pem -out certificate_request.csr
  ```
    - `-new`: Indicates that a new certificate request is being created.  
    - `-key`: Specifies the private key to use for signing the certificate request.  
    - `-out`: Specifies the output file for the generated certificate request.

- `openssl x509`: Displays and manages X.509 certificates.

- `openssl s_client`: Connects to a remote server using SSL/TLS and displays 
  the server's certificate and other information.

- `openssl s_server`: Starts a simple SSL/TLS server



