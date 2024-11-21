# Setting up Ansible

## Table of Contents
* [Concepts, Terms, and Setup](#concepts-terms-and-setup) 
    * [Basic Concepts and Terms](#basic-concepts-and-terms) 
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

## Some Knowledge about Concepts, Terms, and Tools
### Basic Concepts and Terms  

* Host: A remote machine managed by Ansible.  
* Group: Several hosts grouped together that share a common attribute.  

* Inventory: A collection of all the hosts and groups that Ansible manages.  
    * Usually stored as `inventory.yml`
    * Could be a static file in the simple cases or we can pull the inventory  
      from remote sources, such as cloud providers.  

* YAML: The file format used for Ansible inventories and playbooks. 

* Roles: Redistributable units of organization that allow users to share automation code easier.  
    * Roles are similar to classes in OOP languages. They have the same tasks,
      variables, and handlers.   

---

* Playbooks: An ordered list of tasks along with its necessary parameters that define a recipe to configure a system.  
* Modules: Units of code that Ansible sends to the remote nodes for execution.  
* Tasks: Units of action that combine a module and its arguments along with some other parameters.  





### Most Common Ansible Tools
* `ansible`: Run ad-hoc commands on hosts.
* `ansible-playbook`: Execute structured automation workflows via YAML playbooks.
* `ansible-doc`: Look up documentation for modules and plugins.
* `ansible-vault`: Manage secrets securely.
* `ansible-inventory`: Work with inventories dynamically.
* `ansible-galaxy`: Handle roles and collections for modular automation.
* `ansible-console`: Experiment and debug interactively.


#### Different Ansible CLIs
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




### Requirements for Ansible  

#### Control Node Requirements  
Your "Control Node" (the machine running Ansible) can be any Linux/Unix  
machine with Python 3.8 or newer installed.  
* Your Control Node cannot be a Windows machine.  

#### Managed Nodes Requirements  

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

## Installing Ansible with Python

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

### Testing Ansible with a Demo  
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
