
# Accessing the Command Line on the Flipper Zero

There are [three methods](https://docs.flipper.net/development/cli#HfXTy) to access the
Flipper Zero command line:  
1. Using Flipper Lab
2. Using the web serial terminal
3. Using a serial terminal


## Using a Serial Terminal on Windows
##### Official guide [here](https://docs.flipper.net/development/cli#rnDLl)


You need [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to
access the Flipper Zero command line on Windows.

* qFlipper can not be running.
* Plug in the Flipper Zero to your PC.
* Go to Device Manager -> Ports (COM & LPT).
* Look at the COM port number of your Flipper Zero connected.
* If there are several COM port numbers, disconnect and connect your Flipper Zero back
  to see the added port number.
* Run the PuTTY application.
* In the opened window, in the Connection type, select Serial.
* In the Serial line field, enter the COM port number (For example, COM3).
* In the Speed field, enter 230400.
* Click the Open button.



## Available Commands
##### Full command documentation [here](https://docs.flipper.net/development/cli/#nSulJ)

| Command | Description
|-|-
| `!`  | Alias for the info device command.
| `?`  | Alias for the help command.
| `bt` | Radio core (BLE) test app: intended for factory tests. It can be used to check the BLE HCI version.
| `crypto` | Crypto tool: used for enclave key provisioning and data encryption/decryption.
| `date` | Displays/sets the current date and time.
| `device_info` | Alias for the info device command (obsolete).
| `factory_reset` | Resets your device to the factory settings. Data on the microSD card will be saved.
| `free` | Displays heap memory allocator information. It can be used for general application memory use profiling.
| `free_blocks` | Displays heap memory allocator free blocks and their respective size. It can be used to estimate heap fragmentation.
| `gpio` | Allows to directly control GPIO pins: set mode, read/write state.
| `help` | Displays the list of available commands.
| `i2c` | I2C bus scan tool: can be used to search for a device on the bus.
| `ikey` | Reads, emulates, and writes iButton keys.
| `info` | Displays detailed information about the device and power system.
| `input` | Input subsystem command line tool: displays input and allows to inject input events into.
| `ir` | Reads and sends infrared signals.
| `led` | Notification service test app: allows to directly control LEDs and LCD backlight.
| `loader` | Application / Script loader: can enumerate compiled-in apps, can open internal or external (fap) app.
| `log` | System log viewer: allows to see device or app logs.
| `nfc` | NFC factory test app: controls field when the device is in Debug mode.
| `onewire` | 1-Wire bus scan app. It works on the same pins as iButton, but only scans for 1-Wire devices.
| `power` | Turns off and reboots the device, as well as enables the power supply to GPIO pins.
| `ps` | Process list: lists running processes and various information about them.
| `rfid` | Reads and emulates data from low-frequency RFID cards.
| `start_rpc_session` | Activates the remote procedure call (RPC) session. Switches the CLI into protobuf mode. Normally, you don’t need to do that.
| `storage` | Provides commands for interaction with the file system of the device.
| `subghz` | Sub-GHz test app: mostly used for factory testing, but also contains various supplementary tools.
| `sysctl` | System Control: configures various system settings.
| `update` | Firmware updater command-line tool: updates and backs up the device, and restores the internal storage.
| `uptime` | Displays the time since the last reboot of the device.
| `vibro` | Activates and deactivates the vibration motor.


