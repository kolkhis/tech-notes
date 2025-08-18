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

But, it's better to use either [`declare`](#using-declare) or [`local`](#using-local) 
to declare your variables, depending on if it's being used in a function or not.  

### Using `declare`
The `declare` command is a bash builtin that declares a variable.  

```bash
declare MY_VAR
```

Using `declare` for your variables is a good practice, as it makes your programs more
readable, as well as easier to edit and maintain.  

By default, `declare` will make a **globally-scoped** variable. That means that the
variable can be accessed in any location within the same script.  

An exception to this is if you use a subshell. If you use a subshell, the variable
**must** be **exported** for the variable to be used.  

A variable can be exported with the `export` command, or by giving the `-x` option
to the `declare` builtin.  
```bash
declare -x MY_VAR
# or
export MY_VAR
```

### Using `local`

The `local` command is also a bash builtin.  

This command declares a variable inside a **function**. It will make the variable
**locally-scoped** to that function.  

This basically means that it **limits** that variable so that it can only be seen and
used inside the function.  

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











