--[[Resources:

API docs
https://neovim.io/doc/user/api.html#API

Pynvim docs
https://pynvim.readthedocs.io/en/latest/usage/python-plugin-api.html#nvim-api-methods-vim-api

Lua reference
https://learnxinyminutes.com/docs/lua/

Regex
:h character-classes
https://www.vimregex.com/


-- Nightly repo for apt
-- sudo add-apt-repository ppa:neovim-ppa/unstable -y



-- `c/word` <- change to searched text
-- `c?word` <- same as above, change backwards to search term


--[=[ Regex with vim ]=]--

            Pattern atom

    ^ start matching from beginning of a line
        /^This match This only at beginning of line
    $ match pattern should terminate at end of a line
        /)$ match ) only at end of line
        /^$ match empty line
    . match any single character, excluding new line
        /c.t match 'cat' or 'cot' or 'c2t' or 'c^t' but not 'cant'

For more info, :h pattern-atoms


            Pattern Qualifiers

    *greedy match preceding character 0 or more times
        /abc* match 'ab' or 'abc' or 'abccc' or 'abcccccc' etc
    \+ greedy match preceding character 1 or more times
        /abc\+ match 'abc' or 'abccc' but not 'ab'
    \? match preceding character 0 or 1 times (\= can also be used)
        /abc\? match 'ab' or 'abc' but not 'abcc'
    \{-} non-greedy match preceding character 0 or more times
        Consider this line of text 'This is a sample text'
        /h.\{-}s will match: 'his'
        /h.*s will match: 'his is a s'
        Read more on non-greedy matching
    \{min,max} greedy match preceding character min to max times (including min and max)
        min or max can be left unspecified as they default to 0 and infinity respectively
        greedy match, tries to match as much as possible
    \{-min,max} non-greedy match, tries to match as less as possible
    \{number} match exactly with specified number
        /c\{5} match exactly 'ccccc'

For more info, 
:h pattern-overview
:h character-classes




On Termux and WSL, comment out shell opts set.lua.

Add "Edit with Neovim" to dotfiles
Windows Registry Editor Version 5.00


[HKEY_CLASSES_ROOT\*\shell\Edit with Neovim]
"Icon"="C:\Users\username\AppData\Local\Programs\Neovim\bin\nvim-qt.exe"
OR, if installed globally:
"Icon"="C:\Program Files\Neovim\bin\nvim-qt.exe"

[HKEY_CLASSES_ROOT\*\shell\Edit with Neovim\command]
@="C:\Users\username\AppData\Local\Programs\Neovim\bin\nvim-qt.exe" "%1"
OR, if installed globally:
@="C:\Program Files\Neovim\bin\nvim-qt.exe" "%1"



vim.fn functions:
https://neovim.io/doc/user/usr_41.html#function-list





--- Playing with the vim.api
-- vim.keymap.set('n', '<leader>tk', function ()
--  -- vim.cmd('lua print("wowowow")')
--  -- local buf = vim.api.nvim_get_current_buf()
--  -- vim.api.nvim_set_current_buf(buffer)
--  -- vim.api.nvim_create_autocmd(event, opts?)
--  -- Trying to create a floating window
--  local buf = vim.api.nvim_create_buf(false, true)
--  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
--  -- vim.api.nvim_buf_set_text(buf, 1, 1, -1, -1, 'wowowowoowowow')
--  vim.api.nvim_buf_set_lines(buf, 0, 0, false, {'Wowowowowoowow'})
-- end)
-- local win = vim.api.nvim_get_current_win()








--[[
anything in nvim/plugin will load/run at runtime.

package.loaded has a table of loaded packages.
vim.api.nvim_get_keymaps

  --[[  Neo-Tree Setup  ]]
  -- Switching from neo-tree to harpoon
  --
  -- use({
  --   'nvim-neo-tree/neo-tree.nvim',
  --   branch = 'v2.x',
  --   requires = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  --     'MunifTanjim/nui.nvim',
  --   },
  --   config = function()
  --     -- Unless you are still migrating, remove the deprecated commands from v1.x
  --     vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  --     vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
  --     vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
  --     vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
  --     vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
  --   end,
  -- })
--[[  End of Neo-Tree Setup  ]]
  --



--[=======[

Window navigation:
:h wincmd

:e https://github.com/somefile.c -- this works


--[=[ Refactoring tip ]=]--

>> Grep with Telescope (or :vim[grep]), add to quickfix list
>> Then, to apply a cmd to each thing:
:cdo <cmd>
:cfdo {cmd}     Execute {cmd} in each file in the quickfix list.
            It works like doing this: >
                :cfirst
                :{cmd}
                :cnfile
                :{cmd}
                etc.
<           Otherwise it works the same as `:cdo`.

Location list (do the same thing, but with :lvim[grep])
:ldo {cmd}
:lfdo {cmd} 

:h cdo


Disable LSP for current buffer
-- :lua vim.lsp.diagnostics.disable(vim.api.nvim_get_current_buf())

--]=======]

---Alternative pure-lua (no vim api) toggle case function
---@param word string
---@return string new_word
M.lower_upper_tog = function(word)
  local lcase = word:match('%l')
  local ucase = word:match('%u')

  local new_word = ""
  for i=1, #word do
    local char = word:sub(i,i)
    if lcase and not ucase then
      new_word = new_word .. char:upper()
    elseif not lcase and ucase then
      new_word = new_word .. char:lower()
    elseif lcase and ucase then
      new_word = new_word .. char:upper()
    else
      new_word = new_word .. char
    end
  end
  return new_word
end
