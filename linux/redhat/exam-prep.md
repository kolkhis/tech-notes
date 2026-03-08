# RHCSA Exam Prep

Notes taken from a video from Ozzoy Bits, found [here](https://www.youtube.com/watch?v=Odr61cc6CpE).  

## Exam Task Structure

The exam will have a series of tasks that must be executed to achieve a desired
machine state.  

**Note**: All RHCSA labs must achieve the desired state **with `firewalld` and
SELinux enabled**. This is a hard requirement.  


## Example Tasks

### Configure the Network

!!! info "Scenario"

    Configure the network for Server A first. Then Server B after password reset
    The networks will already be configured on these servers but the
    configuration must be changed to reflect the desired state.  

    Assign this IP address configuration to your virtual machines as follows:

    - Hostname servera.lab.example.com and serverb.lab.example.com
    - IP address:   192.168.1.150-151
    - NetMastk:     255.255.255.0
    - Gateway:      192.168.1.1
    - Nameserver:   192.168.1.100

    The root password for Server A will be provided, but they may require you
    do do the root password recovery process for Server B to get/set the root
    password.  

Example solution:

- Use NetworkManager (either `nmcli` or `nmtui`)

Example using `nmcli` (as root):
```bash
nmcli connection show
ip a
nmcli connection modify PROFILE_NAME  \
    ipv4.address 192.168.1.150/24 \
    ipv4.gateway 192.168.1.1 \
    ipv4.dns 8.8.8.8 \
    ipv4.method static
ping -c 1 google.com
```

Using `nmtui`, you'd simply run (as root):
```bash
nmtui
```
Then go through the user interface to modify the connection to the specified
state.  
Set the "IPv4 CONFIGURATION" setting to "Manual" then just fill in the rest of
the configuration.  
Once the settings are changed in the `nmtui`, you must go back and select the
same network interface and deactivate/reactivate it for changes to take effect.
 

