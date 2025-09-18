# Loops in Bash

## Table of Contents
* [`for` Loops](#for-loops) 
    * [Create 200 files named `file<number>` skipping every even number 001-199](#create-200-files-named-filenumber-skipping-every-even-number-001-199) 
        * [Using `seq`,](#using-seq) 
        * [Using Brace Expansion (Parameter Expansion)](#using-brace-expansion-parameter-expansion) 
        * [Using and C-style For-Loops](#using-and-c-style-for-loops) 
* [`while` Loops](#while-loops) 
    * [Loop with a Counter](#loop-with-a-counter) 
    * [Loop over lines from a file in bash](#loop-over-lines-from-a-file-in-bash) 
    * [Loop over lines from a command](#loop-over-lines-from-a-command) 
    * [Forever (Infinite Loop)](#forever-infinite-loop) 


## `for` Loops 
### Create 200 files named `file<number>` skipping every even number 001-199  

#### Using `seq`,
```bash
# Using `seq`
for i in $(seq 1 2 200); do  
    touch file${i}
done  
```

#### Using Brace Expansion (Parameter Expansion)
```bash  
# Bash 4+ Exclusive: Brace expansion  
for i in {1..200..2}; do  
    touch file${i}
done  
```

#### Using and C-style For-Loops 
```bash
# C-style loop  
for (( i=0; i<200; i+2 )); do  
    touch file${i}
done  
```


## `while` Loops

### Loop with a Counter

```bash
counter=0
while [[ $counter < 10 ]]; do
    printf "Counter: %d\n" "$counter"
    counter++
done
```

### Loop over lines from a file in bash  
```bash
while read -r line; do  
    echo "$line"  
done < file.txt  # Reading from `file.txt`
```

### Loop over lines from a command (process substitution)
```bash
while read -r line; do  
    echo "$line"  
done < <(find . -maxdepth 1 -name '*.txt')  # All .txt files in current dir  
```

### Forever (Infinite Loop)  
```bash
while true; do  
    echo "This will run forever."  
done  

while :; do
    echo "This will also run forever."
done
```


## `select` Loops

`select` is a bash builtin that's used to handle user input.  

The `select` builtin is used to create interactive menus for the user to select
a specific thing.  

It creates a loop that continues to prompt the user for input.  

```bash
select word in {one,two,three}; do
    echo "Input: $word"
done
```

It prompts the user with a menu containing the items given:
```plaintext
1) one
2) two
3) three
#? 
```

- The `#?` is what the user's prompt will be by default.  
    - This prompt can be changed by modifying the `PS3` variable.  
- The user must select one of the **numbers** on the itemized list.  

This loop will run indefinitely unless you put in a `break`.  
You'd want to handle the user input anyway, so that's where you'd `break`.    
```bash
select word in {apple,orange,banana}; do
    echo "Input: $word"
    case $word in
        1)
            printf "You chose 'apple'.\n"
            break
            ;;
        2)
            printf "You chose 'orange'.\n"
            break
            ;;
        3)
            printf "You chose 'banana'.\n"
            break
            ;;
        *)
            printf "Bad selection!\n" # Don't break here
            ;;
    esac
done
```

The `word` variable will contain the number that the user selected.  

This is yet another method you can use to interactively get user input.  

