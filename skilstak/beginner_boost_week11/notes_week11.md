# Multiple Windows/Terminal Sessions With Tmux

## Terminal Multiplexer
Multiplexer means "Multiple Displays" or "Multiple Screens".


## Tmux/Screen
"Terminal Multiplexer"

Tmux is a Terminal Window Manager. It can manage 
multiple terminal sessions across different windows and panes.
Helps manage a single screen. Can switch between actions.

Process Management:
    1. Connect to a remote system, start tmux, and do something.
    1. Use that session to run a program
    1. Use tmux to create a new session
    1. do something else in another window.



You can use Tmux (or screen) to share a screen/keyboard with other people (via SSH into the same machine)

Screen = the whole display
Window = Terminal Session
Panes  = Terminal Splits 


The Terminals that are emulated: 
Deck VT100
VT100-extended (color support)

## GNU Screen
### Rob recommends learning Screen before Tmux.
* This is because any system that doesn't have tmux will almost always have screen.

Useful `screen` commands:

`$ screen -ls`
- This shows whether or not there is an existing screen session
    - Tmux has the same thing (as `$ tmux ls`)

`$ screen -r [processid]`
- This reattaches to the given process.

`$ screen -d [processid]`
- This detaches from the given process.

#### Key Combinations

Default `screen` <leader> is <Ctrl-a>


* <C-a>w (or <leader>w) will show which window is active
* <leader>0 - will take you to screen 0
* <leader>: - will take you to screen command line
* <leader>:help<CR> - shows help
* <leader>c - Create a new window.
* <leader>aa - Hop between screen windows
* <leader>d - detaches from current window
    * screen -r to reattach


## Don't do this at work
* <leader>\ - Kill all windows and terminate screen


#### Copy mode

* <leader>[ - Enter copy mode

Select text with <enter(or space)> motion <enter>

* <leader>] - Paste from screen buffer

To paste into vim/nvim:
* :set paste
* i
* <leader>]

#### Screen Sharing

To share screen session with another user:

* <leader>a:multiuser on
    * `<leader>a` and then `:` to enter command mode
    * `:multiuser on` to enable multi-user support

Get the screen session with <leader>ad (detach) and `$ screen -ls`

Then other user will connect, `$ screen -S [session_name]`


## Tmux
### Tmux is "more robust" by default

`$ tmux ls` to list active tmux clients/sessions

#### Hotkeys

Tmux <leader> key is <C-b> by default.

* <leader>? - List keybindings
* <leader>:list-keys - Get a better list of keybindings

##### Default Binidings that Tmux shares with Screen
* <leader>c - will create a new window. Same as Screen
* <leader>: - Enter command mode.
* <leader>[ - Enter copy mode
* <leader>] - Paste most recently copied tmux buffer
* <leader>w - Show all windows, with current one highlighted.
* <leader>0-9 - Switch between windows 0-9


##### Default Bindings Tmux Specific 

* <leader>l - "Move to the previously selected window" - Toggle between 2 windows a session
* <leader>t - Show current time (UTC by default)


##### Panes

* <leader>% - VSplit current window (new pane)
* <leader>; - Move to the previously active pane (like <leader>l, but for panes.)
* <leader>z - Zoom/unzoom the active pane
* <leader>x - kill the active pane
* <leader>o - select next pane
* <leader>q - show pane numbers
* <leader><C-o> - Rotate panes
* <leader>! - Break Pane into new window
* <leader>" - Split window vertically
* <leader>E - Spread out panes evenly
* <leader>M - Clear the marked pane


##### Paste 

* <leader>[ - Copy mode
* <leader>] - paste
* <leader># - List all paste buffers


