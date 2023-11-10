vim.cmd('colo material-deep-ocean')

vim.api.nvim_set_hl(0, 'Cursor', { fg = 'White', bg = 'Red' })

let g:netrw_banner = 0
let g:netrw_alto = 0
let g:netrw_altv = 1
let g:netrw_preview = 1 " open previews in vsplit

" Fix dumb python indenting
let g:python_indent = {
    \ 'open_paren': 4,
    \ 'nested_paren': 4,
    \ 'continue': 4,
    \ 'closed_paren_align_last_line': 0
\ }

" Modify path for better find/completion
set path+=**

" Stop persistent highlight after search
set nohlsearch

" Set line numbers
set number
set relativenumber

" Keep 5 lines before the cursor when scrolling  
set scrolloff=5
set sidescrolloff=5

" Enable mouse mode
set mouse=a

" Sync clipboard between os and nvim.
set clipboard=unnamedplus

" Enable break indent (linewrap indent)
set breakindent

" Save undo history
set undofile

" Case insensitive searching UNLESS /C or capital in search
set ignorecase
set smartcase

" Keep signcolumn on by default
set signcolumn=yes

" Timeout for hotkeys
set timeout 
set timeoutlen=350

" Set completeopt to have a better completion experience
set completeopt=menuone,noselect

" Enable 24-bit RGB
set termguicolors

" Indentation
set smarttab " Smart tabbing
set nosmartindent " Smart indenting (for C-like programs?)
" set tabstop=4

set softtabstop=4
set shiftwidth=4 " Set Tab to 4 spaces. 
set expandtab

set showbreak=> " Show a > when lines wrap
set autoread " Automatically reload file when it was changed elsewhere.
set textwidth=100 " cuz PEP8 lol
" set wrapmargin=-1000 " Attempt to make python format correctly with `gq`

" Autosaving
set updatecount=50
set updatetime=200 

" Matching paren QOL
set showmatch
set matchtime=1


" [[ Highlight on yank ]]
" See `:help vim.highlight.on_yank()`
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * call s:highlight_on_yank()
augroup END

function! s:highlight_on_yank()
  highlight YankHighlight cterm=reverse gui=reverse
  exec 'match YankHighlight /\%'.line('.').'l\%'.col('.').'c\_.\{-}/'
  call timer_start(200, {-> execute('', 'match')})
endfunction
