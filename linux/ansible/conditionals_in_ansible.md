# Conditionals in Ansible
Ansible supports the use of conditional statements.  
This is done mainly with the `when` keyword, used as a key.


## `when`
`when` is used to evaluate a condition, written in `Jinja2` syntax.  
If the condition evaluates to `true`, the task/block will be executed.
If `false`, it's skipped.  

Conditions use `Jinja2` syntax, so you can use `Jinja2` filters and operators.  
```yaml
when: some_list | length > 5
```

### Syntax of `when`
```yaml
tasks: 
  - name: Example conditional task
    debug:
      msg: "This task runs if the condition is true."
    when: some_variable == "value"
```

---

## Conditional Operators (TODO)
Ansible supports the following conditional operators:
* `==`
* ``

## Examples of Using Conditionals in Ansible
### Conditional Task Execution
This task will only execute if the `when` condition is `true`.  
```yaml
tasks: 
  - name: Install nginx if the web_server variable is true
    apt:
      name: nginx
      state: present
    when: web_server == true
```

### Using Facts in Conditions
You can use "facts", which are variables that Ansible gathers about the remote host, 
in your conditions.
This is stored as a dictionary, and can be accessed using `ansible_facts` along with
a key (`ansible_facts['key']`).  
```yaml
tasks:
  - name: Install NGINX on Debian-based systems
    apt: 
      name: nginx
      state: present
    when: ansible_facts['os_family'] == 'Debian'
```

### Using Multiple Conditions
You can use multiple conditions in `when` statements using `and`/`or`.  
```yaml
tasks:
  - name: Task runs if either condition is true
    debug:
      msg: "At least one condition is true."
    when: ansible_facts['os_family'] == 'RedHat' or some_variable == "value"

  - name: Task runs if both conditions are true
    debug:
      msg: "Both conditions are true."
    when: ansible_facts['os_family'] == 'Debian' and some_variable == "value"
```

### Checking for the Existence of a File
Use the `stat` module to conditionally execute tasks based on the existence of a file.  
```yaml
tasks:
  - name: Check if a file exists
    stat:
      path: /etc/nginx/nginx.conf
    register: nginx_conf

  - name: Run task only if the file exists
    debug: 
      msg: "The nginx config file exists!"
    when: nginx_conf.stat.exists == true
```

### Using Conditional Loops
Use the `loop` keyword to iterate over a list of items, only if a condition is met.  
```yaml
tasks:
  - name: Install only necessary packages
    apt:
      name: "{{ item }}"
      state: present
    loop:
      - nginx
      - apache2
      - mysql-server
    when: item != "apache2"
```

### Negate Conditions (the `not` keyword)
Use `not` to negate a condition.  
```yaml
tasks:
  - name: Skip this task if the variable is true
    debug:
      msg: "This task will run if 'web_server' is false."
    when: not web_server
```

## Using `when` with Blocks
You can apply conditions to entire blocks of tasks.  
```yaml
tasks:
  - block:
    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Start Apache
      service: 
        name: apache2
        state: started
  when: ansible_facts['os_family'] == "Debian"
```

---

## Default Values for Variables in Conditions
If a variable used in a `when` statement is not defined, the task will always fail.  
You can use default values for variables by using the `default()` filter.  
```yaml
when: my_var | default(false)
```

## Conditionally Include other Playbooks or Tasks
You can use conditions to include other playbooks or tasks.
```yaml
- import_tasks: tasks.yml
  when: ansible_facts['os_family'] == "Debian"
```

