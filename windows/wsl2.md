

To allow WSL2 to open files and links using native graphical programs:
Install `xdg-utils` and `wslu`.  

```bash
sudo apt install xdg-utils
sudo apt install wslu
```

To add support for USB devices, install the USBIPD-WIN project.  
```bash
winget install --interactive --exact dorssel.usbipd-win
```

