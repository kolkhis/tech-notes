# Ansible  
[Vagrant](https://www.vagrantup.com/) is a tool that allows us to create virtual machines.  
[Proxmox](https://proxmox.com/) is a virtualization platform that allows us to create
virtual machines and containers.  
These tools are very useful for testing and practicing Ansible.  

Also see [conditionals in Ansible](./conditionals_in_ansible.md).  


## Table of Contents
* [Ansible Playbooks](#ansible-playbooks) 
    * [Run an Ansible Playbook](#run-an-ansible-playbook) 
    * [Debugging an Ansible Playbook](#debugging-an-ansible-playbook) 
    * [Items in Playbooks](#items-in-playbooks) 
    * [Tasks](#tasks) 
    * [Modules](#modules) 
        * [Common Modules](#common-modules) 
        * [General Structure of a Task using a Module](#general-structure-of-a-task-using-a-module) 
* [Getting Help with Ansible Modules](#getting-help-with-ansible-modules) 
* [Ansible Roles](#ansible-roles) 
* [Loops in Ansible](#loops-in-ansible) 
* [Defining an Inventory using a Hosts File](#defining-an-inventory-using-a-hosts-file) 
    * [More Detailed Example Host Files](#more-detailed-example-host-files) 
* [Resources](#resources) 
* [What about Terraform?](#what-about-terraform) 
* [Questions](#questions) 


## Ansible Playbooks
Ansible playbooks are `yaml` files that can do several things:
* Declare configurations for systems
* Automate and organize the steps of a manual process, running them in a specific
  order on one or more machines.
* Run tasks either synchronously or asynchronously.  

Ansible playbooks are read and executed top to bottom, procedurally.  

The `yaml` in Ansible should use 2-space indentation throughout the whole file.  
That's the most common and is considered a best practice.  

### Run an Ansible Playbook
```bash
ansible-playbook -i inventory.yml my_playbook.yml
```
* `-i`: Specifies the inventory file.  

---

### Debugging an Ansible Playbook
Run playbooks with `-v` for 'verbose' output.  
You can use up to 3 levels of verbosity (`-vvv`).  


### Items in Playbooks
When a line starts with a `-` (hyphen), it represents an item in a list.  
```yaml
- name: Install and Configure nginx
  hosts: webserver
  become: yes
  tasks:
    - name: install nginx
      apt:
        name: nginx
        state: present
    - name: start nginx
      service:
        name: nginx
        state: started
```
Here’s what the hyphens represent: 
1. The first hyphen starts a `play` in the playbook.  
    * A `play` is a set of instructions applied to specified hosts. 
2. The subsequent hyphens start tasks within that `play`.  
    * Each `task` defines a specific action to perform.

Playbook-level keys:
* `- name: Install and configure NGINX`
    * Provides a descriptive name for the `play` (or playbook).
* `hosts: webserver`: Specifies the target machine or group of machines where the play will run.  
    * `webserver`: Refers to a group defined in the `inventory.yml` file.  
* `become: yes`: Indicates that the tasks in the play should run with elevated privileges.  
* `tasks:`: Defines the set of actions to perform on the target hosts.  
    * Tasks are the core of a playbook.  


### Tasks 
Tasks are defined by a name, then a module.  
```yaml
- name: Example play
  hosts: some-inventory-group
  become: yes  # Become root user to perform tasks
  tasks:
    - name: Example Task
      copy:  # The 'copy' Ansible module
        dest: ~/random_file.txt
        content: "This is what will be written to the file"
        mode: 0755  # Setting file permissions 
```


### Modules
Modules are essentially "tools" that perform individual tasks.  

Each module has its own purpose and set of arguments.  

Ansible provides many modules out of the box to handle administrative and
configuragion management tasks. 
```bash
ansible-doc -l           # List all modules available
ansible-doc module-name  # View docs for a specific module  
```

#### Common Modules 
* `apt`: Managing packages on Debian-based systems.  
* `setup`: Gathering facts about remote hosts.  
* `stat`: Getting information about files and directories.  
* `copy`: Copying files to remote hosts.  
* `file`: Managing files and directories.  


#### General Structure of a Task using a Module
```yaml
- name: Description of the task
  module_name:
    argument1: value1
    argument2: value2
    ...etc
```

## Getting Help with Ansible Modules
`ansible-doc` is the help command used to view documentation on Ansible modules.  
```bash
ansible-doc module-name  # Show docs for a specific module
```
It will show you all the `options` you can use for a module in a playbook.  
It will also show you the types that the options should have.  

```bash
ansible-doc apt # Show options for the `apt` Ansible module
ansible-doc -l  # List all modules available
```

To see a snippet of how to use a module in a playbook, use `-s`/`--snippet`.  
```bash
ansible-doc -s module-name
ansible-doc -s apt   # Show snippet for the `apt` Ansible module
ansible-doc -s stat  # Show snippet for the `stat` Ansible module
ansible-doc -s setup # Show snippet for the `setup` Ansible module
```


## Ansible Roles 
See [roles in Ansible](./roles_in_ansible.md).  

## Loops in Ansible
You can use a conditional to loop through a list of items.  
```yaml
tasks:
  - name: Loop through a list of items
    debug:
      msg: "The current item is {{ item }}.  "
    loop:
      - nginx
      - apache2
      - python3
      - "some other item"
    when: item != 'apache2'
```

## Updating in Batches (Serial)
In Ansible, `serial` refers to the number of hosts to run tasks on simultaneously during a play.  
It controls how Ansible processes a play across a group of hosts in chunks or "batches."

The `serial` keyword is defined in a playbook to specify the batch size for
processing hosts.  
```yaml
- name: Run tasks on hosts in batches
  hosts: webservers
  serial: 2
  tasks:
    - name: Example task
      debug: 
        msg: "Running on {{ inventory_hostname }}"
```
In this example, if there are 6 `webservers` in the inventory, tasks will be executed
on 2 hosts at a time.  
The play will process the first 2 hosts in parallel, then the next 2 hosts, etc.  

`ansible_play_batch` contains the list of active hosts in the current batch being
processed.  
If you're processing hosts in batches of 2, then `ansible_play_batch` will contain
the first 2 hosts in the inventory, then the next 2, as they're being processed.  


## Defining an Inventory using a Hosts File
See [inventory files in Ansible](./inventory_files.md) for more details.  

You can use a hosts file to define a group of hosts.  
By default, Ansible looks for `/etc/ansible/hosts` to specify an inventory.  

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


## Resources
* [Ansible Cheatsheet](https://devhints.io/ansible)
* [Ansible Modules](https://devhints.io/ansible-modules) 
* [Ansible Basics Cheatsheet](https://devhints.io/ansible-guide)
* [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)  
* [The Copy Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html

### Practicing with Ansible
[Vagrant](https://www.vagrantup.com/) is a tool that allows us to create virtual machines.  
[Proxmox](https://proxmox.com/) is a virtualization platform that allows us to create
virtual machines and containers.  
These tools are very useful for testing and practicing Ansible, as you can set up a
bunch of hosts to run playbooks on.  

## What about Terraform?
Ansible and Terraform serve very different purposes.  
Ansible is more automating server configuration & tasks, where Terraform is automating infrastructure.  
You'd use Terraform to spin up an EC2 instance, you'd use Ansible to install nginx on that EC2 instance.  
Generally speaking, TF spins up your infrastructure, Ansible configures it.  

## Questions

How do conditionals work in ansible?  
What is an ansible collection?  
What are 'blocks' in ansible?  
What are 'handlers' in ansible?


