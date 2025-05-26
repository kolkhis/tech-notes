# Domain Name Configuration

Configurating a domain name for a website (e.g., a GitHub Pages website) requires
setting up DNS records.  


---

## GitHub Pages

To set up a domain name for a GitHub Pages website: 

1. Create a CNAME file in the GitHub repo (root of repo).  
    - Put the domain name in this file.  
      ```plaintext
      kolkhis.dev
      ```
    - It can be a sub-domain as well.  
      ```plaintext
      docs.kolkhis.dev
      ```
    - Push it to GH.  

2. Update DNS settings in your domain name provider.  
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


3. Enable custom domain in your GitHub repository.  
    - Settings -> pages -> custom domain
    - Enter your domain (e.g., `docs.kolkhis.dev`)
    - Check the box for **enforce HTTPS**.  

DNS propogation can take a while. Sometimes a few minutes, sometimes a few hours.  

Check with `dig`:
```bash
dig docs.kolkhis.dev +short
```

