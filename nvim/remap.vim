
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
