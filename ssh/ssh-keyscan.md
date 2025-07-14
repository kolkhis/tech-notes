# `ssh-keyscan`

The `ssh-keyscan` tool is used to fetch public keys from servers.

As such, it can also be used to get the SSH fingerprint of a host or destination so
it can be added to the `~/.ssh/known_hosts` or `/etc/ssh/ssh_known_hosts` file.  

## Getting the Fingerprints

If you have an IP that you want to add to your `known_hosts` file, you can do a
simple `ssh-keyscan -H <ip>`.  
```bash
ssh-keyscan -H 192.168.1.10
```
This will fetch the server's public key and then hash it. 

---

> If you don't use `-H`, the output can still be used in the same way, but the output 
> may contain sensitive information that you may not want in your `known_hosts` file.  

---

So that output can be added to your `known_hosts` file.  

```bash
ssh-keyscan -H 192.168.1.10 | tee -a ~/.ssh/known_hosts
```

---


## Reading Hosts from File

The `ssh-keyscan` tool can read in hosts from a file.  

The file must be formatted as comma-delimited fields of:
```bash
address name,address name,address name
```
The `name` entry is optional. If can just be a comma-delimited list of IPs/addresses.  
```bash
192.168.1.10,192.168.1.11,github.com
```

Read in this file with `-f`:
```bash
ssh-keyscan -f ./hosts
```

You can also use this flag to read from stdin by giving `-` instead of a filename:
```bash
printf "192.168.1.10,192.168.1.11" | ssh-keyscan -f -
```








