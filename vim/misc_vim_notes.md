
# Misc Vim Notes

Reading the help pages (like a book): `:h 1.1`

List of all vim commands for each mode:
* *:h index*
* *:h insert-index* / *visual-index*

## Undo Line
Pressing `U` (`<Shift-u>`) undoes all the changes made on the 
last line that was edited. This command is a change by itself,
which is undone by the normal undo (`u`).

## Use `man` in NeoVim
In nvim (not vim as of right now) `:Man {cmd}` will pull up
the man page for the given cmd. Defined by the `'keywordprg'/ 'kp'`
option.

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
    `CFLAGS = -g -Wall -Wextra -Wshadow -Wmissing-prototypes -Wunreachable-code -Wno-deprecated-declarations -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1`


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


### Recursive Macros
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

### Making a Numbered List Using Macros
1. Create the first list entry, make sure it starts with a number.
2. qa	     - start recording into register 'a'
3. Y	     - yank the entry
4. p	     - put a copy of the entry below the first one
5. CTRL-A    - increment the number
6. q	     - stop recording
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
command! MakeTags !ctags -R .  
" `C-]` will jump to tag  
" `g<C-]>` will list all tags  
" `<C-t>` will jump back up the tag stack  


### Command Mode Editing
Or Ex mode editing.  
* `c_CTRL-z` will show all Ex commands in autocomplete.
* `c_CTRL-u` will remove all the text between the cursor and the beginning of the command (to the `:`)
* `c_CTRL-p`/`c_CTRL-n` will insert the last command executed / cycle through command history.
* `c_CTRL-a` (double tap in tmux) will dump all commands?


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


### Various Options
`:h options`

`:h emoji`  
`emoji`    emoji characters are full width  
     - set emo    noemo  

`splitkeep`    determines scroll behavior for split windows  
     set cursorspk    spk  

`clipboard`    "unnamed" to use the * register like unnamed register  
    "autoselect" to always put selected text on the clipboard  
     set cb=unnamedplus  

`backspace`    specifies what <BS>, CTRL-W, etc. can do in Insert mode  
     set bs=indent,eol,start  

`complete`    specifies how Insert mode completion works for CTRL-N and CTRL-P  
    (local to buffer)  
     set cpt=.,w,b,u,t  

`completeopt`    whether to use a popup menu for Insert mode completion  
     set cot=menuone,noselect,  


#### More Tab Options
`vartabstop`    list of number of spaces a tab counts for  
    (local to buffer)  
     set vts=  
`varsofttabstop`    list of number of spaces a soft tabsstop counts for  
    (local to buffer)  
     set vsts=  

##### Formatting Options For `gq`
`formatexpr`    expression used for "gq" to format lines  
    (local to buffer)  
     set fex=v:lua.vim.lsp.formatexpr()  

#### Undo Options
`undolevels`    maximum number of changes that can be undone  
    (global or local to buffer)  
     set ul=1000  
`undofile`    automatically save and restore undo history  
     set udf    noudf  
`undodir`    list of directories for undo files  
     set udir=/home/kolkhis/.local/state/nvim/undo//  
`undoreload`    maximum number lines to save for undo on a buffer reload  
     set ur=10000  

### Misc `:!{cmd}` Notes
Any "%" in {cmd} is expanded to the current file name.  
Any "#" in {cmd} is expanded to the alternate file name.  
Special characters are not escaped, use quotes or  
shellescape(): >  
    :!ls "%"  
    :exe "!ls " .. shellescape(expand("%"))  

To avoid the hit-enter prompt use: >  
    :silent !{cmd}  

Repeat last ":!{cmd}".  
    :!!  

### Recursive Macros
* **Position my cursor where I want to make the first change**  
* `qa` - start recording into register 'a'
* **Make all my changes, doing it in a way that should apply cleanly to all locations**
* `q` - stop recording
* **Position cursor on next location I want changed**
* `@a` - run the macro to test and make sure it works as intended
* `qA` - start recording to append to macro register 'a'
* **Move cursor to next location to change**
* `@a`
* `q`

##### More from the author of the Recursive macro tip
Now, if I call it again, register 'a' contains a macro that does my change, moves to the next spot, and then calls itself again.  
It will run repeatedly until it encounters an error.  
This could be trying to move past the end of the buffer, finding no matches for a search, search hitting the end of buffer if `nowrapscan` is set, or any other command failure indicating all the changes are complete.  
Quick and easy way to process an entire file!  

The other thing I want to mention is more fundamental: text-objects.  
I hesitate to mention it because you said "uncommon commands" and I hope everyone using Vim already knows about those and uses them constantly.  
But in case you don't know about them, go find them in the help and change your life.  
You'll get to do things like `"=aB"` to re-indent an entire C-style code block (from anywhere in the block) or `cit` to delete everything within the current XML tag and drop you into insert mode ready to add new content.  
Note these also combine really well with macro techniques mentioned above, as well.  



### Using the `=` Register for Formulas
Using the = register to calculate numeric inputs for motions.  

For example `@=237*8<cr><c-a>` to increment a value by 237\*8.  
There are a number of ways to go about this and it might seems odd but I use it surprisingly often.  

Also I don’t think many people make use of onoremap or omap for operator pending mode, basically to expand your set of motions (eg define in( to work just like i( but on the next pair of parens)  

I don’t find myself using zg or zug or the other variants for modifying spellcheck, but I guess I don’t use spell check too often. 

I find gi helpful and didn’t use it for the longest time.  
Also `<c-a>` and `<c-d>` in Ex mode for autocompleting all strings or showing a list (when you don’t set list in wildmode).  
I think :~ is not so common either.  
I never use virtual replace mode gR.  

Some commands I do use quite often that might be less common are `:@“` to run an ex command that I copied from some buffer,  
 mainly for testing changes to my vimrc, `@:` to rerun the last ex command  
  (I abuse makeprg and use make to do a lot of testing, and sometimes I need to repeat lest run one script to test against another).  
I don’t think going into ex mode via `Q` is too common, but `q:` is handy for modifying ex history.  
But I don’t know, maybe everyone else uses these regularly, I guess it depends on your work flow.  




### Function author for a quick search type thing
He wrote an operator mapping activated by <leader>/ that takes  
the result of the motion and sets the search register to it.  

For example, hitting <leader>/i( will search for the string currently in the parentheses where the cursor is.  

he's on a mobile right now so can't share it, but grab any of your existing mappings for o mode and just set @/ to the captured text.  
For extra fun, replace all whitespace with \s+ to make it even more useful so hitting <leader>/i' inside 'a b' will match 'a b', also.  

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
Using a <Del> in markdown will strikethrough all subsequent lines </Del>