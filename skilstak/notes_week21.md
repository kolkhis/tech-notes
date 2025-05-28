


## Infinite Loops
A simple infinite loop that will show the date and clear the screen over and over
```bash
while true; do date; sleep 0.2; clear; done
```
The same for the weather (this is a custom script):
```bash
while true; do weather; sleep 60; clear; done
```


### Badgers (doing a while loop only a certain number of times)

Note: Floating point number calculations aren't supported by bash/sh itself, should use `bc` or
another tool for it.

```bash
#!/bin/bash
# !! <- shortcut for :.! 
# :.!termcolors
black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
white="\e[37m"
reset="\e[0m"


count=1
while [ $count -le 12 ]; do   # This is the POSIX-compliant way of doing this (this is the same as `while test`)
    echo badgers
    sleep 0.3
    # count+=1  # This is the shorthand
    count=$(( $count+1 ))  # Arithmetic expressions must be done in this way: $(( expression ))
done

# This is a Bash-only for-loop
for ((count=1; count<=2; count++)); do
    printf "%s mushrooms!\n" "$yellow$count"
    sleep 0.6
done
```

## Locals and Declarations (`local` and `declare` keywords)
These are builtins:
```bash
help local
help declare
```

### Locals (`local`)
> The `local` keyword is BASH-ONLY
The `local` keyword can only be used within functions to create
variables that are only available within a function (local scope). 
```bash
output () {
    local -i max=$1  # Local Scope Integer (-i)
}
```
Multiple locals of the **SAME TYPE** can be assigned on the same line:
```bash
output () {
    local -i max=$1
    local sec=$2 color=$3 string=$4  # Local Scope Strings
}
```

### Declarations (`delcare`)
> Declarations are POSIX-compliant (portable).
The `declare` keyword can be used anywhere in the script to declare
a variable of a given type with the given attributes. If used within a function,
it is not global by default.
```bash
output () {
    declare -i max=$1 # Local Scope integer
    declare -g -i max=$1 # Global Scope (-g)
}
```




