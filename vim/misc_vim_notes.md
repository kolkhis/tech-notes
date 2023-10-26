
# Misc Vim Notes

### Special Characters (Diagraphs)

* `i_<C-k>` + 2 letters will output a special character.
* `:h default-diagraphs`
* `:h diagraphs`


* `:h visual-search`


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
* `/pattern/`: 	next line where pattern matches
* `?pattern?`: 	previous line where pattern matches
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
`:h options `

`:h emoji`  
`emoji`	emoji characters are full width  
 	set emo	noemo  

`splitkeep`	determines scroll behavior for split windows  
 	set cursorspk	spk  

`clipboard`	"unnamed" to use the * register like unnamed register  
	"autoselect" to always put selected text on the clipboard  
 	set cb=unnamedplus  

`backspace`	specifies what <BS>, CTRL-W, etc. can do in Insert mode  
 	set bs=indent,eol,start  

`complete`	specifies how Insert mode completion works for CTRL-N and CTRL-P  
	(local to buffer)  
 	set cpt=.,w,b,u,t  
`completeopt`	whether to use a popup menu for Insert mode completion  
 	set cot=menuone,noselect,  


#### More Tab Options
`vartabstop`	list of number of spaces a tab counts for  
	(local to buffer)  
 	set vts=  
`varsofttabstop`	list of number of spaces a soft tabsstop counts for  
	(local to buffer)  
 	set vsts=  

##### Formatting Options For `gq`
`formatexpr`	expression used for "gq" to format lines  
	(local to buffer)  
 	set fex=v:lua.vim.lsp.formatexpr()  

#### Undo Options
`undolevels`	maximum number of changes that can be undone  
	(global or local to buffer)  
 	set ul=1000  
`undofile`	automatically save and restore undo history  
 	set udf	noudf  
`undodir`	list of directories for undo files  
 	set udir=/home/kolkhis/.local/state/nvim/undo//  
`undoreload`	maximum number lines to save for undo on a buffer reload  
 	set ur=10000  

### Misc `:!{cmd}` Notes
Any "%" in {cmd} is expanded to the current file name.  
Any "#" in {cmd} is expanded to the alternate file name.  
Special characters are not escaped, use quotes or  
|shellescape()|: >  
    :!ls "%"  
    :exe "!ls " .. shellescape(expand("%"))  

To avoid the hit-enter prompt use: >  
    :silent !{cmd}  

Repeat last ":!{cmd}".  
    :!!  

### Recursive Macros
* <Position my cursor where I want to make the first change>  
* `qa` - start recording into register 'a'
* <Make all my changes, doing it in a way that should apply cleanly to all locations>
* `q` - stop recording
* <Position cursor on next location I want changed>
* `@a` - run the macro to test and make sure it works as intended
* `qA` - start recording to append to macro register 'a'
* <Move cursor to next location to change>
* `@a`
* `q`

##### More from the author of the Recursive macro tip
Now, if I call it again, register 'a' contains a macro that does my change, moves to the next spot, and then calls itself again.  
It will run repeatedly until it encounters an error.  
This could be trying to move past the end of the buffer, finding no matches for a search, search hitting the end of buffer if 'nowrapscan' is set, or any other command failure indicating all the changes are complete.  
Quick and easy way to process an entire file!  

The other thing I want to mention is more fundamental: text-objects.  
I hesitate to mention it because you said "uncommon commands" and I hope everyone using Vim already knows about those and uses them constantly.  
But in case you don't know about them, go find them in the help and change your life.  
You'll get to do things like "=aB" to re-indent an entire C-style code block (from anywhere in the block) or "cit" to delete everything within the current XML tag and drop you into insert mode ready to add new content.  
Note these also combine really well with macro techniques mentioned above, as well.  



### Using the `=` Register for Formulas
Using the = register to calculate numeric inputs for motions.  

For example @=237*8<cr><c-a> to increment a value by 237*8.  

There are a number of ways to go about this and it might seems odd but I use it surprisingly often.  

Also I don’t think many people make use of onoremap or omap for operator pending mode, basically to expand your set of motions (eg define in( to work just like i( but on the next pair of parens).  

I don’t find myself using zg or zug or the other variants for modifying spellcheck, but I guess I don’t use spell check too often.  

I find gi helpful and didn’t use it for the longest time.  
Also <c-a> and <c-d> in Ex mode for autocompleting all strings or showing a list (when you don’t set list in wildmode).  
I think :~ is not so common either.  
I never use virtual replace mode gR.  

Some commands I do use quite often that might be less common are :@“ to run an ex command that I copied from some buffer,  
 mainly for testing changes to my vimrc, @: to rerun the last ex command   
  (I abuse makeprg and use make to do a lot of testing, and sometimes I need to repeat lest run one script to test against another).  
I don’t think going into ex mode via Q is too common, but q: is handy for modifying ex history.  
But I don’t know, maybe everyone else uses these regularly, I guess it depends on your work flow.  




### Function author for a quick search type thing
I wrote an operator mapping I activate by <leader>/ that takes the result of the motion and sets the search register to it.  
For example, hitting <leader>/i( will search for the string currently in the parentheses where the cursor is.  

I'm on a mobile right now so can't share it, but grab any of your existing mappings for o mode and just set @/ to the captured text.  
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

