# Moving Tmux Panes to Different Windows

> NOTE: My personal tmux prefix is `Ctrl-a`. The default prefix is `Ctrl-b`.

## Moving Panes 
* Identify the Target Pane and Window:
    * Get the index of the pane you want to move.  
        * `prefix+q`
    * Identify the target window AND pane you want to attach the pane to.

### Moving a Pane into a New Window
* `prefix+!`: This will run the `break-pane` command on the current pane.  
or
* Navigate to the pane you want to move.  
* With your cursor in the pane, enter command mode with `prefix+:`  
* Use the `break-pane` command.  
    * This will detach the pane from the current window and put it into a new one.


### Moving a Pane to a Different Window
* Move the Pane to a Different Window:
    * Use the `join-pane` command to move the pane.  
    * Syntax:
     ```bash
     join-pane -s src-pane -t dst-window
     # e.g.,
     join-pane -s 1.1 -t 2.1
     ```
    * `src-pane` will be `x.x`; like `1.1`, for "Window 1, Pane 1". 
    * `dst-window` will be the same: `2.1`, for "Window 2, Pane 1".

### Moving a Pane Around Within the Same Window
* OR, if you want to keep the pane in the same window, but attach it to a different
  pane:
    * ```bash
      join-pane -s src-pane -t dst-pane
      # e.g.,
      join-pane -s 1.1 -t 3
      ```
    * This will attach pane 1 in window 1 to pane 3 in window 1.



### Example

Assuming you want to move pane 1 from window 1 to window 2, here’s how you can do it:

* Move the Pane from Window 1 to Window 2:
    * Use the following command:
     ```bash
     tmux join-pane -s 1.1 -t 2.1
     ```
    * Here, `1.1` represents the first pane in window 1, and `2` represents window 2.
* Attach pane 1 in window 1 to pane 3 in window 1:
    * ```bash
      :join-pane -s 1.1 -t 2
      ```

### Summary (TL;DR)

* Determine the source pane and target window.

* Attach the pane to another pane in the same window:
    - Use the `join-pane` command, e.g., `tmux join-pane -s 1.1 -t 2`.
      ```bash
      tmux join-pane -s 1.1 -t 2
      ```

* Move the pane to another pane in a different window:
    - Use the `join-pane` command, e.g., `tmux join-pane -s 1.1 -t 2.1`.
      ```bash
      tmux join-pane -s 1.1 -t 2.1
      ```
      Joins the pane from the source `1.1` (window 1, pane 1) to the target pane
      `2.1` (window 2, pane 1).  

* Use `prefix`, then `:` to enter command mode and type `join-pane -s 1.1 -t 2`.
    ```bash
    [prefix]:join-pane -s 1.1 -t 2
    ```
    Moves the pane from the source `1.1` (window 1, pane 1) to the target window
    `2` (window 2).  

## Moving a Window to a Different Session

- To move a window to a different session, you can use the `move-window` command.  
  ```bash
  tmux move-window -s src-window -t dst-session
  # e.g.,
  tmux move-window -s 1 -t new-session
  ```
  If you're outside of the session where the window exists, also specify the
  source session:
  ```bash
  tmux move-window -s old-session:1 -t new-session
  ```

- If you're in the window you want to move, use `prefix+:` to enter command mode and then run:
  ```bash
  move-window -t new-session
  ```
