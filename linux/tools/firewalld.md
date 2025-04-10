# `firewalld` - The RedHat Flavored Firewall

Firewalld is the firewall that is used on RedHat-based distributions (i.e., Rocky
Linux, RHEL).  

Firewalld utilizes `iptables`.  


## Controlling Firewalld
The command line tool for controlling `firewalld` is `firewall-cmd`.  

* Check if the firewalld daemon is running, and start/enable it:
  ```bash
  systemctl status firewalld
  # start if it's not
  systemctl start firewalld
  # or, to enable and start
  systemctl enable --now firewalld
  ```

* Check what ports are exposed in `firewalld`
  ```bash
  firewall-cmd --list-ports
  ```

* Check what services are allowed through `firewalld`
  ```bash
  firewall-cmd --list-services
  ```

* Check both exposed services *and* ports:
  ```bash
  firewall-cmd --list-all
  ```

* List the firewall's "zones", and see if they have anything assigned to them:
  ```bash
  firewall-cmd --list-all-zones  # lists all the zones, and if they have anything assigned to them
  ```

* List active zones nad what network interface they're attached to:
  ```bash
  firewall-cmd --get-active-zones 
  ```

* Check the configuration files for a specific zone:
  ```bash
  vi $(firewall-cmd --permanent --path-zone=public) # open config for the 'public' zone in vi
  ```

* Expose a port in `firewalld`:
  ```bash
  # make temp changes
  firewall-cmd --add-port=8080/tcp
  firewall-cmd --add-port=8080/udp
  # make changes persist
  firewall-cmd --permanent --add-port=8080/tcp
  firewall-cmd --permanent --add-port=8080/udp
  # reload so changes take effect
  firewall-cmd --reload
  ```
    * This will add the ports, but the changes will not be persistent.  
        * Use the `--permanent` flag to make changes persist.  
    * Each rule must specify what kind of packets are allowed through the port (`tcp`/`udp`).  


* Expose several ports in `firewalld`:
  ```bash
  firewall-cmd --permanent --add-port={179,6443,2379}/tcp
  # Reload so changes take effect
  firewall-cmd --reload     
  ```

* Add a 'masquerade'
  ```bash
  firewall-cmd --add-masquerade --permanent
  firewall-cmd --reload     
  ```
    * Adds a `MASQUERADE` rule to `iptables` (used by firewalld).  
    * Ensures that packets exiting the node can use the node's external IP.  
    * Masquerade verification:
      ```bash
      # verify iptables rules allow inter-node traffic
      sudo iptables -L -n -v | grep MASQUERADE
      # if flannel isn't working, maybe try forwarding explicitly
      sudo iptables -P FORWARD ACCEPT
      ```

## Working with Ports

### Adding/Exposing Ports
To expose a port in `firewalld`, use the `--add-port` option:
```bash
# make temp changes during runtime
firewall-cmd --add-port=8080/tcp
firewall-cmd --add-port=8080/udp
```
This will add the ports, but the changes will not be persistent.  
Any changes without `--permanent` will only be part of the runtime configuration.  

```bash
# make permanent changes 
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=8080/udp
# reload so permanent changes take effect
firewall-cmd --reload
```
* Use the `--permanent` flag to make changes persist.  
    * When using `--permanent`, you must reload or restart `firewalld` for changes to
      take effect.  
* To make changes in both the runtime config and permanent config *without reloading*, 
  use the same call with and without the `--permanent` flag.  

* Each rule must specify what kind of packets are allowed through the port (`tcp`/`udp`).  

---

If you want to add a port only for a specific zone, you can specify the `--zone`:
```bash
firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --permanent --zone=public --add-port=8080/udp
firewall-cmd --reload
```

### Removing Ports
This works in the same way as adding ports, but use the `--remove-port` option
instead.  

```bash
firewall-cmd --remove-port=8080/tcp
firewall-cmd --remove-port=8080/udp
```
This changes the runtime config to disable these ports.  

Again, use `--permanent` and `--reload` to make permanent changes.  
```bash
firewall-cmd --permanent --remove-port=8080/tcp
firewall-cmd --permanent --remove-port=8080/udp
firewall-cmd --reload
```


## Working with Services
<!-- TODO: Finish this section -->



