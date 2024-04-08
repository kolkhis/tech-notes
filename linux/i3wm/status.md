
## Table of Contents
* [Configuring the i3status bar](#configuring-the-i3status-bar) 
    * [Configuration File](#configuration-file) 
    * [How to Configure](#how-to-configure) 
    * [Testing your Configuration](#testing-your-configuration) 
    * [Calling External Scripts](#calling-external-scripts) 
* [Variables](#variables) 
    * [output_format](#output_format) 
    * [Colors](#colors) 
* [Default Modules](#default-modules) 
* [Universal `i3bar` Module Options](#universal-`i3bar`-module-options) 
    * [General](#general) 
    * [File Contents](#file-contents) 
    * [Volume](#volume) 
* [Sample Configuration (`man://i3status 34`)](#sample-configuration-(`man://i3status-34`)) 
* [Resources](#resources) 
* [Examples](#examples) 



# i3status

The `i3status` is the status bar shown at the bottom while using i3.


## Configuring the i3status bar
* The basic idea of i3status is that you can specify which "modules" should be
  used (the `order` directive).  
* You can configure each module with its own section.


### Configuration File

* `-c` Specifies an alternate configuration file path.
    * By default, `i3status` looks for config files in the following order:
        1. `~/.config/i3status/config` (or `$XDG_CONFIG_HOME/i3status/config` if set)
        2. `/etc/xdg/i3status/config` (or `$XDG_CONFIG_DIRS/i3status/config` if set)
        3. `~/.i3status.conf`
        4. `/etc/i3status.conf`


### How to Configure

1. Defining Modules:
    * To add a module to `i3status`, specify it in the `order` directive of your 
      configuration file.  
    * This `order` directive defines which `modules` appear on your status bar and in what order.

   * Example:
   ```config
   order += "datetime"
   order += "cpu_usage"
   order += "battery"
   ```
   Here, `"datetime"`, `"cpu_usage"`, and `"battery"` are the names of modules.


2. Configuring Modules:
    * Each module has its own section in the configuration file where you can customize its 
      behavior and appearance.

    * A more concrete example, configuring the `datetime` module:
      ```config
      datetime {
          format = "%Y-%m-%d %H:%M:%S"
      }
      ```

3. Customizing Output Format:
    * For every module, you can specify the output format to control how its information 
      is displayed on the bar.

    * Example of customizing the `battery` module output:
      ```config
      battery 0 {
          format = "%status %percentage %remaining"
      }
      ```

### Testing your Configuration
* Reload your config with a command like `i3-msg restart` from within i3.
* You can test your `i3status` configuration directly in a terminal by running `i3status`.  
    * You can change the `output_format` to `term` while doing this. `i3bar` will
      output JSON.  


### Calling External Scripts
* You can write scripts and call them from `i3status`.  
    * Example:
      ```config
      order += "custom_script"
      custom_script {
        exec = "/path/to/your/script.sh"
      }
      ```
      The output of the script is what will be shown on the status bar.  



## Variables
### `output_format`
For every module, you can specify the output format.  
You'd set the `output_format` in the `general` module to define it globally.  
 
Using `output_format` you can choose which format strings `i3status` should use in 
its output.

Available output formats:
* `i3bar`
    * `i3bar` comes with `i3` and provides a workspace bar which does the right thing in multi-monitor situations.  
    * It also comes with tray support and can display the `i3status` output.  
    * This uses JSON to pass as much metadata to `i3bar` as it can (colors, which blocks 
      can be shortened in which way, etc.).
* `none`
    * Does not use any color codes.  
    * Separates values by the pipe symbol by default.  
    * This should be used with `i3bar` and can be used for custom scripts.
* `term`
    * Good for debugging config files in the terminal.  

Other output formats:
* `dzen2`
* `xmobar`
* `lemonbar`

---

### Other Variables

---
 
* `format`  
 
This is the variable that will determine how the text is displayed on the
status bar.

---

* `align`



### Colors

Colors are defined in hex

Available color directives are:
* `colors`: Whether or not to show colors (turns colors off if `false`)
* `color_good`: Used to show a "good" value (successful).
* `color_degraded`: Used when a value is degraded.  
* `color_bad`: Used to show a "bad" value (an error). 
* `color_separator`: Used to color the separator for each module
    * This option has no effect when `output_format` is set to i3bar or none.


It’s also possible to use the `color_good`, `color_degraded`, `color_bad` directives 
to define specific colors per module (module scope overrides `general` scope).  

If one of these directives is defined in a module section its value will override the 
value defined in the `general` section just for this module.


## Default Modules

* `IPv6`: This module gets the IPv6 address used for outgoing connections (that is, the best available
   public IPv6 address on your computer).
* `Disk`: Gets used, free, available and total amount of bytes on the given mounted filesystem.
* `Run-watch`: Expands the given path to a pidfile and checks if the process ID found inside is valid (that
       is, if the process is running).
* `Path-exists`: Checks if the given path exists in the filesystem.
* `Wireless`: Gets the link quality, frequency and ESSID of the given wireless network interface.
* `Ethernet`: Gets the IP address and (if possible) the link speed of the given ethernet interface.
* `Battery`: Gets the status (charging, discharging, unknown, full), percentage, remaining time and power
       consumption (in Watts) of the given battery and when it’s estimated to be empty.
* `CPU-Temperature`: Gets the temperature of the given thermal zone.
* `CPU Usage`: Gets the percentual CPU usage from /proc/stat (Linux) or sysctl(3) (FreeBSD/OpenBSD).
* `Memory`: Gets the memory usage from system on a Linux system from /proc/meminfo.
* `Load`: Gets the system load (number of processes waiting for CPU time in the last 1, 5 and 15
       minutes).
    * See [`top` output](../tools/top.md#top-output).

* `Time`: Outputs the current time in the local timezone.
* `TzTime`: Outputs the current time in the given timezone.
* `DDate`: Outputs the current discordian date in user-specified format.
* `Volume`: Outputs the volume of the specified mixer on the specified device.
* `File Contents`: Outputs the contents of the specified file.




## Universal `i3bar` Module Options
When using the `i3bar` output format, there are a few additional options that can be used with
all modules to customize their appearance:

* `align`: The alignment policy to use when the minimum width (see below) is not reached.
* `min_width`: The minimum width (in pixels) the module should occupy.
* `separator`: A boolean value which specifies whether a separator line should be 
               drawn after this block.
* `separator_block_width`: The amount of pixels to leave blank after the block.

Example:
```
disk "/" {
   format = "%avail"
   align = "left"
   min_width = 100
   separator = false
  separator_block_width = 1
}
```



### General
The `general` module is where you set your "global" variables for `i3status`.  

```.c
general {
       output_format = "dzen2"
       colors = true
       interval = 5
       color_good = "#00FF00"
}
```


### File Contents
##### `man://i3status 561`
Outputs the contents of the specified file.



### Volume
##### `man://i3status 506`

List the names of your devices:
```bash
pacmd list-sinks | grep name
```
Output will look something like:
```plaintext
name: <alsa_output.usb-Logitech_G433_Gaming_Headset_000000000000-00.analog-stereo>
```
The name is what’s inside the angle brackets, not including them.




## Sample Configuration (`man://i3status 34`)
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









## Resources

* i3 User’s Guide: Comprehensive guide and reference for i3 users.  
    * Available at: [https://i3wm.org/docs/userguide.html](https://i3wm.org/docs/userguide.html)

* `i3status` Man Page: Detailed documentation on i3status, covering all available 
  modules and configuration options.  
    * `man://i3status`



## Examples

* Example of customizing the `battery` module output:
  ```config
  battery 0 {
      format = "%status %percentage %remaining"
  }
  ```

* A more concrete example, configuring the `datetime` module:
  ```config
  datetime {
      format = "%Y-%m-%d %H:%M:%S"
  }
  ```

* Example of calling a custom script:
  ```config
  order += "custom_script"
  custom_script {
      exec = "/path/to/your/script.sh"
  }
  ```

