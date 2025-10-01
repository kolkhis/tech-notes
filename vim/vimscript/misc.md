# Misc.

"Yank on Hightlight"
```vim
" Highlight on yank:
if v:version >= 801
    " Version needs to be 8.01+ for the TextYankPost 
    aug highlightYankedText
        au!
        au TextYankPost * call YankHighlight()
    aug end

    fu! YankHighlight()
        if v:event['operator'] == 'y'
            if (!exists('g:yanked_text_matches'))
                let g:yanked_text_matches = []
            endif

            let g:yank_match_id = matchadd('IncSearch', ".\\%>'\\[\\_.*\\%<']..")
            let g:yank_window_id = winnr()
            call add(g:yanked_text_matches, [g:yank_match_id, g:yank_window_id])
            call timer_start(100, 'DelYankHighlight')
        endif
    endf

    fu! DelYankHighlight(timer_id)
        while !empty(g:yanked_text_matches)
            let l:match = remove(g:yanked_text_matches, 0)
            let l:match_id = l:match[0]
            let l:window_id = l:match[1]
            try
                call matchdelete(l:match_id, l:window_id)
            endtry
        endwhile
    endf

endif

```


"Cheatsheet"
```vim
" :h builtin
						" *literal-Dict* *#{}*
" To avoid having to put quotes around every key the #{} form can be used.  This
" does require the key to consist only of ASCII letters, digits, '-' and '_'.
" Example: >
	" :let mydict = #{zero: 0, one_key: 1, two-key: 2, 333: 3}
" Note that 333 here is the string "333".  Empty keys are not possible with #{}.

" AUTOCOMPLETE:
" The good stuff is documented in |ins-completion|
" HIGHLIGHTS:
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our path+=** trick!)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option
" NOW WE CAN:
" - Use ^n and ^p to go back and forth in the suggestion list


" SNIPPETS:
" Read an empty HTML template from a file ($HOME/.vim/.skeleton.html) 
" and move cursor to title
nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a



" FILE BROWSING:
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'



" PATTERN:
" ( :h '[ , :h \_. , :h \%<'m )
"
".\\%>'\\[\\_.*\\%<'].."
" Since this is in a string, the backslashes need to be escaped as well.
" . matches any char (current) 
" '[ is the mark that matches the first char of the last changed or yanked text, 
"       but needs to be escaped (`:h /[]`)
"       '] does the same for the last char of the last changed/yanked text.
" \%>'m matches after the position of mark m. ( \%>'\[ )
" the `.` atom doesn't match EOL, so I need `\_.` instead. (`:h \_.`)
" \%<'m matches before the position of mark m. ( \%<'\] )
" two dots are required to include mark '] in the match


" TIMER:
" :h timer_start
" Takes a time in ms, and a callback (function to run after the specified time)

" AUTOCMD_EVENTS:
" :h autocommand-events
" :h autocmd-events-abc
" Vim ignores the case of event names
" (e.g., you can use "BUFread" or "bufread" instead of "BufRead").
" CompleteChanged: 
" After each time the Insert mode completion manu changed.
"                   - not triggered on popup menu hide
" Sets these |v:event| keys:
"     completed_item	See |complete-items|.
"     height		nr of items visible
"     width		screen cells
"     row			top screen row
"     col			leftmost screen column
"     size		total nr of items
"     scrollbar		TRUE if visible


```


remaps
```vim
" Remaps from my nvim config translated to vimscript

nnoremap <silent> <Space> <Nop>
let g:mapleader = ' '
let g:maplocalleader = ' '

nnoremap <silent> zp <C-u>zz
nnoremap <silent> zn <C-d>zz
inoremap <silent> zj <Esc>
nnoremap <silent> <C-u> <C-u>zz
nnoremap <silent> <C-d> <C-d>zz


inoremap <silent> <C-Space> <C-r>*<Esc>i

nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

nnoremap <silent> <leader>fm <Cmd>lua vim.lsp.buf.format({ async = true })<CR>

nnoremap <silent> <leader>sm <Cmd>SM<CR>

nnoremap <silent> <leader>pv <Cmd>Ex<CR>
nnoremap <silent> <leader>pV <Cmd>Sex!<CR>

nnoremap <silent> <leader>Y "+Y
nnoremap <silent> <leader>y "+y
xnoremap <silent> <leader>p "_dP

nnoremap <silent> <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

if has('unix')
  nnoremap <silent> <leader>x <Cmd>!chmod +x %<CR>
endif

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <silent> <leader>yf <Cmd>%y+<CR>

cnoremap <silent> <leader>\ ()\<Left><Left>

augroup MarkdownAug
  autocmd!
  autocmd BufEnter,BufWinEnter *.md nnoremap <silent> ;td :call nvim_put(['* [ ]'], 'c', v:true, v:true)<CR>
augroup END
```

set
```vim
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
```
