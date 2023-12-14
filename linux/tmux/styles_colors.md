
# Tmux Styling and Colors  

> tmux offers various options to specify the colour and attributes of aspects of the interface,
> for example `status-style` for the status line.  
>  
> Embedded styles may be specified in format options,
> such as `status-left`, by enclosing them in `#[` and `]`.  
>  
> - *`man tmux`*  

## Embedded Styles  


fg=colour Set the foreground colour.  
bg=colour Set the background colour.  

fill=colour  
     Fill the available space with a background colour if appropriate.  

none    Set no attributes (turn off any active attributes).  

## Attributes  
* `acs`
* `bright (or bold)`
* `dim`
* `underscore`
* `blink`
* `reverse`
* `hidden`
* `italics`
* `overline,`
* `strikethrough`
* `double-underscore`
* `curly-underscore`
* `dotted-underscore`
* `dashed-underscore`
        Set an attribute.  
        Any of the attributes may be prefixed with ‘no’ to unset.  

align=left (or noalign), align=centre, align=right  
         Align text to the left, centre or right of the available space if appropriate.  





* `list=on`
* `list=focus`
* `list=left-marker`
* `list=right-marker`
* `nolist`
     Mark the position of the various window list components in the `status-format` option:  
         `list=on` marks the start of the list;  
         `list=focus` is the part of the list that should be kept in focus if the 
            entire list won't fit in the available space (typically the current window);  
         `list=left-marker` and `list=right-marker` mark the text to be used to mark that  
         text has been trimmed from the left or right of the list if there is not enough space.  

* `push-default`
* `pop-default`
             Store the current colours and attributes as the default or reset to the previous de‐  
             fault.  
             A `push-default` affects any subsequent use of the default term until a  
             `pop-default`.  
             Only one default may be pushed (each `push-default` replaces 
             the previous saved default).  

* `range=left`
* `range=right`
* `range=window|X`
* `norange`
             Mark a range in the `status-format` option.  
             `range=left` and `range=right` are the text used for the `StatusLeft` and `StatusRight` mouse keys.  
             `range=window|X` is the range for a window passed to the `Status` mouse key, where `X` is a window index.  



## Examples  

```bash  
fg=yellow bold underscore blink  
bg=black,fg=default,noreverse  
```


## Status Line  

The colour and attributes of the status line can be configured:   
* The entire status line using the `status-style` session option.  
* Individual windows using the `window-status-style` window option.  

Each line of the status line is configured with the `status-format` option.  
The default is made of three parts:  
* Configurable left and right sections 
    * May contain dynamic content such as the time or output  
      from a shell command. 
        * see the `status-left`, `status-left-length`, `status-right`, and `status-right-length`
* A central window list.  

### Window List  
By default, the window list shows the index, name and (if any) flag of  
the windows in the current session, sorted by number.  

It can be customized with the `window-status-format`
and `window-status-current-format` options.  

### Window Flags  
The flag is one of the following symbols appended to the window name:  
|Flag |  Meaning 
|-|-  
| `*` | Denotes the current window.  
| `-` | Marks the last window (previously selected).  
| `#` | Window activity is monitored and activity has been detected.  
| `!` | Window bells are monitored and a bell has occurred in the window.  
| `~` | The window has been silent for the monitor-silence interval.  
| `M` | The window contains the marked pane.  
| `Z` | The window's active pane is zoomed.  


### Automatic Refreshing
The status line is automatically refreshed at `interval` if it has changed.  
The interval can be changed with the `status-interval` session option.  


### Status Line Commands
Commands related to the status line are as follows:

```bash
# Open the tmux command prompt in a client.
command-prompt [-1ikNTW] [-I inputs] [-p prompts] [-t target-client] [template]

# Ask for confirmation before executing command.
confirm-before [-p prompt] [-t target-client] command
(alias: confirm)

# Display a menu on target-client.
display-menu [-O] [-c target-client] [-t target-pane] [-T title] [-x position] [-y position]
(alias: menu)

# Display a message.
display-message [-aINpv] [-c target-client] [-d delay] [-t target-pane] [message]
(alias: display)

# Display a popup running shell-command on target-client
display-popup [-CE] [-c target-client] [-d start-directory] [-h height] [-t target-pane] [-w
(alias: popup)
```




