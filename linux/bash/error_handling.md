# Error Handling in Bash

Since bash operates on exit codes for conditionals, you can easily use that to your
advantage in error handling.  

## Basic Conditional Error Handling

### Using `if` Statements
A typical way to handle errors is with `if` statments.  
```bash
if ! sudo apt install -y someprogram; then
    printf "[ERROR]: Failed to install program!\n"
fi
```

Since conditionals operate on exit codes, the `apt install` command will run, then
the `if` statement will check the exit code of that command.  

If the exit code of `apt install` is **non-zero**, then we enter into the code block,
and the `printf` command will run.  

If the exit code is **zero**, the `if` check will not pass and the program will
continue to execute normally.  


---


### Using `$?`

The `$?` variable is a special variable in Bash that stores the exit code of the last
run command.  

This is also combined with `if` statements.  

```bash
sudo apt install -y someprogram
if [[ $? -ne 0 ]]; then
    printf "[ERROR]: Failed to install package!\n"
fi
```

This works much the same as the previous `if ! cmd...`, but this gives us the option
to check for **specific exit codes**.  

For instance, if we know `grep` will exit with `1` if no lines were selected, and `2`
if there was an error, and we just want to know if no lines were selected, we could
check for an exit code of `1`.  
```bash
grep -qi 'term' /some/file.txt
if [[ $? -eq 1 ]]; then
    printf "[ERROR]: Line was not found!\n"
fi
```

---

### Using Inline Conditional Logic

Another method of error handling is to use an inline `||` (OR):
```bash
sudo apt install -y someprogram || printf "[ERROR]: Failed to install program!\n"
```

- The `||` here will only be triggered if the exit code of `apt install` is
  **non-zero**.  

Keep in mind, when using `||`, you can only specify one command to **reliably** run.  

Doing this won't work as intended:
```bash
# BAD:
sudo apt install -y someprogram || printf "[ERROR]: Failed to install program!\n" && exit 1 
```

This could potentially run the `exit 1` command unintentionally due to how bash
handles conditional logic execution.  

The way around this is to use a command group (`{ ... }`):
```bash
sudo apt install -y someprogram || {
    printf "[ERROR]: Failed to install program!\n" && exit 1
}
```
This will only run the command group if the first command (`apt install`) fails.  


