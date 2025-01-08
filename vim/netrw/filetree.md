# Using Netrw as a File Tree

A lot of people like to have file trees inside their text editors.  

Netrw is capable of doing this.  

## Table of Contents
* [List Styles](#list-styles) 
* [Toggling a File Tree on the Side](#toggling-a-file-tree-on-the-side) 

## List Styles

The variable `g:netrw_liststyle` is responsible for determining how netrw displays files.
You can change this on the fly inside netrw by pressing `i`, which cycles through the different file list styles.  
The tree view is `g:netrw_liststyle = 3`.  

```vim
" vimscript
let g:netrw_liststyle=3
```
This shows the files in a tree view.  
You can also hide the banner using the `g:netrw_banner` variable.

```vim
let g:netrw_banner=0
```

Now it looks exactly like file trees that are shown in a lot of other text editors.

## Toggling Netrw as a File Tree on the Side

Many people like having their file trees open in their buffers while editing text.  
You can simply use the Ex command `:Lex` to open it up.  
```vim
:Lex
```

Netrw ships with a `NetrwShrink` function.  
This is a function that will toggle a `:Lex` instance, either minimizing or
maximizing it.  

You can map this to a keybinding:
```vim
" Minimize/Maximize a :Lex netrw instance
nnoremap  <leader>ns <Plug>NetrwShrink
```
* Note the `<Plug>` - this is needed because netrw is technically a plugin.  





