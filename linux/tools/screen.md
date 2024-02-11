

# GNU Screen

## Basics
`screen` starts a new screen session.
`screen -ls` lists all screen sessions.
`screen -r` reattaches to a running screen session.  

## Default Keybindings:

* `C-a` is the prefix.
* `C-a ?` for a list of keybindings.  

## Regions
Regions don't take on their own terminal instance like in tmux.
You can use them to access other windows.  
i.e., You can use a region to access window 2 while working in window 1.  


### Working with regions (called panes in tmux):
* `C-a S` Splits the screen horizontally (capital S). 
* `C-a |` Splits the screen vertically. (not `\`, that kills all the windows).
* `C-a C-i` switches between regions (panes).
* `C-a C-tab` also switches between regions (panes).
* `C-a Q` Kills all regions except the current one. 


