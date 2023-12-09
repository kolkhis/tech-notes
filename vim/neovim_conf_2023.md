

Nvim can connect to any other nvim and show its ui
nvim --list ./foo

from a different terminal (in the same dir as ./foo)
nvim --remote-ui --server ./foo


:InspectTree
:EditQuery
:Inspect

Run those cmds in treesitter highlight file
when the cursor goes on the tokens, it highlights the corresponding hl

:InspectTree
for developing colorschemes

run lua files
nvim -l f.lua --arg1 --arg2


Lua stdlib
type annotations for vim.*, vim.fm.*, vim.api.*

:h vimscript-functions is now generated
can lsp hover on vim.fn.*


vim.iter is a complete answer to any iterables.

neovim 'hosted' model

git: neovim-backup


With LLMs, now documentation matters more than ever before. Documentation = Leverage

vim.lsp.server()



HSL Colors:
Hex is the most common format for representing color but its not the most useful. When designing a theme, your color palette can be easily cluttered with the need to support numerous highlights. By using HSL (Hue, Saturation, and Lightness) instead, you can maintain a color scheme that is consistent and well-coordinated. In this talk, I’ll share tips for efficiently designing a Neovim theme using HSL colors. It will include how to highlight HSL code with echasnov

HSL:

Hue         0-360
Saturation  0-100
Lightness   0-100

[w3schools HSL calculator](https://www.w3schools.com/colors/colors_hsl.asp)

Colorbuddy: Colorscheme helper [>>](https://github.com/tj-devries/colorbuddy.nvim)

in nvim:
hsl(192, 100, 5),
the `hsl` function converts to hex.

mimi.hipatterns  <-- supports highlighting simple hex colors. Needs tweaks to support HSL colors.

solarized-osaka.hsl


## Macro
Apply a macro to visual selection
```vim
:'<,'>norm @q
```
can also use `cdo`

Some keymaps
```lua
vim.keymap.set('n', 'Q', '@qj')
vim.keymap.set('x', 'Q', ':norm @q<CR>')
```
### Recurse
if you do `@Q`, you'll append to the `q` register.
```vim
norm ,ttj}k 
```
* nvim-macroni - check out.

## Paste a Recorded Macro
* `"qp` - Paste the macro recorded in the register `q`


## Vim Options (By "WHO KNOWS" guy)

Global local option: Can have both global and local values. No clear way to know when to use a
global/local value.

### dict-like string opts
```vim
set laststatus=-1
set fillchars=fold:\ ,diff:\
```
### list-like string opts
```vim
wildmode=longest,list,full
```
### function-like string opts
```vim
set completeopt=v:lua.vim.lsp.omnifunc
```
Function-like options can't be set to Lua options.
they can, but only with `v:lua` 
Many global-local options use arbitrary values to represent an unset local value.
```vim
'undolevels': -123456
'autoread': -1
```

### Boolean options
vim bool opts have 3 states
true, false, none
No way to unset 'winbar' for a single window

### Vimscript
```vim
let &opt = val,&b:opt = val,&g:opt = val
```
Vim script functions:
```vim
getbufvar()
getwinvar()
setbufvar()
setwinvar()
```
API functions:
```vim
call nvim_get_option_value()
call nvim_set_option_value()
```

### Lua
lua:
```lua
vim.o
vim.bo
vim.wo
vim.go
```

### Option scopes
* Global: This is the only scope that makes any sense
* Window-local: Two values, one for all buffers and one for current buffer
* Buffer-local: have global values too
* Global-local: These have both local and global values.
When you set a global values for a global-local option, it also sets the local value.
```c
set_bool_option()
set_num_option()
set_string_option()
```
* `set` uses `do_set_option_value()`
* `let` uses `ex_let_option()`
* api functions use set_option_value



## Square Bracket Movement
* `]]`/`[[`: Next/Previous Header
* `[b ]b`
* `[g ]g`
* `[d`: Display the first macro definition that contains the macro under the cursor.
    * `]d`: like `[d`, but start at the current cursor position. 
    * See `:ds`/`:dsearch`
* `[e ]e`
* `[w ]w`
* `[c ]c`
* `[i`: Display the **first** line that contains the keyword under the cursor. (see `:is[earch]`)
    * `]i`: like `[i`, but start at the current cursor position (instead of the beginning).
* `[I`: Display **all** lines that contain the keyword under the cursor. (see `:il[ist]`)
    * `]I`: like `[I`, but start at the current cursor position.
* `[f ]f`: Deprecated version of `gf`
* Custom to speaker:
    * `[t ]t`
* `[D`: Display all macro definitions that contain the macro under the cursor.
    * `]D`: like `[D`, but start at the current cursor position.
* `[ CTRL-I`: Jump to the first line that contains the keyword under the cursor.
    * `] CTRL-I`: like `[ CTRL-I`, but start at the current cursor position.

* `:is[search]`: Like `[I` and `]I`, but search in [range] lines (default: whole file).
* `il[ist]`: Like `[i`  and `]i`, but search in [range] lines (default: whole file).


## Servers
* `:h clientserver`
Other:
* `:h include-search  definition-search`
* `:h tagfunc`
* `:h script-here`
* `:h tag-preview`
```help

  :map <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " .. nr .. "[\t"<CR>
<
                            *[i*
[i          Display the first line that contains the keyword
            under the cursor.  The search starts at the beginning
            of the file.  Lines that look like a comment are
            ignored (see 'comments' option).  If a count is given,
            the count'th matching line is displayed, and comment
            lines are not ignored.




6. Include file searches        *include-search* *definition-search*
...
                            *:is* *:isearch*
:[range]is[earch][!] [count] [/]pattern[/]
            Like "[i"  and "]i", but search in [range] lines
            (default: whole file).
            See |:search-args| for [/] and [!].

CTRL-W CTRL-D                   *CTRL-W_CTRL-D* *CTRL-W_d*
CTRL-W d        Open a new window, with the cursor on the first
            macro definition line that contains the keyword
            under the cursor.  The search starts from the
            beginning of the file.  If a count is given, the
            count'th matching line is jumped to.

                            *:dsp* *:dsplit*
:[range]dsp[lit][!] [count] [/]string[/]
            Like "CTRL-W d", but search in [range] lines
            (default: whole file).
            See |:search-args| for [/] and [!].

                            *:checkp* *:checkpath*
:checkp[ath]        List all the included files that could not be found.

:checkp[ath]!       List all the included files.

                                *:search-args*
Common arguments for the commands above:
[!] When included, find matches in lines that are recognized as comments.
    When excluded, a match is ignored when the line is recognized as a
    comment (according to 'comments'), or the match is in a C comment
    (after "//" or inside `/* */`).  Note that a match may be missed if a
    line is recognized as a comment, but the comment ends halfway the line.
    And if the line is a comment, but it is not recognized (according to
    'comments') a match may be found in it anyway.  Example: >
        /* comment
           foobar */
<   A match for "foobar" is found, because this line is not recognized as
    a comment (even though syntax highlighting does recognize it).
    Note: Since a macro definition mostly doesn't look like a comment, the
    [!] makes no difference for ":dlist", ":dsearch" and ":djump".
[/] A pattern can be surrounded by "/".  Without "/" only whole words are
    matched, using the pattern "\<pattern\>".  Only after the second "/" a
    next command can be appended with "|".  Example: >
    :isearch /string/ | echo "the last one"
<   For a ":djump", ":dsplit", ":dlist" and ":dsearch" command the pattern
    is used as a literal string, not as a search pattern.

                            *:dj* *:djump*
:[range]dj[ump][!] [count] [/]string[/]
            Like "[ CTRL-D"  and "] CTRL-D", but search  in
            [range] lines (default: whole file).
            See |:search-args| for [/] and [!].

                            *:dli* *:dlist*
:[range]dli[st][!] [/]string[/]
            Like `[D`  and `]D`, but search in [range] lines
            (default: whole file).
            See |:search-args| for [/] and [!].
            Note that `:dl` works like `:delete` with the "l"
            flag, not `:dlist`.






DPRECATED:

- *]f* *[f*     Same as "gf".
OPTIONS
- *cpo-<* *:menu-<special>* *:menu-special* *:map-<special>* *:map-special*
```




*:ds* *:dsearch*
*:dli* *:dlist*
*[_CTRL-D*
* `[ CTRL-D`: Jump to the first macro definition that contains the
            keyword under the cursor.`:dsp`/`:dsplit`
*:checkp* *:checkpath*
*:dli* *:dlist*
*:dj* *:djump*

*CTRL-W_CTRL-I* *CTRL-W_i*
* `CTRL-W i`:   Open a new window, with the cursor on the first line that contains the
                keyword under the cursor.
## Using Tags
> `:h tags-file-format / ctags / jtags`  

Format:
1. ` {tagname}      {TAB} {tagfile} {TAB} {tagaddress} `
    * The first format is a normal tag, which is completely compatible with Vi.
2. ` {tagname}      {TAB} {tagfile} {TAB} {tagaddress} {term} {field} .. `
    * The second format is new.  
    * It includes additional information in optional fields at the end of each line.
    * It is backwards compatible with Vi.
    * It is only supported by new versions of ctags (i.e., Universal ctags or Exuberant ctags).





## Square Bracket Movement

| Motion  |  Action  |
|---------|----------|
| `]]`/`[[`|: Next/Previous Header |
| `[b`/`]b` |  |
| `[g`/`]g` |  |
| `[d` |  Display the first macro definition that contains the macro under the cursor. |
| `]d` |  like `[d`, but start at the current cursor position.  |
| `[e`/`]e` |  |
| `[w`/`]w` |  |
| `[c`/`]c` |  |
| `[i` |  Display the **first** line that contains the keyword under the cursor. (see `:is[earch]`) |
| `]i` |  like `[i`, but start at the current cursor position (instead of the beginning). |
| `[I` |  Display **all** lines that contain the keyword under the cursor. (see `:il[ist]`) |
| `]I` |  like `[I`, but start at the current cursor position. |
| `[f`/`]f` |  Deprecated version of `gf` |
| `[t`/`]t` |  |
| `[D` |  Display all macro definitions that contain the macro under the cursor. |
| `]D` |  like `[D`, but start at the current cursor position. |
| `[ CTRL-I` |  Jump to the first line that contains the keyword under the cursor. |
| `] CTRL-I` |  like `[ CTRL-I`, but start at the current cursor position. |




