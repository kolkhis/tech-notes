### Steps to Root Samsung Galaxy S8:

#### Step 1: Backup Data

Even though you mentioned you don't have important data on the device, it's always good to double-check.

#### Step 2: Check Bootloader Status and Unlock It

1. Check Status: Go to `Settings -> About Phone -> Software Information` and tap on `Build Number` 7 times to enable Developer Options. Then go to `Settings -> Developer Options` and check if `OEM Unlocking` is greyed out or not. If it's not, your bootloader is likely locked.
2. Unlock: If it's locked, toggle the `OEM Unlocking` option to unlock it.

#### Step 3: Install ADB and Fastboot

* Windows with WSL: You can install ADB and Fastboot via WSL using the command `sudo apt update && sudo apt install adb fastboot`.
* Ubuntu Server: Run the same command as above.

#### Step 4: Install Custom Recovery (TWRP)

1.  Download the TWRP image for your device from the official site.
    * If you have an Exynos variant, download the [TWRP file for Samsung Galaxy S8 (Exynos)](https://twrp.me/samsung/samsunggalaxys8.html).
    * If you have a Snapdragon variant, download the [TWRP file for Samsung Galaxy S8 (Snapdragon)](https://twrp.me/samsung/samsunggalaxys8qcom.html).
    * If you don't know your variant, see [determining TWRP version](#determining-twrp-version)
2.  Connect your phone to the computer.
3.  Open a terminal and run `adb reboot bootloader` to boot into bootloader mode.
4.  Run `fastboot flash recovery [path-to-twrp.img]` to flash TWRP.

#### Step 5: Root the Device Using Magisk

1.  Download the latest Magisk ZIP from the [official GitHub repository](https://github.com/topjohnwu/Magisk/releases).
2.  Boot into TWRP recovery on your phone.
3.  Select `Install` and choose the Magisk ZIP file to install it.

#### Step 6: Install Termux

Once your device is rooted, you can install Termux from the Google Play Store and gain root access within the app by typing `su`.

### Warnings

*   This will void your warranty.
*   Make sure your device is charged sufficiently before starting the process.

#### tl;dr

To root your Samsung Galaxy S8, you'll need to unlock the bootloader, install ADB and Fastboot, flash a custom recovery like TWRP, and then use Magisk to root the device.  
Finally, you can install Termux for root access.

#### Questions to Consider:

* What is ADB and Fastboot?
    
    * Answer: ADB (Android Debug Bridge) and Fastboot are command-line tools used for interacting with Android devices. ADB is used for debugging and Fastboot is used for flashing firmware.
* What is Magisk?
    
    * Answer: Magisk is a tool that provides root access and allows you to modify the system without altering system partitions.
* What is Termux?
    
    * Answer: Termux is a terminal emulator for Android that allows you to run a Linux distribution on your device.




## Determining TWRP Version
To determine which version of TWRP (Exynos or Snapdragon) you should download for your Samsung Galaxy S8, you need to know which chipset your device is using. Samsung Galaxy S8 models are released with different chipsets in different regions: Exynos and Snapdragon. Here's how you can find out which chipset your Galaxy S8 has:

### Method 1: Check the Model Number

1.  Go to `Settings` on your Galaxy S8.
2.  Scroll down and select `About phone`.
3.  Look for the `Model number`.

* If your model number is one of the following, it's an Exynos variant: SM-G950F, SM-G950FD, SM-G955F, or SM-G955FD.
* If your model number is one of the following, it's a Snapdragon variant: SM-G950U, SM-G950W, SM-G955U, or SM-G955W.

### Method 2: Use a Device Info App

You can also use a device information app from the Google Play Store to check your chipset. Apps like "CPU-Z" or "DevCheck Hardware and System Info" can provide detailed information about your device, including the chipset.

1.  Download and install a device info app from the Google Play Store.
2.  Open the app and navigate to the section displaying your device's chipset.

### Method 3: Use Mobitrix Tool

Another way to find detailed information about your device, including the chipset, is by using the Mobitrix tool.
Let's use Mobitrix to search for your Samsung Galaxy S8 and find out which chipset it has.

I'll perform a search for you. Please wait a moment.

### After Determining Your Chipset
* If you have an Exynos variant, download the [TWRP file for Samsung Galaxy S8 (Exynos)](https://twrp.me/samsung/samsunggalaxys8.html).
* If you have a Snapdragon variant, download the [TWRP file for Samsung Galaxy S8 (Snapdragon)](https://twrp.me/samsung/samsunggalaxys8qcom.html).

