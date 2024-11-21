

# Ansible  
[Vagrant](https://www.vagrantup.com/) is a tool that allows us to create virtual machines.  
This tool is very useful for testing and practicing Ansible.  


## Table of Contents
* [What about Terraform?](#what-about-terraform) 
* [Basic Concepts and Terms](#basic-concepts-and-terms) 
* [Ansible Roles](#ansible-roles) 
    * [Role Directory Structure](#role-directory-structure) 
    * [Creating and Using a Role](#creating-and-using-a-role) 
        * [Creating a Role](#creating-a-role) 
        * [Defining Role Tasks](#defining-role-tasks) 
        * [Using a Role in a Playbook](#using-a-role-in-a-playbook) 
        * [Where you can Use Roles](#where-you-can-use-roles) 
* [Getting Help with Ansible](#getting-help-with-ansible) 
* [Most Common Ansible Tools](#most-common-ansible-tools) 
    * [Different Ansible CLIs](#different-ansible-clis) 
* [Requirements for Ansible](#requirements-for-ansible) 
    * [Control Node Requirements](#control-node-requirements) 
    * [Managed Nodes Requirements](#managed-nodes-requirements) 
* [Installing Ansible](#installing-ansible) 
    * [Installing Ansible on Debian-based Systems](#installing-ansible-on-debian-based-systems) 
    * [Installing Ansible with Python](#installing-ansible-with-python) 
    * [Upgrading Ansible](#upgrading-ansible) 
    * [Verify the Installation](#verify-the-installation) 
* [Testing Ansible with a Demo](#testing-ansible-with-a-demo) 
* [Ansible Playbooks](#ansible-playbooks) 
    * [Run an Ansible Playbook](#run-an-ansible-playbook) 
    * [Items in Playbooks](#items-in-playbooks) 
    * [Tasks](#tasks) 
    * [Modules](#modules) 
        * [General Structure of a Task using a Module](#general-structure-of-a-task-using-a-module) 
* [Inventory](#inventory) 
* [Resources](#resources) 


## Basic Concepts and Terms  

* Host: A remote machine managed by Ansible.  
* Group: Several hosts grouped together that share a common attribute.  

* Inventory: A collection of all the hosts and groups that Ansible manages.  
    * Could be a static file in the simple cases or we can pull the inventory  
      from remote sources, such as cloud providers.  

* YAML: The file format used for Ansible inventories and playbooks. 

* Roles: Redistributable units of organization that allow users to share automation code easier.  

---

* Playbooks: An ordered list of tasks along with its necessary parameters that define a recipe to configure a system.  
* Modules: Units of code that Ansible sends to the remote nodes for execution.  
* Tasks: Units of action that combine a module and its arguments along with some other parameters.  

## Ansible Roles 
Roles are used to organize and reuse playbook content.  

Roles are essentially a collection of tasks and their associated resources (variables,
templates, handlers, etc.) packaged together for a specific purpose.  
The purpose can be something like configuring a web server or setting up a database.  

---

### Role Directory Structure
A role has a predefined structure with specific directories for different types of content.  
This is what a typical role looks like:
```bash
roles/
└── myrole/
    ├── tasks/           # Contains the main list of tasks to execute
    │   └── main.yml     # Entry point for tasks
    ├── handlers/        # Contains handlers (triggered by tasks)
    │   └── main.yml
    ├── templates/       # Contains Jinja2 template files
    ├── files/           # Contains static files to copy to remote machines
    ├── vars/            # Contains variable definitions (static)
    │   └── main.yml
    ├── defaults/        # Contains default variable definitions (can be overridden)
    │   └── main.yml
    ├── meta/            # Contains metadata about the role (dependencies, etc.)
    │   └── main.yml
    └── tasks/main.yml   # Main entry point for the role
```
* `tasks/`: Where you define the main tasks for the role.  
* `handlers/`: Define handlers that are triggered by `notify` directive in `tasks`.  
* `templates/`: Store `Jinja2` templates for dynamically generating files.  
* `files/`: Store static files that can be copied to remote hosts.  
* `vars/`: Define variables that are specific to the role.  
* `defaults/`: Define default values for variables (lowest precedence).  
* `meta/`: Include metadata about the role (like depenencies).  

---

### Creating and Using a Role

#### Creating a Role
You *can* manually create the directory structure.  
You can also use the `ansible-galaxy` command:
```bash
ansible-galaxy init roles/myrole  # Initialize a new role
```
This will generate the full directory structure for a role named `myrole` under the
`roles` directory.  

---

#### Defining Role Tasks
The file `roles/myrole/tasks/main.yml` is used to define tasks for the role.  
```yaml
- name: Install NGINX
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Enxure NGINX is started
  service:
    name: nginx
    state: started
    enabled: yes
```

---

#### Using a Role in a Playbook
Use the name of the role in a playbook using the `roles` key.  
```yaml
- name: Example Playbook play
  hosts: webserver
  roles:
    - myrole
```
The playbook calls the `myrole` role.  
This runs the tasks and resources defined in the role (`roles/myrole`).  

---

#### Where you can Use Roles
* Playbooks
  ```yaml
  - hosts: webservers
    roles:
      - myrole
      - otherrole
  ```
* Role dependencies
    * Roles can depend on other roles. Define dependencies in
      `roles/myrole/meta/main.yml`
      ```yaml
      dependencies:
        - role: common
        - role: firewall
        - role: otherrole
      ```
* In the `include_role` task. You can include roles dynamically in a task.  
```yaml
- name: Include the myrole role
  include_role:
    name: myrole
```
* In collections. Roles can be part of an Ansible collection.
    * This can make them easy to distribute and reuse.  

## Getting Help with Ansible
`ansible-doc` is the help command used to view documentation on Ansible modules.  
```bash
ansible-doc module-name
```
It will show you all the `options` you can use for a module in a playbook.  
It will also show you the types that the options should have.  

```bash
ansible-doc apt  # Show options for the `apt` Ansible module
```



## Most Common Ansible Tools
* `ansible`: Run ad-hoc commands on hosts.
* `ansible-playbook`: Execute structured automation workflows via YAML playbooks.
* `ansible-doc`: Look up documentation for modules and plugins.
* `ansible-vault`: Manage secrets securely.
* `ansible-inventory`: Work with inventories dynamically.
* `ansible-galaxy`: Handle roles and collections for modular automation.
* `ansible-console`: Experiment and debug interactively.


### Different Ansible CLIs
```bash
ansible 
ansible-console     # REPL console for executing Ansible tasks (interactive prompt).
ansible-inventory   # View or manipulate inventory data (i.e., listing all hosts or their variables)
ansible-config      # View, list, or validate Anxible config files and settings
ansible-doc         # Plugin documentation tool. Displays module docs, inventory plugins, etc.
ansible-playbook    # Runs ansible playbooks.  
ansible-vault       # Encryption/decryption utility for Ansible data files
ansible-galaxy      # Manage roles and collections (install, list, remove, or create)
ansible-pull        # Pull and execute playbooks from remote SCM repositories (like Git)
ansible-connection  # Internal tool for managing remote connections (primarily for devs)
ansible-test        # Internal testing tool for validating changes to ansible itself (for contributors)
```




## Requirements for Ansible  

### Control Node Requirements  
Your "Control Node" (the machine running Ansible) can be any Linux/Unix  
machine with Python 3.8 or newer installed.  
* Your Control Node cannot be a Windows machine.  

### Managed Nodes Requirements  

For the "Managed Nodes" (the machines being managed by Ansible), Ansible  
needs to communicate with them over SSH and SFTP (can be switched to SCP in  
the `ansible.cfg` file), or WinRM (Windows Remote Management) for Windows hosts.  

The Managed Nodes also need Python 2.6 or later, *or* Python 3.5 or later.  
 
For Windows nodes, you need PowerShell 3.0 or later, and at least .NET 4.0 installed.  

So, to summarize, managed nodes need:  
* SSH/SFTP (or SCP) access to the Managed Nodes 
* Python 2.6 or later, *or* Python 3.5 or later.  

Or, managed nodes on windows:
* WinRM access for Windows.  
* PowerShell 3.0+ and .NET 4.0+ for Windows.  
 


## Installing Ansible  
Ansible installation can vary depending on your OS.  

### Installing Ansible on Debian-based Systems
For Debian-based systems, you can install Ansible using `apt`.
```bash
apt-get install ansible -y
```
* See [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu) for the official installation guide.  

### Installing Ansible with Python

If you don't have `pip` installed, you will need to install `pip` under  
your current Python version.  
```bash  
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  
python3 get-pip.py --user  
```

With `pip` installed, you can install Ansible.  
```bash  
python3 -m pip install --user ansible  
```

### Upgrading Ansible  
To upgrade the existing Ansible installation, just 
add `--upgrade` or `-U` to the command:  
```bash  
python3 -m pip install --upgrade --user ansible  
```

### Verify the Installation  
Test in the terminal to see if the installation was successful.  
```bash  
ansible --version  
```

## Testing Ansible with a Demo  
The demo is [here](https://spacelift.io/blog/ansible-tutorial).  

To test Ansible, we need a machine to use as a Control Node, and  
either physical machines or Virtual Machines to use for Managed Node(s).  

The managed nodes only need to be reachable by the Control Node via SSH/SFTP 
(or SCP if you changed it in `ansible.cfg`), or reachable via WinRM for Windows.  


The managed nodes can be physical machines or VMs, so we can use 
[Vagrant](https://developer.hashicorp.com/vagrant/docs/installation) to  
create some VMs. 
* Vagrant is a Hashicorp tool that allows us to create virtual machines.  
  This tool is very useful for running Ansible tests and practicing Ansible.  

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

#### General Structure of a Task using a Module
```yaml
- name: Description of the task
  module_name:
    argument1: value1
    argument2: value2
    ...etc
```











## Resources
* [Ansible Cheatsheet](https://devhints.io/ansible)
* [Ansible Modules](https://devhints.io/ansible-modules) 
* [Ansible Basics Cheatsheet](https://devhints.io/ansible-guide)
* [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)  
* [The Copy Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)


## What about Terraform?
Ansible and Terraform serve very different purposes.  
Ansible is more automating server configuration & tasks, where Terraform is automating infrastructure.  
You'd use Terraform to spin up an EC2 instance, you'd use Ansible to install nginx on that EC2 instance
Generally speaking, TF spins up your infrastructure, Ansible configures it

## Questions

What is an ansible collection?


