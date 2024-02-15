
# Android Development

Download the [Android SDK](https://developer.android.com/tools/releases/platform-tools).  

[Android Studio](https://developer.android.com/studio/index.html)
is the IDE that people use for Android development.  

## Cool and Useful Packages

* [`adb`](https://developer.android.com/tools/adb): Android Debug Bridge
    * This is a CLI tool that lets you communicate with android devices.  

* [scrcpy](https://github.com/Genymobile/scrcpy) 
    * This allows you to mirror your android device to your PC.  
    * It's useful for debugging or remotely controlling your device.  

* [Shizuku](https://github.com/RikkaW/Shizuku) 
    * Allows you to run Android apps on non-rooted devices.  
    * Lets your app use the full Android API.  

* [fastboot](https://developer.android.com/tools/releases/platform-tools)
    * On Android, Fastboot is a diagnostic tool.  
    * Enables access all your device's partitions.
        * Not just the Android system, but also the data partition, the boot partition, and so on.
    * It's essential if you need to unbrick your phone, and is most commonly used
      to install a custom recovery.


* [`Termux`](https://termux.com/)
    * A terminal emulator for Android that provides a Linux environment.  
    * This allows you to use a variety of Linux packages on Android.
    * Great for running scripts, compilers, and even a text-based development
      environment directly on your device.

* `Tasker`
    * An automation app that lets you automate almost anything on your Android
      device without needing to root it.
    * Can be used for a wide range of tasks from simple to complex, such
      as changing settings by application, time, location, and more.

* [`TWRP`](https://twrp.me/) (Team Win Recovery Project)
    * An open-source, community-developed recovery firmware for Android devices.
    * Provides a touchscreen-enabled interface that allows users to
      install third-party firmware and backup the current system, which
      is often unsupported by stock recovery images.

* `Magisk`
    * A suite of open-source tools for customizing Android, supporting devices
      higher than Android 4.2 (API 17).
    * Offers root access, module support, and hide from 
      detections: banking apps, game tamper checks, etc.

* [`Flutter`](https://flutter.dev/)
    * An open-source UI software development kit created by Google for
      building natively compiled applications for mobile, web, and desktop
      from a single codebase.
    * It's not Android-specific but is very useful for developing high-quality,
      cross-platform apps that run on Android and other platforms.

* `Android Studio`
    * The official integrated development environment (IDE) for Android application development.
    * Provides a powerful code editor, a flexible build system, and a wide variety
      of tools and plugins for debugging and profiling your applications.

* [`Fastlane`](https://fastlane.tools/)
    * An open-source platform aimed at simplifying Android and iOS deployment.
    * Automates tedious tasks like generating screenshots, dealing with signing
      certificates, and releasing your application.

* [`Gradle`](https://gradle.org/)
    * An open-source build automation tool that is designed to be flexible
      enough to build almost any type of software.
    * The default build tool for Android Studio, allowing for the automation
      of building, testing, and deploying Android apps.

* [`Firebase`](https://firebase.google.com/)
    * A platform developed by Google for creating mobile and web applications.
    * Offers a wide array of tools and services that help you develop high-quality
      apps, grow your user base, and earn more profit.


## Other Tips
* Use Android Virtual Devices (AVDs) in Android Studio or Genymotion
  for testing your apps on different devices and Android versions without
  needing physical devices.
* Explore GitHub for Android-related projects and libraries.  
    * Open-source projects can provide valuable learning resources and tools
      you can integrate into your own projects.
* Get familiar with Android's Material Design guidelines to ensure your
  apps not only work well but also have a consistent look and feel that
  adheres to modern design principles.


