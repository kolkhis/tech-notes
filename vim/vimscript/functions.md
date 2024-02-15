

# Vim Script Functions

## Builtin Functions
There are a number of builtin functions in Vimscript that can be used to get info
on the state of the editor.  

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


## Custom Functions


```vim
function! IsMarkdownHeader()
    " Get the current line number
    let lnum = line('.')

    " Check if the current line starts with a '#'
    let line = getline(lnum)
    if line =~ '^\s*#'
        " Iterate from the current line upwards to find if it's inside a code block
        let inCodeBlock = 0
        while lnum > 0
            let lnum -= 1
            let prevLine = getline(lnum)
            " Check for the start/end of a code block
            if prevLine =~ '^```'
                let inCodeBlock = !inCodeBlock
            elseif prevLine =~ '^\s*```'
                " This handles the case where code blocks might be indented
                let inCodeBlock = !inCodeBlock
            endif
        endwhile

        " If not in a code block, it's a header
        if !inCodeBlock
            echo "This is a Markdown header."
            return 1
        else
            echo "This is within a code block."
            return 0
        endif
    else
        echo "This line does not start with a header marker."
        return 0
    endif
endfunction

```


