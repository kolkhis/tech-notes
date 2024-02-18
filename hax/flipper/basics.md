

# Flipper Zero Basics
Notes from the F0 [documentation](https://docs.flipper.net/basics/first-start).


## Table of Contents
* [Flipper Zero Basics](#flipper-zero-basics) 
* [Getting Started](#getting-started) 
    * [Powering On](#powering-on) 
    * [Rebooting](#rebooting) 
    * [Installing microSD Card](#installing-microsd-card) 
    * [Safely Removing the microSD Card](#safely-removing-the-microsd-card) 
* [Updating the Firmware](#updating-the-firmware) 
    * [Connecting to the Flipper Zero](#connecting-to-the-flipper-zero) 
    * [Updating Flipper Zero via the Flipper Mobile App](#updating-flipper-zero-via-the-flipper-mobile-app) 
* [Customizing system preferences](#customizing-system-preferences) 



## Getting Started
### Powering On
Power on the device by holding the `BACK` button for 3 seconds.  


### Rebooting
Reboot the device by holding `BACK` and `LEFT` for 5 seconds.


### Installing microSD Card
Mount the microSD card by inserting it (bottom side up).  
* More info on the microSD card [here](https://docs.flipper.net/basics/sd-card)



### Safely Removing the microSD Card
##### Official guide [here](https://docs.flipper.net/basics/sd-card#G4RTl)
Unmount the microSD card before removing it from your Flipper Zero.  
 
Removing the card while the device is still accessing it may 
corrupt the data or damage the file system on the card.
 
To safely remove the microSD card from your Flipper Zero:
1. Go to **Main Menu -> Settings -> Storage**.
2. Select **Unmount SD Card** and follow the instructions on the screen.
3. Once you have been notified that the microSD card is unmounted, remove the card
   from your Flipper Zero by gently pushing and then pulling the card.



## Updating the Firmware
##### Official guide [here](https://docs.flipper.net/basics/firmware-update)
* **Note**: It's important that an SD card is inserted before updating the firmware.  
Update the firmware via the [Flipper Mobile App](https://docs.flipperzero.one/mobile-app) or
[qFlipper](https://docs.flipperzero.one/qflipper).  



## qFlipper
### Updating the Firmware via the qFlipper Desktop App
##### Official guide [here](https://docs.flipper.net/qflipper#ORL5Q)
To update your Flipper Zero via the qFlipper application:
 
1. Connect your Flipper Zero to your computer via a USB cable.
2. On your computer, run the **qFlipper** application.
3. In the qFlipper application, go to the **Advanced controls** tab.
4. Click **Update Channel** and select a firmware version from the drop-down list 
    * Release is recommended.
5. Click **Update** to start the update process.



## Controlling the Flipper Zero via qFlipper
##### Official [docs](https://docs.flipper.net/qflipper#Yag86)
 
You can also control your Flipper Zero remotely via the qFlipper application:
1. In the Device information tab, click the Flipper Zero image.
2. Click the buttons on the screen
    * Or use your keyboard to control your Flipper Zero remotely.
    * Click ℹ️ to learn more about keyboard controls.
        * `WASD` for navigation
        * `space` or `enter` for `OK`
        * `backspace` for `BACK`
 
You can take screenshots from your Flipper Zero device and save them
directly to your computer by clicking the **SAVE SCREENSHOT** button.



## Flipper Mobile App
### Connecting to the Flipper Zero with the Flipper Mobile App
Connecting to Flipper Zero is done via the [Flipper Mobile App](https://docs.flipperzero.one/mobile-app) 
1. Activate Bluetooth on your Flipper Zero by following these steps:
    1. Go to Main **Menu -> Settings -> Bluetooth**.
    2. Set Bluetooth to **ON**.
2. In the Flipper Mobile App, tap **Connect**.
3. On the next page, next to the detected Flipper Zero's name, tap Connect.
4. In the Flipper Mobile App, **enter the pairing code** displayed on the Flipper Zero screen.
5. Tap Pair to finalize pairing.



### Updating Flipper Zero via the Flipper Mobile App
To update the firmware on the Flipper Zero via the Flipper Mobile App:
1. In the Main Menu tab, tap the Update button.
2. Tap the Update button to confirm the action.
* The update process via the Flipper Mobile App usually takes 2-3 minutes.
 More info on updating the firmware: [Firmware update](https://docs.flipperzero.one/basics/firmware-update).



## Customizing system preferences
Official guide [here](https://docs.flipper.net/basics/first-start#lFLy_).  
Once the firmware is updated, you can modify the system settings.  
  
E.g., left-handed mode, preferred units for measurements, time and date formats...
  
Do this by going to **Main Menu -> Settings -> System**.


## Getting Logs

### Current Session Logs
To get qFlipper logs for the current session:
1. In the qFlipper application, click **LOGS**.
2. Click **OPEN FULL LOG** and save the opened file to your 
   computer in the `.txt` format.

### Previous Session Logs
qFlipper saves logs for 100 last sessions on your computer, ensuring
easy access to past issue records.
To retrieve the qFlipper logs for the previous session:
1. In the qFlipper application, click **LOGS**.
2. Right-click the area where the current session logs are shown.
3. In the opened context menu, click **Browse all logs**.
4. In the opened folder, select the log file you need, paying close
   attention to the timestamp indicated in its name.








