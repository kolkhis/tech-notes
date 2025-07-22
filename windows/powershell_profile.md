
# PowerShell Profile  

## PowerShell vs Windows PowerShell 
PowerShell (`pwsh.exe`) is a different program from Windows PowerShell (`powershell.exe`).  

PowerShell (called "pwsh" on this page) is the newer shell for Windows.  

Any PowerShell version 7.0 or above is referencing `pwsh.exe`.  

## Profile  

Since these two programs are different, both `pwsh.exe` and 
`powershell.exe` have different `$PROFILE` files.  

* Note: The `$PROFILE` variable will be set even if there is no profile file.  
  To create one, just start editing it with a text editor. (`nvim $PROFILE`).  

You can check to see if your configuration file actually exists with the `Test-Path` cmdlet.  

```powershell  
Test-Path -Path $PROFILE  
```

* If there is a file, `Test-Path` returns `TRUE`.  
* If no file is set, the response is `FALSE`.  

## Profile Locations  

### PowerShell (`pwsh.exe`) `$PROFILE` Location  
By default, on Windows, the `$PROFILE` for pwsh will be set to:  
```powershell  
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
```powershell  
C:\Users\kolkhis\OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1  
# or  
~/OneDrive/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1  
```


## Vi Mode  
```powershell  
Install-Module PSReadLine  
```
Then in your profile:  
```powershell
Set-PSReadLineOption -EditMode Vi  
Set-PSReadLineKeyHandler -Chord Ctrl+[ -Function ViCommandMode  
# If the above doesn't work for ESC:  
Set-PSReadLineKeyHandler -Chord Ctrl+Oem4 -Function ViCommandMode  
```

## Aliases  
```powershell  
Set-Alias -Name vim -Value nvim  
```

## Customizing The Prompt  

To customize the prompt, we make a function called `prompt`.  
```powershell  
function prompt {
    "$pwd`nPS > "  
}
```
This prints the current directory, a newline (\`n), and then the prompt `PS > `.  
Escape sequences are done with backticks instead of backslashes in PowerShell.  

## Prompt Colors in Pwsh (7.x)  

You can define colors in-line in the strings with `$PSStyle`, 
specifially the `$PSStyle.Foreground.FromRgb` command:  
```powershell  
function prompt  
{
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(102, 0, 0))${FirstSep} " -NoNewline 
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(132, 65, 45))$env:USERNAME" -NoNewline  
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(64, 64, 64))@" -NoNewline  
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(128, 106, 0))$(hostname)" -NoNewline  
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(64, 64, 64)):" -NoNewline 
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(0,106,128))${PWD} " -NoNewline  
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(204, 0, 0))$(Get-GitBranch)" 
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(102, 0, 0))${SecondSep}" -NoNewline 
    Write-Host "$($Global:PSStyle.Foreground.FromRgb(64, 64, 64)) $" -NoNewline 
    return "$($Global:PSStyle.Foreground.FromRgb(160, 160, 160)) "  
# Alternatively, return the 2nd line instead of using Write-Host:  
# return "$($Global:PSStyle.Foreground.FromRgb(102, 0, 0))┖$($Global:PSStyle.Foreground.FromRgb(64, 64, 64)) $ "  
}
```

You can also use ANSI control sequences with the ``` `e[5m ``` syntax (PowerShell
uses backticks for its escape sequences).  

If your terminal supports it, you can use 255-colors with ANSI control sequences.  
```powershell
$BURNT_ORANGE="`e[38;5;130m"
$DARK_YELLOW="`e[38;5;58m"
$GREY="`e[38;5;241m"
$MUTED_BLUEGREEN="`e[38;5;30m"
$RED_256="`e[38;5;160m"
$DARK_RED="`e[38;5;88m"
$RESET="`e[0m"

$FIRST_SEP="┏"
$SECOND_SEP="┗"
function prompt
{
    # Return a blank prompt to let Write-Host handle everything
    Write-Host "${SEP_COLOR}${FIRST_SEP} " -NoNewline 
    Write-Host "${NAME_COLOR}$env:USERNAME" -NoNewline 
    Write-Host "${GREY}@" -NoNewline 
    Write-Host "${HOST_COLOR}$(hostname)" -NoNewline 
    Write-Host "${GREY}:" -NoNewline 
    Write-Host "${PATH_COLOR}${PWD}" -NoNewline
    Write-Host "${RED_256}$(Get-GitBranch)"
    Write-Host "${SEP_COLOR}${SECOND_SEP} " -NoNewline 
    Write-Host "${GREY}$" -NoNewline
    return " ${RESET}"
}
```



## Prompt Colors in Powershell (5.x)  

Since powershell 5.x doesn't have `$PSStyle`, you need to use  
the default colors to customize the prompt (as far as I know).  
Pass them into `Write-Host` with the `-ForegroundColor` argument:  
```powershell  
    $Global:NameColor = "DarkRed"  
    $Global:HostColor = "DarkMagenta"  
    $Global:PathColor = "DarkCyan"  
    $Global:GitBranchColor = "DarkRed"  
    $Global:SepColor = "DarkRed"  
    $Global:VenvColor = "Yellow"  
function prompt  
{
    Write-Host "$env:USERNAME" -NoNewline  -ForegroundColor $Global:NameColor  
    Write-Host "@" -NoNewline  -ForegroundColor $Global:DarkGray  
    Write-Host "$(hostname)" -NoNewline  -ForegroundColor $Global:HostColor  
    Write-Host ":" -NoNewline  -ForegroundColor $Global:DarkGray  
    Write-Host "${PWD} " -NoNewline -ForegroundColor $Global:PathColor  
    Write-Host "$(Get-GitBranch)" -NoNewline -ForegroundColor $Global:GitBranchColor  
    Write-Host "$" -NoNewline -ForegroundColor $Global:DarkGray  
    return " "  
}
```

## PSReadLine Terminal Output Colors  

The `-Colors` argument to `PSReadLine` accepts a hash table (dictionary).  
Dictionaries in PowerShell are defined with the syntax:  
```powershell 
$MyDict = @{ "key" = "value" }
```
* All variable definitions are started with `$`
    * To make it Global, use `$Global:MyDict` or `$Global:MyVar`
* Before the opening brace, use an `@` symbol
    * `@{ ... }`

---

There are 18 keys you can specify colors to with `PSReadLine`.  

| Key/Token | What it Colors
|-----------|---------------
| `"Number"` | The number token color.  
| `"Error"` | The error color. 
| `"Emphasis"` | The emphasis color. 
| `"Selection"` | The color to highlight the menu selection or selected text.  
| `"Default"` | The default token color.  
| `"Comment"` | The comment token color.  
| `"Keyword"` | The keyword token color.  
| `"String"` | The string token color.  
| `"Operator"` | The operator token color.  
| `"Variable"` | The variable token color.  
| `"Command"` | The command token color.  
| `"Parameter"` | The parameter token color.  
| `"Type"` | The type token color.  
| `"Member"` | The member name token color.  
| `"InlinePrediction"` | The color for the inline view of the predictive suggestion.  
| `"ListPrediction"` | The color for the leading `>` character and prediction source name.  
| `"ListPredictionSelected"` | The color for the selected prediction in list view.  
| `"ContinuationPrompt"` | The color of the continuation prompt.  |

* With PowerShell 7.x, you can use the ``` `e ``` sequence for ANSI escape sequences.  
    * Example: ```"`e[38;5;39m"```
* For PowerShell 5.x, you need to use `$([char]0x1b)`
    * Example: `"$([char]0x1b)[38;5;39m"`


### `pwsh` PS 7.x PSReadLine Colors

```powershell  
######################/* PSReadLineOption Color Tokens */######################  
# PSReadLineOption -Colors {Hash Table}. Escape with `e for pwsh, $([char]0x1b) for powershell.exe (5.x)  
$colors = @{
    "Number"                    = "`e[38;5;39m"     # The number token color.  
    "Error"                     = "`e[38;5;1m"      # The error color. 
    "Emphasis"                  = "`e[38;5;200m"    # The emphasis color. 
    "Selection"                 = "`e[38;5;250m"    # The color to highlight the menu selection or selected text.  
    "Default"                   = "`e[38;5;254m"    # The default token color.  
    "Comment"                   = "`e[38;5;244m"    # The comment token color.  
    "Keyword"                   = "`e[38;5;45m"     # The keyword token color.  
    "String"                    = "`e[38;5;113m"    # The string token color.  
    "Operator"                  = "`e[38;5;206m"    # The operator token color.  
    "Variable"                  = "`e[38;5;82m"     # The variable token color.  
    "Command"                   = "`e[38;5;208m"    # The command token color.  
    "Parameter"                 = "`e[38;5;111m"    # The parameter token color.  
    "Type"                      = "`e[38;5;171m"    # The type token color.  
    "Member"                    = "`e[38;5;150m"    # The member name token color.  
    "InlinePrediction"          = "`e[38;5;240m"    # The color for the inline view of the predictive suggestion.  
    "ListPrediction"            = "`e[38;5;53m"     # The color for the leading `>` character and prediction source name.  
    "ListPredictionSelected"    = "`e[38;5;128m"    # The color for the selected prediction in list view.  
    "ContinuationPrompt"        = "`e[38;5;255m"    # The color of the continuation prompt.  
}
Set-PSReadLineOption -Colors $colors  
```

### `powershell` PS 5.x PSReadLine Colors

```powershell
$colors = @{
    "Number"                    = "$([char]0x1b)[38;5;39m"     # The number token color.
    "Error"                     = "$([char]0x1b)[38;5;1m"      # The error color. 
    "Emphasis"                  = "$([char]0x1b)[38;5;200m"    # The emphasis color. 
    "Selection"                 = "$([char]0x1b)[38;5;245m"    # The color to highlight the menu selection or selected text.
    "Default"                   = "$([char]0x1b)[38;5;254m"    # The default token color.
    "Comment"                   = "$([char]0x1b)[38;5;244m"    # The comment token color.
    "Keyword"                   = "$([char]0x1b)[38;5;45m"     # The keyword token color.
    "String"                    = "$([char]0x1b)[38;5;113m"    # The string token color.
    "Operator"                  = "$([char]0x1b)[38;5;206m"    # The operator token color.
    "Variable"                  = "$([char]0x1b)[38;5;82m"     # The variable token color.
    "Command"                   = "$([char]0x1b)[38;5;208m"    # The command token color.
    "Parameter"                 = "$([char]0x1b)[38;5;111m"    # The parameter token color.
    "Type"                      = "$([char]0x1b)[38;5;171m"    # The type token color.
    "Member"                    = "$([char]0x1b)[38;5;150m"    # The member name token color.
    "InlinePrediction"          = "$([char]0x1b)[38;5;240m"    # The color for the inline view of the predictive suggestion.
    "ListPrediction"            = "$([char]0x1b)[38;5;53m"     # The color for the leading `>` character and prediction source name.
    "ListPredictionSelected"    = "$([char]0x1b)[38;5;128m"    # The color for the selected prediction in list view.
    "ContinuationPrompt"        = "$([char]0x1b)[38;5;238m"    # The color of the continuation prompt.
}
Set-PSReadLineOption -Colors $colors
```

## Troubleshooting

If your profile isn't loading when PowerShell starts, it could be an ExecutionPolicy
problem.  

Check the current ExecutionPolicy for your user account.  
```powershell
Get-ExecutionPolicy -Scope CurrentUser
```
If it's set to `Restricted` or even `Undefined`, you can change it to `RemoteSigned` to
enable running scripts on the system.  
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Try reloading the shell again, and you should see your prompt.  
To make sure, you can add a short output line to the end of your `$PROFILE`.  
```powershell
Write-Host '>>> Profile loaded.'
```


