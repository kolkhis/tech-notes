

# Tab Pages in Vim
##### *:h tabpage*  

## Table of Contents
* [Tab Pages in Vim](#tab-pages-in-vim) 
* [Opening multiple files in tabs](#opening-multiple-files-in-tabs) 
* [Closing a tab page](#closing-a-tab-page) 

## Opening multiple files in tabs

1. When starting Vim: `vim -p filename ...` opens each file argument in a separate
   tab page (up to `'tabpagemax'`). 
    * `-p [n]`: Sets the number of tab pages to open. 
        * If `n` is not specified, opens each file in its own tab.

1. `:tabedit [filename]`: Opens a file in a new tab page.
    * Aliases `:tabe`, `:tabnew`,

1. `:tabfind {file}`: Open a new tab page and edit `{file}` in `'path'`, 
                      like with `:find`. 

1. `:tab {cmd}`: Execute `{cmd}`, and when `{cmd}` opens a new window, open a new tab
                 page instead. 


1. `CTRL-W gf`: Open a new tab page and edit the file name under the cursor.
    * Similar to `gf` but opens the file in a new tab.

1. `CTRL-W gF`: Open a new tab page and edit the file name under the cursor,
                and jump to the line number following the file name.
    * Similar to `gf` but also jumps to the line number following the file name.


A note about `gF`:
White space between the filename, the separator and
the number are ignored.
Examples:
```plaintext
eval.c:10 ~
eval.c @ 20 ~
eval.c (30) ~
eval.c 40 ~
```

## Closing a tab page

1. `:tabclose[!]`: Close current tab page.
    * Aliases: `:tabc`
    * Can provide a `count` to close multiple tab pages. (`:tabclose {count}`)

Examples:
| Command        |  Description
|-|-
| `:-tabclose`   |  Close the previous tab page
| `:+tabclose`   |  Close the next tab page
| `:1tabclose`   |  Close the first tab page
| `:$tabclose`   |  Close the last tab page
| `:tabclose -2` |  Close the 2nd previous tab page
| `:tabclose +`  |  Close the next tab page
| `:tabclose 3`  |  Close the third tab page
| `:tabclose $`  |  Close the last tab page
| `:tabclose #`  |  Close the last accessed tab page

1. `:tabonly[!]`: Close all other tab pages.
    * This also accepts a `{count}` argument.
        * `:tabonly {count}` closes all tab pages except `{count}`

Examples:
| Command        |  Description
|-|-
| `:.tabonly`   |  Close all tabs except current tab  
| `:-tabonly`   |  Close all tabs except the previous one
| `:+tabonly`   |  Close all tabs except the next one
| `:1tabonly`   |  Close all tabs except the first one
| `:$tabonly`   |  Close all tabs except the last one
| `:tabonly -`  |  Close all tabs except the previous one
| `:tabonly +2` |  Close all tabs except the two next one
| `:tabonly 1`  |  Close all tabs except the first one
| `:tabonly $`  |  Close all tabs except the last one
| `:tabonly #`  |  Close all tabs except the last accessed one






`:tabnext`, `:tabfirst`, `:tablast`.
