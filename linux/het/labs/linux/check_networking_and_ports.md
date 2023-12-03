

# Linux Commands for network information

## Scenario
You are a new system administrator at a company. You've been tasked with finding out information about a set of servers that has very little to no documentation on it.
Check network information.
Put the name of your network interface into a file called `/root/interface`.
Put the ip address of your network interface into a file called `/root/primary-ip`.
Write the default route out to a file called `/root/default`.

## Commands

1. Check your ip address
```bash
ip addr 
```

1. What is the name of your interface?
```bash
ip addr | grep enp | grep mtu | awk '{print $2}' | sed 's/://'
```

1. Put that value in a file `/root/interface`.
```bash
ip addr | grep enp | grep mtu | awk '{print $2}' | sed 's/://' > /root/interface
```
There are other ways to do this, but this will do it with one command.


1. What is the ip of your interface?
```bash
ip addr | grep enp | grep inet | awk '{print $2}' 
```

1. Put that value in a file `/root/primary-ip`.
```bash
ip addr | grep enp | grep inet | awk '{print $2}' > /root/primary-ip
```

1. Let's pull the default route for your system
```bash
ip route
```

1. What is the default route for your system? Write this out to `/root/default`
```bash
ip route | grep -i default | awk '{print $3}' > /root/default
```

1. Ping the default gateway 3 times and verify that you get a response back
```bash
ping -c3 `ip route | grep -i default | awk '{print $3}'`
```

