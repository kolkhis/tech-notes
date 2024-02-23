

# Flipper Zero Scripting
 
Flipper Zero can act as a BadUSB device, recognized by computers as a Human Interface
Device (HID), such as a keyboard.  
 
A BadUSB device can change system settings, open backdoors, retrieve data, initiate
reverse shells, or do anything that can be achieved with physical access.  
It is done by executing a set of commands written in the Rubber Ducky Scripting Language,
also known as DuckyScript.  
 
This set of commands is also called a payload.

## Table of Contents
* [Flipper Zero Scripting](#flipper-zero-scripting) 
* [DuckyScript](#duckyscript) 
* [DuckyScript Basics](#duckyscript-basics) 
* [Keystroke Injection](#keystroke-injection) 
    * [Keywords](#keywords) 
    * [`STRING`](#string) 
    * [`REM`](#rem) 
    * [`DELAY`](#delay) 
    * [`ENTER`](#enter) 
* [DuckyScript Examples](#duckyscript-examples) 
* [Commands Exclusive to the Flipper Zero](#commands-exclusive-to-the-flipper-zero) 
    * [Modifier Keys](#modifier-keys) 
    * [ALT+Numpad Input Method](#alt+numpad-input-method) 
    * [Magic SysRq key](#magic-sysrq-key) 
* [BadUSB](#badusb) 
* [Using the Flipper Zero as a BadUSB Device](#using-the-flipper-zero-as-a-badusb-device) 
* [Uploading New Payloads to your Flipper Zero](#uploading-new-payloads-to-your-flipper-zero) 
* [Additional Info](#additional-info) 
    * [Rubber Ducky Terminology](#rubber-ducky-terminology) 


## DuckyScript 
##### See [DuckyScript Quickref](https://docs.hak5.org/hak5-usb-rubber-ducky/duckyscript-tm-quick-reference). 
The Flipper Zero has it's own scripting language.  
The syntax is compatible with DuckyScript, i.e., the classic [Rubber Ducky Scripting Language 1.0](https://web.archive.org/web/20220816200129/http://github.com/hak5darren/USB-Rubber-Ducky/wiki/Duckyscript).  
 
Unlike the Rubber Ducky scripting language, the Flipper Zero language  
provides additional commands and features, such as the `ALT+Numpad` input   
method, the `SysRq` command, and more.  
 
Both `\n` and `\r\n` line endings are supported.  
Empty lines are allowed, as well as spaces or tabs for line indentation.  
The `Bad USB` application can execute only scripts in the `.txt` format.  
These scripts don't need to be compiled.  


## DuckyScript Basics
* Each line has a 256 character limit.  
* `DELAY 1000` (ms) = 1 second.
* [Sample profiles/examples](https://github.com/dekuNukem/duckyPad/tree/master/sample_profiles)

## Keystroke Injection
### Keywords

* `REM` is short for Remark and adds a comment to the payload, like a title or the author's name
* `DELAY` pauses the payload for a given amount of time, expressed in milliseconds
* `STRING` injects keystrokes, or "types", the given characters (a-z, 0-9, punctuation & specials)
* `ENTER` is a special key which may be pressed, like TAB, ESCAPE, UPARROW or even ALT F4.



### `STRING`
The `STRING` command keystroke injects (types) a series of keystrokes.  
```duckyscript
STRING The quick brown fox jumps over the lazy dog
```
* The `STRING` command will automatically press the `SPACE` cursor key and interpret
  uppercase letters.
* Leading spaces will be included, but trailing spaces will be not.


### `REM`
The `REM` command adds a comment to the payload. 
```duckyscript
REM This is a comment
```

### `DELAY`
The `DELAY` command pauses the payload for a certain amount of time.
Uses milliseconds.
```duckyscript
STRING Hello,
DELAY 600
STRING  World!
```

### `ENTER`
The `ENTER` command will be interpreted as a keystroke.
Other modifier keys will be interpreted as keystrokes as well.
```duckyscript
REM Open task manager
CONTROL SHIFT ESCAPE
TAB
TAB
ENTER
REM Alt+F4 will be interpreted, and pressed after 600ms
ALT F4
```

## DuckyScript Examples
* Open Task Manager on Windows:
```duckyscript
CONTROL SHIFT ESC
```

* Open a webpage on Windows:
```duckyscript
WINDOWS r
DELAY 400
STRING https://www.youtube.com/watch?v=dQw4w9WgXcQ
ENTER
```

* Save a webpage and then close it:
```duckyscript
CONTROL s
DELAY 600
ENTER
DELAY 600
CONTROL w
```

## Commands Exclusive to the Flipper Zero
The commands that Flipper Zero can execute in addition to the 
Rubber Ducky Scripting Language 1.0 syntax:
* Modifier keys
* ALT+Numpad input (Windows only)
* Magic SysRq key (Linux only)


### Modifier Keys
|  Command     |  Equivalent
|-|-
|  `CTRL-ALT`    |  `CTRL+ALT`
|  `CTRL-SHIFT`  |  `CTRL+SHIFT`
|  `ALT-SHIFT`   |  `ALT+SHIFT`
|  `ALT-GUI`     |  `ALT+WIN`
|  `GUI-SHIFT`   |  `WIN+SHIFT`


### ALT+Numpad Input Method
On Windows, you can input characters by pressing the ALT key and entering its code on the Numpad.
| Command   | Parameters     | Notes
|-|-|-
| `ALTCHAR`   | Character code | Print single character
| `ALTSTRING` | Text string    | Print text string using ALT+Numpad method
| `ALTCODE`   | Text string    | Same as ALTSTRING, presented in some Ducky Script implementations


### Magic SysRq key
On Linux, you can execute commands using the
[Magic SysRq Key](https://en.wikipedia.org/wiki/Magic_SysRq_key).
 
| Command | Parameters
|-|-
| `SYSRQ` | Single character


## BadUSB
##### BadUSB application [source code](https://github.com/flipperdevices/flipperzero-firmware/tree/dev/applications/main/bad_usb)
 

## Using the Flipper Zero as a BadUSB Device
 
To use your Flipper Zero as a BadUSB device, do the following:
1. If the qFlipper application is running on your computer, close the application.
2. On your Flipper Zero, go to **Main Menu -> Bad USB**.
3. Select the payload and press the OK button.
4. Modify the keyboard layout by pressing the **LEFT** button, if necessary.
    * The default configuration is the US English keyboard layout.
5. Connect your Flipper Zero to the computer via a USB cable.
6. Press **Run** to execute the payload on the computer.






## Uploading New Payloads to your Flipper Zero
##### [Official docs](https://docs.flipper.net/bad-usb#IomSQ)
Once the payload is created, you can upload it to your Flipper Zero via
qFlipper or Flipper Mobile App to the `SD Card/badusb/` folder.  
 
The new payloads will be available in the Bad USB application.  
 
* [qFlipper](https://docs.flipperzero.one/qflipper)
* [Flipper Mobile App](https://docs.flipperzero.one/mobile-app) 



## Additional Info
### Rubber Ducky Terminology

* Keystroke Injection — a type of hotplug attack which mimics keystrokes entered by a human.
* Hotplug Attack — an attack or automated task that takes advantage of plug-and-play.
* Plug and Play — a peripheral standard whereby connected devices work automatically.
* HID — a Human Interface Device;  the protocol a keyboard uses to speak to a computer
* Mass Storage  — what we think of as a thumb drive or SD Card

* USB Rubber Ducky — the USB device that delivers hotplug attacks.
* Payload — the specific hotplug attack instructions processed by the USB Rubber Ducky.
* DuckyScript — both the programming language of, and source code for USB Rubber Ducky payloads.  
    * May refer to a specific payload in human-readable DuckyScript source code.
* inject.bin — the binary equivalent of the DuckyScript source code generated by the 
  compiler and encoder consisting of byte code to be interpreted by the USB Rubber Ducky.

* Payload Studio — Integrated Development Environment consisting of a source code 
  editor, compiler, encoder and debugger for programming DuckyScript.
* Editor — the text processing element of the Payload Studio featuring syntax 
  highlighting, autocomplete, indentation and snippets specific to the DuckyScript 
  programming language.
* Compiler — the element of the Payload Studio which converts the DuckyScript source
  code (payload.txt) into the byte code (inject.bin) interpreted by the USB Rubber Ducky.  
    * The Compiler also tests the DuckyScript source to be syntactically correct.  
    * May provide warning or error messages if a programming bug is found.
* Debugger — the element of the Payload Studio which may be used to help you test
  or troubleshoot your payload. 
* Language File — also referred to as the Language JSON, this is the lookup table
  the Compiler uses to encode your keystrokes for a given keyboard language
* Loot — the logs, data and other information obtained during the deployment
  of a payload, often consisting of details about the target (recon) or
  information from the target (exfiltration).
* Arming — the act of transferring a payload to the hotplug attack device.
* Arming Mode — a mode whereby the USB Rubber Ducky facilitates convenient payload
  and loot transfer by acting as USB mass storage.
* Target — the computing device (or "Host") on which the payload will be deployed.
* Deployment — the execution of the payload on the target

