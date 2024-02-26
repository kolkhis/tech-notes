

# colorcolumn
The `'colorcolumn'` option is used to highlight a particular 
column or range of columns.

This is useful for highlighting the current line, or for highlighting the
column after `'textwidth'`.

The screen column can be an absolute number, or a number preceded with
`+` or `-`, which is added to or subtracted from `'textwidth'`.

```vim
set cc=80  " Highlight column 80 
set cc=+1  " Highlight column 'textwidth' + 1
set cc=+1,+2,+3 " Highlight 3 columns after 'textwidth' 
```

A helper function:
```lua
function Line(pos)
  pos = pos or ''
  if vim.api.nvim_get_option_value('colorcolumn', {scope = "local"}) == tostring(pos) then
    pos = '' -- When reusing the same value, unset the colorcolumn instead.
  end
  vim.api.nvim_set_option_value('colorcolumn', tostring(pos), {scope = "local"})
end
vim.cmd("command! -nargs=? Line lua Line(<args>)")
--                -nargs=? means 0 or 1 arguments are allowed

vim.cmd("command! Line80 lua Line(80)")
```
This function can be used to highlight a particular line, or to unset the 
highlight of the line.  





