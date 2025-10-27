# Menus in Tmux

## The `display-menu` command

### Usage
```bash
display-menu (menu) [-O] [-c target-client] [-t target-pane] [-T title] [-x position] [-y position] name key command ...  
```

* `menu` can be used as an alise for `display-menu`

### Options for Styling the Menu
`-T` is a format for the menu title (see `man://tmux 2138`).

`-x` and `-y` give the position of the menu.
Both may be a row or column number, or one of the following special values:

| Value |  Flag   | Meaning
|-|-|-
| `C`   | Both    | The centre of the terminal
| `R`   | -x      | The right side of the terminal
| `P`   | Both    | The bottom left of the pane
| `M`   | Both    | The mouse position
| `W`   | Both    | The window position on the status line
| `S`   | -y      | The line above or below the status line

Or a format, which is expanded including the following additional variables:

| Variable name                 |      Replaced with
|-|-
| `popup_centre_x`              | Centered in the client
| `popup_centre_y`              | Centered in the client
| `popup_height`                | Height of menu or popup
| `popup_mouse_bottom`          | Bottom of at the mouse
| `popup_mouse_centre_x`        | Horizontal centre at the mouse
| `popup_mouse_centre_y`        | Vertical centre at the mouse
| `popup_mouse_top`             | Top at the mouse
| `popup_mouse_x`               | Mouse X position
| `popup_mouse_y`               | Mouse Y position
| `popup_pane_bottom`           | Bottom of the pane
| `popup_pane_left`             | Left of the pane
| `popup_pane_right`            | Right of the pane
| `popup_pane_top`              | Top of the pane
| `popup_status_line_y`         | Above or below the status line
| `popup_width`                 | Width of menu or popup
| `popup_window_status_line_x`  | At the window position in status line
| `popup_window_status_line_y`  | At the status line showing the window


### Menu Items

* Each menu consists of items followed by a key shortcut shown in brackets.
* If the menu is too large to fit on the terminal, it is not displayed.
* Pressing the key shortcut chooses the corresponding item.

Examples:
```bash
"Kill" X kill-pane 
"Respawn" R "respawn-pane -k" 
```

* `"Kill" X kill-pane`
    * `"Kill"` is the text shown for the menu item.
    * `X` is the key shortcut.
    * `kill-pane` is the command to run when the item is selected.
* `"Respawn" R "respawn-pane -k"`
    * `"Respawn"` is the text shown for the menu item.
    * `R` is the key shortcut.
    * `"respawn-pane -k"` is the command to run when the item is selected.

### Conditional Menu Items
You can set conditions for menu items.  
Items that don't match the condition can be disabled.  

* Follows a structure: `"${?#{conditional},,-}Display Text" x "command"`
  E.g.,:
  ```bash
  "#{?#{>:#{window_panes},1},,-}Swap Up" u "swap-pane -U"
  ```
* The conditional: `{>:#{window_panes},1}` checks `#{window_panes}` to see if
  there's more than one pane in the window.  
* That's passed to the outer conditional format (`#{?conditional,true,false}`), where `true`
  is set to nothing, and `false` is set to `-`.  
    * If there is more than one pane, do nothing.
    * If there isn't more than 1 pane, disable (set to `-`)

### Keys
The following keys are also available:

| Key      |  Function
|-|-
| `Enter`  | Choose selected item
| `Up`     | Select previous item
| `Down`   | Select next item
| `q`      | Exit menu

