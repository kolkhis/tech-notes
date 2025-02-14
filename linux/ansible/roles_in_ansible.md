
# Ansible Roles 
See [roles in Ansible](./roles_in_ansible.md).  
Roles are used to organize and reuse playbook content.  

Roles are essentially a collection of tasks and their associated resources (variables,
templates, handlers, etc.) packaged together for a specific purpose.  
The purpose can be something like configuring a web server or setting up a database.  

They're somewhat similar to classes in object-oriented programming.  

## Table of Contents
* [Role Directory Structure](#role-directory-structure) 
* [Creating and Using a Role](#creating-and-using-a-role) 
    * [Creating a Role](#creating-a-role) 
    * [Defining Role Tasks](#defining-role-tasks) 
    * [Using a Role in a Playbook](#using-a-role-in-a-playbook) 
    * [Where you can Use Roles](#where-you-can-use-roles) 
* [Example of Using a Role in Ansible](#example-of-using-a-role-in-ansible) 
    * [Directory Structure](#directory-structure) 
    * [Playbook: `site.yml`](#playbook-siteyml) 
    * [Role tasks: `roles/nginx/tasks/main.yml`](#role-tasks-rolesnginxtasksmainyml) 

## Role Directory Structure
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

## Creating and Using a Role

### Creating a Role
You *can* manually create the directory structure.  
You can also use the `ansible-galaxy` command:
```bash
ansible-galaxy init roles/myrole  # Initialize a new role
```
This will generate the full directory structure for a role named `myrole` under the
`roles` directory.  

---

### Defining Role Tasks
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

### Using a Role in a Playbook
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

### Where you can Use Roles
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


---


## Example of Using a Role in Ansible

### Directory Structure
This is the directory structure for the example:
```bash
myproject/
├── roles/
│   └── nginx/
│       ├── tasks/
│       │   └── main.yml
│       ├── handlers/
│       │   └── main.yml
│       ├── templates/
│       │   └── nginx.conf.j2
│       ├── files/
│       ├── vars/
│       │   └── main.yml
│       ├── defaults/
│       │   └── main.yml
│       ├── meta/
│       │   └── main.yml
├── inventory
└── site.yml
```

### Playbook: `site.yml`
```yaml
- hosts: webservers
  roles:
    - nginx
```
* `-` Indicates the start of the play.  
* This will inherit and run all the `tasks` in the `nginx` role.  
* All tasks will be run on the `webservers` hosts defined in the `inventory.yml`

### Role tasks: `roles/nginx/tasks/main.yml`
```yaml
- name: Install NGINX
  apt:
    name: nginx
    state: present
 
- name: Deploy NGINX configuration
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    mode: 0644

- name: Start and Enable NGINX
  service:
    name: nginx
    state: started
    enabled: yes
```


## Basic Role Usage
- Create a directory called `roles`:  
  ```bash
  mkdir roles
  cd roles
  ```

- Then initialize a role:  
  ```bash
  ansible-galaxy init <role_name>
  ```
  Then a bunch of directories are created.  
  This can be overwhelming at first but if you just need to run tasks then you only need look at the `tasks` directory.  

- Look in the `<role_name>/tasks/` directory for a file called `main.yml`.  
  Put any tasks you want to run in that file.  

- Then, in your playbook:
  ```yaml
  - name: Name of the playbook
    hosts: your-hosts
    roles:
      - role_name
  ```
  All the tasks in that `main.yml` file should be run.  

If you need to use variables, templates, etc., there are other directories where you put those (like `<role_name>/vars` for variables).  


## Using Variables to Assign Roles Dynamically

If you want to assign roles dynamically based on host variables, you can do:
```yaml
- name: Apply roles based on host variables
  hosts: all
  roles:
    - "{{ assigned_roles }}"
```

Then, in your inventory:
```ini
[web_servers]
web1 ansible_host=192.168.1.10 assigned_roles=["webserver_role"]
web2 ansible_host=192.168.1.11 assigned_roles=["webserver_role"]

[db_servers]
db1 ansible_host=192.168.1.20 assigned_roles=["database_role"]
db2 ansible_host=192.168.1.21 assigned_roles=["database_role"]
```
* The `assigned_roles` variable will be used to determine which roles to run on each given host.  

