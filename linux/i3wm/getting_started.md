# Getting Started with i3

- See: <https://i3wm.org/docs/userguide.html>

Keys to use with $mod (Alt):
<img src="https://i3wm.org/docs/keyboard-layer1.png"></img>

Keys to use with Shift+$mod:
<img src="https://i3wm.org/docs/keyboard-layer2.png"></img>

## Introduction to i3wm

i3wm, or i3 window manager, is a tiling window manager designed for X11 that 
emphasizes efficiency, productivity, and customization.  
Its goal is to improve your workflow with a clean and minimalistic approach that 
reduces the clutter of windows and maximizes your workspace efficiency.

## Getting Started with i3wm

### Installation

i3wm can be installed via the package manager.  
Open a terminal and run:

```bash
sudo apt update && sudo apt install i3
```

During the installation, you might be prompted to choose a display manager; LightDM 
is a common choice that works well with i3.

### First Launch

After installing, log out of your current session.  
At the login screen, you can switch the session to i3 before logging in.  

Once you log in with i3 selected, you'll be greeted with a basic setup prompt, which 
will ask if you want i3 to generate a default configuration file in your home 
directory (`~/.config/i3/config`).  

Say yes, and choose either `Win` or `Alt` as your Mod key (the primary modifier key 
for i3 commands).

### Basic Navigation

* Opening a terminal: By default, you can open a terminal with `Mod+Enter`.
* Closing windows: Close windows with `Mod+Shift+Q`.
* Moving between windows: Navigate between windows with `Mod+arrow keys`.
* Splitting windows: You can split windows horizontally with `Mod+h` and vertically 
  with `Mod+v`.
* Full screen mode for a window: Toggle full screen with `Mod+f`.
* Exiting i3: Exit i3 or logout with `Mod+Shift+E`.

## Configuring and Customizing i3wm

Your i3 config file is located at `~/.config/i3/config`.  

### Customizing Key Bindings

Key bindings allow you to execute commands with key combinations.  
You can customize them in your config file.  
For example, to bind `dmenu` (which we'll discuss shortly) to `Mod+d`, you'd add:

```config
bindsym Mod1+d exec --no-startup-id dmenu_run
```

Replace `Mod1` with `Mod4` if you're using the Windows key as your Mod key.

### Changing Look and Feel

i3wm is highly customizable.  
You can change the color of the window borders, title bar, and more by adding color settings to your config file.  
For example:

```config
 Set border, background, text, and indicator colors
client.focused #4C7899 #285577 #ffffff #2e9ef4
client.unfocused #333333 #5f676a #ffffff #484e50
```

### Autostart Applications

You might want some applications to start automatically when i3 starts.  
This can be done by adding `exec` commands in your config file.  
For example, to start nm-applet (Network Manager applet) on i3 startup:

```config
exec --no-startup-id nm-applet
```

## Getting `dmenu` Working

`dmenu` is a dynamic menu for X, which provides a fast way to launch applications.  
It should work out of the box with i3, but if it's not installed, you can install it
via `apt`:

```bash
sudo apt install dmenu
```

After installing, you can use the binding (`Mod+d` if you've set it as above) to launch `dmenu`.  
If it doesn't work, check that the binding is correctly set in your i3 config file and that there are no conflicts or syntax errors.

## Troubleshooting

If `dmenu` or any part of your i3 setup isn't working as expected:

* Check the syntax of your `~/.config/i3/config` file for errors.
* Consult the i3wm documentation and user forums for specific configuration issues.
* Restart i3 in-place with `od+Shift+R` to apply configuration changes without ending your session.

## TL;DR

* Install i3wm on Linux Mint with `sudo apt update && sudo apt install i3`, and choose your Mod key on first launch.
* Navigate using the Mod key + defined shortcuts, and customize your setup by editing `~/.config/i3/config`.
* Install `dmenu` with `sudo apt install dmenu` and bind it to a shortcut for fast application launching.
* Customize, configure, and troubleshoot using the i3 documentation as needed.

