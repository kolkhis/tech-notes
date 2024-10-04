
# SELinux (Security Enhanced Linux)  

SELinux is a Linux Security Module (LSM) that provides an additional security layer for the  
system.  
This module implements a Mandatory Access Control (MAC) security model.  


## Table of Contents
* [tl;dr](#tldr) 
* [How SELinux Works](#how-selinux-works) 
* [SELinux Contexts](#selinux-contexts) 
    * [Contexts in Files](#contexts-in-files) 
    * [Context Examples](#context-examples) 
* [SELinux Modes](#selinux-modes) 
    * [Disabled](#disabled) 
    * [Permissive](#permissive) 
    * [Enforcing](#enforcing) 
* [Configuring SELinux Contexts](#configuring-selinux-contexts) 
    * [The Files where SELinux Contexts are Stored](#the-files-where-selinux-contexts-are-stored) 
    * [Important SELinux Commands for Managing Contexts](#important-selinux-commands-for-managing-contexts) 
    * [Managing Contexts Across Reboots](#managing-contexts-across-reboots) 
    * [Viewing SELinux Logs for Troubleshooting](#viewing-selinux-logs-for-troubleshooting) 
* [SELinux Troubleshooting](#selinux-troubleshooting) 
* [Resources](#resources) 



## tl;dr

* SELinux is a Linux module that implements a Mandatory Access Control (MAC) security model.  
* SELinux uses contexts to define the security domain of an "object" (file or process).
* An SELinux Context is a rule that defines access permissions for files/directory.  
    * Shown as `user:role:type:level` with `ls -Z`.  
* SELinux rules are checked *after* Discrectionary Access Control (DAC) rules (normal 
  Linux permissions) are checked.  
    
* `semanage`, `restorecon`, and `chcon` are used to manage SELinux contexts.  
    * Changes made with `semanage` are persistent across reboots. 
    * Changes made with `chcon` are temporary and revert after a reboot or relabel operation.
    * `restorecon` restores the SELinux context to match the policy you defined with `semanage`.
        * After setting the file context with `semanage`, you need to apply it to existing 
          files with `restorecon`.

* `ls -Z` and `ps -Z` 
    * Use `ls -Z` to view the SELinux context of files.
    * Use `ps -Z` to view the SELinux context of processes.


## How SELinux Works  

SELinux uses a **policy** file that sets the security **context** of each file or  
process.  



## SELinux Contexts  

Contexts define the security domain of an object (file or process).  
These domains control how different types of objects and subjects can interact.  
SELinux uses these contexts to enforce its access control policies.  

* An SELinux Context is a rule that defines access permissions for files/directory.  
* It consists of 4 parts:  
    * `user`: SELinux user identity.  
        * This is not the same as a Linux user. It's an SELinux-specific user that 
          processes and objects are assigned to.  
        * E.g., `system_u` represents system processes.  
    * `role`: This defines what a user or process is allowed to do on the system.  
        * E.g., `object_r` for files and directories, `system_r` for system processes.  
    * `type`: Defines what a process can interact with.  
        * Processes are labeled with a type, and files/resources are labeled with  
          a different type.  
        * SELinux policies decide which types can access or interact with each  
          other. This is called the "type enforcement".  
    * `level`: Defines the sensitivity or integrity level of the object. 
        * This is used for "Multi-Level Security" (MLS) and Multi-Category Security (MCS).  
        * Often used in government or other high-security environments.  
        * Default level is `s0`. 

### Contexts in Files  

Every file on an SELinux-enabled system is labeled with a context.  
This context controls which processes can access the file, and in what way.  

---

An SELinux Context is a rule that defines access permissions for files/directory.  
It consists of 4 parts:  
* `user`: SELinux user identity.  
    * This is **not** the same as a Linux user. It's an SELinux-specific user that 
      processes and objects are assigned to.  
    * E.g., `system_u` represents system processes, not an actual user on the system.  
* `role`: This defines what a user or process is allowed to do on the system.  
    * E.g., `object_r` for files and directories, `system_r` for system processes.  
* `type`: Defines what a process can interact with.  
    * Processes are labeled with a type, and files/resources are labeled with  
      a different type.  
    * SELinux policies decide which types can access or interact with each  
      other. This is called the "type enforcement".  
* `level`: Defines the sensitivity or integrity level of the object. 
    * This is used for "Multi-Level Security" (MLS) and Multi-Category Security (MCS).  
    * Often used in government or other high-security environments.  
    * Default level is `s0`. 


The `type` (third field) is important when defining what actions can be 
performed on the file.  

Examples:  
* Files labeled with the type `httpd_sys_content_t` can be read by the Apache web server but 
  not by other processes.  
* Files labeled with the type `ssh_home_t` are accessible only to the SSH daemon.  

### Context Examples  

Running `ls -Z` on a file, you'll see its SELinux context.  

* Check the context of the file with `ls -Z`:  
  ```bash  
  ls -Z /etc/passwd  
  ```
  Output:  
  ```plaintext  
  system_u:object_r:passwd_file_t:s0 /etc/passwd  
  ```
    * `system_u`: The system user, which is the user domain for system-related processes and files.  
    * `object_r`: The role, usually `object_r` for files and directories, which means it's
                  just a file-related role.
    * `passwd_file_t`: The file type (or domain) that indicates how SELinux policies handle this file.
        * `passwd_file_t` specifically identifies this file as the `/etc/passwd` file.
        * The type allows SELinux to apply the appropriate rules and restrictions.
    * `s0`: Security level.
        * This is the security level (MLS, or Multi-Level Security) part of the SELinux 
          context. Usually used in high-security environments.  
        * `s0`, the default, usually indicates the lowest security level, with no special restrictions applied.


---

Check context:
```bash  
ls -Z /var/www/html/index.html  
# Output:
-rw-r--r--. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html/index.html
#                     ^ user   ^ role   ^ type              ^ level
```
* `system_u`: SELinux user (`system_u` is a system user).
* `object_r`: The role (for files and directories, it's typically `object_r`).
* `httpd_sys_content_t`: The type (this means the file is meant to be served by an HTTP server).
* `s0`: The level, which is the default sensitivity level in this case.

In this example, the context `httpd_sys_content_t` is used to allow the Apache web 
server (`httpd_t` type) to read this file, but restrict access by other types of 
processes.



## SELinux Modes
The SELinux mode can be set in `/etc/selinux/config`.  

SELinux has 3 modes:
* Disabled
* Permissive
* Enforcing


### Disabled
When SELinux is set to disabled mode, the system does not enforce SELinux policies, 
and it does not label any persistent "objects" (files, directories, etc.) with a 
context.  

### Permissive
When SELinux is set to permissive mode, the system acts like SELinux is enforcing the
policies set. It labels objects, and logs access denial entries in the logs, but it
doesn't actually deny any operations. It's like a dry run.  

### Enforcing
Enforcing mode is the default. It labels objects and enforces all the SELinux policies.  




---


## Configuring SELinux Contexts


### The Files where SELinux Contexts are Stored
Contexts are stored in `/etc/selinux/targeted/contexts/files/file_contexts`.  
The format is:
```plaintext
/pattern/ -- user:role:type:level
```
* The whitespace on either side of the `--` are tabs.  
    * These are options, sometimes `-d`, `-c`, etc
* `/pattern/` can be a path or basic regular expression.  


### Important SELinux Commands for Managing Contexts 
The commands `semanage`, `restorecon`, and `chcon` are used to manage/modify file contexts.

1. `semanage`: The `semanage` command is used to manage SELinux policies, including 
   file contexts. You can view, add, and modify contexts with `semanage`.
   ```bash
   # List the contexts for a file or directory
   semanage fcontext -l | grep /var/www/html
 
   # Add or modify a context for a file or directory
   semanage fcontext -a -t httpd_sys_content_t "/mydir(/.*)?"
   ```
   By default, `semanage` will generate policies for the SELinux target.

2. `restorecon`: After setting the file context with `semanage`, you need to apply it 
   to existing files with `restorecon`.  
   `restorecon` restores the SELinux context to match the policy you defined with `semanage`.
   ```bash
   restorecon -Rv /mydir
   ```
   This recursively applies the correct context to `/mydir` and its contents based on 
   the `file_contexts` policy.

3. `chcon`: The `chcon` command changes the SELinux context for a file or directory, but
   unlike `semanage`, it only applies to the specific file or directory temporarily.  
    * If the system is rebooted or the file is relabeled, the context change will be lost.  
      So, this should only be used for temporary changes.
  ```bash
  chcon -t httpd_sys_content_t /path/to/file
  ```
  This command changes the type of the specified file to `httpd_sys_content_t`.

4. `ls -Z` and `ps -Z`: 
    * Use `ls -Z` to view the SELinux context of files.
    * Use `ps -Z` to view the SELinux context of processes.
   ```bash
   ls -Z /var/www/html
   ps -Z | grep httpd
   ```

### Managing Contexts Across Reboots 
Changes made with `semanage` are persistent across reboots. 
Changes made with `chcon` are temporary and revert after a reboot or relabel operation.

To make context changes persist, always use `semanage` and follow up with `restorecon`.  


### Viewing SELinux Logs for Troubleshooting
SELinux logs are stored in `/var/log/audit/audit.log`.  
 
You can use the `audit2why` and `audit2allow` tools to interpret these logs and 
create custom policies.


## SELinux Troubleshooting
Check the audit logs for context violations:
* `/var/log/audit/audit.log`
* `/var/log/messages` (if auditd isn't running)
The `ausearch` and `sealert` tools are also useful for troubleshooting:
```bash
ausearch -m avc -ts recent
# or
sudo sealert -a /var/log/audit/audit.log
```


## Resources
* [SELinux Project Documentation](https://selinuxproject.org) 
* [Red Hat SELinux Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux)





