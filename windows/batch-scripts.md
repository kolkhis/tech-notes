# Batch Scripting

A batch script (or batch file) is a type of shell script on Windows.  

It's a script that runs with `cmd.exe` and uses the `.bat` or `.cmd` file extension.  


## Syntax Overview

The general syntax for batch scripts:

```batch
REM comment here
:: Also a comment

:: Setting a variable
SET VAR=value

:: Wrap var name in % signs to expand it
ECHO %VAR%

:: Conditions
IF "%X%"=="y"...

:: Run a command
ECHO Hi
```

The official way to comment is using `REM` (stands for remark). The `::` comment 
syntax is a hack using the label operator `:` twice.  

> NOTE: If using comments in a `FOR` loop, use `REM` style comments rather than `::`.  
> Using `::` comments in `FOR` loops can cause errors.  




## Batch Script to Disconnect Samba Shares

This is a simple batch script that disconnects all SMB shares and deletes saved
credentials for the samba server.  

```bat
@echo off
echo Disconnecting all samba shares...
net use * /delete /y

echo Deleting cached credentials...
cmdkey /delete:192.168.4.11

echo Done!
pause
```

The `@echo off` disables the actual commands themselves from being printed to the
terminal, only the output of the commands will be printed.  

The `pause` at the end is so that the output can be inspected if running the script
from the GUI (e.g., double clicking on `disconnect_samba.bat`). Without a `pause`, it
would not hang to let you read the output.  

## Special Variables

Like Linux systems, there are environment variables that are always on the system.  

- `%USERPROFILE%`: Expands to the user's home directory (`C:\Users\your-user`)


## Resources

- <https://steve-jansen.github.io/guides/windows-batch-scripting/>
 
