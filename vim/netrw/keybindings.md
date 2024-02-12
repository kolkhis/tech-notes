
# Netrw Keybindings

## Table of Contents
* [Netrw Keybindings](#netrw-keybindings) 
* [Default Keybindings](#default-keybindings) 
    * [View / Opening Files](#view-/-opening-files) 
    * [Browsing](#browsing) 
    * [Modifying Files](#modifying-files) 
    * [Bookmarks](#bookmarks) 
    * [File Display / Information](#file-display-/-information) 
* [User Specified Maps/Keybindings in netrw](#user-specified-maps/keybindings-in-netrw) 
* [Related Topics / Variables](#related-topics-/-variables) 


## Default Keybindings

### View / Opening Files
* `i`: Cycle through the different listing styles.
* `o`: Opens file under cursor in horizontal split.
* `v`: Opens file under cursor in vertical split.
* `t`: Opens file under cursor in a new tab.
* `gx`: Open file with an external program
    * This can be disabled by setting the `g:netrw_nogx` variable.

### Browsing
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


## User Specified Maps/Keybindings in netrw
> ##### *:h netrw-usermaps*

Custom user maps can be added.  
Make a variable (`g:Netrw_UserMaps`), to hold a List of lists (nested lists)  
```vim
let g:Netrw_UserMaps = [["keymap-sequence","ExampleUserMapFunc"],
                      \ ["keymap-sequence","AnotherUserMapFunc"]]
```
* Vim will go through all entries of `g:Netrw_UserMaps`, and set up maps:
```vim
nno <buffer> <silent> KEYMAP-SEQUENCE
:call s:UserMaps(islocal,"ExampleUserMapFunc")
```
* refreshes if result from that function call is the string
  "refresh"
* if the result string is not "", then that string will be
  executed (`:exe result`)
* if the result is a List, then the above two actions on results
  will be taken for every string in the result List

The user function is passed one argument; it resembles
```vim
fun! ExampleUserMapFunc(islocal)
```
where `a:islocal` is 1 if it's a local-directory system call or 0 when
remote-directory system call.





## Related Topics / Variables
* see cmdline-window




