# Collections in Ansible

Collections are a way to package and distribute content for reuse.  
Available in Ansible starting with version 2.9.


Collections bundle related Ansible resources, such as roles, playbooks, modules, 
plugins, and more, into a single, shareable package.  


Collections, like Roles, follow a standard directory structure.  

## What Collections Contain
An Ansible collection can contain any or all of these:
* Roles: Modular task definitions.
* Playbooks: High-level workflows that orchestrate tasks across systems.
* Modules: Custom-built functionality for performing specific tasks.
* Plugins: Extend Ansible with additional capabilities (e.g., lookup, callback, filter plugins).
* Documentation: Describes the purpose and usage of the collection.
* Tests: Provide automated tests for verifying the content.


## Directory Structure of a Collection

A collection has a predefined directory layout:
```bash
collection_name/
├── README.md               # Description of the collection
├── galaxy.yml              # Metadata for the collection
├── roles/                  # Roles included in the collection
│   └── myrole/             # Example role
├── playbooks/              # Playbooks included in the collection
├── plugins/                # Custom plugins (e.g., modules, filters, lookups)
│   ├── modules/            # Custom modules
│   ├── filters/            # Custom filter plugins
│   └── callbacks/          # Custom callback plugins
├── files/                  # Shared static files
├── tests/                  # Test cases for the collection
└── docs/                   # Documentation for the collection
```

## Using a Collection

You can install collections from Ansible Galaxy (or another repository) using
the `ansible-galaxy collection install` command:
Syntax:
```bash
ansible-galaxy collection install mynamespace.mycollection
```

An example:
```bash
ansible-galaxy collection install community.general
```
This installs the `community.general` collection from the Ansible Galaxy repository.  
This contains general purpose modules, roles, and plugins.  


### Using a collection in a playbook
Oncer you install a collection, you can use the content by including it in your
playbooks.  
```yaml
- name: Use a module from a collection
  hosts: localhost
  tasks:
    - name: Print a message
      community.general.echo:
        msg: "Hello from the community.general collection!"
```
`community.general.echo` refers to the `echo` module in the `community.general` collection.

---

## Creating a Collection

Use `ansible-galaxy` to create a collection skeleton:
```bash
ansible-galaxy collection init my_namespace.my_collection
```
This generates the directory structure for your collection 
under `my_namespace/my_collection`.

## Publishing a Collection
If you want to publish a collection, you can publish it to Ansible Galaxy (or another repository).  
Compress it into a `.tar.gz` and publish it:
```bash
ansible-galaxy collection publish path_to_collection.tar.gz
```


## Example of Using a Collection

Install the `nginxinc.nginx` collection from Ansible Galaxy:
```bash
ansible-galaxy collection install nginxinc.nginx
```

Use the collection’s roles and modules in your playbook:
```yaml
- name: Manage NGINX with a collection
  hosts: webservers
  roles:
    - nginxinc.nginx.nginx_config
```



