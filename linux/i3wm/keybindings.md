
# i3wm Keybindings


NOTE: Any time you see `Alt`/`alt`/`M-`, I'm referring to `Mod1`, the first modifier
key. This is `alt` by default.  


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

* `M-s` changes to stacked window layout
* `M-w` changes to tabbed window layout
* `M-e` switches between vertical and horizontal splits.


## Default i3 Window Manager Keybindings Cheatsheet

| Keybinding                        | Action                                               |
|-----------------------------------|------------------------------------------------------|
| `Alt-Enter`                      | Open a new terminal window                           |
| `Alt-d`                          | Open the application launcher (dmenu/rofi)           |
| `Alt-Shift-q`                    | Close the focused window                             |
| `Alt-j`                          | Focus the window to the left                         |
| `Alt-k`                          | Focus the window above                               |
| `Alt-l`                          | Focus the window below                               |
| `Alt-;`                          | Focus the window to the right                        |
| `Alt-h`                          | Move the focused window to the left                  |
| `Alt-Shift-k`                    | Move the focused window up                           |
| `Alt-Shift-l`                    | Move the focused window down                         |
| `Alt-Shift-;`                    | Move the focused window to the right                 |
| `Alt-f`                          | Toggle fullscreen for the focused window             |
| `Alt-Shift-Space`                | Toggle floating mode for the focused window          |
| `Alt-Space`                      | Change focus between tiling and floating windows     |
| `Alt-1` to `Mod1-9`              | Switch to workspace 1 to 9                           |
| `Alt-Shift-1` to `Mod1-Shift-9`  | Move the focused window to workspace 1 to 9          |
| `Alt-arrow keys`                 | Resize windows in tiling mode                        |
| `Alt-Ctrl-r`                     | Restart i3 in place                                  |
| `Alt-Shift-e`                    | Exit i3                                              |
| `Alt-s`                          | Change to stacking layout                            |
| `Alt-w`                          | Change to tabbed layout                              |
| `Alt-e`                          | Change to split layout (default horizontal)          |
| `Alt-v`                          | Change to vertical split layout                      |
| `Alt-Shift-c`                    | Reload i3 configuration file                         |
| `Alt-Shift-r`                    | Restart i3                                           |
| `Alt-Shift-s`                    | Switch focus between outputs (monitors)              |
| `Alt-b`                          | Toggle visibility of the status bar                  |
| `Alt-p`                          | Launch screenshot utility                            |
| `Alt-Shift-r`                    | Refresh (restart) i3wm without logging out           |
| `Alt-Tab`                        | Switch between last two workspaces                   |

### i3wm-Specific Terminology

1. `Mod1`:
    * Mod1 refers to the modifier key used in i3wm keybindings, typically set to the "Windows" key (also called the "Super" key) or the "Alt" key, depending on your configuration.

2. Workspace:
    * A workspace in i3wm is a virtual desktop.  
    * Each workspace can contain multiple windows, and you can switch between workspaces using `Mod1+1` to `Mod1+9`.  
    * Workspaces help organize your workflow by grouping related windows together.

3. Tiling:
    * Tiling refers to the arrangement of windows in a non-overlapping layout.  
    * Windows are automatically positioned to fill the available screen space.  
    * i3wm uses tiling by default, which maximizes screen real estate and minimizes window management.

4. Floating:
    * Floating windows can be moved and resized freely, similar to traditional window managers.  
    * You can toggle a window between tiling and floating mode with `Mod1+Shift+Space`.

5. Layouts:
     * i3wm supports different layouts to organize windows:
     * Split Layout: The default layout, where windows are split horizontally or vertically.
     * Stacking Layout: Windows are stacked on top of each other, and only the top window is visible.
     * Tabbed Layout: Windows are organized into tabs, and you can switch between them.

6. Focus:
    * The focused window is the active window that receives keyboard input.  
    * You can change the focus using `Mod1+j`, `Mod1+k`, `Mod1+l`, and `Mod1+;`.

7. Move:
   * You can move windows to different positions within the current layout using `Mod1+Shift` combined with the direction keys.

8. Resize:
   * Resize windows in tiling mode using `Mod1+arrow keys`.

9. Configuration File:
   * The i3wm configuration file (`~/.config/i3/config`) contains all the settings and keybindings.  
    * You can reload the configuration file without restarting i3wm using `Mod1+Shift+c`.

10. Status Bar:
    * The i3 status bar displays system information and can be toggled on and off using `Mod1+b`.

* Custom Keybindings: You can customize keybindings by editing the i3 configuration file.  
    * For example, to change the keybinding for opening a terminal to `Mod1+Return`, add the line: `bindsym Mod1+Return exec terminal`.
* Autostart Programs: To start programs automatically when i3 starts, add them to the configuration file with the `exec` command, for example: `exec firefox` to start Firefox on login.
* Save Workspace Layouts: You can save and restore complex workspace layouts using external tools like `i3-save-tree`.

By understanding these keybindings and terminologies, you can efficiently navigate and manage windows in i3wm, enhancing your productivity and making the most out of this powerful tiling window manager.

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




