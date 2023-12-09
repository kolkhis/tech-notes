

# Formatting Text in Vim / Neovim  

## Keymaps for Formatting  
### Formatting keymaps:  
By default, these will only format based on line length  
if `formatexpr` or `formatprg` aren't set.  

* `gq{motion}`: Format text selected with `{motion}`.  
    * Uses `formatexpr` if it's set.  
    * Uses `formatprg` if it's set.  
    * Otherwise formatting is done internally (using `textwidth`).  
* `gw{motion}`: Like `gq`, but the cursor keeps its position. 
    * Doesn't use `formatexpr`

## Indenting keymaps:  
### Normal/Visual mode:  
* `={motion}`: Filter `{motion}` lines through external program in `equalprg`.  
    * Uses `indentexpr` if set (`:h indent-expression`).  
    * When `equalprg` is empty (default), uses internal formatting 
      function C-indending and `lisp`.  
Search for how to set indenting with `:h [ft-]{language}-indent` (i.e., `:h html-indent`).  
* The `ft-` (filetype) is optional for searching help.  
* For Vimscript: `:h vim-indent`.  

### Insert Mode  
* `CTRL-T`: Indents the current line once using the `shiftwidth` option.  
* `CTRL-D`: Unindents the current line once using the `shiftwidth` option.  



## Easy Formatting  
| Ex Command        | Effect            |
|-------------------|-------------------|
| `:ri`/`:right`    | Right-Align Text  |
| `:ce`/`:center`   | Center-Align Text |
| `:le`/`:left`     | Left-Align Text   |







## C-style Indenting  

These five options control C program indenting:  
* `cindent`: Enables Vim to perform C program indenting automatically.  
* `cinkeys`: Specifies which keys trigger reindenting in insert mode.  
* `cinoptions`: Sets your preferred indent style.  
* `cinwords`: Defines keywords that start an extra indent in the next line.  
* `cinscopedecls`: Defines strings that are recognized as a C++ scope declaration.  

### The cinkeys option  
`:h cinkeys-format` `indentkeys-format`
The `cinkeys` option is a string that controls Vim's indenting in response to  
typing certain characters or commands in certain contexts.  

Default:  

The default is `0{,0},0),0],:,0#,!^F,o,O,e` which specifies that indenting  
occurs as follows:  

| Value  | Meaning |
|--------|---------|
| `0{`  | if you type `{` as the first character in a line      |
| `0}`  | if you type `}` as the first character in a line      |
| `0)`  | if you type `)` as the first character in a line      |
| `0]`  | if you type `]` as the first character in a line      |
| `:`   | if you type `:` after a label or case statement       |
| `0#`  | if you type `#` as the first character in a line      |
| `!^F` | if you type CTRL-F (which is not inserted)            |
| `o`   | if you type a `<CR>` anywhere or use the `o` command (not in insert mode!)  |
| `O`   | if you use the `O` command (not in insert mode!)      |
| `e`   | if you type the second 'e' for an `else` at the start of a line  |

>#### `:h i_CTRL-F`




```vim  
indent({lnum})  
getline({lnum} [, {end}])  
getline(1)  
getline(".")  
line({expr} [, {winid}])  
```



