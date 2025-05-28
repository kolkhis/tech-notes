# Tmux Overview

Tmux is a terminal multiplexer. It's a successor to GNU Screen (which is still
alive) with more features.  

## Table of Contents
* [Tmux vs Screen](#tmux-vs-screen) 
    * [Multiple user session](#multiple-user-session) 
* [Attach to Existing Session in Tmux](#attach-to-existing-session-in-tmux) 
* [Create a New Tmux Session](#create-a-new-tmux-session) 
* [Tmux Commands](#tmux-commands) 
    * [Session Management](#session-management) 
    * [Window Management](#window-management) 
    * [Pane Management](#pane-management) 
    * [Miscellaneous Commands](#miscellaneous-commands) 
    * [Session, Window, and Pane Indexing](#session-window-and-pane-indexing) 
    * [Copy Mode (for copying text)](#copy-mode-for-copying-text) 
* [Keybindings and Key Tables](#keybindings-and-key-tables) 
    * [Key Tables](#key-tables) 

## Tmux vs Screen
Tmux and screen have a lot of overlapping functionality.  
The thing that stands out the most (to me) is the fact that tmux panes are much 
easier to use and more full-featured than Screen's split window.  

They both support multiple users at one time, but Screen is a bit better in this
regard.  

### Multiple user session:

* Both have multi-user support
* Screen allows users to share a session, but be in different windows
  ```bash
  screen -r sessionowner/[pid.tty.host]
  ```
* Tmux session allows users to share a session, but switching windows switches for 
  both users.

## Tmux Commands

### Create a New Tmux Session

* `tmux new`: Ran by itself, with no arguments, creates a new session. 
    * The name of the session is an automatically generated number.
    * A zero-index-based number is given based on how many other sessions are open.

To create a session with a custom name:

* `tmux new -s my-session-name`
    * Then you'd attach to it with `tmux a -t my-session-name`

### Attach to Existing Session in Tmux:

```bash
tmux attach -t 0
```

* `0` is the target session from `tmux ls`

As a shorthand for `attach`, you can just use `a`:

```bash
tmux a -t 0
```

### Session Management:


* `tmux new-session`: Create a new session.

* `tmux attach-session`: Attach to an existing session.

* `tmux switch-client`: Switch to a different client in a session.

* `tmux list-sessions`: List existing sessions.

* `tmux detach-client`: Detach the current client from the session.

* `tmux kill-session`: Terminate a session.

* `tmux has-session`: Check if a session exists.



### Window Management: 


* `tmux new-window`: Create a new window.

* `tmux select-window`: Switch to a specific window.

* `tmux last-window`: Switch to the previously used window.

* `tmux next-window`: Switch to the next window.

* `tmux previous-window`: Switch to the previous window.

* `tmux list-windows`: List existing windows.

* `tmux kill-window`: Close the current window.



### Pane Management: 


* `tmux split-window`: Split the current pane into two vertical panes.

* `tmux split-window -h`: Split the current pane into two horizontal panes.

* `tmux swap-pane -[UDLR]`: Swap panes with the specified direction (Up, Down, Left, Right).

* `tmux select-pane -[UDLR]`: Select the pane in the specified direction.

* `tmux select-pane -t <pane-number>`: Select a specific pane by number.

* `tmux resize-pane -[UDLR] <size>`: Resize the current pane in the specified direction by size.

* `tmux kill-pane`: Close the current pane.



### Miscellaneous Commands:


* `tmux list-keys`: List all keybindings.

* `tmux list-commands`: List all commands.

* `tmux info`: Display information about the current session, window, or pane.

* `tmux source-file <file>`: Load a configuration file.



### Session, Window, and Pane Indexing:


* `tmux choose-session`: Interactively choose a session.

* `tmux choose-window`: Interactively choose a window.

* `tmux choose-pane`: Interactively choose a pane.

* `tmux switch-client -t <target-client>`: Switch to a specific client (session or window).


### Copy Mode (for copying text):


* `tmux copy-mode`: Enter copy mode.

* `tmux send-keys -X copy-selection`: Copy selected text to the clipboard.



## Keybindings and Key Tables
##### See the [docs](https://github.com/tmux/tmux/wiki/Getting-Started#key-bindings)

### Key Tables
* The `root` table contains key bindings for keys pressed without the prefix key.
* The `prefix` table contains key bindings for keys pressed after the prefix key, like 
  those mentioned so far in this document.
* The `copy-mode` table contains key bindings for keys used in copy mode with 
  emacs-style keys.
* The `copy-mode-vi` table contains key bindings for keys used in copy mode with 
  vi-style keys.

