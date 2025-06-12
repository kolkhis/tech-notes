# Ansible-Doc

The `ansible-doc` tool is shipped with Ansible, and contains Ansible documentation.  

It allows you to reference ansible documentation without leaving the command line.  

## Module Documentation

You can use `ansible-doc <builtin-module>` to get the documentation for a specific 
module.  
```bash
ansible-doc file
```

This will pull up the documentation for the `ansible.builtin.file` module.  

---

If you have a custom module that you need to reference the docs for, you can specify
the path to that module with the `-M` flag.  
```bash
ansible-doc -M /path/to/module
```

## Viewing Available Docs

You can use `ansible-doc -l` to view the modules that Ansible has documentation for.  

```bash
ansible-doc -l
```
This output can be very long, so do a `grep` if you're looking for something
specific.  

For instance, to check for `amazon` modules:
```bash
ansible-doc | grep amazon
```

This will show you the modules for `amazon.aws` that you can use with `ansible-doc`.  

E.g.:
```bash
ansible-doc amazon.aws.ec2
```

This shows you the documentation for the `amazon.aws.ec2` module.  

