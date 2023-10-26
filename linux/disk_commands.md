


# Bash Commands for Disk Management and Monitoring



`iostat -d 1 5`
- Monitors disks

### Get bits: Zero, random or random 0/1
/dev/zero : returns zero
/dev/random : returns random
/dev/urandom : returns random 0 or 1


-rw------
^
l = sym link, - = hard link

`uname -a`: Check OS version
`uname -r`: Check kernel version
`uptime`  : Check how long system has been up
`cat /proc/cmdline` : Get info on how the system was started
`vmstat 1 5` : Check virtual memory usage (1 second intervals for 5 seconds)
`mpstat 1 5` : Check overall CPU usage
`ps -ef` : Check what processes are running on the system
`ps -ef | awk '{print $1}' | sort | uniq -c`

`pidstat 1 5` : Check which processes are executing on the processor
`iostat -xz 1 5` : More CPU and Disk usages

`sar -n DEV 1 5`: Check network usage and load of system

`ethtool enp1s0`: Check link to `enp1s0`, or any other network connection

`dmidecode` : Get system information

If you can ping localhost, you're listening all the way through your NIC


`dpkg -l | wc -l` : Get number of packages in `dpkg`

`dpkg -l | grep -i ssh`


`xdsh computer 'rpm -qa | wc -l'`

`fdisk -l | grep -i vd`: Check physical disk(s)
Physical disks will be `vd{a,b,c..}`
Disk partitions will be `vd{a,b,c..}{1,2,3,4}`
e.g.,
Disk:
`Disk /dev/vda:`
Partition:
`/dev/vda1`

`lsblk`: check disk information
`blkid`: check disk information

`df -h`: Filesystem usage

`mount | grep vda`

`blkid /dev/vda1`

`df -h / | grep -v Size | awk '{print $2}'`
`df -h / ` will show the `/` root directory in df
`grep -v Size` will remove the Size column
`awk '{print $2}'` will print 2nd column


`df -i`: Inodes


## Logging
https://killercoda.com/het-tanis/course/Linux-Labs/102-monitoring-linux-logs
Grafana
Promtail pushes logs into the Loki server
Loki - API driven log aggregator



