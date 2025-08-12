# `read`

The `read` builtin utility is used to parse input into a variable.  

One of its most common uses is to get input from a user via `stdin`, but it can be
used in other ways as well.  


## Using `read`

### Getting User Input

Typically when prompting for user input, you'd use `read`.  

```bash
#!/bin/bash

declare MY_VAR

read -r -p "Enter input: " MY_VAR

printf "You entered: %s\n" "$MY_VAR"
```

- `read -r -p "Enter input: " MY_VAR`:
    - `-r`: Do not expand escape sequences (e.g., `\n`)
    - `-p "Enter input: "`: Show this prompt to the user (`Enter input: `).  
    - `MY_VAR`: The variable name to save the input into.  

This is a very simple way to interactively get input from a user and save it into a
variable.  

### Reading Programmatically with `read`

The `read` builtin can also be used to parse lines into an array.  

To do so, you direct an input stream to `read` via `stdin`, either via pipe (`|`) or
input redirection (`<`).  
```bash
#!/bin/bash

declare MY_FILE='./file.txt'
declare -a LINES
IFS=$'\n' read -r -d '' -a LINES < "$MY_FILE"

printf "File: %s\n" "${LINES[@]}"
```

- `IFS=$'\n'`: Set the internal field separator to a newline so elements are read
  into the array line-by-line.  
- `-d ''`: This tells `read` to read until end of file (EOF), rather than end of line (EOL).  
- `-a LINES`: Specify the array to read into.  



