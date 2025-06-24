# Ansible.cfg


## Setting to Read from SSH Config
You can edit your ansible config (`Ansible.cfg`) file to define the SSH config file
you want Ansible to use for its SSH connections.  

Just add a `[ssh_connection]` section to `Ansible.cfg`:

```ini
[defaults]
inventory = ./inventory.yml
host_key_checking = False
timeout = 10
private_key_file = /home/kolkhis/.ssh/id_ed25519

[ssh_connection]
ssh_args = -F /home/kolkhis/.ssh/config
```

---

As long as your inventory file has the same hostnames as the SSH config file, you can
use this method to define your inventory addresses.  

```bash
all:
  children:
    nodes:
      hosts:
        node1: {}
        node2: {}
        node3: {}
        node4: {}
        node5: {}
        node6: {}
        pi: {}
    devbox:
      hosts:
        devbox: {}
```



