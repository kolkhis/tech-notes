
# Customizing the Status Bar in i3wm

The runtime configuration file for the i3wm status bar: `~/.config/i3status/config`
This is separate from the `i3` config file, which is at `~/.config/i3/config`

## i3status

## Example (default) i3status:
```conf
# i3status configuration file.
# see "man i3status" for documentation.

# It is important that this file is edited as UTF-8.
# The following line should contain a sharp s:
# ß
# If the above line is not correctly displayed, fix your editor first!

general {
        colors = true
        interval = 5
}

order += "ipv6"
order += "wireless _first_"
order += "ethernet _first_"
order += "battery all"
order += "disk /"
order += "load"
order += "memory"
order += "tztime local"

wireless _first_ {
        format_up = "W: (%quality at %essid) %ip"
        format_down = "W: down"
}

ethernet _first_ {
        format_up = "E: %ip (%speed)"
        format_down = "E: down"
}

battery all {
        format = "%status %percentage %remaining"
}

disk "/" {
        format = "%avail"
}

load {
        format = "%1min"
}

memory {
        format = "%used | %available"
        threshold_degraded = "1G"
        format_degraded = "MEMORY < %available"
}

tztime local {
        format = "%Y-%m-%d %H:%M:%S"
}
```


### Suffix Options

There are options you can use to specify network interfaces in i3status.  
 
These options help you control how i3status selects which network interface to 
monitor and display.

#### tl;dr

* `_first_`: Selects the first network interface of the specified type.
* `_up_`: Selects the first network interface of the specified type that is currently active.
* `_down_`: Selects the first network interface of the specified type that is currently inactive.

#### `_first_` Suffix

In i3status configuration, the `_first_` suffix is used to specify the first network 
interface that matches a given type (e.g., wireless, ethernet).  

This can be useful when you have multiple network interfaces and you want i3status to 
display the status of the first available one.

- **Purpose**: The `_first_` suffix is used to indicate that i3status should display information for the first network interface of a specified type that it finds.
- **Example**:
  ```i3config
  wireless _first_ {
      format_up = "WiFi: (%quality at %essid) %ip"
      format_down = "WiFi: Not Connected"
      align = "left"
      separator_block_width = 25
  }
  ```

  This configuration tells i3status to display the status of the first wireless network interface it finds.


#### `_up_` Suffix

The `_up_` suffix tells i3status to display information for the first network 
interface of the specified type that is currently up (active).
* Example:
  ```i3config
  wireless _up_ {
      format_up = "WiFi: (%quality at %essid) %ip"
      format_down = "WiFi: Not Connected"
      align = "left"
      separator_block_width = 25
  }
  ```

  This tells `i3status` to display the status of the first wireless network interface 
  that is currently active.

#### `_down_` Suffix

The `_down_` suffix tells i3status to display information for the first network interface of the specified type that is currently down (inactive).
* Example:
  ```i3config
  wireless _down_ {
      format_up = "WiFi: (%quality at %essid) %ip"
      format_down = "WiFi: Not Connected"
      align = "left"
      separator_block_width = 25
  }
  ```
  This tells `i3status` to display the status of the first wireless network interface 
  that is currently inactive.


