
# Neovim LSP
###### *:h lsp-core*



## `vim.lsp` API
###### *:h lsp-buf*
Toggle inlay hints:
```lua
vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
```

Display a hover popup for the current "symbol" (word, token, etc) under the cursor:
```lua
vim.lsp.buf.hover()
```
-- Displays hover information about the symbol under the cursor in a floating
window. Calling the function twice will jump into the floating window.

Rename/refactor the current "symbol" (word, token, etc) under the cursor:
```lua
vim.lsp.buf.rename()
```



```lua
vim.lsp.buf.references()  -- Lists all the references to the symbol under the cursor in the quickfix window.
vim.lsp.buf.clear_references() -- Removes document highlights from current buffer.
vim.lsp.buf.code_action()  -- Selects a code action available at the current cursor position.
vim.lsp.buf.completion()  -- Retrieves the completion items at the current cursor position. Can only be called in Insert mode.
vim.lsp.buf.declaration()  -- Jumps to the declaration of the symbol under the cursor. Many servers do not implement this method. Generally, see `vim.lsp.buf.definition()` instead.
vim.lsp.buf.definition()  -- Jumps to the definition of the symbol under the cursor.
vim.lsp.buf.format()  -- Formats a buffer using the attached (and optionally filtered) language server clients.
vim.lsp.buf.implementation()  -- Lists all the implementations for the symbol under the cursor in the quickfix window.
vim.lsp.buf.references()  -- Lists all the references to the symbol under the cursor in the quickfix window. 
vim.lsp.buf.rename()  -- Renames all references to the symbol under the cursor.
vim.lsp.buf.signature_help()  --  Displays signature information about the symbol under the cursor in a floating window. 
vim.lsp.buf.type_definition() -- Jumps to the definition of the type of the symbol under the cursor.  -- 
```
