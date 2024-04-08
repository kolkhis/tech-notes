
# Sample i3status Configuration (`man://i3status 34`)
```.c
general {
       output_format = "dzen2"
       colors = true
       interval = 5
}

order += "ipv6"
order += "disk /"
order += "run_watch DHCP"
order += "run_watch VPNC"
order += "path_exists VPN"
order += "wireless wlan0"
order += "ethernet eth0"
order += "battery 0"
order += "cpu_temperature 0"
order += "memory"
order += "load"
order += "tztime local"
order += "tztime berlin"

wireless wlan0 {
       format_up = "W: (%quality at %essid, %bitrate) %ip"
       format_down = "W: down"
}

ethernet eth0 {
       format_up = "E: %ip (%speed)"
       format_down = "E: down"
}

battery 0 {
       format = "%status %percentage %remaining %emptytime"
       format_down = "No battery"
       status_chr = "⚡ CHR"
       status_bat = "🔋 BAT"
       status_unk = "? UNK"
       status_full = "☻ FULL"
       path = "/sys/class/power_supply/BAT%d/uevent"
       low_threshold = 10
}

run_watch DHCP {
       pidfile = "/var/run/dhclient*.pid"
}

run_watch VPNC {
       # file containing the PID of a vpnc process
       pidfile = "/var/run/vpnc/pid"
}

path_exists VPN {
       # path exists when a VPN tunnel launched by nmcli/nm-applet is active
       path = "/proc/sys/net/ipv4/conf/tun0"
}

tztime local {
       format = "%Y-%m-%d %H:%M:%S"
       hide_if_equals_localtime = true
}

tztime berlin {
       format = "%Y-%m-%d %H:%M:%S %Z"
       timezone = "Europe/Berlin"
}

load {
       format = "%5min"
}

cpu_temperature 0 {
       format = "T: %degrees °C"
       path = "/sys/devices/platform/coretemp.0/temp1_input"
}

memory {
       format = "%used"
       threshold_degraded = "10%"
       format_degraded = "MEMORY: %free"
}

disk "/" {
       format = "%free"
}

read_file uptime {
       path = "/proc/uptime"
}
```

