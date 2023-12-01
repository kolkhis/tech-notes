

# Cygwin - GNU/Linux Utilities on Windows

## Installing

You can install Cygwin using [scoop](https://scoop.sh), which is a command-line installer for
Windows. 
```ps1
irm get.scoop.sh | iex
```
If that doesn't work, try running this first:  
```ps1
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
That setting (`-ExecutionPolicy RemoteSigned`) is needed to run a remote script the first time.  

When scoop is installed, run:
```ps1
scoop install cygwin
```

Now it's installed. Easy.
## Add to Windows Terminal as a Profile
1. Open the JSON settings in Windows terminal.
1. Search for `"profiles"`, and under that, `"list"`
1. Add Cygwin to the `"list"` of profiles:
   ```json
       "profiles": 
    {
        "defaults": 
        {
            "bellStyle": "taskbar",
            "colorScheme": "Argonaut",
            "cursorShape": "filledBox",
            "font": 
            {
                "face": "RobotoMono Nerd Font Mono",
                "size": 11.0,
                "weight": "normal"
            }
        },
        "list": 
        [
            {
                "guid": "{00000000-0000-0000-0000-000000000001}",
                "commandline": "%UserProfile%/scoop/apps/cygwin/current/root/Cygwin.bat",
                "icon": "%UserProfile%/scoop/apps/cygwin/current/root/Cygwin-Terminal.ico",
                "hidden": false,
                "name": "Cygwin"
            },
   ```


## Config

While pulling dotfiles down from Github, it seemed to have converted everything
to CR/LF, since Cygwin runs from Windows (even if pushed from Ubuntu Server).  

I found that doing a straight `scp` from the Ubuntu Server worked fine.  

Alternatively, run any dotfiles through a script to remove the CRs (`\r`).  
```bash
#!/bin/bash
# tr '\r' ' ' > ~/.bashrc < .userver_bashrc   # This, for some reason, did not work.
cat .userver_bashrc | tr '\r' ' ' > ~/.bashrc
cat .userver_bash_aliases | tr '\r' ' ' > ~/.bash_aliases
cat .userver_bash_functions | tr '\r' ' ' > ~/.bash_functions
```




