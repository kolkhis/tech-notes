


# BadUSB Script File format and Command Syntax

Original documentation [here](https://github.com/flipperdevices/flipperzero-firmware/blob/dev/documentation/file_formats/BadUsbScriptFormat.md).  

The Flipper Zero's BadUSB app uses **extended** Duckyscript syntax.  
It is fully compatible with classic USB Rubber Ducky 1.0 scripts.

BadUSB has some additional commands and features: 
* Custom USB IDs
* `ALT+Numpad` input method
* The `SYSRQ` command
* More functional keys



BadUSB can execute only scripts from `.txt` files.
Scripts don't need to be compiled.  
Both LF and CRLF (`\n` and `\r\n`) line endings are supported.  
Empty lines are allowed.  
You can use spaces or tabs for line indentation.


## Script Commands


### Comments
Just a single comment line.  
The interpreter will ignore all text after the `REM` command.
| Command   | Parameters
|-|-
| `REM`     | Comment text       


### Delays
Pause script execution by a defined time.
| Command         | Parameters        | Notes                               
|-|-|-
| `DELAY`         | Delay value in ms | Single delay                        
| `DEFAULT_DELAY` | Delay value in ms | Add a delay before every command that appears after this
| `DEFAULTDELAY`  | Delay value in ms | Same as `DEFAULT_DELAY`               


### Special Keys
| Command              | Notes            
|-|-
| `DOWNARROW` / `DOWN` |                  
| `LEFTARROW` / `LEFT` |                  
| `RIGHTARROW` / `RIGHT`|                  
| `UPARROW` / `UP`     |                  
| `ENTER`              |                  
| `DELETE`             |                  
| `BACKSPACE`          |                  
| `END`                |                  
| `HOME`               |                  
| `ESCAPE` / `ESC`     |                  
| `INSERT`             |                  
| `PAGEUP`             |                  
| `PAGEDOWN`           |                  
| `CAPSLOCK`           |                  
| `NUMLOCK`            |                  
| `SCROLLLOCK`         |                  
| `PRINTSCREEN`        |                  
| `BREAK`              | Pause/Break key  
| `PAUSE`              | Pause/Break key  
| `SPACE`              |                  
| `TAB`                |                  
| `MENU`               | Context menu key 
| `APP`                | Same as `MENU`     
| `Fx`                 | (where `x` is a number `1`-`12`) `F1-F12` keys 


### Modifier Keys
These can be combined with a special key command or a single character.
| Command          | Notes      
|-|-
| `CONTROL`/`CTRL` |            
| `SHIFT`          |            
| `ALT`            |            
| `WINDOWS`/`GUI`  |            
| `CTRL-ALT`       | `CTRL+ALT`   
| `CTRL-SHIFT`     | `CTRL+SHIFT` 
| `ALT-SHIFT`      | `ALT+SHIFT`  
| `ALT-GUI`        | `ALT+WIN`    
| `GUI-SHIFT`      | `WIN+SHIFT`  
| `GUI-CTRL`       | `WIN+CTRL`   


### Holding and Releasing Keys
You can hold up to 5 keys simultaneously.
| Command   | Parameters                      | Notes                                    
|-|-|-
| `HOLD`    | Special key or single character | Press and hold key until `RELEASE` command 
| `RELEASE` | Special key or single character | Release key                              


### Wait for User Input (Button Press)
Wait indefinitely for a button to be pressed.  
| Command                 | Parameters   | Notes                                                                 
|-|-|-
| `WAIT_FOR_BUTTON_PRESS` | None         | Will wait for the user to press a button to continue script execution 



### Strings
| Command    | Parameters  | Notes                                      
|- |-|-                         
| `STRING`   | Text string | Input a text string                          
| `STRINGLN` | Text string | Input a text string and press `ENTER` after it 


### String delay
Add a delay between keypresses.
| Command        | Parameters        | Notes                                         
|-|-|-
| `STRING_DELAY` | Delay value in ms | Applied once to next appearing `STRING` command 
| `STRINGDELAY`  | Delay value in ms | Same as `STRING_DELAY`                          


### Repeat
Use this to repeat the last command that was executed.
| Command   | Parameters                   | Notes                   
|-|-|-
| `REPEAT`  | Number of additional repeats | Repeat the previous command 


### ALT Codes (ALT+Numpad input) 
On Windows and some Linux systems, you can print characters by holding `ALT` key and entering its code on Numpad.
| Command     | Parameters     | Notes                                                           
|-|-|-
| `ALTCHAR`   | Character code | Input a single character                                          
| `ALTSTRING` | Text string    | Input a text string using `ALT+Numpad` method                       
| `ALTCODE`   | Text string    | Same as `ALTSTRING`, appears in some Duckyscript implementations 


### SysRq
Send [SysRq command](https://en.wikipedia.org/wiki/Magic_SysRq_key)
| Command   | Parameters
|-|-
| `SYSRQ`   | Single character  


## USB device ID
You can set the custom ID of the Flipper USB HID device.  
ID command should be in the **first line** of script, it is executed before script run.
| Command   | Parameters
|-|-
| `ID`      | `VID:PID` Manufacturer:Product

E.g., `ID 1234:abcd Flipper Devices:Flipper Zero`

* `VID` and `PID` are hex codes and are mandatory.  
* Manufacturer and Product are text strings and are optional.

