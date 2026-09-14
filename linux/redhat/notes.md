# RHCSA Notes

A collection of notes on RHCSA tasks and tools.  




## NTP (Network Time Protocol) and Chrony


On RHEL10, Chrony is the standard NTP implementation.  
Things to remember for the exam:
- `chrony`: The RPM package name (`dnf install -y chrony`)  
- `chronyd`: The systemd service and daemon name (`systemctl enable --now chronyd`)  
- `chronyc`: The CLI tool used to inspect and control `chronyd`  
- `/etc/chrony.conf`: The main config file for chrony  


A typical RHCSA task might include setting up NTP (Chrony) and configuring it
to use a specific source (e.g., `time.google.com`).  
```bash
dnf install -y chrony
vi /etc/chrony.conf
```
Add or modify an NTP source in this file by using the following syntax.  
```plaintext
server time.google.com iburst
```
The `server` keyword is used to specify a server to use, followed by the
address. Options can be added afterwards, e.g., `iburst`, which will start with
4-8 requests in order to make the first update of the clock sooner.  




