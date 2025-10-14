# Connecting to your Homelab Remotely
## All Things Open 2025
## Presented by Alex Kretzschmar (Tailscale)

YT KTZ systems
alex.ktz.me
selfhosted.show


## what is a homelab?
- space safe to educate and break some egs

- a place to learn what uptime really means

- give old hardware new life

- a place to discover the empowerment of digital sivereignty and self-hosting

- a place to store your data

---

you don't need a rack. SFF PCs are:
- small  
- cheap
- easily expanded
- power efficient

raspis are used to fill this niche but not anymore

---

self hosting is fun!
- you own your data. you can lose your data and it's your fault, all the outages too!

- Build a solution piece by piece 

- considered project selection means you can build somlutions to last a lifetime with real craftmanship and care

- there is no bsiness model to feed (excpent an OSS developer.  

---

## Self hosted 

- Proxmox 
- Jellyfin
- Forgejo - self hosted git forge (eg., gittea, gitlab): does PRs, issues, has
  CI integrations
- Jellyfin: Selfhosted media server
- LibreSpeed: Speedtester.
- Home Assistant: One of the most important OSS of the time? Removes juggling.
  Brings home apps for IoT together.  

## How do we remotely access the homelab?

Model of trust we have for small local networks does not scale for WAns.  

Firewall was, in construction, a wall designed to stop fires.  

NAT was the solution to "not enough IPs" (not ipv6).  Network Address
Tanslation -- allows multiple devices on a sprivate network to share a singlle
IP when accessing the internet.  

---
Options:
- port forwarding.
    - usually a really bad idea. you can map any service to any port
      and poke a hole in the firewall.  
    - port forwarding is extremely dangerous.
- RDP (port 3389).  


No open ports means no one can get in.  

Alternative?

- tailscale
- 100 devices and 3 users for free.  

### NAT traversal challenge

> you want to connect from your phone on celluar to a service running behind a
> residential firewall
>
> both devices are behind firewalld and cannot directly connect to each other. 
> 
> Each side needs to "speak first" but their respective firewalls don't allow it.  

Each peer queries Tailscale STUN servers to discuver their public IP:PORT.  

- STUN server reports "I see your packets coming from XXXX:YYYYY".  
- Coordination server exchanges this endpoint info between peer.  
- Now each peer knows where to send packets.  

- Both peers send UDP packets to each other simultaenously
- First packets may be blocked, but they open the firewall for return traffic.  
    - If they fail, it'll hit a DERP server.  
- Subsequent packets flow through and a bidirectional connection is established.
- Firewalls now recognize traffic as "expected responses"

Every device talks to every other device.  


## Super easy to setup






## Resources
cramden hardware / cramden institute (durham)


- what is a port: IP:Port -- Arpartment:AptNum
- DNS on port 53



- realVnc 
- How NAT traversal works (on the tailscale website)

---
libvert

Things I hear:
- Why do you use NixOS instead of--
    - "because i hate myself"



