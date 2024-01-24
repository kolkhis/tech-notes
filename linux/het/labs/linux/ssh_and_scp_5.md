
# Linux Commands to Connect to Another System  


## Part 1  

### Scenario  
You are a new administrator and need to connect from the main jump server to  
another server in the organization.  
You realize you need a better understanding of the ssh connection process.  

Goal:  
* Connect to the other server and look at the specifics of the ssh connection.  

---

1. Check your ip address
```bash
ssh node01
```

1. Type in exit to return to the original system
```bash
exit
```

1. Check system uptime and one layer of debug.
```bash
ssh -v node01 'uptime'
```
* What additional information was shown with the -v option? (debug1)  
    * Shows each step of the connection process.
    * Includes attempts at authentication.


1. Check system uptime and two layers of debug.
```bash
ssh -vv node01 'uptime'
```
* What additional information was shown with the -vv option? (debug2)
    * Channel information is shown on debug2.

1. Check system uptime and three layers of debug.
```bash
ssh -vvv node01 'uptime' 
```
* What additional information was shown with the -vvv option (debug3)
    * Shows more channel information, as well as packet exchanges.
    * Includes the client and server key fingerprints.


So we looked at a ssh connection over to node01. You should note that the keys are being used and that is why no password was asked to connect. We'll explore that more shortly.

---

## Part 2


### Scenario
You are tasked with pushing the new MOTD message onto a server.
You also know that the server has a correct `/etc/crontab` configuration
that you will want to use on other systems.

`scp` is always "from" "to" on the command line, so the syntax is:
```bash
scp sourcetarget destinationtarget
```

Push the `/root/motd` file over to node01 at location `/etc/motd` and then log in to verify that the file has been pushed.

Pull `/etc/crontab` from `node01` to `controlplane` as file `/tmp/node01.crontab`

1. Verify the file you have at `/root/motd`
```bash
cksum /root/motd
```

1. Copy over the /root/motd to node01:/etc/motd
```bash
scp /root/motd node01:/etc/motd
```

1. You get to see information about how long it took to push the file.
Let's ssh over and see our MOTD
```bash
timeout 1 ssh node01
```

1. Let's verify the file is exactly the size we think it is over there
We can see them, so we'll set that to yes.
```bash
ssh node01 'cksum /etc/motd'
```

You should now both see the motd as you log in, as well as seeing the cksum matches what you did in step 1.

---

Now we have config files that we need to pull and give to the vendor. Let's pull those logs back over to this server from `node01`.

1. Verify cksum of `/etc/crontab` file
```bash
ssh node01 'cksum /etc/crontab'
```

1. Pull file over to /tmp/node01.crontab from node01
```bash
scp node01:/etc/crontab /tmp/node01.crontab
```

1. So now that you've pulled the file over, verify that it's exactly the same as you just saw it.
```bash
cksum /tmp/node01.crontab
```


