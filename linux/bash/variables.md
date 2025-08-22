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

It's always a good idea to declare your variables at the top of your script.  
There are several ways to do this.  

As we saw earlier, you can just set a variable:
```bash
MY_VAR=
```
This will both declare the variable and give it a **null** value.  

But, it's better to use either [`declare`](#declare) or [`local`](#local) 
to declare your variables, depending on if it's being used in a function or not.  

### `declare` 
The `declare` command is a bash builtin that declares a variable.  

```bash
declare MY_VAR
```

This is what's known as **intializing** a variable.  

Using `declare` for your variables is a good practice, as it makes your programs more
readable, as well as easier to edit and maintain.  


By default, `declare` will make a **globally-scoped** variable (when used outside of
a function). That means that the variable can be accessed in any location within the 
same script.  

An exception to this is if you use a subshell. If you use a subshell, the variable
**must** be **exported** for the variable to be used.  

A variable can be exported with the `export` command, or by giving the `-x` option
to the `declare` builtin.  
```bash
declare -x MY_VAR
# or
export MY_VAR
```

If `declare` is used **inside** a function, it will make a **locally-scoped**
variable (just like `local`).  

---

#### Declaring Multiple Variables

You can use a single `declare` statement to initialize multiple variables.  
```bash
declare MY_VAR MY_OTHER_VAR ANOTHA_ONE
```

This will initialize all 3 of those variables.  
Any options that are passed to `declare` will apply to all variables within this
declaration.  

For example, if you used `-x`, all three would be exported.  
```bash
# Export all 3 variables
declare -x MY_VAR MY_OTHER_VAR ANOTHA_ONE
```


### `local`

The `local` command is also a bash builtin.  

This command declares a variable inside a **function**. It will make the variable
**locally-scoped** to that function.  

This basically means that it **limits** that variable so that it can only be seen and
used inside the function.  

---

#### Example of `local`

Here's a program that showcases how `local` variables work:
```bash
my-func() {
    local my_var
    my_var=20
    printf "Value of my_var: %d\n" "$my_var" 
}
my-func
printf "Value of my_var: %d\n" "$my_var" # Won't work
```
Here's the output of that program:
```text
Value of my_var: 20
value of my_var: 0
```

Here we're creating a function called `my-func`, and within that function we're
declaring a **local** variable called `my_var` and assigning it the value of `20`.  

Then we print the value of `my_var` at the end of the function.  

After the function finishes, it will go on to the last `printf` statement, which
tries to access the value of `my_var`. It will not print the value that we set inside
the function, because it thinks it's a new variable. 


## Variable Attributes

The `declare` and `local` builtins have options that allow you to set **attributes**
for variables.  

For instance, the `-i` flag sets the **integer attribute**.  

This attribute will **only** allow the variable to store **integers**.  

An example:
```bash
declare -i test
test=hello
echo $test
# Output: 0
```
The assignment `test=hello` does not actually assign the value `'hello'` to the
`test` variable. It can't.  

Trying to assign it a value other than an integer fails, and is instead assigned
the value of `0`.  

---

### `declare` Options

You can use `declare` options to assign attributes to variables when initializing
them.  

Below are the `declare` options that set attributes for variables:

- `-a`: Array attribute.  
    - Makes the variable(s) indexed arrays (if supported).  
    - Only available in Bash v2.0+.  

- `-A`: Associative Array attribute.  
    - Makes the variable(s) associative arrays (if supported).  
    - Only available in Bash v4.0+.  
    - Associative arrays are always **unordered** in Bash.  

- `-i`: Integer attribute.  
    - Makes the variable(s) have the `integer` attribute.  
    - The variable(s) can not hold any value that is not an integer.  

- `-l`: Lowercase attribute.  
    - Converts the value of each the variable(s) to lowercase on assignment.  
- `-u`: Uppercase attribute.  
    - Converts the value of each the variable(s) to uppercase on assignment.  

- `-n`: Named Reference attribute.  
    - Make the variable(s) a reference to the variable named by its value
      ```bash
      declare MY_VAR=10
      declare -n my_ref='MY_VAR'
      echo $my_ref # 10
      ```
    - I haven't seen this one used very much.  

- `-r`: Read-Only attribute.  
    - Makes the variable(s) readonly.  

- `-t`: Trace attribute.  
    - This is only useful for functions. It has no effect on variables.  
    - Makes the function have the `trace` attribute.  
    - With this attribute, the function inherits the `DEBUG` and `RETURN` traps.  

- `-x`: Export attribute.  
    - Exports the variable(s)  

Using `+` instead of `-` on the option explicitly **removes** that attribute.  











