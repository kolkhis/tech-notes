
# Vim's Netrw Ex Commands and Functions

## Table of Contents
* [Vim's Netrw Ex Commands and Functions](#vim's-netrw-ex-commands-and-functions) 
* [Netrw Ex Commands](#netrw-ex-commands) 
    * [Netrw Directory Browsing](#netrw-directory-browsing) 
* [Netrw Functions](#netrw-functions) 
* [Netrw-Associated Variables](#netrw-associated-variables) 
    * [Browsing Variables](#browsing-variables) 
    * [Style Variables](#style-variables) 
    * [Other Variables](#other-variables) 

## Netrw Ex Commands

### Netrw Directory Browsing
All of the directory browsing commands can take no arguments,
direcory names, or **patterns** (`netrw-starstar`).  
```vim
:Explore[!]  / :Ex[!]  " Explore directory of current file  
:Hexplore[!] / :Hex[!] " Horizontal Split & Explore  
:Lexplore[!] / :Lex[!] " Left Explorer Toggle  
:Sexplore[!] / :Sex[!] " Split&Explore current file's directory  
:Vexplore[!] / :Vex[!] " Vertical Split & Explore  
:Texplore    / :Tex    " Tab & Explore  
:Rexplore    / :Rex    " Return to/from Explorer  
```

Patterns can be:
```bash
:Ex */filepat    # Current direcory.
:Ex **/filepat   # Recursive from current direcory.
:Ex *//pattern   # Current direcory. Uses vimgrep.
:Ex **//pattern  # Recursive. Uses vimgrep.
```

Using a pattern will add all matches to the **Argument List**.  
If there are files in the **Argument List**, these commands become available too:  
* `:Nexplore[!] / :Nex[!]`: Go to the next file in argument list.  
    * Can use `Shift + Up` if supported.
* `:Pexplore[!] / :Pex[!]`: Go to the previous file in argument list.  
    * Can use `Shift + Down` if supported.

The optional bang (`[!]`) can be used to switch which side the netrw
window is opened. 
**Note**: Using a bang `!` is not available for `:Texplore` or `:Rexplore`.  
By default:  

| Command  | Side
|-|-
|  `:Sex`  |   Top      
|  `:Hex!` |   Top      
|  `:Hex`  |   Bottom      
|  `:Sex!` |   Left      
|  `:Vex`  |   Left      
|  `:Lex`  |   Left      
|  `:Vex!` |   Right      
|  `:Lex!` |   Right(1)      
|  `:Tex`  |   New Tab    
|  `:Rex`  |   Return to/from Explorer(2)      
1. `:Lex!` is used for `<Plug>NetrwShrink`.  
2. `:Rex` can be used when using `:Ex` (full-window netrw)

## Netrw Functions

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













## Netrw-Associated Variables
Variables associated with Netrw.  
The behavior of Netrw can be changed by modifying these variables.  

### Browsing Variables
* `g:netrw_keepdir`
* `g:netrw_browse_split`
* `g:netrw_fastbrowse`
* `g:netrw_ftp_browse_reject`
* `g:netrw_ftp_list_cmd`
* `g:netrw_ftp_sizelist_cmd`
* `g:netrw_ftp_timelist_cmd`
* `g:netrw_list_cmd`
* `g:netrw_liststyle`


### Style Variables

* `g:netrw_menu` 
    * `0` = disable netrw's menu
    * `1` = (default) netrw's menu enabled

* `g:netrw_bufsettings`
    * The settings that netrw buffers have 
    * Default: `noma nomod nonu nowrap ro nobl`

* `g:netrw_preview`   
    * `0` = (default) preview window shown in a horizontally split window
    * `1` = preview window shown in a vertically split window.

* `g:netrw_chgwin`
    * Specifies a window number where subsequent file edits will take place.  



### Other Variables

* `g:Netrw_UserMaps` 
    * Specifies a function or `List` of functions which can be used to set
      up user-specified maps and functionality.

