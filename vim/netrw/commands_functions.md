
# Vim's Netrw Ex Commands and Functions


## Ex Commands

### Directory Browsing
All of the directory browsing commands can take no arguments,
direcory names, or **patterns** (`netrw-starstar`).  
* `:Explore[!]  / :Ex[!] `: Explore directory of current file  
* `:Hexplore[!] / :Hex[!]`: Horizontal Split & Explore  
* `:Lexplore[!] / :Lex[!]`: Left Explorer Toggle  
* `:Sexplore[!] / :Sex[!]`: Split&Explore current file's directory  
* `:Vexplore[!] / :Vex[!]`: Vertical Split & Explore  
* `:Texplore    / :Tex   `: Tab & Explore  
* `:Rexplore    / :Rex   `: Return to/from Explorer  

Patterns can be:
```bash
:Ex */filepat    # Current direcory.
:Ex **/filepat   # Recursive.
:Ex *//pattern   # Current direcory. Uses vimgrep.
:Ex **//pattern  # Recursive. Uses vimgrep.
```

If a pattern was used on one the above commands, 
these commands become available too:  
* `:Nexplore[!] / :Nex[!]`: Go to the next matching file of the pattern.  
    * Can use `Shift + Up` if supported.
* `:Pexplore[!] / :Pex[!]`: Go to the previous matching file of the pattern.  
    * Can use `Shift + Down` if supported.

The optional bang (`[!]`) can be used to switch which side the netrw
window is opened. By default:  
* `:Lex` will open a netrw window on the Left, `:Lex!` will open it on the right.  
    * This one is used for `<Plug>NetrwShrink`.
* `:Vex` will open a netrw window on the Left, `:Vex!` will open it on the right.  
* `:Sex` will open a netrw window on the top, `:Sex!` will open it on the left.  
* `:Hex` will open a netrw window on the bottom, `:Hex!` will open it on the top.  
#### Not available for `:Texplore` or `:Rexplore`.  



## Functions

Not necessarily a function. It's a `<Plug>` keycode.
```vim
nnoremap <silent> <leader>ns <Plug>NetrwShrink


call netrw_gitignore#Hide()
" Example: Git-ignored files are hidden in Netrw.
let g:netrw_list_hide=netrw_gitignore#Hide()
" Example: Function can take additional files with git-ignore patterns.
let g:netrw_list_hide=netrw_gitignore#Hide('my_gitignore_file')
" Example: Combining 'netrw_gitignore#Hide' with custom patterns.
let g:netrw_list_hide=netrw_gitignore#Hide() . '.*\.swp$'

call emenu File.Exit
```













## Associated Variables

### Browsing
* `g:netrw_keepdir`
* `g:netrw_browse_split`
* `g:netrw_fastbrowse`
* `g:netrw_ftp_browse_reject`
* `g:netrw_ftp_list_cmd`
* `g:netrw_ftp_sizelist_cmd`
* `g:netrw_ftp_timelist_cmd`
* `g:netrw_list_cmd`
* `g:netrw_liststyle`
