
# Neovim's Lua API  
Always either `vim.print()` or `vim.inspect()` tables.  

## Table of Contents
* [Getting the current line or a range of lines](#getting-the-current-line-or-a-range-of-lines) 
    * [Getting the current line](#getting-the-current-line) 
        * [Using the Nvim API](#using-the-nvim-api) 
        * [Using Vimscript functions](#using-vimscript-functions) 
    * [Getting a range of lines](#getting-a-range-of-lines) 
    * [Getting lines of the visual selection](#getting-lines-of-the-visual-selection) 
* [Loop over lines of visual selection](#loop-over-lines-of-visual-selection) 
* [Using a String as a Table Key](#using-a-string-as-a-table-key) 
* [Running Lua From Vimscript](#running-lua-from-vimscript) 
                * [*:h v:lua-call*](#*h-vlua-call*) 
* [Setting Vim Options from Lua](#setting-vim-options-from-lua) 
            * [*:h vim.o* | *vim.opt*](#*h-vim.o*-|-*vim.opt*) 
    * [Lua Equivalents to Setting Options in Vimscript](#lua-equivalents-to-setting-options-in-vimscript) 
* [Option Objects](#option-objects) 
    * [Option Object Methods](#option-object-methods) 
* [Tab Completion Keymap](#tab-completion-keymap) 
* [Modes](#modes) 
    * [Getting Current Mode](#getting-current-mode) 
* [Getting the Mode Using Vimscript](#getting-the-mode-using-vimscript) 
    * [Keymap Modes](#keymap-modes) 
* [Get a List of Global Keymaps](#get-a-list-of-global-keymaps) 
    * [Get List of Marks](#get-list-of-marks) 
* [Ringbuffer: Self-Updating Fixed Size List](#ringbuffer-self-updating-fixed-size-list) 
    * [Ringbuffer Methods](#ringbuffer-methods) 
* [Getting Iterators for Loops](#getting-iterators-for-loops) 
    * [Iterators from Tables (Lists or Dicts)](#iterators-from-tables-(lists-or-dicts)) 
    * [Using `vim.spairs({table})`](#using-vim.spairs(table)) 
    * [Using Lua](#using-lua) 
    * [Creating an `Iter` Object](#creating-an-iter-object) 
    * [Useful Iter Methods](#useful-iter-methods) 
* [User Defined Ex Commands](#user-defined-ex-commands) 
    * [Allowing Arguments for User-Defined Ex-Commands](#allowing-arguments-for-user-defined-ex-commands) 
        * [Argument Completion for User-Defined Ex Commands](#argument-completion-for-user-defined-ex-commands) 
* [Digraphs](#digraphs) 
* [Accessing Vim Variables](#accessing-vim-variables) 
    * [Vimscript Variable Scopes](#vimscript-variable-scopes) 
    * [Predefined Vim Variables](#predefined-vim-variables) 
* [Vimscript Types](#vimscript-types) 
    * [Useful Vim API Functions](#useful-vim-api-functions) 
    * [RPC Only](#rpc-only) 
* [+cmd - Running Commands on Files when Opening](#+cmd---running-commands-on-files-when-opening) 
* [Terminal Codes and Key Codes](#terminal-codes-and-key-codes) 
    * [Replacing Terminal Codes and Keycodes](#replacing-terminal-codes-and-keycodes) 
    * [Translating Keycodes](#translating-keycodes) 
* [RPC / Remote Plugins](#rpc-/-remote-plugins) 
    * [Important Functions](#important-functions) 
* [API for Buffers and Windows (UI)](#api-for-buffers-and-windows-(ui)) 
* [Terminal Instances from nvim](#terminal-instances-from-nvim) 
* [Vim Highlighting and Syntax](#vim-highlighting-and-syntax) 
    * [Highlights](#highlights) 
    * [Namespace Highlighting](#namespace-highlighting) 
    * [Highlighting Tags](#highlighting-tags) 
    * [Syntax](#syntax) 
        * [Adding your own syntax](#adding-your-own-syntax) 
    * [Testing Syntax Time When Syntax is Slow](#testing-syntax-time-when-syntax-is-slow) 
    * [Highlighting Naming Conventions & Default Highlight Groups](#highlighting-naming-conventions-&-default-highlight-groups) 


## Getting the current line or a range of lines  
### Getting the current line  
To get the current line, use any of the following functions.  

#### Using the Nvim API  
The simplest method using the Nvim API:  
* `vim.api.nvim_get_current_line()`
```lua  
local line = vim.api.nvim_get_current_line()  
```
  
#### Using Vimscript functions  
The simplest method using a Vimscript function:  
* A Vimscript function, `vim.fn.getline()`:  
```lua  
local line = vim.fn.getline('.')  
```
  
Less simple Vimscript methods:  
* To get only a single line, `vim.fn.getbufoneline(bufnr, linenr)`
```lua  
local line = vim.fn.getbufoneline(vim.fn.bufnr('%'), linenr)  
```

Both of those methods return the line the cursor is currently on.  

### Getting a range of lines  
To get a range of lines, use:  
* `vim.api.nvim_buf_get_lines(buf, start, end, strict_indexing)`:  
    * This function uses zero-based indexing for line numbers.  
        * i.e., line number `0` is the first line.  
    * The `end` is non-inclusive.  
    * Pass `0` to `buf` to use the current buffer.  

```lua  
--- Get the first 10 lines of the current buffer  
local first_ten_lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)  
 
--- Get everything from line 10 to the end of the buffer  
local lines_from_10_to_end = vim.api.nvim_buf_get_lines(0, 10, -1, false)  
 
-- Get the current line and the line after  
local line_no = vim.fn.line('.')  
local line = vim.api.nvim_buf_get_lines(0, line_no - 1, line_no + 1, true)  
```

Alternatively, you can use a Vimscript function:  
* `vim.fn.getbufline(buf, start, end)`
    * This is similar to `vim.api.nvim_buf_get_lines()`, but uses 1-based indexing  
      for line numbers.  
        * i.e., line number `1` is the first line.  
    * It returns a table of lines, based on the given line number, in  
      the given buffer (`%` for current buffer).  
    * To get the current buffer number, use `vim.fn.bufnr('%')`

```lua  
-- Get the current line  
local line_no = vim.fn.line('.')  
local line = vim.fn.getbufline(vim.fn.bufnr('%'), line_no)[1]  
-- or  
local line = vim.fn.getbufline('%', line_no)[1]  
 
-- Get the current line and the line after  
local lines = vim.fn.getbufline('%', line_no, line_no + 1)  
 
-- Get the first 10 lines of the current buffer  
local first_ten_lines = vim.fn.getbufline(0, 0, 10)  
```


### Getting lines of the visual selection  
First, get the line numbers of the visual selection:  
```lua  
local ln_start = unpack(vim.api.nvim_buf_get_mark(0, '<'))  
local ln_end = unpack(vim.api.nvim_buf_get_mark(0, '>'))  
-- or  
local ln_start, ln_end = vim.fn.line("'<"), vim.fn.line("'>")  
```
Then, use `vim.api.nvim_buf_get_lines()` to get the lines:  
```lua  
local lines = vim.api.nvim_buf_get_lines(0, ln_start - 1, ln_end, false)  
```

## Loop over lines of visual selection  
This function will loop over the lines of the visual selection, and  
save them into a table:  

```lua  
function M:loop_selection()  
    local ln_start, ln_end = vim.fn.line("'<"), vim.fn.line("'>")  
    S = {}
    for i = ln_start, ln_end do  
        S[i] = vim.fn.getline(i)  
    end  
end  
```

## Using a String as a Table Key 
Table keys will automatically be accessible as strings.  
```lua  
myTable = { key = "value" }
print(myTable['key'])  
-- value  
```
But if you *need* a key that has some special characters in it,
you can enclose it in square brackets `[ ]`.  
```lua  
myTable = { ['<C-k>'] = "Value" }
print(myTable['<C-k>'])  
-- Value  
```
This is useful for when some part of the nvim API returns funky stuff.  



## Running Lua From Vimscript  
###### *:h v:lua-call*  
Using `v:lua` as a prefix, you can run lua from vimscript.  
E.g.,
```vim  
:echo v:lua.vim.api.nvim_get_mode().mode  
```



## Setting Vim Options from Lua  
##### *:h vim.o* | *vim.opt*  
Generally you'll use `vim.o.*` or `vim.opt.*` to access vim options.  
```lua  
vim.o.number = true  
--or 
vim.opt.number = true  
```

---  

The following methods of setting a map-style option are equivalent:  
Vimscript:  
```vim  
set listchars=space:_,tab:>~  
```
Lua:  
```lua  
vim.o.listchars = 'space:_,tab:>~'  
-- or  
vim.opt.listchars = { space = '_', tab = '>~' }
```

---  

### Lua Equivalents to Setting Options in Vimscript  
To replicate the behavior of `:set+=`:  

```bash  
vim.opt.wildignore:append { `*.pyc`, `node_modules` }
```

To replicate the behavior of `:set^=`:  
```lua  
vim.opt.wildignore:prepend { "new_first_value" }
```

To replicate the behavior of `:set-=`:  
```lua  
vim.opt.wildignore:remove { "node_modules" }
```

The following methods of setting a map-style option are equivalent:  
In Vimscript:  
```vim  
set listchars=space:_,tab:~  
```

In Lua using `vim.o`:  
```lua  
vim.o.listchars = 'space:_,tab:~'  
```

In Lua using `vim.opt`: lua  
```lua  
vim.opt.listchars = { space = '_', tab = '~' }
```




## Option Objects  
`vim.opt` returns an `Option` object, not the value of the option.  
The values are accessed through `vim.opt:get()` (see [Option Object Methods](#option-object-methods)):  
```lua  
vim.print(vim.opt.wildignore:get())  
-- These are equivalent:  
vim.opt.formatoptions:append('j')  
vim.opt.formatoptions = vim.opt.formatoptions + 'j'  
```

Options that are strings that can be added to or subtracted to using  
normal vimscript operators (such as `set shortmess+=c`) need to be called  
with `vim.opt` to manipulate the `Option` object.  

To replicate the behavior of `:set+=`, use:  
```lua  
vim.opt.wildignore:append({ "*.pyc", "node_modules" })  
```
To replicate the behavior of `:set^=`, use:  
```lua  
vim.opt.wildignore:prepend({ "new_first_value" })  
```
To replicate the behavior of `:set-=`, use:  
```lua  
vim.opt.wildignore:remove({ "node_modules" })  
```

### Option Object Methods  

The `Option` object methods:  
* `vim.opt.option_name:get()`
    * Returns a lua representation (a table) of the object's values.  
    * E.g., `:lua vim.print(vim.opt.listchars:get())` will print the values of `listchars`.  
* `vim.opt.option_name:remove(value)`
    * Removes (deletes) a value from the option (`:set-=`)  
* `vim.opt.option_name:append(value)`
    * Appends (inserts at the end) a value to the option (`:set+=`)  
    * These are equivalent:  
      ```lua  
      vim.opt.formatoptions:append('j')  
      vim.opt.formatoptions = vim.opt.formatoptions + 'j'  
      ```
* `vim.opt.option_name:prepend(value)`
    * Prepends (inserts at the beginning) a value to the option (`:set^=`)  
    * These are equivalent:  
      ```lua  
      vim.opt.wildignore:prepend('*.o')  
      vim.opt.wildignore = vim.opt.wildignore ^ '*.o'  
      ```




## Tab Completion Keymap  
This is already handled by nvim-cmp (must be remapped from `<Enter>`), but this is neat to know:  
```lua  
vim.keymap.set('i', '<Tab>', function()  
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"  
end, { expr = true })  
```



## Modes  
### Getting Current Mode  
`vim.api.nvim_get_mode()`: does not return 'v' for visual mode. 
It returns a table, with the keys `['blocking']` and `['mode']`.  
* `vim.api.nvim_get_mode().blocking`:  
    * `true` if Nvim is waiting for input, otherwise `false`.  
To get the mode: 
```lua  
vim.api.nvim_get_mode().mode 
-- or 
vim.api.nvim_get_mode()['mode']  
```
It returns:  
* `'i'` for Insert mode  
* `'n'` for Normal mode  
* `'v'` for Visual mode  
* `'V'` for Visual Line mode 
* `'<C-V>'` for visual block mode  
* `'t'` for terminal mode  
* `'s'` for Select mode  
* `'S'` for Select Line mode  
* `'ic'` for Insert mode completion  
* `'R'` for Replace mode  
* `'Rv'` for Virtual Replace mode  
* `'c'` for Command-line mode  
* `'cv'` for Vim Ex mode  
* `'ce'` for Normal Ex mode  
* `'r'` for Prompt mode  
* `'rm'` for More prompt mode  
* `'r?'` for Confirm prompt mode  


`vim.api.nvim_get_mode().mode` return values in a table:  
| Mode | Return Value |
|-|-|  
| Insert mode | `'i'` |
| Normal mode | `'n'` |
| Visual mode | `'v'` |
| Visual Line mode | `'V'` |
| Visual Block mode | `['<C-V>']` |
| Terminal mode | `'t'` |
| Select mode | `'s'` |
| Select Line mode | `'S'` |
| Insert mode completion | `'ic'` |
| Replace mode | `'R'` |
| Virtual Replace mode | `'Rv'` |
| Command-line mode | `'c'` |
| Vim Ex mode | `'cv'` |
| Normal Ex mode | `'ce'` |
| Prompt mode | `'r'` |
| More prompt mode | `'rm'` |
| Confirm prompt mode | `['r?']` |


Here's some lua that will get the current mode:  
```lua  
local modes = {
    ['i'] = 'Insert mode',
    ['n'] = 'Normal mode',
    ['v'] = 'Visual mode',
    ['V'] = 'Visual Line mode',
    ['<C-V>'] = 'Visual Block mode',
    ['t'] = 'Terminal mode',
    ['s'] = 'Select mode',
    ['S'] = 'Select Line mode',
    ['ic'] = 'Insert mode completion',
    ['R'] = 'Replace mode',
    ['Rv'] = 'Virtual Replace mode',
    ['c'] = 'Command-line mode',
    ['cv'] = 'Vim Ex mode',
    ['ce'] = 'Normal Ex mode',
    ['r'] = 'Prompt mode',
    ['rm'] = 'More prompt mode',
    ['r?'] = 'Confirm prompt mode',
}
vim.keymap.set('', )  
```

## Getting the Mode Using Vimscript  
The `mode()` function will return the current mode.  

| Mode | Return Value |
|-|-|  
| `'n'`         | Normal  
| `'no'`        | Operator-pending  
| `'nov'`       | Operator-pending (forced charwise `o_v`)  
| `'noV'`       | Operator-pending (forced linewise `o_V`)  
| `'noCTRL-V'`  | Operator-pending (forced blockwise `o_CTRL-V` - `CTRL-V` is one character)  
| `'niI'`       | Normal using `i_CTRL-O` in `Insert-mode`
| `'niR'`       | Normal using `i_CTRL-O` in `Replace-mode`
| `'niV'`       | Normal using `i_CTRL-O` in `Virtual-Replace-mode`
| `'nt'`        | Normal in `terminal-emulator` (insert goes to Terminal mode)  
| `'ntT'`       | Normal using `t_CTRL-\_CTRL-O` in `Terminal-mode`
| `'v'`         | Visual by character  
| `'vs'`        | Visual by character using `v_CTRL-O` in Select mode  
| `'V'`         | Visual by line  
| `'Vs'`        | Visual by line using `v_CTRL-O` in Select mode  
| `'CTRL-V'`    | Visual blockwise  
| `'CTRL-Vs'`   | Visual blockwise using `v_CTRL-O` in Select mode  
| `'s'`         | Select by character  
| `'S'`         | Select by line  
| `'CTRL-S'`    | Select blockwise  
| `'i'`         | Insert  
| `'ic'`        | Insert mode completion `compl-generic`
| `'ix'`        | Insert mode `i_CTRL-X` completion  
| `'R'`         | Replace `R`
| `'Rc'`        | Replace mode completion `compl-generic`
| `'Rx'`        | Replace mode `i_CTRL-X` completion  
| `'Rv'`        | Virtual Replace `gR`
| `'Rvc'`       | Virtual Replace mode completion `compl-generic`
| `'Rvx'`       | Virtual Replace mode `i_CTRL-X` completion  
| `'c'`         | Command-line editing  
| `'cr'`        | Command-line editing overstrike mode `c_<Insert>`
| `'cv'`        | Vim Ex mode `gQ`
| `'cvr'`       | Vim Ex mode while in overstrike mode `c_<Insert>`
| `'r'`         | Hit-enter prompt  
| `'rm'`        | The -- more -- prompt  
| `'r?'`        | A `:confirm` query of some sort  
| `'!'`         | Shell or external command is executing  
| `'t'`         | Terminal mode: keys go to the job  




### Keymap Modes  
- `:h map-table` for all the different modes for keymaps.  
See `../keybind_cheatsheet.md`.  


## Get a List of Global Keymaps  
Get a list of all the global keymaps for a given mode:  
```lua  
local maps = nvim_get_keymap({'n'})  
print(vim.inspect(vim.api.nvim_get_keymap('n')))  
-- Or  
vim.print(vim.api.nvim_get_keymap('n'))  
```

Or, to get a list of *all* keymaps for all modes:  
 
```lua  
print(vim.inspect(vim.api.nvim_get_keymap('')))  
-- Or  
vim.print(vim.api.nvim_get_keymap(''))  
```


### Get List of Marks  
```vim  
getmarklist([{buf}])  
```
This function returns **Global Marks** by default, unless provided with a buffer number(or name?)  
```vim  
local buf = bufname()  
```

---  

## Ringbuffer: Self-Updating Fixed Size List  
*:h vim.ringbuf()*  
Creates a ring buffer limited to a max number of items.  
```lua  
local rb = vim.ringbuf({3})  
rb:push(1)  
rb:push(2)  
rb:push(3)  
rb:push(4) -- replaces 1  
print(rb:pop())  -- prints 2
print(rb:pop())  -- prints 3
-- Can be used as iterator. Pops remaining items:  
for val in rb do  
  print(val)  
end  
```
When the limit is reached, the newest items will replace the 
oldest items. Calling `Ringbuf:pop()` will return the oldest item in  
the ring buffer.  

### Ringbuffer Methods  
`vim.ringbuf({n})` Returns a Ringbuf instance with the following methods:  
| Method            |   Effect                                                          |
|-------------------|------------------------------------------------------------------ |
| `Ringbuf:push()`  | Adds an item, overriding the oldest item if the buffer is full.   |
| `Ringbuf:pop()`   | Removes and returns the first unread item                         |
| `Ringbuf:peek()`  | Returns the first unread item without removing it                 |
| `Ringbuf:clear()` | Clear all items                                                   |

---  

## Getting Iterators for Loops  
### Iterators from Tables (Lists or Dicts)  
*:h vim.spairs()*  

### Using `vim.spairs({table})`
Enumerate a dict-like table (key:value pairs), sorted by key.  

### Using Lua  
* Use `ipairs(table)` on a list-like table to enumerate (idx, val).  
* Use `pairs(table)` on a dict-like table to iterate k:v pairs (key, val).  

### Creating an `Iter` Object  
*:h vim.iter*  
`vim.iter` is an interface for iterables.  
It wraps a table or function argument into an `Iter` object that has methods.  
```lua  
-- Run each item through a function  
local it = vim.iter({ 1, 2, 3, 4, 5 })  
it:map(function(v)  
          return v * 3
        end)  
it:rev()  
it:skip(2)  -- Skip the first 2 items  
it:totable()  
-- { 9, 6, 3 }

-- Check if an item exists in the Iter  
vim.iter({ a = 1, b = 2, c = 3, z = 26 }):any(function(k, v)  
  return k == 'z'  
end)  
-- true  
```
`Iter` functions can also be applied to `Ringbuf` objects after  
casting the `Ringbuf` as an `Iter` (`vim.iter(ringbuf)`).  
```lua  
local rb = vim.ringbuf(3)  
rb:push("a")  
rb:push("b")  
vim.iter(rb):totable()  
-- { "a", "b" }
```

### Useful Iter Methods  
* `Iter:each({f})`: Call a function once for each item in the pipeline. 
                    This is used for functions which have side effects. Use `map` to modify the  
                    values in the iterator.  
* `Iter:map({f})`: Add a map step to the iterator pipeline.  
* `Iter:filter({f})`: Add a filter step to the iterator pipeline.  
    ```lua  
    local bufs = vim.iter(vim.api.nvim_list_bufs()):filter(vim.api.nvim_buf_is_loaded)  
    ```
* `Iter:next()`: Return the next value from the iterator.  
* `Iter:peek()`: Peek at the next value in the iterator without consuming it.  
* `Iter:skip({n})`: Skip values in the iterator.  


---  


## User Defined Ex Commands  
By default, you'll error out if you try to provide arguments to a  
user-defined command. You can allow arguments by adding the `-nargs=` argument  
when defining the command.  
```vim  
:command -nargs=1 Error echoerr <args>  
```
### Allowing Arguments for User-Defined Ex-Commands  
There are some special characters allowed in this argument:  
* `-nargs=0`: No arguments are allowed (the default)  
* `-nargs=1`: Exactly one argument is required, it includes spaces  
* `-nargs=*`: Any number of arguments are allowed (0, 1, or many), separated by white space  
* `-nargs=?`: 0 or 1 arguments are allowed  
* `-nargs=+`: Arguments must be supplied, but any number are allowed  

#### Argument Completion for User-Defined Ex Commands  
Argument completion can be enabled when `-nargs` is not set to zero.  
* `-complete=arglist`: file names in argument list  
* `-complete=augroup`: autocmd groups  
* `-complete=buffer`: buffer names  
* `-complete=behave`: :behave suboptions  
* `-complete=color`: color schemes  
* `-complete=command`: Ex command (and arguments)  
* `-complete=compiler`: compilers  
* `-complete=dir`: directory names  
* `-complete=environment`: environment variable names  
* `-complete=event`: autocommand events  
* `-complete=expression`: Vim expression  
* `-complete=file`: file and directory names  
* `-complete=file_in_path`: file and directory names in `'path'`
* `-complete=filetype`: filetype names `'filetype'`
* `-complete=function`: function name  
* `-complete=help`: help subjects  
* `-complete=highlight`: highlight groups  
* `-complete=history`: :history suboptions  
* `-complete=locale`: locale names (as output of locale -a)  
* `-complete=lua`: Lua expression `:lua`
* `-complete=mapclear`: buffer argument  
* `-complete=mapping`: mapping name  
* `-complete=menu`: menus  
* `-complete=messages`: `:messages` suboptions  
* `-complete=option`: options  
* `-complete=packadd`: optional package |pack-add| names  
* `-complete=shellcmd`: Shell command  
* `-complete=sign`: `:sign` suboptions  
* `-complete=syntax`: syntax file names `'syntax'`
* `-complete=syntime`: `:syntime` suboptions  
* `-complete=tag`: tags  
* `-complete=tag_listfiles`: tags, file names are shown when CTRL-D is hit  
* `-complete=user`: user names  
* `-complete=var`: user variables  
* `-complete=custom,{func}`: custom completion, defined via {func}
* `-complete=customlist,{func}`: custom completion, defined via {func}
If you specify completion while there is nothing to complete (-nargs=0, the  
default) then you get error *E1208* .  



## Digraphs  
* `:h dig` | `digraphs`  
  
Digraphs are special characters that can be inserted (while in insert mode) with `<C-k>xx` where  
`xx` is a key combination for a given `digraph`.  


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

### Useful Vim API Functions  
* `vim.fs.normalize({path}, {opts})`: Normalize a path to a standard format. Expands `~` to home and  
  converts backslash (\) to forward slashes (/). Environment variables are also expanded.  
* `vim.fs.find({names}, {opts})`: Find files or directories (or other items as specified by `opts.type`) in the given path.  
* `vim.is_callable({f})`: Returns true if object `f` can be called as a function.  
* `vim.tbl_count({t})`: Counts the number of non-nil values in table `t`. 
* `vim.tbl_isempty({t})`: Checks if a table is empty.  
* `vim.trim({s})`: Trim whitespace (Lua pattern "%s") from both sides of a string.  

Open buffers, tabs, windows, etc.:  
* `nvim_list_bufs()`: Gets the current list of buffer handles.  
* `nvim_list_tabpages()`: Gets the current list of tabpage handles.  
* `nvim_list_wins()`: Gets the current list of window handles.  
* `nvim_set_current_buf({buffer})`: Sets the current buffer.  
* `nvim_set_current_line({line})`: Sets the current line.  
* `nvim_set_current_tabpage({tabpage})`: Sets the current tabpage.  
* `nvim_set_current_win({window})`: Sets the current window.  
* `nvim_set_current_dir({dir})`: Changes the global working directory.  

Variables  
* `nvim_set_var({name}, {value})`: Sets a global (g:) variable.  
* `nvim_set_vvar({name}, {value})`: Sets a v: variable, if it is not readonly.  

Calculating what's on screen  
* `nvim_strwidth({text})`: Calculates the number of display cells occupied by `text`.  


### RPC Only:  
* `nvim_subscribe({event})`: Subscribes to event broadcasts.  
* `nvim_unsubscribe({event})`: Unsubscribes to event broadcasts.  
* `nvim_buf_detach({buffer})`: Deactivates buffer-update events on the channel.  
* `nvim_ui_attach({width}, {height}, {options})`: Activates UI events on the channel.  
* `nvim_ui_detach()`: Deactivates UI events on the channel.  
    * Not labelled RPC only, but related:  
    * `nvim_list_uis()`: Gets a list of dictionaries representing attached UIs.  
* `nvim_ui_term_event({event}, {value})`: Tells Nvim when a terminal event has occurred  
* `nvim_ui_set_focus({gained})`: Tells the nvim server if focus was gained or lost by the GUI.  
* `nvim_set_client_info({name}, {version}, {type}, {methods}, {attributes})`
    * Self-identifies the client.  



* `nvim_notify({msg}, {log_level}, {opts})`: Notify the user with a message.  


* `nvim_put({lines}, {type}, {after}, {follow})`: Puts text at cursor, in any mode.  
    * Compare `:put` and `p` which are always linewise.  
* `nvim_paste({data}, {crlf}, {phase})`: Pastes at cursor, in any mode.  
    * Invokes the `vim.paste` handler, which handles each mode appropriately.  
    * Sets redo/undo. Faster than `nvim_input()`.  
* `nvim_open_term({buffer}, {*opts})`: Open a terminal instance in a buffer  
* `nvim_out_write({str})`: Writes a message to the Vim output buffer.  
* `nvim_load_context({dict})`: Sets the current editor state from the given |context| map.  


For possible Python plugins:  
* `nvim_list_chans()`: Get information about all open channels. `:h channel`

* `vim.validate({opt})`: Validates a parameter specification (types and values).  
    ```lua  
    function user.new(name, age, hobbies)  
        -- Check types  
        vim.validate({
            name={name, 'string'},
                age={age, 'number'},
                hobbies={hobbies, 'table'},
        })  
    end  
    -- Checking values AND types  
    vim.validate({arg1={{'foo'}, 'table'}, arg2={'foo', 'string'}})  
       --> NOP (success)  
    vim.validate({arg1={1, 'table'}})  
       --> error('arg1: expected table, got number')  
    vim.validate({arg1={3, function(a) return (a % 2) == 0 end, 'even number'}})  
       --> error('arg1: expected even number, got 3')  

    -- Multiple types can be given as a list. (Success if the type is in the list given)  
        vim.validate({arg1={{'foo'}, {'table', 'string'}}, arg2={'foo', {'table', 'string'}}})  
        -- NOP (success)  
        vim.validate({arg1={1, {'string', 'table'}}})  
        -- error('arg1: expected string|table, got number')  
    ```


## +cmd - Running Commands on Files when Opening 
A lot of Ex commands accept `+cmd`, i.e., a command to be run on the file.  

The `[+cmd]` argument can be used to position the cursor in the newly opened  
file, or execute any other command:  
| Command     |  What it Does  
|-------------|--------------  
| `+`         | Start at the last line.  
| `+{num}`    | Start at line `{num}`.  
| `+/{pat}`   | Start at first line containing `{pat}`.  
| `+{command}`| Execute `{command}` after opening the new file.  

`{command}` is any Ex command.  

To include a white space in the `{pat}` or `{command}`, precede it with a  
backslash.  Double the number of backslashes.  
```vim  
:edit  +/The\ book           file  
:edit  +/dir\ dirname\\      file  
:edit  +set\ dir=c:\\\\temp  file  
```
Note that in the last example the number of backslashes is halved twice: Once  
for the `+cmd` argument and once for the `:set` command.  


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

> *:h nvim_list_chans()*  

## API for Buffers and Windows (UI)  
> *:h api-ui*  
> *:h api-window*  
> *:h api-win_config*  

## Terminal Instances from nvim  
> *:h nvim_open_term()*  


## Vim Highlighting and Syntax  
Plugin to check out: [colorbuddy.nvim](https://github.com/tjdevries/colorbuddy.nvim)  
Colorbuddy is only for Neovim.  

### Highlights  
> *:h :hi-normal* | *:highlight-normal*  
> *:h :highlight* | *:hi*  
> *:h :highlight-link* | *:hi-link*  
> *:h :highlight-default* | *:hi-default*  


### Namespace Highlighting  
Get or create a namespace used for buffer highlights and 
virtual text with `nvim_create_namespace()`.   
* Returns a Namespace ID  

To get existing, non-anonymous namespaces `nvim_get_namespaces()`  
* Returns a Dictionary that maps from Names to Namespace IDs.  

This namespace can then be used to add highlights or `extmarks`.  

Get the active highlight namespace with `nvim_get_hl_ns()`.  
* Returns Namespace ID, or -1  
* Returns -1 when `nvim_win_set_hl_ns()` hasn't been 
  called for the window (or was called with a namespace of -1).  

Extmarks are often used with namespace highlights.  

Related to namespace highlighting:  
* `nvim_buf_add_highlight()` and `nvim_buf_set_extmark()`.  


### Highlighting Tags  
> *:h tag-highlight*  

### Syntax  
> *:h syntax-functions*  
> *:h g:syntax_on*  
> *:h :syn-files*  
> *:h :syn* | *:syntax*  
> *:h :syn-on* | *:syntax-on* | *:syn-enable* | *:syntax-enable*  
> *:h :syntax-reset* | *:syn-reset*  
#### Adding your own syntax  
> *:h b:current_syntax-variable*  
> *:h :ownsyntax*  
> *:h mysyntaxfile*  
> *:h mysyntaxfile-add*  
> *:h mysyntaxfile-replace*  

### Testing Syntax Time When Syntax is Slow  
> *:h :syntime*  

### Highlighting Naming Conventions & Default Highlight Groups  
> *:h group-name* *{group-name}*  

* `Comment`: any comment  
* `Constant`: any constant  
* `String`: a string constant: `"this is a string"`  
* `Character`: a character constant: `c`, `\n`  
* `Number`: a number constant: 234, 0xff  
* `Boolean`: a boolean constant: TRUE, false  
* `Float`: a floating point constant: `2.3e10`  

* `Identifier`: any variable name  
* `Function`: function name (also: methods for classes)  

* `Statement`: any statement  
* `Conditional`: if, then, else, endif, switch, etc.  
* `Repeat`: for, do, while, etc.  
* `Label`: case, default, etc.  
* `Operator`: `sizeof`, `+`, `*`, etc.  
* `Keyword`: any other keyword  
* `Exception`: try, catch, throw  

* `PreProc`: generic Preprocessor  
* `Include`: preprocessor #include  
* `Define`: preprocessor #define  
* `Macro`: same as Define  
* `PreCondit`: preprocessor #if, #else, #endif, etc.  

* `Type`: int, long, char, etc.  
* `StorageClass`: static, register, volatile, etc.  
* `Structure`: struct, union, enum, etc.  
* `Typedef`: A typedef  

* `Special`: any special symbol  
* `SpecialChar`: special character in a constant  
* `Tag`: you can use CTRL-] on this  
* `Delimiter`: character that needs attention  
* `SpecialComment`: special things inside a comment  
* `Debug`: debugging statements  

* `Underlined`: text that stands out, HTML links  

* `Ignore`: left blank, hidden  |hl-Ignore|
* `Error`: any erroneous construct  
* `Todo`: anything that needs extra attention; mostly the  keywords TODO FIXME and XXX  



