## Modes
### Getting Current Mode
`vim.api.nvim_get_mode()`: does not return 'v' for visual mode. 
Instead, it returns:
- `'n'` for normal mode
- `'i'` for insert mode  
- `'v'` for visual mode
- `'V'` for visual line mode
- `'<C-V>'` for visual block mode
- `'t'` for terminal mode

### Keymap Modes
- `:h map-table` for all the different modes for keymaps.



## Running Lua From Vimscript
Using `v:lua` as a prefix, you can run lua from vimscript.
- `:h v:lua-call`



## Accessing Vim Variables
Vimscript Variables can be accessed using `vim.<scope>` where `<scope>` is the scope type of the
variable.  
Invalid or unset keys/variables will return nil.  


### Vimscript Variable Scopes

* `vim.g`:                                                                  *vim.g*
    Global (`g:`) editor variables.  
* `vim.b`:                                                                  *vim.b*
    Buffer-scoped (`b:`) variables for the current buffer.  
* `vim.w`:                                                                  *vim.w*
    Window-scoped (`w:`) variables for the current window.  
* `vim.t`:                                                                  *vim.t*
    Tabpage-scoped (`t:`) variables for the current tabpage.  
* `vim.v`:                                                                  *vim.v*
    Access predefined `v:` variables.  


### Predefined Vim Variables
> `:h vim-variable` | `v:var` |` v:`
For full list, see `./vim_variables.md`



## Vimscript Types
* bool
* number
* float
* string
* blob
* list<{type}>
* dict<{type}>
* job
* channel
* func
* func: {type}
* func({type}, ...)
* func({type}, ...): {type}

Not supported yet:
* tuple<a: {type}, b: {type}, ...>


## Terminal Codes and Key Codes

### Replacing Terminal Codes and Keycodes
> *:h nvim_replace_termcodes()*
Using Neovim's lua api, `termcodes` and `keycodes` can be replaced.  
```lua
nvim_replace_termcodes({str}, {from_part}, {do_lt}, {special})
    --[=[-- 
    Replaces terminal codes and |keycodes| (<CR>, <Esc>, ...) in a string with
    the internal representation. 
    --]=]--
```
  
### Translating Keycodes
> *:h vim.keycode()*
It's also possible to 'translate' keycodes.  
```lua
vim.keycode({str})
    --[=[-- 
    Translates keycodes.
    Example:
        local k = vim.keycode
        vim.g.mapleader = k'<bs>'
    --]=]--
```

## RPC / Remote Plugins
### Important Functions
> *:h nvim_set_client_info()*

> *:h nvim_set_current_buf()*
> *:h nvim_set_current_line()*
> *:h nvim_set_current_dir()*
> *:h nvim_set_current_tabpage()*
> *:h nvim_set_current_win()*

## Vim Highlighting and Syntax
### Highlights
> *:h :hi-normal* | *:highlight-normal*
> *:h :highlight* | *:hi*
> *:h :highlight-link* | *:hi-link*
> *:h :highlight-default* | *:hi-default*

### Highlighting Tags
> *:h tag-highlight*

### Syntax
> *:h g:syntax_on*
> *:h :syn-files*
> *:h :syn* | *:syntax*
> *:h :syn-on* | *:syntax-on* | *:syn-enable* | *:syntax-enable*
> *:h :syntax-reset* | *:syn-reset*
#### Adding your own syntax
> *:h :ownsyntax*
> *:h mysyntaxfile*
> *:h mysyntaxfile-add*
> *:h mysyntaxfile-replace*

### Testing Syntax Time When Syntax is Slow
> *:h :syntime*

#### Naming Conventions
> *:h group-name* *{group-name}*

* `Comment`: any comment
* `Constant`: any constant
* `String`:    a string constant: "this is a string"
* `Character`: a character constant: 'c', '\n'
* `Number`:    a number constant: 234, 0xff
* `Boolean`: a boolean constant: TRUE, false
* `Float`:    a floating point constant: 2.3e10

* `Identifier`: any variable name
* `Function`: function name (also: methods for classes)

* `Statement`: any statement
* `Conditional`: if, then, else, endif, switch, etc.
* `Repeat`:    for, do, while, etc.
* `Label`:    case, default, etc.
* `Operator`: "sizeof", "+", "*", etc.
* `Keyword`: any other keyword
* `Exception`: try, catch, throw

* `PreProc`: generic Preprocessor
* `Include`: preprocessor #include
* `Define`:    preprocessor #define
* `Macro`:    same as Define
* `PreCondit`: preprocessor #if, #else, #endif, etc.

* `Type`:    int, long, char, etc.
* `StorageClass`: static, register, volatile, etc.
* `Structure`: struct, union, enum, etc.
* `Typedef`: A typedef

* `Special`: any special symbol
* `SpecialChar`: special character in a constant
* `Tag`:    you can use CTRL-] on this
* `Delimiter`: character that needs attention
* `SpecialComment`: special things inside a comment
* `Debug`:    debugging statements

* `Underlined`: text that stands out, HTML links

* `Ignore`:    left blank, hidden  |hl-Ignore|
* `Error`:    any erroneous construct
* `Todo`:    anything that needs extra attention; mostly the
* ``       keywords TODO FIXME and XXX



