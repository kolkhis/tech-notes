# Inventory Files / Hosts Files in Ansible

An inventory file is a list of hosts and groups of hosts. 
These files are used to run Ansible playbooks on multiple hosts at a time.  

## Table of Contents
* [Defining an Inventory using a Hosts File](#defining-an-inventory-using-a-hosts-file) 
* [Example Host Files](#example-host-files) 
    * [Using `ini`](#using-ini) 
        * [Host Entries](#host-entries) 
        * [Groups](#groups) 
        * [Group Variables](#group-variables) 
    * [Using `yaml`](#using-yaml) 
* [Testing a Hosts File](#testing-a-hosts-file) 
* [Specifying Different Groups of Hosts (Grouping Hosts)](#specifying-different-groups-of-hosts-grouping-hosts) 
    * [Vizualize an Inventory](#vizualize-an-inventory) 
* [View the Inventory in `yaml` or `json` format](#view-the-inventory-in-yaml-or-json-format) 


## Defining an Inventory using a Hosts File
You can use a hosts file to define a group of hosts.  
By default, Ansible looks for `/etc/ansible/hosts` for the inventory file.  

Specify an inventory file by using the `-i` option when running an Ansible command.
```bash
ansible-playbook -i inventory.yml my_playbook.yml
```

---

The file can be in `ini` format (most common) or `yaml` format.  
* `hosts.ini`:
  ```ini
  [servers]
  controlplane
  node01
  ```

* `hosts.yaml`:
  ```yaml
  all:
    hosts:
      controlplane:
        ansible_host: 192.168.1.10
        ansible_user: ubuntu
      node01:
        ansible_host: 192.168.1.11
        ansible_user: ubuntu
      
  ```

---

## Example Host Files

### Using `ini`
Using `ini` format, `hosts.ini`:
```ini
# File: hosts.ini

# Define individual hosts
webserver ansible_host=192.168.1.10 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
dbserver ansible_host=192.168.1.20 ansible_user=root

# Define groups
[webservers]
web1 ansible_host=192.168.1.11
web2 ansible_host=192.168.1.12

[databases]
db1 ansible_host=192.168.1.21
db2 ansible_host=192.168.1.22

# Nested groups. The parent group will contain all hosts in all its child groups.
[all_servers:children]
webservers
databases

# Group variables (applied to all hosts in the group)
[webservers:vars]
ansible_user=deploy
ansible_port=2222
```

#### Host Entries:

Each line specifies a hostname or alias (e.g., `webserver`) and optional connection variables.
* `ansible_host`: IP or domain name of the host.
* `ansible_user`: User to connect as.
* `ansible_ssh_private_key_file`: Path to the SSH private key.

#### Groups:

Group hosts together using descriptive names, like `[webservers]` or `[databases]`.  
Create nested groups with the `:children` suffix.  
`[all_servers:children]` makes `webservers` and `databases` groups children of the `all_servers` group.  

#### Group Variables:

Use the `:vars` suffix to define variables applied to all hosts in the group.  
`[webservers:vars]` applies the variables to all hosts in the `webservers` group.  

---

### Using `yaml`
Using `yaml` format, `hosts.yml`:
```yaml
# File: hosts.yml

all:
  children:
    webservers:
      hosts:
        web1:
          ansible_host: 192.168.1.11
          ansible_user: deploy
        web2:
          ansible_host: 192.168.1.12
    databases:
      hosts:
        db1:
          ansible_host: 192.168.1.21
          ansible_user: root
```

`yaml` uses a nested structure.
* `all`: The top-level group containing all hosts and subgroups.
* `children`: Subgroups under the all group.
* `hosts`: List of hosts with their variables.

## Testing a Hosts File
Test the inventory you've specified by using `ansible servers`.  
```bash
ansible servers -i /root/hosts -m ping
```

You can see how Ansible looks at your hosts file:
```bash
ansible-inventory -i /path/to/hosts --list
ansible-inventory -i /path/to/hosts --graph

# To see it in yaml format:
ansible-inventory -i /path/to/hosts --list -y
```

## Specifying Different Groups of Hosts (Grouping Hosts)
```ini
[servers]
controlplane
node01

[test_env]
controltest type=client
node01test  type=server

[prod_env]
controlprod type=client
node01prod  type=server

# Assign to a group
[non-prod:children]
servers
test_env
```

This makes both the `servers` and `test_env` groups part of the `non-prod` group.  
 
Parent groups inherit all hosts from their children.  

If I specify `hosts` as `non-prod` in a playbook, it will run on all hosts in 
the `servers` and `test_env` groups.


### Vizualize an Inventory
To see a graph of the hosts file:
```bash
ansible-inventory -i /root/hosts --graph
```
We see that hosts file is interpreted by Ansible as:
```bash
@all:
  |--@non-prod:
  |  |--@servers:
  |  |  |--controlplane
  |  |  |--node01
  |  |--@test_env:
  |  |  |--controltest
  |  |  |--node01test
  |--@prod_env:
  |  |--controlprod
  |  |--node01prod
  |--@ungrouped:
```

## View the Inventory in `yaml` or `json` format
You can specify the format of the output when using `ansible-inventory` to view the
inventory in `json` or `yaml` data.  
By default, `ansible-inventory --list` will output in `json`.  
Add `-y`/`--yaml` to see it in `yaml` format.  
```bash
# View inventory in json
ansible-inventory -i hosts.ini --list 
ansible-inventory -i hosts.ini --list 
# For yaml format:
ansible-inventory -i hosts.ini --list --yaml
ansible-inventory -i hosts.ini --list -y
```


