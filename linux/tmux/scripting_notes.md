

# Misc. Tmux notes that could be helpful in scripting


Getting all panes by numbers:
```bash
tmux list-panes -F '#P'
```

Getting all windows by their numbers:
```bash
tmux list-windows -F '#I'
```

Sending keys to a specific pane:
```bash
send-keys -t ${pane} "$@"
```

Sending keys to a specific pane in a specific window:
```bash
send-keys -t ${window}.${pane} "$@"
```

Listing host and pane number in each pane:
```bash
setw -g pane-border-status top  # "off", or "{position}" (e.g., "top")
```

Get current state of border status:
```bash
display-message -p "#{pane-border-status}" 
```






