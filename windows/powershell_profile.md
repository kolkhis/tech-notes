
# PowerShell Profile

## PowerShell vs Windows PowerShell 
PowerShell (`pwsh.exe`) is a different program from
Windows PowerShell (`powershell.exe`).  
PowerShell (called "pwsh" from now on) is the newer shell for
Windows.  

## Profile

Since these two programs are different, both *pwsh* and
*powershell* have different `$PROFILE` files.
* Note: The `$PROFILE` variable will be set even if there is no profile file.  
  To create one, just start editing it with a text editor. (`nvim $PROFILE`).

You can check to see if your configuration file actually exists with the `Test-Path` cmdlet.  
```ps1
Test-Path -Path $PROFILE
```
* If there is a file, `Test-Path` returns `TRUE`.
* If no file is set, the response is `FALSE`.

## Profile Locations

### PowerShell (`pwsh.exe`) `$PROFILE` Location
By default, on Windows, the `$PROFILE` for pwsh will be set to:
```ps1
C:\Users\kolkhis\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# or 
~/OneDrive/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
```

On Ubuntu/Debian systems:
```bash
/home/kolkhis/.config/powershell/Microsoft.PowerShell_profile.ps1
```

### Windows PowerShell (`powershell.exe`) `$PROFILE` Location
The default `$PROFILE` location for powershell is:
```ps1
C:\Users\kolkhis\OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# or
~/OneDrive/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
```


## Vi Mode
```ps1
Install-Module PSReadLine
```
Then in your profile:
```ps1
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Chord Ctrl+[ -Function ViCommandMode
# If the above doesn't work for ESC:
Set-PSReadLineKeyHandler -Chord Ctrl+Oem4 -Function ViCommandMode
```


## Customizing The Prompt

To customize the prompt, we make a function called `prompt`.
```ps1
function prompt {
    "$pwd`nPS > "
}
```
This prints the current directory, a newline (\`n), and then the prompt `PS > `.  
Escape sequences are done with backticks instead of backslashes in PowerShell.  



