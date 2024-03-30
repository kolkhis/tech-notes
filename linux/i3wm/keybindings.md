
# i3wm Keybindings


## Default Keybindings
##### These are in the [official i3wm docs](https://i3wm.org/docs/userguide.html#_default_keybindings)

The `Mod` key is either Alt or Win (super) by default. 


* `M-Enter` starts a terminal.
* `M-f` makes the currently selected window full-screen. 
* `M-k` and `M-l` switch which windows are selected.
* `M-Shift-Q` will close the current window.

### Movement
The default movement keybindings are *like* vim, except they're all shifted right by one.
So, instead of `hjkl`, it's `jkl;`. 


### Changing Window Layout

* M-s changes to stacked window layout
* M-w changes to tabbed window layout
* M-e switches between vertical and horizontal splits.


## Workspaces

Workspaces group a set of windows.  
 
By default, you are on the first workspace. 
The bar on the bottom left indicates the current workspace.  

To switch to another workspace, press `$mod+num` where `num` is the number of the workspace you want to use.  

If the workspace does not exist yet, it will be created.

A common paradigm:
1. A workspace for the web browser.
2. A workspace for communication applications (mutt, irssi, …). 
3. A workspace for the applications you use for work.  
Of course, there is no need to follow this approach.

### Workspaces with Multiple Screens
* If you have multiple screens, a workspace will be created on each screen at startup.  
* If you open a new workspace, it will be bound to the screen you created it on.  
* When you switch to a workspace on another screen, i3 will set focus to that screen.




