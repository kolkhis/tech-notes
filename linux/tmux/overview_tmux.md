
### Tmux vs Screen
#### Multiple user session:
* Both have multi-user support
* Screen allows users to share a session, but be in different windows
      * screen -r sessionowner/[pid.tty.host]
* Tmux session allows users to share a session, but switching windows switches for both users.

### Attach to Existing Session in Tmux:
* `tmux attach -t 0`
    * Where 0 is the target session from `tmux ls`
As a shorthand for `attach`, you can just use `a`:
* `tmux a -t 0`

### Create a New Tmux Session
* `tmux new`
    * This creates a session. 
    * The name of the session is an automatically generated number.
        * A zero-index-based number is given based on how many other sessions are open.
To create a session with a given name:
* `tmux new -s new_session`
    * Then you'd attach to it with `tmux a -t new_session`

### Tmux Commands
<details>
<summary> Session Management:</summary>


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

* `tmux send-keys` -X copy-selection: Copy selected text to the clipboard.

</details>



