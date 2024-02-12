
# The Buffer List in Vim

## Table of Contents
* [The Buffer List in Vim](#the-buffer-list-in-vim) 
* [Buffer List](#buffer-list) 
* [Alternate File in Vim](#alternate-file-in-vim) 
        * [*:h alternate-file*](#*h-alternate-file*) 
* [Buffer List Commands](#buffer-list-commands) 
    * [Buffer Types](#buffer-types) 

## Buffer List
Use `:ls` (or `:files`, or `:buffers`) to see the buffer list.  

In vim's buffer list (`:ls`), there's a current file and alternate file.
* The current buffer is represented with `%`.
* The alternate buffer is represented with `#`.

## Alternate File in Vim
#### *:h alternate-file*

When there's more than one buffer loaded, you'll have an alternate file.


It can be represented with `#` on the command line.
The `CTRL-^` command toggles between the current and the alternate file.


```help
%	Is replaced with the current file name.		  *:_%* *c_%*
#	Is replaced with the alternate file name.	  *:_#* *c_#*
This is remembered for every window.
#n	(where n is a number) is replaced with		  *:_#0* *:_#n*
the file name of buffer n.  "#0" is the same as "#".     *c_#n*
##	Is replaced with all names in the argument list	  *:_##* *c_##*
concatenated, separated by spaces.  Each space in a name
is preceded with a backslash.
#<n	(where n is a number > 0) is replaced with old	  *:_#<* *c_#<*
file name n.  See |:oldfiles| or |v:oldfiles| to get the
number.							*E809*
```
## Buffer List Commands

* `:bad {fname}` / `:badd {fname}`:  Add a file to the buffer list without 
  loading it, if it wasn't listed yet. (Pneumonic: Buffer Add)  
    * You can specify a line number to go to when it's first entered.
    * `:bad 16 file.txt` will go to line 16 of `file.txt` when you first enter it.
* `:balt {fname}`: Same as `:badd`, but also set the `alternate file` for the current
                   window to `{fname}`. (Pneumonic: Buffer Alternate)

* `:b`: Edit buffer given by number, name, or partial name.
* `:sb`: Like `:b` but edit in a split.
* `:br`/`:bf`: Go to the first buffer in the buffer list.  
    * `:sbr`/`:sbf`: Same as above but do it in a split.  
* `:bl`: Go to the last buffer in the buffer list.  
    * `:sbl`: Same as above but do it in a split.  
* `:bm`: Go to the next buffer that has been modified.  
    * You can specify a number and go to the `n`th modified buffer.
    * Also finds buffers not in the buffer list. 
* `:unhide`: Rearranges the screen to open one window for each loaded buffer in the buffer list.
* `:ba`/`:ball` Rearrange the screen to open one window for each buffer in the buffer list.
    * When a count is given, this is the maximum number of windows to open.  

### Buffer Types
There are different buffer types, here are a few:
* quickfix
* help
* terminal
* directory
* scratch
* unlisted

