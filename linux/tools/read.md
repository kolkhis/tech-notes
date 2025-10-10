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


## Reading Multiple Values at a Time

We can use `read` to split up lines into different variables.  
```bash
read -r name age <<< "paul 50"
echo "Name: $name, Age: $age"
# output: 
# Name: paul, Age: 50
```
This is useful if you want to read in multiple variables from lines that are
separated into columns (without using `awk` or `cut`).  

For instance, if we wanted to utilize this to loop over lines with two columns:
```bash
tmpfile="$(mktemp)"
cat << EOF > "$tmpfile"
paul 50
jack 22
anna 30
tara 45
EOF

while read -r name age; do
    echo "Name: $name, Age: $age"
done < "$tmpfile"
```

This separates the elements based on the `IFS` value, which includes whitespace
by default.  

If we set IFS to null, it would not work as intended.
```bash
IFS= read -r name age <<< "paul 50" # BAD
echo "Name: $name, Age: $age"
# Output:
# Name: paul 50, Age:
```

If we want to be specific, and ensure that the two columns are split up into
their respective variables, we can set the IFS to a space just for the `read`
command.
```bash
IFS=' ' read -r name age <<< "paul 50"
```
This will guarantee that the line gets split on spaces.  

If we also wanted to include tabs to account for different types of whitespace,
we could add that to IFS as well.  
```bash
IFS=$' \t' read -r name age <<< "paul 50"
```

!!! note "ANSI-C Quoting"

    When setting the IFS to characters like tab (`\t`), use ANSI-C quoting
    (`$'...'`) to make sure it's interpreted correctly, as a literal tab character 
    instead of the literal `\t` characters.  

    [More about ANSI-C Quoting here](../bash/ansi-c-quoting.md).  

