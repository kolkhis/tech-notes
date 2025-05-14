

# Misc Vim Notes  

You can read the help pages (like a book): `:h 1.1`  
Information on Vimscript and Vimscript functions are found in `usr_41.txt`.  
* See [Vim Script for Python Developers](https://gist.github.com/yegappan/16d964a37ead0979b05e655aa036cad0)  
List of all default vim keybindings/commands for each mode:  
* *:h index*  
* *:h insert-index* / *visual-index*  
* *:h default-mappings*  

## Table of Contents
* [Misc Vim Notes](#misc-vim-notes) 
* [Neovim Resources](#neovim-resources) 
* [Easily Selecting Lines for an Ex Command](#easily-selecting-lines-for-an-ex-command) 
* [Searching with :vimgrep or :vim](#searching-with-vimgrep-or-vim) 
* [Normal Mode Commands on Visual Selection with `:'<,'>norm`](#normal-mode-commands-on-visual-selection-with-'<'>norm) 
* [Encrypting Files with Vim (NOT RECOMMENDED)](#encrypting-files-with-vim-(not-recommended)) 
* [History Tables](#history-tables) 
* [Replace Tabs with Spaces](#replace-tabs-with-spaces) 
    * [`:ret`](#ret) 
* [Use an Ex Command on Lines Based on Range or Pattern](#use-an-ex-command-on-lines-based-on-range-or-pattern) 
* [Registers](#registers) 
    * [Getting help with registers: `:h quote_{reg}`/`:h quote{reg}`](#getting-help-with-registers-h-quote_reg/h-quotereg) 
    * [Writing to a Register](#writing-to-a-register) 
            * [`:h :let-@`](#h-let-@) 
* [Command-line Window](#command-line-window) 
* [Getting a List of Functions, or a Function's Arguments](#getting-a-list-of-functions-or-a-function's-arguments) 
* [Debugging a Slow Vim](#debugging-a-slow-vim) 
* [Regex with vim](#regex-with-vim) 
    * [Pattern atom](#pattern-atom) 
    * [  Pattern Qualifiers](#--pattern-qualifiers) 
* [Helpful Functions for Plugin Dev](#helpful-functions-for-plugin-dev) 
    * [Get the details of loaded packages](#get-the-details-of-loaded-packages) 
    * [Refactoring tip](#refactoring-tip) 
    * [Disable LSP for current buffer](#disable-lsp-for-current-buffer) 
* [Undo Line](#undo-line) 
* [Use `man` in Neovim](#use-man-in-neovim) 
* [Perform Actions on Ranges Using Searches](#perform-actions-on-ranges-using-searches) 
* [Use a Normal Mode Command from Insert Mode](#use-a-normal-mode-command-from-insert-mode) 
* [Use a Visual Mode Command From Select Mode](#use-a-visual-mode-command-from-select-mode) 
* [Vimscript Types](#vimscript-types) 
    * [Installing Vim With Full Feature Support](#installing-vim-with-full-feature-support) 
    * [Mapping Modes](#mapping-modes) 
* [Select mode](#select-mode) 
    * [Commands in Select mode](#commands-in-select-mode) 
* [Jumping Around Files Based on Percentage](#jumping-around-files-based-on-percentage) 
* [Recursive Macros](#recursive-macros) 
* [Paste a Recorded Macro](#paste-a-recorded-macro) 
    * [Making a Numbered List Using Macros](#making-a-numbered-list-using-macros) 
    * [Special Characters (Diagraphs)](#special-characters-(diagraphs)) 
    * [Debugging Vim](#debugging-vim) 
    * [Omnicomplete](#omnicomplete) 
    * [Netrw](#netrw) 
    * [Tags](#tags) 
    * [Command Mode Editing](#command-mode-editing) 
    * [Command Line Ranges](#command-line-ranges) 
        * [Search and Range Items](#search-and-range-items) 
    * [Easy Searching](#easy-searching) 
* [Browsing the List of Options](#browsing-the-list-of-options) 
* [Various Options](#various-options) 
    * [More Tab Options](#more-tab-options) 
        * [Formatting Options For `gq`](#formatting-options-for-gq) 
    * [Undo Options](#undo-options) 
    * [Misc `:!{cmd}` Notes](#misc-!cmd-notes) 
* [tl;dr: Recursive Macros](#tl;dr-recursive-macros) 
    * [Using the `=` Register for Formulas (The Expression Register)](#using-the-=-register-for-formulas-(the-expression-register)) 
    * [Function author for a quick search type thing](#function-author-for-a-quick-search-type-thing) 
    * [Misc](#misc) 
    * [Help Sections to Read Up On](#help-sections-to-read-up-on) 
* [Random Stuff](#random-stuff) 
* [Note Formatting Vim Regex Patterns](#note-formatting-vim-regex-patterns) 
    * [Add Linebreaks for Easier Readability](#add-linebreaks-for-easier-readability) 
* [Things to look into](#things-to-look-into) 


## Neovim Resources:  
* Nightly repo for `apt-get`:  
    * `sudo add-apt-repository ppa:neovim-ppa/unstable -y`
* [API docs](https://neovim.io/doc/user/api.html#API)  
* [Pynvim docs](https://pynvim.readthedocs.io/en/latest/usage/python-plugin-api.html#nvim-api-methods-vim-api)  
* [Lua reference](https://learnxinyminutes.com/docs/lua/)  
* [Regex](https://www.vimregex.com/) 
    * *:h character-classes*  
* [`vim.fn` Functions](https://neovim.io/doc/user/usr_41.html#function-list)  


## Easily Selecting Lines for an Ex Command  
Pressing `!` and then doing a motion will select the lines that the motion  
would have traversed, and put them in the Ex command line.  
E.g., `!}` at the top of a paragraph will put the whole paragraph selection  
into the Ex Command Line (for example, `:.,.+4!` for a 4-line paragraph).  


## Getting the ASCII Code of a Character
You can also get the ASCII code of a character directly in VIM. To get the code of 
the character under the cursor in insert mode, you can type `ga` or the command `:as` 
for ASCII.

## Searching with :vimgrep or :vim  
To use `:vimgrep` (`:vim`)  to search for patterns across files  
in the current directory, use the syntax:  
```vim  
:vim /pattern/ *  
```

To search recursively:  

* Note: You may need to enable the `globstar` in your shell for this to work.  

```vim  
:vim /pattern/ **/*  
```
This uses the `globstar` feature in bash.  
The recursive searching goes up to 100 directories deep.  

* `:vimgrep` puts all matching files in the `quickfix list`/`error list`.  
    * Using `:lvimgrep` (or `:lvim`) will use the `location list` instead.  
* Just like in substitutions, the `/` can be swapped for another char (i.e., `;`)  
* `:vimgrep` follows the `'ignorecase'` option. 
    * To overrule it put `\c` in the pattern to ignore case or `\C` to match case.

To get the list of all files that were matched (the quickfix list):  
```vim  
:cope  
```

To search for a fixed string instead of a pattern, use the `f` flag:  
```vim  
:vimgrep /myString/f **/*  
```

## Normal Mode Commands on Visual Selection with `:'<,'>norm`
You can execute arbitrary normal mode commands on the visual selection  
with `:'<,'>norm`.  
For instance:  
```vim  
"Add an exclamation point to the end of each selected line  
:'<,'>norm A!  
"Bind this to a key for quick access 
vnoremap '<leader>no' call norm :'<,'>norm 
```
Another example:  
```vim  
" Add a markdown todo box at the beginning of each line  
:'<,'>norm ^i* [ ] <Esc>  
```
Relevant hotkey(s):  

* `gv`: Reselect last visual selection  


## Encrypting Files with Vim (NOT RECOMMENDED) 
See `~/notes/vim/encrypt.md`.  
* This only works in vim, not Neovim.  
* Generally uses the blowfish encryption method, though it can be changed.  
Use `:X` to encrypt a file.  
Basically locks it behind a password.  
Uses the `cryptmethod` to determine encryption algorithm.  
```vim  
:X  
" Enter passphrase twice and write file to encrypt it  
:w  
```
Files can be programatically checked for encryption:  
```vim  
" Check if file is encrypted  
has('crypt-blowfish2')  
" Check for encryption functionality  
if v:version > 704 || (v:version == 704 && has('patch401')) 
```



## History Tables  
There are actually five history tables:  

* one for `:` commands  
* one for search strings  
* one for expressions  
* one for input lines, typed for the `input()` function.  
* one for debug mode commands  


## Replace Tabs with Spaces  
### `:ret`
Using:  
```vim  
:[range]ret[ab][!] [new_tabstop]  
```

* If there's no tabstop size or it's zero, Vim uses `tabstop`.  
* With `!`, Vim also replaces strings of only normal spaces with tabs where appropriate.  
* With `expandtab` on, Vim replaces all tabs with the appropriate number of spaces.  


## Use an Ex Command on Lines Based on Range or Pattern  
Execute arbitrary commands on *matching* patterns by using `:g` (`:global`).  
Execute arbitrary commands on *NON-matching* patterns by using `:g!` (`:global!`) or `:v` (`:vglobal`).  

* `:[range]g[lobal]/{pattern}/[cmd]` / `:g/{pattern}/[cmd]`
    * Execute the Ex command `[cmd]` (default `:p`) on the  
      lines within `[range]` where `{pattern}` matches.  

* `:[range]g[lobal]!/{pattern}/[cmd]` / `:g!/{pattern}/[cmd]`
    * Execute the Ex command `[cmd]` (default `:p`) on the  
      lines within `[range]` where `{pattern}` does NOT match.  

* `:v`: Same as `:g!`

## Registers  
##### Getting help with registers: `:h quote_{reg}`/`:h quote{reg}`

* Display the contents of all registers with `:reg`.  
    * Display certain registers by passing them in as args: 
    `:reg 123abc` (will display registers 1-3, and a-c)  
* `:di`, `:dis`, `:display`: Same as `:reg`

| **Register**  |  **Purpose**            |
|---------------|-------------------------|
|     `"#`      | Alternate file register |
`"=` Expression Register.  

There are ten types of registers:  
1. The unnamed register `""`  
2. 10 numbered registers `"0` to `"9`  
3. The small delete register `"-`  
4. 26 named registers `"a` to `"z` or `"A` to `"Z`  
5. Three read-only registers `":`, `".`, `"%`  
6. Alternate buffer register `"#`  
7. The expression register `"=`  
8. The selection registers `"*` and `"+`  
9. The black hole register `"_`  
10. Last search pattern register `"/`  


### Writing to a Register  
##### `:h :let-@`
You can write to a register with a `:let` command. Example:  
```vim  
:let @/ = "the"  
```


## Command-line Window  
A command line window pre-populated with your command-line history.  
To open:  
* From Normal mode, use the `q:`, `q/` or `q?` command.  
The height of the window is specified with `cmdwinheight`

## Getting a List of Functions, or a Function's Arguments  

Use the `:fun` command to get a list of functions  
```vim  
" List all functions and their arguments.  
:fu[nction] 

" List function {name}, annotated with line numbers unless "!" is given.  
:fu[nction][!] {name} 
" {name} may be a |Dictionary| |Funcref| entry: 
:function dict.init  
```

## Debugging a Slow Vim  

You can use built-in profiling support: after launching vim do  
```vim  
:profile start profile.log  
:profile func *  
:profile file *  
" At this point do slow actions  
:profile pause  
:noautocmd qall!  
```

## Regex with vim  
### Pattern atom  
*  `^` start matching from beginning of a line  
    * `/^This` match This only at beginning of line  
*  `$` match pattern should terminate at end of a line  
    * `/)$` match ) only at end of line  
    * `/^$` match empty line  
*  `.` match any single character, excluding new line  
    * `/c.t` match 'cat' or 'cot' or 'c2t' or 'c^t' but not 'cant'  

For more info:  
* :h pattern-atoms  


###   Pattern Qualifiers  
* `*` greedy match preceding character 0 or more times  
    * `/abc*` match 'ab' or 'abc' or 'abccc' or 'abcccccc' etc  
* `\+`: greedy match preceding character 1 or more times  
    * `/abc\+` match 'abc' or 'abccc' but not 'ab'  
* `\?` match preceding character 0 or 1 times (\= can also be used)  
    * `/abc\?` match 'ab' or 'abc' but not 'abcc'  
* `\{-}` non-greedy match preceding character 0 or more times  
    * Consider this line of text 'This is a sample text'  
    * `/h.\{-}s` will match: 'his'  
    * `/h.*s` will match: 'his is a s'  
    * Read more on non-greedy matching  
* `\{min,max}` greedy match preceding character min to max times (including min and max)  
    * min or max can be left unspecified as they default to 0 and infinity respectively  
    * greedy match, tries to match as much as possible  
* `\{-min,max}` non-greedy match, tries to match as less as possible  
* `\{number}` match exactly with specified number  
    * `/c\{5}` match exactly 'ccccc'  

For more info:  
* :h pattern-overview  
* :h character-classes  


## Helpful Functions for Plugin Dev  

### Get the details of loaded packages  
package.loaded contains a table of loaded packages  
that can be accessed.  
```vim  
:lua print(vim.inspect(package.loaded))  
```

* `vim.api.nvim_get_keymaps`: Gets a list of global (non-buffer-local) |mapping| definitions.  
* `:h wincmd`: Window switching for scripts  
* `:e https://github.com/somefile.c`: Can edit via URL  

Anything in nvim/plugin will load/run at runtime.  


### Refactoring tip  
>> Grep with Telescope, add to quickfix list  
>> Then, to apply a cmd to each thing:  
```vim  
:cdo <cmd>  
:h cdo  
```

### Disable LSP for current buffer  
```vim  
:lua vim.lsp.diagnostics.disable(vim.api.nvim_get_current_buf())  
```

---  


## Undo Line  
Pressing `U` (`<Shift-u>`) undoes all the changes made on the 
last line that was edited. This command is a change by itself,
which is undone by the normal undo (`u`).  

## Use `man` in Neovim  
In nvim (not vim as of right now) `:Man {cmd}` will pull up  
the man page for the given cmd. Defined by the `'keywordprg'/ 'kp'`
option.  

## Perform Actions on Ranges Using Searches  
* `c/[pattern]` <- change to most recently searched text  
* `c?[pattern]` <- same as above, change backwards to most recently search term  


## Use a Normal Mode Command from Insert Mode  
While in Insert Mode, pressing `<C-o>` (`i_CTRL-O`) will allow you  
to use a normal-mode command or motion, allowing for easy navigation,
executing an arbitrary normal-mode command,
or going into Select Mode (with `gh/gH/g^h`).  

## Use a Visual Mode Command From Select Mode  
While in Select Mode, pressing `<C-o>` (`v_CTRL-O`) will allow  
you to switch to Visual mode for the duration of **one** command  
or motion.  


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

### Installing Vim With Full Feature Support  
To get Vim with Python support, it can be installed from source:  
* `https://github.com/vim/vim/blob/master/src/INSTALL`  

Base Installation Dependencies:  
* `git`
* `make`
* `clang`
* `libtool-bin`
X-windows Clipboard Dependencies:  
* `libxt-dev`
Python Dependencies:  
* `libpython3-dev`
* The `CONF_OPT_PYTHON3 = --enable-python3interp` needs to be uncommented from the Makefile.  
GUI Dependencies (lol):  
* `libgtk-3-dev`
Debugging:  
* `valgrind`
* Uncomment in Makefile:  
    * `CFLAGS = -g -Wall -Wextra -Wshadow -Wmissing-prototypes -Wunreachable-code -Wno-deprecated-declarations -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1`


### Mapping Modes  
> `:h map-table` | `:h map-overview`
  
Here is a table representation of the different 
mapping mode letters for keymaps:  

Mode Letter|Regular|Non-recursive|  Removing |      Modes                    |
|---|-------|------------|------------|---------------------------------|
| - | :map  |  :noremap  |   :unmap   |   Normal, Visual, Select, Operator-pending  |
| n | :nmap |  :nnoremap |   :nunmap  |   Normal  |
| v | :vmap |  :vnoremap |   :vunmap  |   Visual and Select  |
| s | :smap |  :snoremap |   :sunmap  |   Select  |
| x | :xmap |  :xnoremap |   :xunmap  |   Visual  |
| o | :omap |  :onoremap |   :ounmap  |   Operator-pending  |
| ! | :map! |  :noremap! |   :unmap!  |   Insert and Command-line  |
| i | :imap |  :inoremap |   :iunmap  |   Insert  |
| l | :lmap |  :lnoremap |   :lunmap  |   Insert, Command-line, Lang-Arg  |
| c | :cmap |  :cnoremap |   :cunmap  |   Command-line  |
| t | :tmap |  :tnoremap |   :tunmap  |   Terminal  |

When put into practice, this graph may be more helpful to identify  
which type of mapping you need:  

| Command mode:  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
|----------------|------|-----|-----|-----|-----|-----|------|------|
| [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
| n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
| [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
| i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
| c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
| v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
| x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
| s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
| o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
| t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
| l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |

The `l` mode (Lang / Language Argument Mode) is used when using 
an 'input method editor' to type text in another language,
such a Korean, Japanese, Chinese, etc.  


## Select mode  
Entering select mode:  
* From Normal mode with:  
    * `gh` for character-wise selection  
    * `gH` for line-wise selection  
    * `g^H` for block-wise selection  
* From Insert mode with:  
    * `<C-o>` followed by one of the above commands.  
* From Visual mode with `<C-g>` (`v_CTRL-G`)  
    * `<C-g>` Toggles between Visual and Select  

In Select mode, vim behaves more like a standard graphical editor.  
The same keybindings for motion you would use in a non-vim-enabled  
environment are applicable in Select mode.  
In Select Mode you can highlight characters with `<Left>` and `<Right>`,
words with `<C-Left>`/`<C-Right>`, etc.  

Movement keys in this mode are the cursor keys,
`<End>`, `<Home>`, `<PageUp>` and `<PageDown>`.  

### Commands in Select mode:  
- Printable characters, `<NL>` and `<CR>` cause the selection to be deleted, and  
  Vim enters Insert mode.  The typed character is inserted.  
- Non-printable movement commands, with the Shift key pressed, extend the  
  selection.  'keymodel' must include "startsel".  
- Non-printable movement commands, with the Shift key NOT pressed, stop Select  
  mode.  'keymodel' must include "stopsel".  
- ESC stops Select mode.  
- CTRL-O switches to Visual mode for the duration of one command. *v_CTRL-O*  
- CTRL-G switches to Visual mode.  
- CTRL-R {register} selects the register to be used for the text that is  
  deleted when typing text. *v_CTRL-R*  
  Unless you specify the "_" (black hole) register, the unnamed register is  
  also overwritten.  




## Jumping Around Files Based on Percentage  
> `:h N%`
{count}% jumps to a line {count} percentage down the file 


## Recursive Macros  
To create a recursive macro, you need to first record the macro you want to repeat.  
For this example, we'll be using the `a` key as a macro register.  

1. Press `q` then another key to start recording to that macro register.  
    * e.g., `qa` will record to the `a` macro register.  
1. Perform the actions that you want to repeat.  
1. Stop recording with `q`.  
1. To make it recursive, you now need to **append** to the same macro register.  
    * To do this, press `q` and then `<Shift>+(original_register)` - the **capital** of the key  
      you chose.  
    * Since we chose `a`, we'd enter `qA`.  
      This **appends** to the macro in the `a` macro register.  
1. Now that you're appending, you want to enter the original macro (so the macro contains the  
   command to call itself). You only need to do this once.  
    * Press `@a` to call the macro.  
    * This calls the macro from within the macro, making it **recursive**.  
1. Exit macro recording with `q`.  
1. Now, call your recursive macro with `@a` (assuming you chose the `a` register)  

## Paste a Recorded Macro  
* `"qp` - Paste the macro recorded in the register `q`

### Making a Numbered List Using Macros  
1. Create the first list entry, make sure it starts with a number.  
2. `qa`        - start recording into register 'a'  
3. `Y`         - yank the entry  
4. `p`         - put a copy of the entry below the first one  
5. `CTRL-A`    - increment the number  
6. `q`         - stop recording  
7. `<count>@a` - repeat the yank, put and increment `<count>` times  



### Special Characters (Diagraphs)  

* `i_<C-k>` + 2 letters will output a special character.  
* `:h default-diagraphs`  
* `:h diagraphs`  
* `:dig` for a list of available digraphs.  


### Debugging Vim  
You can debug your Vim startup sequence by running `vim --startuptime vim.log`.  
This will create a file called vim.log that logs what gets loaded and when.  


### Omnicomplete  
Omnicompletion in vim:  
* The good stuff is documented in `ins-completion`  
* `^x^n`: Searches for completions in JUST this file  
* `^x^f`: Searches for completions in filenames (works with `path+=**`)  
* `^x^]`: Searches for completions in tags only  
* `^n`: for anything specified by the 'complete' option  


### Netrw  
See `./netrw.md`
File browsing with netrw:  
* You can do a lot with netrw. Connect to remote filesystems with ssh, mark files, etc.  
* Open in split with `v`, `o`, or `p`  
* `:h netrw-browse-maps`  
* `:h netrw-usermaps`


### Tags:  
This is basically a fzf.  
Utilizing `ctags`, type `:find *.vim<Tab>` and it pulls up all .vim  
files in the current directory and all subdirectories (with `set path+=**` set)  
"no_plugins.vim"  
```vim  
command! MakeTags !ctags -R .  
```
* `C-]` will jump to tag  
* `g<C-]>` will list all tags  
* `<C-t>` will jump back up the tag stack  


### Command Mode Editing  
Or Ex mode editing.  

* `c_CTRL-z` will show all Ex commands in autocomplete.  
* `c_CTRL-u` will remove all the text between the cursor and the beginning of the command (to the `:`)  
* `c_CTRL-p`/`c_CTRL-n` will insert the last command executed / cycle through command history.  
* `c_CTRL-a` (double tap in tmux) will dump all commands?  
* `c_CTRL-b` will put cursor at the start of the line.  
* `c_CTRL-e` will put cursor at the end of the line.  

Special words for command mode (can be used with `expand()`):  

* `<cfile>`: is replaced with the path name under the cursor (like what `gf` uses)  
* `<cword>`: is replaced with the word under the cursor (like `star`)  
* `<cWORD>`: is replaced with the WORD under the cursor (see `WORD`)  
* `<afile>`: When executing autocmds, is replaced with the file name of the buffer  
             being edited, or the file for a read or write. (`E495`)  
* `<amatch>`: When executing autocmds, is replaced with the pattern match for  
    which this autocommand was executed.  

Paste the contents of a register into the command line:  

* `CTRL-R w`: Pastes the contents of the `w` register into the command line (can be any register).  
* Special Registers for `<C-r>`/`CTRL-R`:  
    * `CTRL-F`:  the Filename under the cursor  
    * `CTRL-P`:  the Filename under the cursor, expanded with `path` as in `gf`
    * `CTRL-W`:  the Word under the cursor  
    * `CTRL-A`:  the WORD under the cursor; see `WORD`
    * `CTRL-L`:  the line under the cursor  



### Command Line Ranges  
> `:h cmdline-ranges`    
> `:h E1247`: Special characters for ranges  
> `:h :;`: Using semicolons vs commas  

With cmds that accept ranges, lines can be separated with commas or semicolons (`,`/`;`)    

* When separated with `;` the cursor position will be set to the match before interpreting the next  
  line specifier:  
  ```vim  
  :/apples/;.1s/old/new/g  
  " Replace 'old' with 'new' in the next line in which "apples" occurs, and the line following it.  
  "(.1 is .+1, and because ; was used, the cursor position is set to the line matching "apples" before interpreting the .+1).  
  " BREAKDOWN 
  :/apples/;  
  " put the cursor at the next occurrence of 'apples'  
  .1s/old/new/g  
  " replace 'old' with 'new' on the curren line (.) and 1 line after (1)  
  ```  
* `:.;.6s/` - Start a substitution from the current line to the next 6 lines  
* `:.1;.6s/` - Start a substitution from the line below the current line, to the next 6 lines  


#### Search and Range Items  
* `/pattern/`:     next line where pattern matches  
* `?pattern?`:     previous line where pattern matches  
* `\/`:         next line where the previously used search pattern matches  
* `\?`:         previous line where the previously used search pattern matches  
* `\&`:         next line where the previously used substitute pattern matches  
* `0;/that`:    first line containing "that" (also matches in the first line)  
* `1;/that`:    first line after line 1 containing "that"  



### Easy Searching  
> Most of these only work when `incsearch` is set.  

* `/_CTRL-L` will select one character to the right in search mode, adding it to the search  
* `/_CTRL-G` & `/_CTRL-T` will cycle through the matches for the current search pattern  


## Browsing the List of Options  
Browse the list of options with:  
```vim  
:browse set | :bro se  
:options    | :opt  
```

## Various Options  
* `:h :options`  
* `:h :emoji`  

* `splitkeep`: Determines scroll behavior for split windows    
    * `set cursorspk=cursor` / `spk=cursor`  
    * Can be changed to `screen` or `topline`  

* `clipboard`: `unnamed` to use the `*` register like unnamed register    
    * `autoselect` to always put selected text on the clipboard  
    * `set cb=unnamedplus`  

* `backspace`: Specifies what `<BS>`, `CTRL-W,` etc. can do in Insert mode  
    * `set bs=indent,eol,start`  

* `complete`: Specifies how Insert mode completion works for CTRL-N and CTRL-P  
    * (local to buffer)  
    * `set cpt=.,w,b,u,t`  

* `completeopt`: Whether to use a popup menu for Insert mode completion  
    * `set cot=menuone,noselect,preview,`  


### More Tab Options  
* `vartabstop`: list of number of spaces a tab counts for  
    * (local to buffer)  
    * `set vts=`  
* `varsofttabstop`: list of number of spaces a soft tabsstop counts for  
    * (local to buffer)  
    * `set vsts=`  

#### Formatting Options For `gq`
* `formatexpr`: expression used for "gq" to format lines  
    * (local to buffer)  
    * `set fex=v:lua.vim.lsp.formatexpr()`  

### Undo Options  
See the undo list with `:undol[ist]` (only contains metadata).  

* `undolevels`: maximum number of changes that can be undone  
    * (global or local to buffer)  
    * `set ul=1000`  
* `undofile`: automatically save and restore undo history  
    * `set udf` / `noudf`  
* `undodir`: list of directories for undo files  
    * `set udir=/home/kolkhis/.local/state/nvim/undo//`  
* `undoreload`: maximum number lines to save for undo on a buffer reload  
    * `set ur=10000`  

### Misc `:!{cmd}` Notes  
Any `%` in `{cmd}` is expanded to the current file name.  
Any `#` in `{cmd}` is expanded to the alternate file name.  
Special characters are not escaped, use quotes or  
`shellescape()`:   
```vim  
:!ls "%"  
:exe "!ls " .. shellescape(expand("%"))  
```

To avoid the hit-enter prompt use:  
```vim  
:silent !{cmd}  
```

Repeat last `:!{cmd}`.  
```vim  
:!!  
```

## tl;dr: Recursive Macros  
* **Position my cursor where I want to make the first change**  
* `qa` - start recording into register `a`
* **Make all my changes, doing it in a way that should apply cleanly to all locations**  
* `q` - stop recording  
* **Position cursor on next location I want changed**  
* `@a` - run the macro to test and make sure it works as intended  
* `qA` - start recording to append to macro register `a`
* **Move cursor to next location to change**  
* `@a`
* `q`

Register `a` contains a macro that does the change,
moves to the next spot, and then calls itself again.  
It will run recursively until it encounters an error.  

This could be 

* Trying to move past the end of the buffer.  
* Finding no matches for a search.  
* Search hitting the end of buffer if `nowrapscan` is set.   
* Any other command failure indicating all the changes are complete.  

##### `:h text-objects`  


### Using the `=` Register for Formulas (The Expression Register)  
Using the = register to calculate numeric inputs for motions.  

For example `@=237*8<cr><c-a>` to increment a value by `237*8`.  
There are a number of ways to go about this.  

Make use of onoremap or omap for operator pending mode,
basically to expand your set of motions.  
E.g., define `in(` to work just like `i(` but on the next pair of parens. 

Using `zg`/`zug`, `zw`/`zuw`, or the other variants for modifying spellcheck, you  
can add or remove words from the wordlist used for:  
```vim  
:setlocal spell spelllang=en_us  
```

`gi` is helpful, didn’t use it for the longest time.  
Also `<c-a>` and `<c-d>` in Ex mode for autocompleting all strings or showing a list (when you don’t set list in wildmode).  
I think `:~` is not so common either.  
I never use virtual replace mode `gR`.  

Some commands that might be less common are `:@"` to run an ex command that I copied 
from some buffer, mainly for testing changes to my vimrc, `@:` to rerun the last ex 
command  (abuse `makeprg` and use `:make` to do testing).  
I don’t think going into ex mode via `Q` is too common, but `q:` is handy for modifying ex history.  
But I don’t know, maybe everyone else uses these regularly, I guess it depends on your work flow.  




### Function author for a quick search type thing  
He wrote an operator mapping activated by `<leader>/` that takes  
the result of the motion and sets the search register to it.  

For example, hitting `<leader>/i(` will search for the string currently in the 
parentheses where the cursor is.  

he's on a mobile right now so can't share it, but grab any of your existing mappings 
for `o` mode and just set `@/` to the captured text.  
For extra fun, replace all whitespace with `\s+` to make it even more useful so hitting `<leader>/i'` inside `'a b'` will match `'a b'`, also.  

```vim  
" Defines an operator (<Leader>/) that will search for the specified text.  
function! SetSearch( type )  
  let saveZ = @z  

  if a:type == 'line'  
    '[,']yank z  
  elseif a:type == 'block'  
    " This is not likely as it can only happen from visual mode, for which the mapping isn't defined anyway  
    execute "normal! `[\<c-v>`]\"zy"  
  else  
    normal! `[v`]"zy  
  endif  

  " Escape out special characters as well as convert spaces so more than one can be matched. 
  let value = substitute( escape( @z, '$*^[]~\/.' ), '\_s\+', '\\_s\\+', 'g' )  

  let @/ = value  
  let @z = saveZ  

  " Add it to the search history.  
  call histadd( '/', value )  

  set hls  
endfunction  
nnoremap <leader>/ :set opfunc=SetSearch<cr>g@  
```



### Misc  
* `:h visual-search`
* `:h feature-list`: Features that are accepted as arguments to `has()`


### Help Sections to Read Up On  

* `:h various.txt`:  
* `:h filter`:  
* `:h redir`:  
* `:h silent`:  
* `:h unsilent`:  
* `:h lsp-defaults`:  
* `:h mkview | mkvie`:  
* `:h loadview | lo`:  
* `:h oldfiles`:  


## Random Stuff  

```md
Using a <Del> in markdown will strikethrough all subsequent lines </Del>  
```

Using a <Del> in markdown will strikethrough all subsequent lines </Del>  

Empty filename for `%` or `#` only works with `:p:h`


## Note Formatting Vim Regex Patterns  
### Add Linebreaks for Easier Readability  
Add two spaces (linebreak) at the end of each line that doesn't already have two spaces,
isn't a comma, and isn't the end of a codeblock (3 backticks):  
```regex  
:%s/\([^,\| \{2}\|`\{3}]$\)/\1  /  
```




--- 
Bootleg Autopairs Mapping  
```vim  
inoremap <Left>  <C-G>U<Left>  
inoremap <Right> <C-G>U<Right>  
inoremap <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ?  
\ repeat('<C-G>U<Left>', col('.') - 1) :  
\ (col('.') < match(getline('.'), '\S') ?  
        \     repeat('<C-G>U<Right>', match(getline('.'), '\S') + 0) :  
        \     repeat('<C-G>U<Left>', col('.') - 1 - match(getline('.'), '\S')))  
inoremap <expr> <End> repeat('<C-G>U<Right>', col('$') - col('.'))  
inoremap ( ()<C-G>U<Left>  
```
This makes it possible to use the cursor keys in Insert mode, without starting  
a new undo block and therefore using `.` (redo) will work as expected.  Also  
entering a text like (with the "(" mapping from above):  

   Lorem ipsum (dolor  

will be repeatable by using `.` to the expected  

   Lorem ipsum (dolor)  

---  



## Things to look into  


* `i_backspacing`
* `i_CTRL-X`
* `i_CTRL-V_digit` - number system conversion  
* `i_CTRL-G`
* `:inoremap <C-H> <C-G>u<C-H>`



