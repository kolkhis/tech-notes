

# Installing Ubuntu Server on a Dell Optiplex 7050

This guide is geared towards the [Dell Optiplex 7050](https://a.co/d/4cy2dJd).


## Create a bootable USB drive

You can create a bootable USB drive right from your Optiplex (if you go through the Windows setup).
Or, if you have another Windows machine, you can use that too.
For MacOS users, use [this guide from Ubuntu](https://ubuntu.com/tutorials/create-a-usb-stick-on-macos#1-overview).

### Windows
Download the Ubuntu Server ISO [here](https://ubuntu.com/download/server)
Download Rufus [here](https://rufus.ie/en/)

##### View Ubuntu's full guide [here](https://ubuntu.com/tutorials/create-a-usb-stick-on-windows#1-overview)

Shortened guide:
1. Insert your USB drive.
1. Launch Rufus
1. Select your USB drive in Rufus
1. Select the Ubuntu Server ISO 
1. Leave all the defaults!
1. Click "Start" and wait for it to finish
    * Click "OK" or "Yes" to any prompts
    * Stick with the default ISO writing method
    * If this winds up not working when trying to install, try DD
1. When the "Start" button says "Ready", click Close.
1. Bootable drive obtained!


## Get the machine ready
1. Reboot the system, press F12 until you get to the boot menu. 
1. Go to Edit Boot Options all the way at the bottom.
1. Select "Enable Legacy Boot, turn Secure Boot OFF"
1. Confirm

## Install Ubuntu Server

View Ubuntu's full guide [here](https://ubuntu.com/tutorials/install-ubuntu-server#1-overview)

1. Make sure the USB drive is plugged into the back of your optiplex.
1. Restart the machine
1. Press F12 until you get to the boot menu
1. Under "Legacy", select "USB Storage Device"
 
1. In GNU GRUB, select "Try or Install Ubuntu Server"
1. Let the thing do the thing (lots of text scrolling by on screen)
 
1. Follow the setup. 
1. Agree to install the latest installer if prompted.
1. Recommended: Install the OpenSSH client.

Wait for it to show your SSH keys and stop printing stuff, then you'll be able to hit enter and
login.

Run `sudo apt update && sudo apt upgrade -y` to update the system.
Run `hostname -I` to find the IP address you'll need to SSH into the machine
* It'll usually be something like `192.168.x.xx`
* It's the first IP output. The rest of the IPv6 can be ignored.
* Can also run `ip a` and it'll be in there somewhere.



