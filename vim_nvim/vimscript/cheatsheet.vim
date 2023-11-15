
" AUTOCOMPLETE:
" The good stuff is documented in |ins-completion|
" HIGHLIGHTS:
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our path trick!)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option
" NOW WE CAN:
" - Use ^n and ^p to go back and forth in the suggestion list


" SNIPPETS:
" Read an empty HTML template from a file and move cursor to title
nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a



" FILE BROWSING:
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'



" PATTERN:
" ( :h '[ , :h \_. , :h \%<'m )
"
".\\%>'\\[\\_.*\\%<'].."
" Since this is in a string, the backslashes need to be escaped as well.
" . matches any char (current) 
" '[ is the mark that matches the first char of the last changed or yanked text, 
"       but needs to be escaped (`:h /[]`)
"       '] does the same for the last char of the last changed/yanked text.
" \%>'m matches after the position of mark m. ( \%>'\[ )
" the `.` atom doesn't match EOL, so I need `\_.` instead. (`:h \_.`)
" \%<'m matches before the position of mark m. ( \%<'\] )
" two dots are required to include mark '] in the match


" TIMER:
" :h timer_start
" Takes a time in ms, and a callback (function to run after the specified time)

" AUTOCMD_EVENTS:
" :h autocommand-events
" :h autocmd-events-abc
" Vim ignores the case of event names
" (e.g., you can use "BUFread" or "bufread" instead of "BufRead").
" CompleteChanged: 
" After each time the Insert mode completion manu changed.
"                   - not triggered on popup menu hide
" Sets these |v:event| keys:
"     completed_item	See |complete-items|.
"     height		nr of items visible
"     width		screen cells
"     row			top screen row
"     col			leftmost screen column
"     size		total nr of items
"     scrollbar		TRUE if visible


