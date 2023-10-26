
# Beginner Boost week 9


* Install Ubuntu Server on a WMware Virtual Machine
* SSH into it with Git Bash on Windows


## Getting stdout with bash and python from within vim

#### Type `:.!bash` to execute this bash loop
for i in {1..5}; do echo item $i.; done

#### Similarly, type `:.!python` (or `:.!python3`) to execute the code with python
[print(f"Item {x}.") for x in range (1, 6)]

. item
. item
. item
. item
. item

Beginner Boost: (Ubuntu Linux Server VMware VM via SSH) ->
        Full Metal Linux: (Linux Mint Cinnamon [Cheap Laptop Install]) ->
                Homelab init: (RedHat Server VM Host [12+ cores, 256+ RAM])

Difference between a VM and container?

Containers share the same machine, VMs don't.
VMs Virtualize a separate machine, containers all share a machine



Containers are *Ephemeral* > Can be discarded/thrown away at any time

### Setting up VM
#### Say No To NAT (If you want to simulate a server)

* Get iso for the distro you wanna install
* Open VMware player
* Click "Create a new VM"
* Select ISO, click next until the Overview
* Select "Customize Hardware" and go to Network Adapter
* Change "Network Adapter" to "Bridged: Connect directly to the physical network"
    - Also check "Replicate physcial network connection state"



You can connect with a VM that is in Bridged mode, using any device on the LAN.



This means that the VM can be accessed, not JUST from within the host PC. This will emulate the
behavior that it is a SEPARATE MACHINE ON THE NETWORK

Selecting NAT will not allow for SSH, running webservers, etc. You'd want it to be Bridged for all
of those use cases.

SSH into VM: in VM, run:
    `$ ip a` - get inet IP

then, in Git Bash:
    `$ ssh user@inetIP` wherer inetIP is the IP from the last cmd


DHCPv4 is a dynamic IP address assigned to the VM on startup. To reserve the IP so it doesn't
change, that must be done in the router.


... 

Install OpenSSH server

- Don't import SSH identity

####################   LOGGING IN WITH A PASSWORD OVER SSH IS INSECURE   ######################

- Only allow password authentication over SSH on Virtual Machines on a 
    LAN (Local Area Network) while setting it up 


SSH is a program for securely connecting to remote computers & Provide tunnel access to other servers


#### SSH Warning: REMOTE HOST IDENTIFICATION HAS CHANGED!

##### There are 2 time you will get this error:

    1. You're re-using a VM that has the same IP address after using a different OS on it (new host-keys).

    2. It's an *actual* man-in-the-middle attack.

If you see this error on a tunnel you've been using regularly without incident, that's a cause for
concern, unless you know FOR A FACT that the machine has changed (new OS, new host key).

So if this error happens over the internet, it's a man-in-the-middle attack, and should not ignore
it.


The fix (for home network/practice stuff, don't use this on real servers):

    $ vim .ssh/known_hosts
        - Go to line 5 (Or whichever line is specified in the error) and delete it
            - This deletes the old host key
            OR
            - Remove `~/.ssh/known_hosts`


##      Tmux
##### is sick.



## Easy SSH With Config:

In ~/.ssh/config you can add hosts to connect to by name
This is what it looks like:

```conf
Host homelab
  User kolkhis
  Hostname 192.168.0.23
```

Can also add a password, so you don't need to type it every time.
To do that, run (in Git Bash, not in the VM):

    `$ ssh-copy-id homelab`

You'll be prompted for password, and you can now SSH into your VM without typing the password

##### NOTE: This should only be done on LAN Servers NOT connected to the internet.
##### Anyone can read the config file.

( Git bash will create a private key that's readable by anyone on the system... )




