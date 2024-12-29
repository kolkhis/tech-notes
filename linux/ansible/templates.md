# Jinja Templates with Ansible

Jinja templating can be used directly inside ansible playbooks, or you can use
dedicated `.j2` files with the `ansible.builtin.template` module.  

They're great for dynamically formatting files/documents to display data in a consistent way.  

## Table of Contents
* [Example: Daily System Health Check](#example-daily-system-health-check) 

## Example: Daily System Health Check
###### Exampe provided by het_tanis and modified by me
A collection of tasks that will gather some basic health information about a system.  
Then, the information is formatted into a jinja template and sent to a webhook.  
```yaml
---
# tasks file for daily_system_check

#Start with gathering all the variables from the systems

- name: Gather all the uptimes from all the systems
  ansible.builtin.shell: "uptime"
  register: uptime

#last --since "$(date -d 'now - 24hour' +'%Y-%m-%d %H:%M')"
- name: login information from the last 24 hours
  ansible.builtin.shell: 
    cmd: |
      last --since \"$(date -d 'now - 24hour' +'%Y-%m-%d %H:%M')\" | awk '{print $1}' | grep -vE 'root|wtmp' | sort | uniq -c |xargs| cut -c 2- 
  register: users_check


#Copy and save the templates for every run
- name: Push out a template for system check items
  ansible.builtin.template:
    src: templates/daily_health_check.j2
    dest: "/root/daily_health_check/daily_system_check.{{ ansible_date_time.iso8601_basic_short }}.txt"
  delegate_to: localhost
  run_once: yes

- name: Health report output capture
  ansible.builtin.shell: 
    cmd: |
      cat /root/daily_health_check/daily_system_check.{{ ansible_date_time.iso8601_basic_short }}.txt
  register: health_report
  delegate_to: localhost
  run_once: yes

- name: Send something simple to sandbox server using a wrapper module for ansible.builtin.uri
  ansible_discord_webhook:  # A custom module
    webhook_url: "{{discord_webhook_url}}"
    content: "{{health_report.stdout}}"
  when: discord_webhook_url is defined
  delegate_to: localhost
  run_once: yes
```


---

This is the template that the data will be formatted into, using the
`ansible.builtin.template` module. 
This is the `templates/daily_health_check.j2` template.

```jinja2
Total systems: {{ ansible_play_hosts_all | length }}
Unreachable systems:
----------------------------------------------
{% for host in ansible_play_hosts_all %}
{% if host not in ansible_play_hosts %}
{{ host }}
{% endif  %}
{% endfor %}

Reboot Report (Last 24 hours):
----------------------------------------------
{% for host in ansible_play_hosts_all %}
{% if hostvars[host].uptime is defined %}
{% if 'day' not in hostvars[host].uptime.stdout %}
{{ host }}
{% endif  %}
{% endif  %}
{% endfor %}

User Logins to Servers in last 24 hours:
----------------------------------------------
{% for host in ansible_play_hosts_all %}
{% if hostvars[host].users_check is defined %}
 {{ hostvars[host].ansible_hostname }} - {{ hostvars[host].users_check.stdout }}
{% endif %}
{% endfor %}
```

