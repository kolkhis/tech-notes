# `read`

The `read` utility is used to parse input into a variable.  

One of its most common uses is to get input from a user via `stdin`.  


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

This is a very simple way to interactively get input from a user.  


