# Ansible  
Ansible is used extensively for automation.  
It has the ability to run tasks on a list of remote hosts.  

---

Ansible uses [Playbooks](#ansible-playbooks), written in `yaml`, to define a list of [tasks](#tasks) to run on a list of hosts.  
Inside the Playbooks, you use [modules](#modules) to define how Ansible will complete tasks.  

---


Also see:  
* [Collections](./collections_in_ansible.md)
* [Conditionals](./conditionals_in_ansible.md)
* [Variables](./variables.md)
* [Roles](./roles_in_ansible.md)
* [Inventory Files](./inventory_files.md)
* [Misc. Ansible Notes](./misc_ansible.md)
* [Setting up Ansible](./setting_up_ansible.md)


## Table of Contents
* [Ansible Playbooks](#ansible-playbooks) 
    * [Run an Ansible Playbook](#run-an-ansible-playbook) 
    * [Debugging an Ansible Playbook](#debugging-an-ansible-playbook) 
    * [Items in Playbooks](#items-in-playbooks) 
    * [Tasks](#tasks) 
        * [Task keywords](#task-keywords) 
    * [Modules](#modules) 
        * [Common Modules](#common-modules) 
        * [General Structure of a Task using a Module](#general-structure-of-a-task-using-a-module) 
* [Tags in Tasks](#tags-in-tasks) 
* [Getting Help with Ansible Modules](#getting-help-with-ansible-modules) 
* [Ad-hoc Commands using Ansible](#ad-hoc-commands-using-ansible) 
    * [Create a Directory on Remote Hosts](#create-a-directory-on-remote-hosts) 
    * [Copy File to Remote Hosts](#copy-file-to-remote-hosts) 
    * [Modifying a Line in a File on Remote Hosts](#modifying-a-line-in-a-file-on-remote-hosts) 
* [Handlers](#handlers) 
* [Ansible Roles](#ansible-roles) 
* [Loops in Ansible](#loops-in-ansible) 
    * [Controlling Loops](#controlling-loops) 
        * [`loop_control` Examples](#loopcontrol-examples) 
* [Updating in Batches (Serial)](#updating-in-batches-serial) 
* [Defining an Inventory using a Hosts File](#defining-an-inventory-using-a-hosts-file) 
* [Save the Output of a Task in Ansible](#save-the-output-of-a-task-in-ansible) 
    * [Accessing The Registered Variable](#accessing-the-registered-variable) 
* [Blocks in Ansible](#blocks-in-ansible) 
    * [Basic Block Example](#basic-block-example) 
    * [Block Error Handling with `rescue` and `always`](#block-error-handling-with-rescue-and-always) 
* [Ansible Configuration Files](#ansible-configuration-files) 
* [Resources](#resources) 
    * [Practicing with Ansible](#practicing-with-ansible) 
* [Questions](#questions) 
    * [What about Terraform?](#what-about-terraform) 



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

Module actions in tasks can be one-liners as well.  
```yaml
- name: Install Vim
  apt: name=vim state=present
```


### Task keywords  
Most commonly used task keywords:  
* `name`: A descriptive name for the task.  
* `vars`: Define variables that are only available to the task.  
* `become`: Execute tasks with elevated privileges (root)  
* `args`: Provide parameters to the module in a dictionary format.  
    ```yaml  
    - name: Create a file  
      command:  
        cmd: ls -l /tmp/newfile  
        creates: /tmp/newfile  
      # The same as:  
    - name: Create a file  
      command:  
        cmd: ls -l /tmp/newfile  
      args:  
        creates: /tmp/newfile  
    ```

* `environment`: Set environment variables for the task.  
* `ignore_errors`: Continue execution even if the task fails.  
* `loop`: Interate over a list or sequence of items (see [loops](#loops-in-ansible)).  
    * `with_items`: Deprecated version of `loop`.  
* `loop_control`: Customize the behavior of the `loop` (see [loops](#loops-in-ansible)).  
    * E.g., Setting variables for indices or limiting output.  
    ```yaml  
    loop_control:  
      index_var: loop_index  
    loop:  
      - item1  
      - item2
      - item3
    ```

* `notify`: Trigger a handler task after the task completes successfully.  
* `register`: Save the output of the task to a variable.  

* `until`: Retry the task until a condition is met. Used with `retries` and `delay`.  
* `delay`: Set a delay before retying the task. Used with `retries`
* `retries`: Number of retries for a task if it fails. Used with `until`.  

* `when`: Specify a condition that must be met for a condition to run.  
* `become_user`: Execute the task as a different user (default is `root`).  
* `timeout`: Set a timeout for tasks (in seconds).  

* `debugger`: Enable the `task debugger` for the specific task. 
* `delegate_to`: Execute the task on a different host than the one in the inventory.  

* `tags`: Assign tags to the task for selective execution.  (see [tags](#tags-in-tasks))  

* `action`: Explicitly defines the module and its parametes (rarely needed, modules are usually defined dicrectly)  

### Playbook Keywords
###### See [Ansible docs on playbook keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html).  

### Modules  
Modules are essentially "tools" that perform individual tasks.  

Each module has its own purpose and set of arguments.  

Ansible provides many modules out of the box to handle administrative and  
configuragion management tasks. 
```bash  
ansible-doc -l           # List all modules available  
ansible-doc module-name  # View docs for a specific module  
```

Ansible recommends using the FQDN of modules inside playbooks (fully qualified domain name).  
E.g.:  
```yaml  
# Short name  
- name: Example task  
  copy:  
    src: /path/to/local/file  
    dest: /path/to/remote/file  
    mode: '0755'  
 
# Long name (FQDN)  
- name: Example task  
  ansible.builtin.copy:  
    src: /path/to/local/file  
    dest: /path/to/remote/file  
    mode: '0755'  
```

#### Common Modules 
These are some common `ansible.builtin` modules.  
* `apt`: Managing packages on Debian-based systems.  
* `setup`: Gathering facts about remote hosts.  
* `stat`: Getting information about files and directories.  
* `copy`: Copying files to remote hosts.  
* `file`: Managing files and directories.  
* `command`: Executing commands on the remote host.  
* `cron`: Managing cron jobs on the remote host.  
* `find`: Finding files on the remote host.  
* `fetch`: Fetching files from the remote host.  
    * Works like `copy`, except in reverse.
* `groups`: Managing groups on the remote host.  
* `ping`: Pinging remote hosts and verifying a usable Python.  
* `shell`: Executing shell commands on the remote host. 
    * Ansible recommends using `ansible.builtin.command` for one-liners. 
    * Use this module when you actually need a shell (e.g., for redirections, pipes, etc)  
* `script`: Running local scripts on a remote host.  
* `reboot`: Rebooting remote hosts.  
* `lineinfile`: Managing text in files (linewise).  
    * Good for single line changes. 
    * For multiple line changes, check `ansible.builtin.replace`.  
    * For modifying blocks of lines `ansible.builtin.blockinfile`.  


#### General Structure of a Task using a Module  
```yaml  
tasks:
  - name: Description of the task  
    module.name:  
      argument1: value1  
      argument2: value2
```
Each module has its own set of `arguments`.  
Refer to the module docs for the list of arguments a module will accept.  

## Tags in Tasks  
Tags allow you to label tasks so you can control which tasks are executed during a play.  
 
Using tags allows you to filter and skip tasks based on tags:  
```yaml  
- name: Install NGINX  
  apt: 
    name: nginx  
    state: present  
  tags:  
    - setup  
    - webserver  
```
Then, when using `ansible-playbook`:  
```bash  
ansible-playbook my_playbook --tags "setup"      # only run tasks with the `setup` tag.  
ansible-playbook my_playbook --skip-tags "setup" # skip all tasks with the `setup` tag.  
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

## Ad-hoc Commands using Ansible  
Ad-hoc commands are used to run tasks on a remote host without creating a playbook.  
```bash  
# Send a command to a host  
ansible servers -m shell -a "reboot"  
```
* `-m`: The module to use.
* `-a`: Arguments to pass to the module.  

```bash
ansible servers -i /hosts/file -m setup -a 'filter=ansible_distribution'
ansible servers -i /hosts/file -m setup -a 'filter=ansible_date_time'
```

### Create a Directory on Remote Hosts
To create a new directory on a list of hosts:
```bash
ansible servers -i /inventory/file -m file -a 'path=/home/user/new_dir state=directory'
```

### Copy File from Local Machine to Remote Hosts
To copy files into that new directory:
```bash
ansible servers -i /inventory/file -m copy -a 'src=/local/file dest=/home/user/new_dir'
```

### Copy file from Remote Host to Local Machine
Use the `fetch` command to bring down files from remote hosts to the local machine.
```bash
ansible servers -i /inventory/file -m fetch -a "src=/remote/file dest=/local/destination"
```

### Modifying a Line in a File on Remote Hosts
To modify a line in a file:
```bash
ansible servers -i /inventory/file -m lineinfile -a "path=/home/user/new_dir/file.txt regexp='^var1' line='var1=1000"
```
You use a regular expression to specify the line(s) you want to modify.  
Then you specify the new line you want to replace it with.  



## Handlers  
Handlers are defined at the play level under `handlers`. 
A `handler` is just like a task but only runs when notified (using `notify` in a task).  
```yaml  
- name: Configure webservers  
  hosts: webservers  
  tasks:  
    - name: Copy nginx config  
      copy:  
        src: nginx.conf  
        dest: /etc/nginx/nginx.conf  
      notify: restart nginx  

  handlers: 
    - name: restart nginx  
      service:  
        name: nginx  
        state: restarted  
```

Handlers are executed at the end of the play.  
If `serial` is used, handlers are executed after all tasks in the current batch.  



## Ansible Roles 
See [roles in Ansible](./roles_in_ansible.md).  

## Loops in Ansible  
###### Also see [playbook loops in ansible docs](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html).  
There are several ways to iterate over a list of items using `loop`.  
When `loop` is being used, each item is stored in the `item` variable.  
You can use a conditional to loop through a list of items.  
```yaml  
tasks:  
  - name: Loop through a list of items with a conditional
    debug:  
      msg: "The current item is {{ item }}.  "  
    loop:  
      - nginx  
      - apache2
      - python3
      - "some other item"  
    when: item != 'apache2'  

  - name: Loop over a range of numbers
    debug: msg="Number is {{ item }}"
    loop: "{{ range(0, 10) }}"

```


### Controlling Loops  
###### Also see [Loop control in the Ansible docs](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#loop-control) 
You can use `loop_control` to change the behavior of a loop.  

#### `loop_control` Examples  
You can use the `label` keyword under `loop_control` to set a label for the loop.  
The label is shown in the output on every iteration of the loop.  
```yaml  
- name: Install packages  
  apt:  
    name: "{{ item }}"  
    state: present  
  loop:  
    - vim  
    - git  
    - curl  
  loop_control:  
    label: "Installing {{ item }}"  

- name: Break out of a loop when a condition is met (version 2.18+)
  vars:
    my_var: "MATCH ME"
  debug: msg="Currently checking {{ item }}"
  loop:
    - "This won't match"
    - "Neither will this"
    - "MATCH ME"
    - "This won't get printed"
  loop_control:
    break_when: # Only version 2.18+
      - item is my_var
```

---  

Setting an `index_var` will set a 1-based index variable, available throughout the task.  
This can be used to dynamically name files or track the position in the loop.  
```yaml  
- name: Create files  
  copy:  
    dest: /tmp/file_{{ loop_index }}
    content: "This is file number {{ loop_index }}"  
  loop:  
    - one  
    - two  
    - three  
  loop_control:  
    index_var: loop_index  
    label: "Creating file {{ loop_index }}"  
```
This will create `/tmp/file_1`, `/tmp/file_2`, and `/tmp/file_3`.  

---  


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

---  



## Save the Output of a Task in Ansible  
You can save the output of a task using the `register` keyword.  
```yaml  
- name: Check free disk space  
  command: df -h  
  register: df_output  
```
* `df_output` is the name of the variable that will hold the output of the task.  

### Accessing The Registered Variable  
The output of a task is a dictionary that holds the values:  
* `stdout`: The output of the command (standard output).  
* `stderr`: Any errors that occurred  (standard error).  
* `rc`: The return code of the command.  
* `changed`: Whether the task caused any changes to the remote host.  

You can use `Jinja2` dot-notation to access the values in the dictionary.  
```yaml  
- name: Print the command output  
  debug:  
    msg: "{{ df_output.stdout }}"  
```
* `.stdout`: This is the actual output of the command.
    * Variables created from `register` are dictionaries themselves.  
    * The `stdout` is a key in the dictionary that contains the standard output of
      the command.  

### Accessing the Registered Variable in a Separate Play in the Same Playbook
If you define a variable in a playbook that has several plays, you can access your 
defined variables using the `hostvars` variable.  
This is a dictionary that holds all the variables and facts about every host in the
inventory.  

---

For example, if your hosts file contains a host named `host1`, you can access the
variables collected on that host in tasks from other hosts by using:
```bash
hostvars['host1']
```
Then you can use dot notation to access any of its variables.  
```bash
hostvars['host1'].ansible_host  # The IP address of host1
hostvars['host1'].ansible_user  # The username used on host1
```

### Capturing the output of Debug Messages
Using `register` with `debug` messages is a good way to save variables to use later.  
```yaml
    - name: Get the hostname for the local host
      ansible.builtin.debug:
        msg: "{{ ansible_hostname }}"
      register: localHostName

    - name: Print the hostname that was captured
      ansible.builtin.debug:
        msg: {{ localHostName.msg }}
```
The `msg` variable is the output of the debug message.  

This can also be done with `echo` from `ansible.builtin.command`, but you'd 
use the `stdout` key to access it instead of `msg`.

## Getting the IP Address of any Host in a Playbook
Get the ip address of a REMOTE host using the `hostvars['host-name'].ansible_host` variable.  
Using this on the localhost (in `hosts: localhost`) will result in localhost being returned (`127.0.0.1`).

## Blocks in Ansible
Blocks are a way to logically group tasks in Ansible.  

They allow you to apply common attributes (like `become` and `when`) to multiple
tasks at once, as well as handle errors using `rescue` and `always` sections for 
tasks within the block. 

A block is defined with the `block` keyword, and tasks are listed inside it.  

It can also include `rescue` (for error recovery) and `always` (for tasks that should
always run).  
* Tasks under `rescue` only run if a task (any task) in `block` fails.  
* Tasks under `always` run no matter what happens inside the `block`.  
```yaml
block: 
  # Tasks to execute
rescue:
  # Tasks to run if a task in the block fails
always: 
  # Tasks to run no matter what happens, success or failure
```

### Basic Block Example
```yaml
- name: Install and configure a web server
  block:
    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Start nginx
      service:
        name: nginx
        state: started
  when: ansible_os_family == 'Debian'
```
This runs both tasks only if the OS family is `Debian`.  
The `when` condition applies to the entire block, so you don't need to repeat it for
each task.  

### Block Error Handling with `rescue` and `always`
```yaml
- name: Install packages with error handling
  block: 
    - name: Install apache
      apt:
        name: apache2
        state: present

    - name: Start apache
      service:
        name: apache2
        state: started
  rescue:
    - name: Roll back by removing Apache
      apt:
        name: apache2
        state: absent

    - name: Notify admin of failure
      debug:
        msg: "Failed to install or start Apache!"
  always:
    - name: Ensure cleanup is done
      file:
        path: /tmp/install_logs
        state: absent
```
The `block` attempts to install and start Apache.  
The `rescue` runs if any task in the `block` fails.  
The `always` section runs no matter what happens in the `block`.  

---

## Ansible Configuration Files

Default config file locations:
* `/etc/ansible/ansible.cfg`: Global config file, used if it exists.  
* `~/.ansible.cfg`: User config file. Overrides the default config if it exists.  
* `./ansible.cfg`: Local config file (in current working directory).
    * This file is assumed to be 'project specific' and overrides the rest if present.

If the `ANSIBLE_CONFIG` environment variable is set, it will override all others and
use the file specified in the variable.  
* This should point to the config file you want to use.  

Check the current config file:
```bash
ansible-config view
ansible-config view -c 'config_file'
```

---
Generate an Ansible config file with all the defaults:
```bash
ansible-config init --disabled > ansible.cfg
```

View the ansible config:
```bash
ansible-config dump
ansible-config list
```

## Using `set_fact` to Persist Variables Across Plays
You can have multiple plays inside a playbook.  
But, when you define a variable inside of a play, it is local to that play.  
It will not be available in other plays, even within the same playbook.  

```yaml
- name: Collect information from one system
  hosts: localhost
  tasks:

    - name: Get the actual network IP for the current machine
      ansible.builtin.shell:
        cmd: 'hostname -I | awk "{ print $1 }"'
      register: master_node_ip

    - name: Save IP to facts
      ansible.builtin.set_fact:
        MASTER_NODE_IP: "{{ master_node_ip.stdout | trim }}" # Trim whitespace

- name: Different play to test fact
  hosts: servers
  tasks:
    - name: Show the information gathered on localhost
      ansible.msg.debug:
        msg: "Localhost IP:  {{ hostvars['localhost']['MASTER_NODE_IP'] }}"
```

## Jinja2 Filters 
Also see [Ansible builtin filters](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html#filter-plugins) and [jinja2 builtin filters](https://tedboy.github.io/jinja2/templ14.html#builtin-filters).  

Filters can be used on any variable using the pipe (`|`) character.  
Syntax:
```bash
"{{ variable | filter }}"
```

Common, useful filters:
* `trim`: Trim whitespace from the value.  
* `upper`: Converts a value to uppercase.  
* `lower`: Converts a value to lowercase.  
* `capitalize`: Converts the first character to uppercase, and the rest to lowercase.  
* `pprint`: Pretty-print the value.  
* `replace`: Perform a substitution on a value.  
    * `replace("hello", "goodbye")`: Replaces all instances of `hello` with `goodbye`.  
    * `replace("hello", "goodbye", 1)`: Replaces `1` instance of `hello` with `goodbye`.  


## Prompt for Passwords

### Password for `become`
Use the `-K` option when running a playbook to prompt for a `become` password.  
This is the same as `--ask-become-pass`.  
That way you don't have to set it anywhere on the system.  
```bash
ansible-playbook example_playbook.yml -K
```

### Password for SSH Connection
Use the `-k` (lowercase) option to prompt for the password needed to connect to the
remote machine.  



## Resources  
* [Intro to Playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html)  
* [Ansible builtin modules](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html)
* [Ansible Cheatsheet](https://devhints.io/ansible)  
* [Ansible Modules](https://devhints.io/ansible-modules) 
* [Ansible Basics Cheatsheet](https://devhints.io/ansible-guide)  
* [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)  
* [The Copy Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)  
* [Ansible Configuration](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)
* [Playbook Variables, Hostvars and Facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html)
* [Using Filters to Manipulate Data](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html)
* [Ansible Builtin Filters](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html#filter-plugins)
* [jinja2 builtin filters](https://tedboy.github.io/jinja2/templ14.html#builtin-filters)

### Practicing with Ansible  
[Vagrant](https://www.vagrantup.com/) is a tool that allows us to create virtual machines.  
[Proxmox](https://proxmox.com/) is a virtualization platform that allows us to create  
virtual machines and containers.  
These tools are very useful for testing and practicing Ansible, as you can set up a  
bunch of hosts to run playbooks on.  

## Questions  

How do conditionals work in ansible?  
What is an ansible collection?  [Ansible collections](./collections_in_ansible.md)  
What are 'blocks' in ansible?  
What are 'handlers' in ansible? [Handlers](#handlers)  

### What about Terraform?  
Ansible and Terraform serve very different purposes.  
Ansible is more automating server configuration & tasks, where Terraform is automating infrastructure.  
You'd use Terraform to spin up an EC2 instance, you'd use Ansible to install nginx on that EC2 instance.  
Generally speaking, TF spins up your infrastructure, Ansible configures it.  


