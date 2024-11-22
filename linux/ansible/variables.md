# Variables in Ansible

Ansible supports the use of variables.  

You can define your own variables, and use built-in special variables.  


## Table of Contents
* [Builtin Ansible Variables](#builtin-ansible-variables) 
    * [Ansible Facts](#ansible-facts) 
    * [Magic Variables](#magic-variables) 
        * [General Execution Context Variables](#general-execution-context-variables) 
        * [Inventory and Host Context Variables](#inventory-and-host-context-variables) 
        * [Playbook/Play Context Variables](#playbookplay-context-variables) 
        * [Role Context Variables](#role-context-variables) 
        * [Collection Variable](#collection-variable) 
        * [Loop Control Variables](#loop-control-variables) 
        * [Tags Variables](#tags-variables) 
    * [File and Path Variables](#file-and-path-variables) 
        * [Task Utility Variable](#task-utility-variable) 
        * [Deprecated Variables](#deprecated-variables) 
    * [Examples for Clarity](#examples-for-clarity) 
* [Resources](#resources) 


## Builtin Ansible Variables

Ansible has a number of builtin variables that you can use.  


### Ansible Facts
Ansible has a builtin "facts" variable (`ansible_facts`) that gathers information about the remote
systems it runs on.  
These facts are available to use in playbooks.  

It's a dictionary, and can be accessed like any other variable.  



### Magic Variables
These are variables that Ansible sets itself, and can't be set by the user.  


#### General Execution Context Variables
* `ansible_check_mode`: `true` if running in check mode (dry run).
* `ansible_diff_mode`: `true` if running in diff mode (show changes).
* `ansible_forks`: Number of concurrent processes (`--forks` setting).
* `ansible_verbosity`: Current verbosity level for output.
* `ansible_version`: Dictionary with Ansible version details (keys: `full`, `major`, `minor`, etc.).
* `ansible_config_file`: Path to the Ansible configuration file being used.
* `ansible_playbook_python`: Path to the Python interpreter on the control node.


#### Inventory and Host Context Variables
* `inventory_dir`: Directory of the inventory file where the host was defined.
* `inventory_file`: Filename of the inventory source for the host.
* `inventory_hostname`: Full hostname of the current host.
* `inventory_hostname_short`: Short hostname (up to the first `.`).
    * If `inventory_hostname = "example.com"`, then `inventory_hostname_short = "example"`.
* `group_names`: List of groups the current host belongs to.
    * If `group_names = ["web", "db"]`, the current host is in the `web` and `db` groups.
* `groups`: Dictionary of all inventory groups and their hosts.
* `hostvars`: Dictionary of all hosts and their variables.


#### Playbook/Play Context Variables
* `ansible_play_batch`: Active hosts in the current batch (e.g., limited by `serial`, see [updating in batches](./ansible.md#updating-in-batches-serial)).
* `ansible_play_hosts`: All hosts in the current play (excluding failed/unreachable ones).
* `ansible_play_hosts_all`: All targeted hosts in the play.
* `ansible_play_name`: Name of the current play.
* `ansible_limit`: Value of the `--limit` CLI option (host filtering).


#### Role Context Variables
* `ansible_role_name`: Fully qualified name of the current role (`namespace.collection.role_name`).
* `ansible_role_names`: All roles currently imported in the play.
* `ansible_parent_role_names`: List of parent roles for the current role (most recent first).
* `ansible_parent_role_paths`: Paths of parent roles (matching the order in `ansible_parent_role_names`).
* `role_name`: Name of the current role (deprecated).
* `role_path`: Path to the current role’s directory.


#### Collection Variable
* `ansible_collection_name`: Name of the collection the task belongs to (`namespace.collection`).


#### Loop Control Variables
* `ansible_index_var`: Variable name for the current index in a loop (if defined via `loop_control.index_var`).
* `ansible_loop`: Dictionary with extended loop details (`loop_control.extended` enabled).
* `ansible_loop_var`: Variable name for the current loop item (`loop_control.loop_var`).


#### Tags Variables
* `ansible_run_tags`: Tags included for the current run (`--tags` CLI option).
    * Running with `--tags=setup`, then `ansible_run_tags = ["setup"]`.
* `ansible_skip_tags`: Tags excluded from the current run (`--skip-tags` CLI option).


### File and Path Variables
* `ansible_search_path`: Current search path for relative files (e.g., templates, tasks).
* `playbook_dir`: Directory of the playbook being executed.


#### Task Utility Variable
* `omit`: Special variable to omit task options (e.g., `home={{ var|default(omit) }}`).


#### Deprecated Variables
* `play_hosts`: Deprecated. Use `ansible_play_batch` instead.
* `role_names`: Deprecated. Use `ansible_play_role_names` instead.



## Resources
* [Special variables in Ansible](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#special-variables)

