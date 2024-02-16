

# Ansible  
[Vagrant](https://www.vagrantup.com/) is a tool that allows us to create virtual machines.  
This tool is very useful for testing and practicing Ansible.  


## Table of Contents  
* [Quickref](#quickref) 
    * [Useful resources](#useful-resources) 
* [Basic Concepts and Terms](#basic-concepts-and-terms) 
* [Requirements for Ansible](#requirements-for-ansible) 
    * [Control Node Requirements](#control-node-requirements) 
    * [Managed Nodes Requirements](#managed-nodes-requirements) 
* [Installing Ansible](#installing-ansible) 
    * [Upgrading Ansible](#upgrading-ansible) 
    * [Verify the Installation](#verify-the-installation) 
* [Testing Ansible with a Demo](#testing-ansible-with-a-demo) 

## Quickref  
* [Ansible Cheatsheet](https://devhints.io/ansible)
* [Ansible Modules](https://devhints.io/ansible-modules) 
* [Ansible Basics Cheatsheet](https://devhints.io/ansible-guide)

### Roles 
Structure:
```
roles/
  common/
    tasks/
    handlers/
    files/              # 'copy' will refer to this
    templates/          # 'template' will refer to this
    meta/               # Role dependencies here
    vars/
    defaults/
      main.yml
```


### Useful resources:  
* [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)  



## Basic Concepts and Terms  

* Host:  
    * A remote machine managed by Ansible.  
* Group:  
    * Several hosts grouped together that share a common attribute.  
* Inventory:  
    * A collection of all the hosts and groups that Ansible manages.  
    * Could be a static file in the simple cases or we can pull the inventory  
      from remote sources, such as cloud providers.  
* Modules:  
    * Units of code that Ansible sends to the remote nodes for execution.  
* Tasks:  
    * Units of action that combine a module and its arguments along with some other parameters.  
* Playbooks:  
    * An ordered list of tasks along with its necessary parameters that define a recipe to configure a system.  
* Roles:  
    * Redistributable units of organization that allow users to share automation code easier.  
* YAML:  
    * A popular and simple data format that is very clean and understandable by humans.  



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
1. SSH/SFTP (or SCP) access to the Managed Nodes 
    * WinRM access for Windows.  
2. Python 2.6 or later, *or* Python 3.5 or later.  
    * PowerShell 3.0+ and .NET 4.0+ for Windows.  

 


## Installing Ansible  
Ansible installation can vary depending on your OS.  
* See [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu) for the official installation guide.  


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


















