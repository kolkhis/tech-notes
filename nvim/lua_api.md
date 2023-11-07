

## Getting Current Mode

`vim.api.nvim_get_mode()` does not return 'v' for visual mode. 

Instead, it returns:

- `'n'` for normal mode
- `'i'` for insert mode  
- `'v'` for visual mode
- `'V'` for visual line mode
- `'<C-V>'` for visual block mode
- `'t'` for terminal mode

