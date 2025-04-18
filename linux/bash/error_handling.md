# Error Handling in Bash

Since bash operates on exit codes for conditionals, you can easily use that to your
advantage in error handling.  

## Basic Conditional Error Handling

### Using `if` Statements
A typical way to handle errors is with `if` statments.  
```bash
if ! sudo apt install -y someprogram; then
    printf "Failed to install program!\n"
fi
```

### Using Inline Conditional Logic
Another method of error handling is to use an inline `||` (OR):
```bash
sudo apt install -y someprogram || printf "Failed to install program!\n"
```

Keep in mind, when using `||`, you can only specify one command to reliably run.  
Doing this won't work as intended:
```bash
# BAD:
sudo apt install -y someprogram || printf "Failed to install program!\n" && exit 1 
```
This could potentially run the `exit 1` command unintentionally due to how bash
handles conditional logic execution.  

The way around this is to use a command group (`{ ... }`):
```bash
sudo apt install -y someprogram || {
    printf "Failed to install program!\n" && exit 1
}
```
This will only run the command group if the first command (`apt install`) fails.  


