# Hashicorp Vault

## Setting up Hashicorp Vault

### Installation
Install Vault via package manager after adding the repository.  

Source: [HCP Vault install guide](https://developer.hashicorp.com/vault/install).  

Installation for Debian-based systems:
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install -y vault
```

Installation for RedHat-based systems (RHEL, Rocky, Alma): 
```bash
# dnf
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf install -y vault

# yum
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vault
```

### KC Lab (notes)

Start the Hashicorp Vault server in dev mode:  
```bash
vault server -dev & # Start dev server and background process
```

Ouput:
```txt
You may need to set the following environment variables:

$ export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: REDACTED
Root Token: hvs.REDACTED
```


Export the vault address and token as environment variables.
```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN="hvs.REDACTED"
```

---

Verify secrets engine Version 2 is running:
```bash
vault secrets list -detailed
```

Add a secret to Hashicorp Vault:  
```bash
vault kv put secret/app1/values username=secretuser password=supersecure
```

Output:
```txt
===== Secret Path =====
secret/data/app1/values

======= Metadata =======
Key                Value
---                -----
created_time       2025-05-17T00:37:40.89642633Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1
```

- Note this `Secret Path`.  

Verify the values were set:
```bash
vault kv get secret/app1/values # the "Secret Path"
```

---

Allowing vault to use usernames and passwords:
```bash
vault auth enable userpass
```

Creating a user for Hashicorp vault
```bash
vault write auth/userpass/users/ansible password=ansible12#$
```

Create a policy to allow reads of secret/app1/values secret (uses `hcl`)
```hcl
cat > /root/ansible-policy.hcl <<-EOF
# Write and manage secrets in key-value secrets engine
path "secret*" {
  capabilities = [ "create", "read", "update", "delete", "list", "patch" ]
}
EOF
```

Write the vault policy into vault
```bash
vault policy write ansible_policy /root/ansible-policy.hcl 
```

Map the policy to the user ansible
```bash
vault write /auth/userpass/users/ansible policies=ansible_policy
```

Verify the mapping of the policy.
```bash
vault read auth/userpass/users/ansible
```

---

### Using Ansible to Access Vault Secrets

```yml
---
- name: Read variables
  hosts: localhost
  vars:
  gather_facts: True
  become: False
  tasks:

  # Hit the vault API
  - name: test my connection to vault for credentials
    uri:
      url: "http://127.0.0.1:8200/v1/auth/userpass/login/{{username}}"  
      return_content: yes
      method: POST
      body_format: json
      body: { password : "{{ password }}" }
    register: user_connect

  # Check the values
  - name: Debug user_connect
    debug:
      var: user_connect
```

Run with extra vars:
```bash
ansible-playbook /root/secret-read.yaml --extra-vars "username=ansible password='ansible12#$'"
```

---

### Adding the Extra Vars to **Ansible** Vault


Create a vault file:  
```bash
ansible-vault create vault.yaml
```

- Create a password for your vault.  


The `vault.yaml` file is just a vars file.  
```yaml
username: ansible
password: ansible12#$
```


We can add this vars file:
```yaml
- name: Read variables
  hosts: localhost
  vars:
  vars_file: /root/vault.yaml
  #....The rest of the playbook
```


Then we need to unlock this file when calling this playbook:
```bash
ansible-playbook --ask-vault-pass /root/secret-read.yaml
```

---

### Displaying the Hashicorp Vault Secrets

If we want, we can add a couple of tasks to debug the variables containing the
secrets that we retrieved from Hashicorp Vault.  
```yaml
  - name: Show the individual username
    debug:
      var: secret_creds.json.data.data.username

  - name: Show the individual password
    debug:
      var: secret_creds.json.data.data.password
```

---


Set ansible user for both prod and dev servers.  
- Prod servers will have one ansible user, dev servers will have another.
- These 2 user accounts will have different credentials.  


