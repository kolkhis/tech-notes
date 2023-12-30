

# Vim Script Functions

### line()
Get a line number from the given position.  
```vim
line('.')  " get current line number
```
Other accepted positions:
* `$`:  the last line in the current buffer
* `'x`: position of mark `x` (if the mark is not set, `0` is returned)
* `w0`: first visible line in current window 
* `w$`: last visible line in current window 
* `v`:  In Visual mode: the start of the Visual area (the cursor is the end). 
    * Differs from `'<` in that it's updated right away.
