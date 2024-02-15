

# Line Manipulation in Vim



## Functions for Retrieving Line Positions

* To get the line number use `line()`.
* To get both line number and column, use `getpos()`.
* For the screen column position use `virtcol()`.
* For the character position use `charcol()`.
* For the cursor position use `getcurpos()`.

### col()
Syntax:
```vim
col({position} [, {window_id}])
```
#### Accepted positions:
* `.`: The cursor position
* `$`: The end of the cursor line (the result is the number of bytes in the cursor line plus one)
* `'x`: position of mark x (if the mark is not set, returns `0`)
* `v`: In Visual mode: the start of the Visual area (the cursor is the end).
    * When not in Visual mode returns the cursor position.
    * Differs from `'<` in that it's updated right away.
* `{position}` can be `[lnum, col]`: a `List` with the line and column number.
    * Most useful when the column is "$", to get the last column of a specific line.
    * When `lnum` or `col` is out of range then `col()` returns `0`.

#### Returns:
The result is a Number: the byte index of the column position given with `{position}`.
The first column is `1`.
Returns `0` if `{position}` is invalid or when the window with ID `{window_id}` is not found.

---

