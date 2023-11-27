
# Disk Management and Logging

## Disk and System Information


### Get System Information
* `uname -a`: Check kernel/OS  
* `uname -r`: Check kernel version
* `uptime`  : Check how long system has been up
* `cat /proc/cmdline` : Get info on how the system was started
* `vmstat 1 5` : Check virtual memory usage (1 second intervals for 5 seconds)
* `mpstat 1 5` : Check overall CPU usage
* `ps -ef` : Check what processes are running on the system
* `ps -ef | awk '{print $1}' | sort | uniq -c`

* `pidstat 1 5` : Check which processes are executing on the processor
* `iostat -xz 1 5` : More CPU and Disk usages

* `sar -n DEV 1 5`: Check network usage and load of system

* `ethtool enp1s0`: Check link to `enp1s0`, or any other network connection

* `dmidecode` : Get system information

* `dpkg -l | wc -l` : Get number of packages in `dpkg`
* `dpkg -l | grep -i ssh`: Get packages with `ssh` in their names

* `xdsh computer 'rpm -qa | wc -l'`: ???

## Disk Information

* `fdisk -l | grep -i vd`: Check physical disk(s) and their partitions.  
    * Physical disks will be `vd{a,b,c..}` or `sd{a,b,c..}`  
        * `Disk /dev/vda:`  
        * `Disk /dev/sda:`  
    * Disk partitions will be `vd{a,b,c..}{1,2,3..}` or `sd{a,b,c..}{1,2,3..}`  
        * `/dev/vda1`  
        * `/dev/sda1`  

* `lsblk`: check disk information  
* `blkid`: check disk information  
    * `blkid /dev/vda1`  
    * `blkid /dev/sda2`  

* `df -h`: Filesystem usage  

* `mount | grep vda`: Mount with no args lists mounted devices  

* `df -h / | grep -v Size | awk '{print $2}'`  
* `df -h / ` will show the `/` root directory in df  
* `grep -v Size` will remove the Size column  
* `awk '{print $2}'` will print 2nd column  

* `df -i`: Inodes  


## Logging and Monitoring

* `iostat -d 1 5` : Monitors disks  



If you can ping localhost, you're listening all the way through your NIC

Killercoda lab on setting up telemetry/logging:
[here](https://killercoda.com/het-tanis/course/Linux-Labs/102-monitoring-linux-logs)  

Uses:
* Grafana - for displaying data nicely  
* Promtail - pushes logs into the Loki server  
* Loki - API driven log aggregator  


## Limiting resources

* `ulimit [-HS] -a`
* `ulimit [-HS] [-bcdefiklmnpqrstuvxPRT [limit]]`
Provides control over the resources available to the shell and to
processes started by it, on systems that allow such control.  
* `man bash; /ulimit \[-HS`

