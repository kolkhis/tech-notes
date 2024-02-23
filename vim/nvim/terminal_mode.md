
# Terminal Mode in Neovim  


Running `:terminal` in nvim will open a new terminal buffer.  
The command can be shortened all the way to `:te`.  

## Basic terminal buffer keybinds  
In Terminal mode, all input (except `<C-\>`) is sent to the process running in  
the current `terminal` buffer (i.e., bash).  

* Pressing `i` after entering a terminal buffer will start `terminal mode`.  
* `<C-\><C-N>`: leaves terminal-mode (back to normal mode).  
* `<C-\><C-O>`: Execute a single normal mode command (same as `<C-o>`in insert mode).  

You can set keymaps for terminal mode using the `t` keymap group.  
```lua  
vim.keymap.set('t', '<C-[><C-[>', [[<C-\><C-n>]], { noremap = true })  
```



