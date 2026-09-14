# RHCSA Notes

A collection of notes on RHCSA tasks and tools.  




## NTP (Network Time Protocol) and Chrony


On RHEL10, Chrony is the standard NTP implementation.  
Things to remember for the exam:
- `chrony`: The RPM package name (`dnf install -y chrony`)  
- `chronyd`: The systemd service and daemon name (`systemctl enable --now chronyd`)  
- `chronyc`: The CLI tool used to inspect and control `chronyd`  
- `/etc/chrony.conf`: The main config file for chrony  
