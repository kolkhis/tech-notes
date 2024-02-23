

# Scripting BadUSB Hotplug Scripts with the Flipper Zero
Scripts need to be written differently for each operating system.  
MacOS and Windows have different key combinations for doing things.  

## Launching Applications on Windows 
The DuckyScript keycode for the Windows key is `GUI`.  

You can usually launch an application on windows by pressing the Windows key,
and typing the name of the application, and hitting `ENTER`.  
```duckyscript
DELAY 3000
GUI
DELAY 1000
STRING notepad
DELAY 1000
ENTER
DELAY 1000
STRING Now notepad is open!
```

Alternatively, you could use `Win+R` to open the `Run` dialog, type the
name of the application, and hit `ENTER`.
```duckyscript
DELAY 3000
GUI r
DELAY 1000
STRING notepad
DELAY 1000
ENTER
DELAY 1000
STRING Now notepad is open!
```

## Launching Applications on MacOS
On MacOS, you can enter the terminal and launch applications by 
typing the name of the application, and hitting `ENTER`.
```duckyscript
DELAY 3000
F4
DELAY 2500
STRING Terminal
DELAY 2500
ENTER
DELAY 1500
STRING ls
ENTER
```





