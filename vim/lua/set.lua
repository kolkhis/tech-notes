M = {}
-------------------
--- Test code for a different implementation of `set.lua`
---
---
-------------------

M.netrw = {
  banner = 0,
  alto = 0,
  altv = 0,
  preview = 1,
  liststyle = 0,
  bufsettings = 'noma nomod nu nowrap ro nobl',
  hide = 0,
  usetab = 1,
  winsize = 20,
  browse_split = 0,
}

M.general_opts = {
  colorscheme = 'material-deep-ocean',
  cursor = {
    fg = 'White',
    bg = 'Red',
  },
  python_indent = {
    open_paren = 4,
    nested_paren = 4,
    continue = 4,
    closed_paren_align_last_line = false,
  },
  path = { '**' },
  cursorlineopt = { 'number' },
  cursorline = true,
  completeopt = { 'menuone', 'noselect', 'preview' },
  hlsearch = false,
  number = true,
  relativenumber = true,
  scrolloff = 5,
  sidescrolloff = 5,
  mouse = 'a',
  clipboard = 'unnamedplus',
  breakindent = true,
  undofile = true,
  ignorecase = true,
  smartcase = true,
  signcolumn = 'yes',
  showtabline = 1,
  splitkeep = 'screen',
  timeout = true,
  ttimeout = true,
  timeoutlen = 350,
  ttimeoutlen = 50,
  termguicolors = true,
  smarttab = true,
  smartindent = false,
  softtabstop = 4,
  shiftwidth = 4,
  expandtab = true,
  showbreak = '> ',
  autoread = true,
  textwidth = 100,
  updatecount = 50,
  updatetime = 200,
  showmatch = true,
  matchtime = 1,
  visualbell = false,
  errorbells = false,
  vimstart = {
    pattern = '*',
    callback = function()
      if vim.fn.expand('%') == '' then
        vim.cmd('e .')
      end
    end,
    desc = 'Open current dir if no file/dir given on startup',
  },
}

local function set_options(opts)
  for name, value in pairs(opts) do
    if type(value) == 'table' then
      vim.g[name] = value
    else
      vim.o[name] = value
    end
  end
  for n, v in pairs(M.netrw) do
    vim.g[('netrw_%s'):format(n)] = v
  end
end

vim.cmd('colo ' .. M.opts.colorscheme)
vim.api.nvim_set_hl(0, 'Cursor', M.opts.cursor)
set_options(M.opts)

local vimstart = {
  pattern = '*',
  callback = function()
    if vim.fn.expand('%') == '' then
      vim.cmd('e .')
    end
  end,
  desc = 'Open current dir if no file/dir given on startup',
}

