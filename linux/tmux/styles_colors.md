# Tmux Styling and Colors  

Tmux offers various options to specify the colour and attributes of aspects of
the interface, e.g., `status-style` for the status line.  
 
Also see the [docs on styling](https://github.com/tmux/tmux/wiki/Getting-Started#list-of-style-and-format-options),
or the `tmux` man page: `man://tmux 2407` or `man tmux /^STYLES`

## Embedded Styles  
`gF` (`<C-w>gF` for a new tab) -> `man://tmux 2407`

Embedded styles may be specified in format options,
such as `status-left`, by enclosing them in `#[` and `]`.  

* `fg=colour`: Set the foreground colour.  
* `bg=colour`: Set the background colour.  
* `fill=colour`: Fill the available space with a background colour if appropriate.  


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
* `none`: Set no attributes (turn off any active attributes).  

Set an attribute.  
Any of the attributes may be prefixed with `no` to unset.  

## Alignment  
Align text to the left, centre or right of the available space if appropriate.  
* `align=left` 
* `align=centre`
* `align=right`  
* `noalign`

---  

Mark the position of the various window list components in the `status-format` option  
* `list=on`: Marks the start of the list.  
    * This is where the list of windows will begin in the status line.  
* `list=focus`: Part of the list that's kept in focus if trimmed.  
    * Typically the current window.  
* `list=left-marker`: Indicator char(s) for when the list is trimmed.  
* `list=right-marker`: Indicator char(s) for when the list is trimmed.  
* `nolist`: Ends the window list in `status-format`

---  

* `push-default`
Store the current colours and attributes as the default or reset to the previous default.  
    * Each `push-default` replaces the previous saved default.  
* `pop-default`: Remove the current default set by `push-default`


### Mouse Stuff  
* Specify the text used for the `StatusLeft` and `StatusRight` mouse keys.  
    * `range=left` 
    * `range=right`
* `range=window|X`:Defines the range for a specific window in the status line,
where X is the window index, for use with the `Status` mouse key.  
* `norange`: End a range in the `status-format`
 


## Examples  

```tmux  
#[fg=yellow bold underscore blink] 
#[bg=black,fg=default,noreverse] 
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


### Variable to Customize the Status Line
See [scripting notes](./scripting_notes.md#variables-with-aliases-for-easy-reference)  
These are the variables that have aliases available:  
| Variable Name            | Alias | Replaced with                      |
|--------------------------|-------|------------------------------------|
| `host`                        |`#H`| Hostname of local host 
| `host_short`                  |`#h`| Hostname of local host (no domain name) 
| `pane_id`                     |`#D`| Unique pane ID 
| `pane_index`                  |`#P`| Index of pane 
| `pane_title`                  |`#T`| Title of pane (can be set by application) 
| `session_name`                |`#S`| Name of session 
| `window_flags`                |`#F`| Window flags with # escaped as ## 
| `window_index`                |`#I`| Index of window 
| `window_name`                 |`#W`| Name of window 


### Window List  
By default, the window list shows the index, name and (if any) flag of  
the windows in the current session, sorted by number.  

It can be customized with the `window-status-format`
and `window-status-current-format` options.  

### Window Flags  
The flag is one of the following symbols appended to the window name:  
|Flag |  Meaning 
|-|-  
| `*` | Denotes the current window (can be changed in `window-status-current-format`).  
| `-` | Marks the last window (previously selected).  
| `#` | Window activity is monitored and activity has been detected. (`monitor-activity` window option)  
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

## Session Option for Monitoring Activity  
* `monitor-activity [on | off]`
    * Monitor for activity in the window.  
    * Windows with activity are highlighted in the status line.  
* Window flag `#` 
    * Indicates window activity is monitored and activity has been detected. 
* `activity-action [any | none | current | other]`
    * Set action on window activity when monitor-activity is on.  
* `visual-activity [on | off | both]`
    * If on, display a message instead of sending a bell when activity occurs in a window for  
      which the monitor-activity window option is enabled.  
* `monitor-bell [on | off]`
    * Monitor for a bell in the window.  

Or, monitor for a lack of activity  
* `monitor-silence [interval]`
    * Monitor for silence (no activity) in the window within interval seconds.  
    * Windows that have been silent for the interval are highlighted in the status line.  
    * An interval of zero disables the monitoring.  

Hooks for activity:  
* `alert-activity`: Run when a window has activity. For `monitor-activity`.  
* `alert-bell`: Run when a window has received a bell. For `monitor-bell`.  
* `alert-silence`: Run when a window has been silent. For `monitor-silence`.  

```tmux  
set-hook -g alert-activity 'display "Activity detected."'  
```

## Hook Commands  
* `set-hook [-agpRuw] [-t target-pane] hook-name command`
    * Sets hook `hook-name` to `command`. (or unsets with `-u`)  
    * The flags are the same as for `set-option`.  
    * With `-R`, runs `hook-name` immediately.  

* `show-hooks [-gpw] [-t target-pane]`
    * Shows hooks.  
    * The flags are the same as for `show-options`.  

---  

## Menus
Each menu consists of items followed by a key shortcut shown in brackets.
A blank single-quoted string will insert a horizontal rule.  
The format for each item is `"String to show" key "command-to-run"`.  
```tmux
bind-key -T prefix > display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -x P -y P 
"Horizontal Split" h "split-window -h" 
"Vertical Split" v "split-window -v" 
'' 
"#{?#{>:#{window_panes},1},,-}Swap Up" u "swap-pane -U" 
"#{?#{>:#{window_panes},1},,-}Swap Down" d "swap-pane -D" 
"#{?pane_marked_set,,-}Swap Marked" s swap-pane 
'' 
Kill X kill-pane 
Respawn R "respawn-pane -k" 
"#{?pane_marked,Unmark,Mark}" m "select-pane -m" 
"#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z "resize-pane -Z"  
```

