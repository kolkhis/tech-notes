

# Copy Mode in Tmux

Copy mode in tmux is a mode where you can copy the contents of the 
current pane to the system clipboard or a tmux paste buffer. 

## Basics of Copy Mode
### Entering Copy Mode

Enter copy mode by using `<prefix>[`.
* `<prefix>` is `<C-b>` by default. 
* Mine is set to `<C-a>`.
  ```bash
  unbind C-b
  set -g prefix C-a
  bind-key C-a send-prefix
  ```

Keybindings in copy mode depend on what your `mode-keys` setting is set to.  
* Mine is set to `vi`:
```bash
set -g mode-keys vi
set -g status-keys vi
```


## Copy Mode Keybindings

```bash
bind-key    -T copy-mode-vi A    send-keys -X append-selection-and-cancel
bind-key    -T copy-mode-vi B    send-keys -X previous-space
bind-key    -T copy-mode-vi D    send-keys -X copy-end-of-line
bind-key    -T copy-mode-vi E    send-keys -X next-space-end
bind-key    -T copy-mode-vi F    command-prompt -1 -p "(jump backward)" "send -X jump-backward \"%%%\""
bind-key    -T copy-mode-vi G    send-keys -X history-bottom
bind-key    -T copy-mode-vi H    send-keys -X top-line
bind-key    -T copy-mode-vi J    send-keys -X scroll-down
bind-key    -T copy-mode-vi K    send-keys -X scroll-up
bind-key    -T copy-mode-vi L    send-keys -X bottom-line
bind-key    -T copy-mode-vi M    send-keys -X middle-line
bind-key    -T copy-mode-vi N    send-keys -X search-reverse
bind-key    -T copy-mode-vi T    command-prompt -1 -p "(jump to backward)" "send -X jump-to-backward \"%%%\""
bind-key    -T copy-mode-vi V    send-keys -X select-line
bind-key    -T copy-mode-vi W    send-keys -X next-space
bind-key    -T copy-mode-vi X    send-keys -X set-mark
bind-key    -T copy-mode-vi ^    send-keys -X back-to-indentation
bind-key    -T copy-mode-vi b    send-keys -X previous-word
bind-key    -T copy-mode-vi e    send-keys -X next-word-end
bind-key    -T copy-mode-vi f    command-prompt -1 -p "(jump forward)" "send -X jump-forward \"%%%\""
bind-key    -T copy-mode-vi g    send-keys -X history-top
bind-key    -T copy-mode-vi h    send-keys -X cursor-left
bind-key    -T copy-mode-vi j    send-keys -X cursor-down
bind-key    -T copy-mode-vi k    send-keys -X cursor-up
bind-key    -T copy-mode-vi l    send-keys -X cursor-right
bind-key    -T copy-mode-vi n    send-keys -X search-again
bind-key    -T copy-mode-vi o    send-keys -X other-end
bind-key    -T copy-mode-vi q    send-keys -X cancel
bind-key    -T copy-mode-vi r    send-keys -X refresh-from-pane
bind-key    -T copy-mode-vi t    command-prompt -1 -p "(jump to forward)" "send -X jump-to-forward \"%%%\""
bind-key    -T copy-mode-vi v    send-keys -X begin-selection
bind-key    -T copy-mode-vi w    send-keys -X next-word
bind-key    -T copy-mode-vi y    send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
bind-key    -T copy-mode-vi \{   send-keys -X previous-paragraph
bind-key    -T copy-mode-vi \}   send-keys -X next-paragraph

bind-key    -T copy-mode-vi '>'  send-keys -X halfpage-down
bind-key    -T copy-mode-vi '<'  send-keys -X halfpage-up
bind-key    -T copy-mode-vi '/'  command-prompt -I search-forward "send -X search-forward \"%%%\""
bind-key    -T copy-mode-vi '?'  command-prompt -I search-backward "send -X search-backward \"%%%\""
bind-key    -T copy-mode-vi 'R'  send-keys -X rectangle-toggle
```

Breakdown of these commands:
* `bind-key`: Setting a keybind.  
* `-T copy-mode-vi`: The key table to use for the keybinding.  
* `-X command`: Execute a tmux command-line command within copy-mode.
* `send-keys`: Sends keys to a window, in this case, tmux commands due to -X.
* `-1`: Accepts one argument from the user.
* `-p "(jump backward)"`: Prompts the user with a message to indicate what to input.
    * `"send -X jump-backward \"%%%\""`:  The command to execute with the input, where `%%%` will be replaced by the user's input.
* `command-prompt`: Opens a prompt in tmux for user input.
    * `-I search-forward`:  The prompt will capture user input and use it for `search-forward`.  
    * The input can be accessed using `"%%%"` in the command:  
      ```bash
      command-prompt -I search-forward 'send -X search-forward "%%%"'
      ```


```bash
# Existing keybindings expanded with breakdown

bind-key    -T copy-mode-vi A    send-keys -X append-selection-and-cancel
# -T target-table    Specifies the key table to use, here it's `copy-mode-vi`.
# append-selection-and-cancel   Appends the selection to the buffer and then cancels copy mode.

bind-key    -T copy-mode-vi B    send-keys -X previous-space
# previous-space     Moves the cursor to the previous space character.

bind-key    -T copy-mode-vi D    send-keys -X copy-end-of-line
# copy-end-of-line   Copies the text from the cursor to the end of the line.

bind-key    -T copy-mode-vi F    command-prompt -1 -p "(jump backward)" "send -X jump-backward \"%%%\""
# command-prompt     Opens a prompt in tmux for user input.
# -1                  Accepts one argument from the user.
# -p "(jump backward)" Prompts the user with a message to indicate what to input.
# "send -X jump-backward \"%%%\""  The command to execute with the input, where %%% will be replaced by the user's input.

bind-key    -T copy-mode-vi y    send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
# copy-pipe-and-cancel "xclip -in -selection clipboard"
#                    Pipes the selection to a shell command and cancels copy mode. Here, piping to `xclip` to copy to the system clipboard.

```


