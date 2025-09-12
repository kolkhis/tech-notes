# Domain Name Configuration

Configurating a domain name for a website (e.g., a GitHub Pages website) requires
setting up DNS records.  


---

## GitHub Pages

To set up a domain name for a GitHub Pages website: 

### 1. Create a CNAME file in the GitHub repo (root of repo).  

- Put the domain name in the `CNAME` file.  
  ```plaintext
  kolkhis.dev
  ```

- It can be a sub-domain as well.  
  ```plaintext
  docs.kolkhis.dev
  ```

- Push it to GitHub.  

### 2. Update DNS settings in your domain name provider.  

- Go to your domain and find "Records."  

- If you set up a subdomain (e.g., `docs.kolkhis.dev`), add a CNAME record.  

  | Type | Host | Answer | TTL
  |-|-|-|-
  | `CNAME` | `docs` | `username.github.io.` | `300`

    - The trailing dot (`io.`) is optional (but recommended).  
    - Do **not** add `https://`. Just the domain.  

- If using the **Apex domain** (e.g., `kolkhis.dev`), use `A` records (`ALIAS`
  records).  

  | Type | Host | Answer | TTL
  |-|-|-|-
  | `A` | `@` | `185.199.108.153` | `300`
  | `A` | `@` | `185.199.109.153` | `300`
  | `A` | `@` | `185.199.110.153` | `300`
  | `A` | `@` | `185.199.111.153` | `300`


### 3. Enable custom domain in your GitHub repository.  

- Go to your GitHub repository.
    - Settings -> Pages -> Custom Domain

- Enter your domain (e.g., `docs.kolkhis.dev`)

- Check the box for **enforce HTTPS**.  

DNS propogation can take a while. Sometimes a few minutes, sometimes a few hours.  

You can check with `dig`:
```bash
dig docs.kolkhis.dev +short
```

## Types of DNS Records

- `A` (Address Record): Maps a hostname to a specific IPv4 address.  
- `AAAA` (IPv6 Address Record): Maps a hostname to a specific IPv6 address.  
- `CAA` (Certificate Authority Authorization): Restricts which Certificate
  Authorities (CAs) can issue TLS/SSL certs for your domain.  
- `CNAME` (Canonical Name Record): Makes one hostname an alias for another.  
    - Use to point subdomains at services (e.g., GitHub Pages, Netlify)
- `ALIAS` (`CNAME` Flattening Record): Point a hostname to another hostname without
  breaking the root domain.  
    - Like a `CNAME`, but works at the apex/root domain, where a `CNAME` isn't
      allowed.
      ```lua
      example.com.    ALIAS    kolkhis.github.io.
      ```
- `HTTPS` (HTTPS Service Record): Lets you publish preferred endpoints, alt
  names, or even enable encrypted SNI.  
    - Like SVCB, but specifically for HTTPS services.
- `MX` (Mail Exchange Record): Tells the world which mail servers accept email for your domain.  
- `NA` (Name Server Record): Lists the authoritative DNS servers for your domain.  
    - Tells the internet where to go for DNS lookups on the domain.  
- `SRV` (Service Record): Specifies the location (host+port) of specific services.  
    - Usually used for SIP, XMPP, LDAP, etc.
- `SVCB` (Service Binding Record): Generalized "service" record type. Lets you
  advertise multiple endpoints, protocols, and priorities.
    - Used as a modern replacement for `SRV` in some cases.  
- `TLSA` (TLS Authentication Record): Associates a TLS server certificate with
  the domain.  
    - Part of DANE (DNS-based Authentication of Named Entities)
- `TXT` (Text Record): Arbitrary text data in DNS.  
    - Common for SPF, DKIM, DMARC, and domain verification.  

