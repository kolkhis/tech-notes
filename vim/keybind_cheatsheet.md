
# Vim Keybindings, Hotkeys & Shortcuts

## Making Custom Keybindings
>###### *:h map-precedence*
>###### *:h map-arguments*
```vim
nnoremap <buffer> <leader>sa rhs
nnoremap <nowait> <leader>sa rhs  
nnoremap <silent> <leader>sa rhs
nnoremap <script> <leader>sa rhs
nnoremap <expr>   <leader>sa rhs
nnoremap <unique> <leader>sa rhs
" Getting help: :h map-buffer, :h map-nowait, etc
```
These can be used in any order.  
They must appear right after the command, before any other arguments.  

### Clear Mappings
```vim
:unmap <buffer> ,w
:mapclear <buffer>
```

---

## Normal Mode

### Toggling Case
* `gUgU` / `gUU`: Make current line uppercase.
* `gugu` / `guu`: Make current line lowercase.
* `gU{motion}`: Make the text selected with `{MOTION}` uppercase
* `gu{motion}`: Make the text selected with `{MOTION}` lowercase


* `g?{MOTION}`: Rot13 encode {motion} text.


---

## Visual Mode
##### *:h visual-index*

### Basic Operations
* `v_o`: (`o`)     move cursor to other corner of area
* `v_r`: (`r`)     replace highlighted area with a character
* `v_s`: (`s`)     delete highlighted area and start insert
* `v_u`: (`u`)     make highlighted area lowercase
* `v_U`: (`U`)     make highlighted area uppercase
* `v_x`: (`x`)     delete the highlighted area
* `v_y`: (`y`)     yank the highlighted area
* `v_~`: (`~`)     swap case for the highlighted area

* `{Visual}g?`: Rot13 encode the highlighted text (for {Visual} see

### Highlingting Around (Inclusive)
* `v_ab`: (`ab`)     extend highlighted area with a () block
* `v_aB`: (`aB`)     extend highlighted area with a {} block
* `v_ap`: (`ap`)     extend highlighted area with a paragraph
* `v_as`: (`as`)     extend highlighted area with a sentence
* `v_at`: (`at`)     extend highlighted area with a tag block
* `v_aw`: (`aw`)     extend highlighted area with "a word"
* `v_aW`: (`aW`)     extend highlighted area with "a WORD"

### Highlingting Inside (Non-Inclusive)
* `v_iB`: (`iB`)     extend highlighted area with inner {} block
* `v_ib`: (`ib`)     extend highlighted area with inner () block
* `v_iW`: (`iW`)     extend highlighted area with "inner WORD"
* `v_iw`: (`iw`)     extend highlighted area with "inner word"
* `v_i[`: (`i[`)     extend highlighted area with inner [] block
* `v_i]`: (`i]`)     same as i[
* `v_ip`: (`ip`)     extend highlighted area with inner paragraph
* `v_is`: (`is`)     extend highlighted area with inner sentence
* `v_it`: (`it`)     extend highlighted area with inner tag block


---

## Ex Mode

### Not Used by Default
* CTRL-O:  not used - available for keymapping
* CTRL-X:  not used (reserved for completion)
* CTRL-Z:  not used (reserved for suspend)

### Basic Keybindings

* `c_CTRL-B`: (`CTRL-B`)  cursor to start of command-line
* `c_CTRL-E`: (`CTRL-E`)  cursor to end of command-line

* `c_<Home>`: (`<Home>`)  cursor to start of command-line
* `c_<End>`: (`<End>`)  cursor to end of command-line
* `c_CTRL-G`: (`CTRL-G`)  next match when 'incsearch' is active

* `c_<Delete>`: (`<Delete>`)  delete the character under the cursor
* `c_<BS>`: (`<BS>`)  delete the character in front of the cursor
* `c_CTRL-H`: (`CTRL-H`)  same as( `<BS>`)
* `c_CTRL-J`: (`CTRL-J`)  same as( `<CR>`)
* `c_<Esc>`: (`<Esc>`)  abandon command-line without executing it
* `c_CTRL-[`: (`CTRL-[`)  same as( `<Esc>`)
* `c_CTRL-\_CTRL-N`: (`CTRL-\ CTRL-N`) go to Normal mode, abandon command-line
* `c_CTRL-\_CTRL-G`: (`CTRL-\ CTRL-G`) go to Normal mode, abandon command-line

* `c_<Up>`: (`<Up>`)  recall previous command-line from history that
                      matches pattern in front of the cursor
* `c_<S-Up>`: (`<S-Up>`)  recall previous command-line from history
* `c_<Down>`: (`<Down>`)  recall next command-line from history that
                          matches pattern in front of the cursor
* `c_<S-Down>`: (`<S-Down>`) recall next command-line from history
* `c_<Insert>`: (`<Insert>`) toggle insert/overstrike mode
* `c_<LeftMouse>`: (`<LeftMouse>`) cursor at mouse click

### Completion
* `c_wildchar`: 'wildchar' Do completion on the pattern in front of the
                           cursor (default:`<Tab>`)
* `c_<Tab>`: (`<Tab>`)  if 'wildchar' is (`<Tab>`): Do completion on
                        the pattern in front of the cursor
* `c_CTRL-I`: (`CTRL-I`)  same as <Tab>
* `c_CTRL-L`: (`CTRL-L`)  do completion on the pattern in front of the
                          cursor and insert the longest common part
* `c_CTRL-N`: (`CTRL-N`)  after using 'wildchar' with multiple matches:
                          go to next match, otherwise: recall older
                          command-line from history.
* `c_CTRL-P`: (`CTRL-P`)  after using 'wildchar' with multiple matches:
                          go to previous match, otherwise: recall older
                          command-line from history.
* `c_<S-Tab>`: (`<S-Tab>`)  same as (`CTRL-P`)

### Quick Insertion
* `c_CTRL-R_CTRL-W`: (`CTRL-R CTRL-W`) 
    Places the current word under cursor onto 
    the command line
* `c_CTRL-R_CTRL-L`: (`CTRL-R CTRL-L`) Places the entire line under cursor onto 
                                       the command line
* `c_CTRL-W`: (`CTRL-W`)  delete the word in front of the cursor
* (`CTRL-Y`)  copy (yank) modeless selection
* `c_CTRL-R`: (`CTRL-R {regname}`) insert the contents of a register or object
                                    under the cursor as if typed
* `c_CTRL-R_CTRL-R`: (`CTRL-R CTRL-R {regname}`)
* `c_CTRL-R_CTRL-O`: (`CTRL-R CTRL-O {regname}`) insert the contents of a register or object
                                                    under the cursor literally
* `c_CTRL-\_e`: (`CTRL-\ e {expr}`) replace the command line with the result of {expr}
* `c_CTRL-]`: (`CTRL-]`)  trigger abbreviation (Doesn't work?)

