# The Line-based Editor, `ed`

`ed` is on almost every Linux machine.  


## Editing with `ed`
Editing is done in two modes: `command` and `input`.
`ed` is in command mode when it's first started.

* Command mode is similar to vim's command mode. Substitutions can be made:
  ```plaintext
  ,s/OLD/NEW/g
  ```
  which replaces all occurences of the string OLD with NEW.
    * The `,` is equivalent to vim's `%`.  
* Input mode reads stdin and writes it directly to the buffer.  


## `ed` Commands


* `q`: Exit 
* `P`: Starts the prompt. Sort of like command mode in vim.  
    * You can run shell commands from here, prefixing with `!` (like vim filters)

All `ed` commands operate over single lines or a range of lines.  

* `d`: deletes lines
* `m`: moves lines

To only modify a portion of a single line, you'd need to use a replacement command (`s`)



`ed` commands consist of optional line addresses, followed by a single character 
command, and sometimes additional parameters;
```plaintext
[Line[,Line]]Command[Parameters]
```
The `Line`s indicate the line or range of lines to be affected by the command.
If fewer addresses are given than the command accepts, then default addresses are used.



### Prompt-mode Commands
* `r`: Reads input into the editor buffer.  
* `<range>p`: Prints the specified range to the terminal
    * `,p` (using a comma) is shorthand for "the whole buffer"


## Input Commands
Input commands make `ed` enter input mode. 
These commands are the main way to add text to a file.  

* Input Commands: 
    * `a`: Append
    * `i`: Insert 
    * `c`: Change

In insert mode, no commands are available.  
Stdin is written directly to the buffer.  

Exit input mode by entering a single dot `.` on a line.  




