# `openssl`

OpenSSL is an open-source toolkit that implements the Secure Socket Layer (SSL)
and Transport Layer Security (TLS) protocols. 

It provides a set of cryptographic functions and utilities for secure communication over networks.

The OpenSSL suite has an `openssl` command line tool, which is robust and versatile, 
allowing the user to perform various cryptographic functions.  

## Usage

The basic syntax for using the `openssl` command is:
```bash
openssl <command> [options] [arguments]
```
There are a ton of `<command>` options available, each serving a specific
purpose.  


### Common Commands

`openssl` has a **lot** of subcommands (over 100), but below are some useful
ones that might be good to know about.  

- `openssl version`: Displays the version of OpenSSL installed on the system.
  ```bash
  openssl version
  ```

- `openssl dgst`: Computes message digests (hashes) of files or data.
  ```bash
  openssl dgst -sha256 file.txt
  ```
    - Alternatively, we can specify the digest algorithm as a subcommand
      instead of using `dgst` with the `-sha256` flag:
      ```bash
      openssl sha256 file.txt
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
    - `genpkey` replaced the older `openssl genrsa` and other keygen subcommands.  
    - Many options are available to customize the key. For example,
      `-pkeyopt rsa_keygen_bits:2048` to specify the key size for RSA keys.
        - See `man openssl-genpkey` and check the `KEY GENERATION OPTIONS` section for a list.

- `openssl req`: Creates and processes certificate requests in PKCS#10 format.
  ```bash
  openssl req -new -key private_key.pem -out certificate_request.csr
  ```
    - `-new`: Indicates that a new certificate request is being created.  
    - `-key`: Specifies the private key to use for signing the certificate request.  
    - `-out`: Specifies the output file for the generated certificate request.

- `openssl x509`: Displays and manages X.509 certificates.

- `openssl rsa`: Manages RSA private keys, including converting between different
  formats and extracting public keys.

- `openssl s_client`: Connects to a remote server using SSL/TLS and displays 
  the server's certificate and other info.

- `openssl s_server`: Starts a simple SSL/TLS server that can be connected to 
  by using `openssl s_client` or other SSL/TLS clients.

- `openssl pkcs12`: Manages PKCS#12 files, which are used to store private keys
  and certificates in a single file.

## Documentation

Each subcommand offered by `openssl` has its own set of options/arguments.  
As such, each subcommand has its own `man` page.  
To access the man page for a specific subcommand:
```bash
man openssl-command
# For example:
man openssl-dgst
man openssl-s_client
```
This pulls up the man page for the `dgst`/`s_client` subcommand.  

The `openssl` command also has really good tab completion in Bash.
Type out `openssl ` (with a space) and pres ++tab+tab++, that'll show all available subcommands.


## Resources

- `man openssl`  
- [OpenSSL Documentation](https://www.openssl.org/docs/)  



