
# Netrw Keybindings

## User Specified Maps in netrw
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
