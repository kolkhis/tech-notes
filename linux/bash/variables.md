# Variables in Bash

Variables are an essential part of Bash scripting, and programming in general.  
Understanding variables is also vital for interacting with Linux systems in general.  


## Overview

Variables are simply containers for data.  

In Bash, a variable consists of:

- A name (e.g., `MY_VAR`)
- A value (e.g., `10`)

Now, there's a bit more to it than that, but that's what it boils down to.  

### Creating a Variable 

Below is a *very simply* example of creating a variable in a Bash script:
```bash
MY_VAR=10
```

This is what we call a **variable assignment**.  

We're creating a variable by giving it a name (`MY_VAR`), and then using 
the **assignment operator** (`=`) to assign it the value of `10`.  

---

### Using a Variable

When you want to call upon the value of your variable, you simply add a dollar 
sign (`$`) before its name.  
```bash
echo $MY_VAR
```

This will output `10`, the value of `MY_VAR`.  

> **Note**: It is generally a good practice to **always** wrap your variables in
> double quotes. This is to prevent word splitting and potential shell injection
> attacks.  

```bash
echo "$MY_VAR"
```

This is much safer than using `$MY_VAR` without quotes.  



## Declaring Variables

TODO










