
# Vim Keybindings, Hotkeys & Shortcuts  

Pressing `!` and then doing a motion will select the lines that the motion  
would have traversed, and put them in the Ex command line.  
E.g., `!}` at the top of a paragraph will put the whole paragraph selection  
into the Ex Command Line (for example, `:.,.+4` for a 4-line paragraph).  


## Table of Contents
* [Quickref](#quickref) 
* [Making Custom Keybindings](#making-custom-keybindings) 
    * [Mapping Modes](#mapping-modes) 
    * [Special Mapping Arguments](#special-mapping-arguments) 
    * [Clearing / Deleting Mappings](#clearing--deleting-mappings) 
* [Normal Mode](#normal-mode) 
    * [Insert text at the same position on the line below/above](#insert-text-at-the-same-position-on-the-line-belowabove) 
    * [Toggling Case](#toggling-case) 
    * [Editing Motions](#editing-motions) 
    * [Macros](#macros) 
    * [Swapping Lines, Chars, and Words](#swapping-lines-chars-and-words) 
    * [Windows](#windows) 
* [Insert Mode](#insert-mode) 
    * [Insert Mode Completion](#insert-mode-completion) 
* [Visual Mode](#visual-mode) 
    * [Basic Operations](#basic-operations) 
    * [Highlingting Around (Inclusive)](#highlingting-around-inclusive) 
    * [Highlingting Inside (Non-Inclusive)](#highlingting-inside-non-inclusive) 
* [Select mode](#select-mode) 
    * [Commands in Select mode](#commands-in-select-mode) 
* [Ex Mode](#ex-mode) 
    * [Not Used by Default](#not-used-by-default) 
    * [Basic Keybindings](#basic-keybindings) 
    * [Ex Mode Completion](#ex-mode-completion) 
    * [Quick Insertion](#quick-insertion) 
* [Netrw](#netrw) 
    * [View / Opening Files](#view--opening-files) 
    * [Browsing](#browsing) 
    * [Modifying Files](#modifying-files) 
    * [Bookmarks](#bookmarks) 
    * [File Display / Information](#file-display--information) 



## Quickref
* `gf`: Go to file under cursor
* `gF`: Go to file under cursor and, if there's a number after the file name, 
        the cursor is positioned on that line in the file.
* `<C-w>gF`: Same as `gF`, but the file is opened in a new tab.  

* `gx`: Go to the filepath or URL under the cursor.
    * Uses the system default handler, by calling `vim.ui.open()`.
    * Returns (doesn't show) an error message on failure.
* `gue` will lowercase all characters from the cursor to the end of the word.
* `<C-a>`: Increment the number under the cursor.  
    * `g<C-a>` (visual): Increment the first number on each line in the selected area.  
* `<C-x>`: Decrement the number under the cursor.  
    * `g<C-x>` (visual): Decrement the first number on each line in the selected area.  


## Making Custom Keybindings  
>###### *:h map-precedence*  
>###### *:h map-arguments*  
>###### *:h key-notation*  


### Mapping Modes  
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
an 'input method editor' (IME) for non-english characters.  


### Special Mapping Arguments  
>##### *:h map-arguments*  

```vim  
nnoremap <buffer> <leader>sa rhs  
nnoremap <nowait> <leader>sa rhs  
nnoremap <silent> <leader>sa rhs  
nnoremap <script> <leader>sa rhs  
nnoremap <expr>   <leader>sa rhs  
nnoremap <unique> <leader>sa rhs  
```
These can be used in any order.  
They must appear right after the command, before any other arguments.  


### Clearing / Deleting Mappings  
```vim  
:unmap <buffer> ,w  
:mapclear <buffer>  
```

---  

## Normal Mode  

### Insert text at the same position on the line below/above  
The `CTRL-G j` and `CTRL-G k` commands can be used 
to insert text in front of a column.  
Example: 
```c  
int i;  
int j;  
```
Position the cursor on the first `int`, type `istatic <C-G>j       `.  
The result is: 
```c  
static int i;  
       int j;  
```
To insert the same text in front of the column in every line,
use the Visual blockwise command `I`.   
`:h v_b_I`.  


Using `CTRL-G u` splits undo: the text typed before and after it is undone separately.  
Using `CTRL-O` does the same thing after performing an action.  

### Toggling Case  
* `gUgU` / `gUU`: Make current line uppercase.  
* `gugu` / `guu`: Make current line lowercase.  
* `gU{motion}`: Make the text selected with `{MOTION}` uppercase  
* `gu{motion}`: Make the text selected with `{MOTION}` lowercase  

* `g?{MOTION}`: Rot13 encode/decode text selected by `{MOTION}`.  


### Editing Motions  
* `d/word`: Delete text up to a searched pattern  
* `d?word`: same as above, except deletes backwards to search term  

* `c/word`: Remove text up to a searched pattern and go into insert mode  
* `c?word`: same as above, except changes backwards to search term  

* `y/word`: Yank text up to a searched pattern  
* `y?word`: same as above, except yanks backwards to search term  

* `vib`: Go into visual mode and select inside parens (` ( ) `)  
* `viB`:  Go into visual mode and select inside braces (` { } `)  

* `ge`/`gE`: Go to the end of the previous `word` / `WORD` respectively.  

* `gv`: Select last visual selection.  

* `J`: Join the line below with the current line.  
* `gJ`: Like `J` but don't add a space between the joined lines.  

### Macros  
* `qa`: Start recording macro into register `a` (where `a` is any letter).  
    * `qA`: Start *appending* to the macro in register `a`.  
* `@a`: Execute macro in register `a`.  
* `Q`: Repeat last *recorded* macro.  
* `@@`: Repeat last *executed* macro.  


### Swapping Lines, Chars, and Words  
* `deep`: exchange two words (start with the cursor in the blank space before the first word).  
    * `dawelp`: Does the same thing but you can be anywhere inside the first word.  

### Windows  

* `<C-w><C-q>`: Close the current window.  
* `<C-w>hjkl`: Move to the window in the corresponding direction  
* `<C-w>r`: Rotate the position of the windows  


---  


## Insert Mode  

* `CTRL-D`: Unindent the current line  
* `CTRL-W`: Delete the previous word  
* `CTRL-U`: Delete all the text entered on the current line  
    * Deletes text only inserted since you went into insert mode.  
    * If you didn't enter any text, it deletes the whole line.  
* `CTRL-Y`: Insert the character **above** the cursor.  

### Insert Mode Completion  
* `CTRL-X {mode}`: enter `CTRL-X` sub mode (omni-completion)  
    * `i_CTRL-X_index`



---  



## Visual Mode  
##### *:h visual-index*  
##### *:h blockwise-operators*  
For Visual Block mode: `blockwise-operators`

### Basic Operations  
* `v_o` (`o`):     move cursor to other corner of area  
* `v_r` (`r`):     replace highlighted area with a character  
* `v_s` (`s`):     delete highlighted area and start insert  
* `v_u` (`u`):     make highlighted area lowercase  
* `v_U` (`U`):     make highlighted area uppercase  
* `v_x` (`x`):     delete the highlighted area  
* `v_y` (`y`):     yank the highlighted area  
* `v_~` (`~`):     swap case for the highlighted area  

* `{Visual}g?`: Rot13 encode/decode the selected text.  
* `gv`: Select last visual selection.  

### Highlingting Around (Inclusive)  
* `v_ab` (`ab`):     extend highlighted area with a () block  
* `v_aB` (`aB`):     extend highlighted area with a {} block  
* `v_ap` (`ap`):     extend highlighted area with a paragraph  
* `v_as` (`as`):     extend highlighted area with a sentence  
* `v_at` (`at`):     extend highlighted area with a tag block  
* `v_aw` (`aw`):     extend highlighted area with "a word"  
* `v_aW` (`aW`):     extend highlighted area with "a WORD"  

### Highlingting Inside (Non-Inclusive)  
* `v_iB` (`iB`):     extend highlighted area with inner {} block  
* `v_ib` (`ib`):     extend highlighted area with inner () block  
* `v_iW` (`iW`):     extend highlighted area with "inner WORD"  
* `v_iw` (`iw`):     extend highlighted area with "inner word"  
* `v_i[` (`i[`):     extend highlighted area with inner [] block  
* `v_i]` (`i]`):     same as i[  
* `v_ip` (`ip`):     extend highlighted area with inner paragraph  
* `v_is` (`is`):     extend highlighted area with inner sentence  
* `v_it` (`it`):     extend highlighted area with inner tag block  

## Select mode  
In Select mode, vim behaves more like a standard graphical editor.  
The same keybindings for motion you would use in a non-vim-enabled  
environment are applicable in Select mode.  

Entering select mode:  
* From Normal mode with:  
    * `gh` for character-wise selection  
    * `gH` for line-wise selection  
    * `g^H` for block-wise selection  
* From Insert mode with:  
    * `<C-o>` followed by one of the above commands.  
* From Visual mode with `<C-g>` (`v_CTRL-G`)  
    * `<C-g>` Toggles between Visual and Select  

The main movement keys for Select Mode are the same as other editors:  
* Cursor Keys  
    * `<Up>`
    * `<Down>`
    * `<Left>`
    * `<Right>`
* Nav Keys  
    * `<Home>`
    * `<End>`
    * `<PageUp>`
    * `<PageDown>`

### Commands in Select mode:  
* Non-movement characters (without `<C-char>`) delete the selection.  
    * The typed character is inserted.  
* Non-printable movement commands, with the Shift key pressed, extend the  
  selection.  
    * `keymodel` must include `startsel`.  
* Non-printable movement commands, with the Shift key NOT pressed,
  stop Select mode.  
    * `keymodel` must include `stopsel`.  
    * Otherwise, extends selection.  
* ESC stops Select mode.  
* `CTRL-O` switches to Visual mode for the duration of one command.  
* `CTRL-G` switches to Visual mode.  
* `CTRL-R` {register} selects the register to be used for the text that is  
  deleted when typing text.  
    * Unless you specify the `_` (black hole) register, the unnamed register is  
      also overwritten.  

---  

## Ex Mode  

### Not Used by Default  
* CTRL-O:  not used - available for keymapping  
* CTRL-X:  not used (reserved for completion)  
* CTRL-Z:  not used (reserved for suspend)  

### Basic Keybindings  

* `c_CTRL-B` (`CTRL-B`):  cursor to start of command-line  
* `c_CTRL-E` (`CTRL-E`):  cursor to end of command-line  
* `c_<Home>` (`<Home>`):  cursor to start of command-line  
* `c_<End>`  (`<End>`):  cursor to end of command-line  

* `c_CTRL-G` (`CTRL-G`):  next match when 'incsearch' is active  

* `c_CTRL-J` (`CTRL-J`):  same as( `<CR>`)  
* `c_CTRL-[` (`CTRL-[`):  same as( `<Esc>`)  

* `c_CTRL-\_CTRL-N` (`CTRL-\ CTRL-N`): go to Normal mode, abandon command-line  
* `c_CTRL-\_CTRL-G` (`CTRL-\ CTRL-G`): go to Normal mode, abandon command-line  
* `c_<Insert>` (`<Insert>`): toggle insert/overstrike mode  
* `c_<LeftMouse>` (`<LeftMouse>`): cursor at mouse click  

* `c_<Up>` (`<Up>`):  recall previous command-line from history that  
                      matches pattern in front of the cursor  
* `c_<S-Up>` (`<S-Up>`):  recall previous command-line from history  
* `c_<Down>` (`<Down>`):  recall next command-line from history that  
                          matches pattern in front of the cursor  
* `c_<S-Down>` (`<S-Down>`): recall next command-line from history  


### Ex Mode Completion  
* `c_wildchar`: 'wildchar' Do completion on the pattern in front of the  
                           cursor (default:`<Tab>`)  
* `c_<Tab>` (`<Tab>`):  if 'wildchar' is (`<Tab>`): Do completion on  
                        the pattern in front of the cursor  
* `c_CTRL-I` (`CTRL-I`):  same as `<Tab>`
* `c_CTRL-L` (`CTRL-L`):  do completion on the pattern in front of the  
                          cursor and insert the longest common part  
* `c_CTRL-N` (`CTRL-N`):  
    * after using 'wildchar' with multiple matches: go to next match  
    * otherwise: recall older command-line from history.  
* `c_CTRL-P` (`CTRL-P`):  
    * after using 'wildchar' with multiple matches: go to previous match  
    * otherwise: recall older command-line from history.  
* `c_<S-Tab>` (`<S-Tab>`):  same as (`CTRL-P`)  

### Quick Insertion  
* `c_CTRL-R_CTRL-W` (`CTRL-R CTRL-W`): 
    * Places the current word under cursor onto the command line  
* `c_CTRL-R_CTRL-L` (`CTRL-R CTRL-L`): 
    * Places the entire line under cursor onto the command line  
* `c_CTRL-W` (`CTRL-W`):  delete the word in front of the cursor  
* (`CTRL-Y`)  copy (yank) modeless selection  
* `c_CTRL-R` (`CTRL-R {regname}`): insert the contents of a register or object  
                                    under the cursor as if typed  
* `c_CTRL-R_CTRL-R` (`CTRL-R CTRL-R {regname}`):  
* `c_CTRL-R_CTRL-O` (`CTRL-R CTRL-O {regname}`): insert the contents of a register or object  
                                                    under the cursor literally  

* Special Registers for `<C-r>`/`CTRL-R`:  
    * `CTRL-F`:  the Filename under the cursor  
    * `CTRL-P`:  the Filename under the cursor, expanded with `path` as in `gf`
    * `CTRL-W`:  the Word under the cursor  
    * `CTRL-A`:  the WORD under the cursor; see `WORD`
    * `CTRL-L`:  the line under the cursor  

* `c_CTRL-\_e` (`CTRL-\ e {expr}`): replace the command line with the result of {expr}
* `c_CTRL-]` (`CTRL-]`):  trigger abbreviation (Doesn't work?)  





## Netrw  

### View / Opening Files  
* `i`: Cycle through the different listing styles.  
* `o`: Opens file under cursor in horizontal split.  
* `v`: Opens file under cursor in vertical split.  
* `t`: Opens file under cursor in a new tab.  
* `gx`: Open file with an external program  
    * This can be disabled by setting the `g:netrw_nogx` variable.  

### Browsing  
Changing the current directory (or working directory):  
* `gn`: Change the "tree top" to the word below cursor (see `:Ntree`)  
* `u`/`U`: Jump to previous/next directory in browsing history.  
    * Change `g:netrw_dirhistmax` to increase the amount of directories saved. (default 10)  
* `-`: Go up a directory (`../`)  

### Modifying Files  
* `D`: Delete marked files/directories (and empty directories). 
       If no files are marked, delete the file/directory under the cursor.  
    * Delete files matching a pattern: `:MF pattern`, then `D`
* `gp`: Ask for new permission for the file under cursor.  
    * Uses `g:netrw_chgperm`. Default: `chmod PERM FILENAME` 
      (Windows: `cacls FILENAME /e /p PERM`)  
* `X`: When pressed when cursor is above an executable, it will prompt the  
       user for arguments. Netrw will call `system()` with that cmd and args.  

### Bookmarks  
* `mb`: Bookmark the currently browsed directory.  
    * Stored in `.netrwbook` (in the `g:netrw_home` directory).  
* `mB`: Remove the currently browsed directory from bookmarks.  
* `qb`: List bookmarks and history  
* `{cnt}gb`: Go to `{cnt}` bookmark.  
* Also available: `:NetrwMB[!] [files/directories]`
    * No Argument (and in netrw buffer):  
        * Adds marked files to bookmarks.  
        * Else, adds file/directory under cursor.  
    * With arguments: `glob()` each arg and bookmark them.  
    * With bang (`!`): Removes files/directories from bookmarks.  

### File Display / Information  
* `qf`: Get file's size and last modification timestamp.  
* `S`: Specify priority via sorting sequence (`g:netrw_sort_sequence`).  
* `gh`: Toggle between hiding the "dotfiles" and not.  
* `a`: Toggle through three hiding modes. Set the hiding list with `<C-h>`
* `<Ctrl-H>`: Brings up a requestor allowing user to change the 
  file/directory hiding list in `g:netrw_list_hide`.  



