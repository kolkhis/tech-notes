# bc - arithmetic expression calculator  

Bash's built-in math support is very limited.  
`bc` is a calculator that supports arithmetic expressions.  
It's available on a lot of Linux distributions.  

## Table of Contents  
* [bc - arithmetic expression calculator](#bc---arithmetic-expression-calculator) 
* [Basics of `bc`](#basics-of-bc) 
    * [Options](#options) 
* [Converting Celsuis to Fahrenheit](#converting-celsuis-to-fahrenheit) 
    * [Getting around `scale` with `-l`](#getting-around-scale-with--l) 


## Basics of `bc`

`bc` uses integer division by default.  
`scale` needs to be set in order to use floating point division.  
Compound operators are supported.  
i.e., `+=`, `*=`, `/=`, etc.. 


### Options  
| Option              | Description                                      |
| ------------------- | ------------------------------------------------ |
| `-h, --help`        | Print the usage and exit.                        |
| `-i, --interactive` | Force interactive mode.                          |
| `-l, --mathlib`     | Define the standard math library.                |
| `-w, --warn`        | Give warnings for extensions to POSIX bc.        |
| `-s, --standard`    | Process exactly the POSIX bc language.           |
| `-q, --quiet`       | Do not print the normal GNU bc welcome.          |
| `-v, --version`     | Print the version number and copyright and quit. |


## Converting Celsuis to Fahrenheit  

Formulas:  
* `°F = (°C × 9/5) + 32`
* `°C = (°F − 32) x 5/9`

Here's how you can use the bc command in a Unix/Linux terminal to convert a  
temperature from Celsius to Fahrenheit:  

Run the `bc` command with the Fahrenheit conversion formula.  
Convert 20 degrees Celsius to Fahrenheit:  
```bash  
echo "scale=2;(9/5)*20+32" | bc  
# or  
printf "scale=2;%s*1.8+32\n" "$1" | bc  
```

* `echo` is used to output the formula to the terminal.  
* `scale=2;` sets the precision to 2 decimal places.  
* `(9/5)*20+32` is the formula that converts Celsius to Fahrenheit.  
* `|` pipes the output from the echo command to the bc command, which performs  
  the arithmetic operation.  

You should see `68.00` as the output, which is 20 degrees Celsius in Fahrenheit.  

* Remember that `bc` uses integer division by default.  
* We're using `scale` to force bc to do decimal calculations.  
* If you do not provide the `scale`, or `-l` (see below), the result will either  
  be `68` instead of `68.00`, or it could be entirely wrong.  

### Getting around `scale` with `-l`
Instead of using `scale=2`, you can just append `-l` to the `bc` command.  
```bash  
echo "(9/5)*20+32" | bc -l  
# or  
printf "%s*1.8+32\n" "$1" | bc -l  
```





