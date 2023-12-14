-- Require necessary modules
local sg = require('sg') -- Sourcegraph module
local sgui = require('sg.extensions.telescope') -- Sourcegraph UI module
local os = require('kolkhis.detect_os') -- Module to detect OS

-- Setup Sourcegraph if on Linux
if os.is_linux then
  -- Minimal Sourcegraph config
  sg.setup({})

  -- Add keybinding to open Sourcegraph fuzzy search
  vim.keymap.set('n', '<leader>ss', function()
    sgui.fuzzy_search_results()
  end)

  M = {}
  M.config = {
    mappings = {
      toggleCody = {
        keys = { 'n', 'v' },
        mapping = '<leader>co',
        cmd = '<cmd>CodyToggle<CR>',
        opts = { silent = true, noremap = true, desc = 'Toggle Cody window' },
      },
      askCody = {
        keys = { 'n', 'v' },
        mapping = '<leader>ca',
        fn = function()
          local mode = vim.api.nvim_get_mode().mode
          local prompt = M.config.prompts.askPrompt[mode]
          vim.ui.input({ prompt = prompt }, function(q)
            M.config.handlers.askHandler(q, mode)
          end)
        end,
      },
      taskCody = {
        keys = { 'n', 'v' },
        mapping = '<leader>cp',
        fn = function()
          local mode = vim.api.nvim_get_mode().mode
          local prompt = M.config.prompts.taskPrompt[mode]
          vim.ui.input({ prompt = prompt }, function(task)
            M.config.handlers.taskHandler(task, mode)
          end)
        end,
        opts = { silent = true, noremap = true, desc = 'Task Cody about file or selection' },
      },
    },

    prompts = {
      askPrompt = {
        n = 'Ask Cody about file > ',
        v = 'Ask Cody about selection > ',
        V = 'Ask Cody about selection > ',
        ['<C-V>'] = 'Ask Cody about selection > ',
      },
      taskPrompt = {
        n = 'Cody Task (global) > ',
        v = 'Cody Task > ',
        V = 'Cody Task > ',
        ['<C-V>'] = 'Ask Cody about selection > ',
      },
    },

    handlers = {
      askHandler = function(q, mode)
        if mode == 'n' then
          vim.cmd((':%% CodyAsk %s'):format(q))
        else
          vim.cmd.norm('I')
          vim.cmd(("'<,'>CodyAsk %s"):format(q))
        end
      end,

      taskHandler = function(task, mode)
        if mode == 'n' then
          vim.cmd(('%% CodyTask %s'):format(task))
        else
          vim.cmd.norm('I')
          vim.cmd((":'<,'>CodyTask %s"):format(task))
        end
      end,
    },
  }

  -- Set up key mappings
  vim.keymap.set(
    M.config.mappings.toggleCody.keys,
    M.config.mappings.toggleCody.mapping,
    M.config.mappings.toggleCody.cmd,
    M.config.mappings.toggleCody.opts
  )

  vim.keymap.set(
    M.config.mappings.askCody.keys,
    M.config.mappings.askCody.mapping,
    M.config.mappings.askCody.fn,
    M.config.mappings.askCody.opts
  )

  vim.keymap.set(
    M.config.mappings.taskCody.keys,
    M.config.mappings.taskCody.mapping,
    M.config.mappings.taskCody.fn,
    M.config.mappings.taskCody.opts
  )
  return M

end

  -----------------------REFACTOR TEST END----------------------------




-- n - Normal mode
-- v - Visual mode
-- V - Visual Line mode 
-- s - Select mode
-- S - Select Line mode
-- i - Insert mode
-- ic - Insert mode completion
-- R - Replace mode
-- Rv - Virtual Replace mode
-- c - Command-line mode
-- cv - Vim Ex mode
-- ce - Normal Ex mode
-- r - Prompt mode
-- rm - More prompt mode
-- ['r?'] - Confirm prompt mode


-- prompts = {
--   askPrompt = {
--     n = 'Ask Cody about file > ',
--     v = 'Ask Cody about selection > ', 
--     V = 'Ask Cody about selection > ',
--     s = 'Ask Cody about selection > ',
--     S = 'Ask Cody about selection > ',
--     i = 'Ask Cody about selection > ',
--     ic = 'Ask Cody about selection > ',
--     R = 'Ask Cody about selection > ',
--     Rv = 'Ask Cody about selection > ',
--     c = 'Ask Cody about selection > ',
--     cv = 'Ask Cody about selection > ',
--     ce = 'Ask Cody about selection > ',
--     r = 'Ask Cody about selection > ',
--     rm = 'Ask Cody about selection > ',
--     ['<C-V>'] = 'Ask Cody about selection > ',
--   },

