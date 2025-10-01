# bc - arithmetic expression calculator  

Bash's built-in math support is very limited.  
`bc` is a calculator that supports mathematic expressions.  
It's available on a lot of Linux distributions.  

`bc` is essentially a programming language of its own. 

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

Using `-l` will give a more precise decimal result:  
```bash
echo "(79 + 79 + 80 + 80 + 45) / 5" | bc
# 72
echo "(79 + 79 + 80 + 80 + 45) / 5" | bc -l
# 72.60000000000000000000
```

## Passing Strings to `bc`
Some strings passed to `bc` will change the way it behaves.  

* `scale=2;` sets the decimal precision to 2 decimal places.  
```bash
echo "scale=2;10/3" | bc
# 3.33
```

* `ibase` and `obase`: Set the input base and output base (for base number conversion).  
    * Useful for converting binary, octal, decimal, and hexadecimal numbers.  
```bash
echo "ibase=16;obase=2; A" | bc  # Convert A from hexadecimal to binary
# 1010
echo "ibase=10;obase=8; 160" | bc  # Convert 160 from deciaml to octal
# 240
```


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


## Syntax

### Comments
Comments in `bc` are the same as C-style multi-line comments, using 
the syntax `/* comment */`. 


## Variables in `bc`
Numbers are stored in two types of variables:

* Simple variables  
* Arrays  

Both simple variables and array variables are named.  
 
Names begin with a letter followed by any number of letters, digits and underscores.  
All letters in the variable names must be lower case.  

* Full alpha-numeric names are an extension. 
* In POSIX `bc`, all names are a single lowercase letter. 

The type of variable is clear by the context; all array variable names will be 
followed by brackets (`[]`).  

There are four special variables:  

* `scale` 
    * Defines how some operations use digits after the decimal point.  
    * The default value of `scale` is 0. 
* `ibase`
* `obase`
    * `ibase` and `obase` define the conversion base for input and output numbers.  
    * The default for both input base and output base is base 10.  
* `last`  
    * (an extension) A variable that has the value of the last printed number.  

## Converting Base10 (Decimal) to Base8 (Octal)  

It's really easy to do base conversion in `bc` using the `ibase` (input base) and
`obase` (output base) variables.

Set the `ibase` to the base you want to convert from, and `obase` to the base you
want to convert to.

### Example Conversion Script

An example script of converting a number from decimal (base10) to octal (base 8):  
```bash
#!/bin/bash
NUM=$1
OUTPUT="$(echo "ibase=10; obase=8; $NUM" | bc)"
printf "Decimal: %s\nOctal: %s\n" "$NUM" "$OUTPUT"
```

To reverse it, just change the `ibase` and `obase` variables.

Converting a number from octal (base 8) to decimal (base10):
```bash
#!/bin/bash
NUM=$1
OUTPUT="$(echo "ibase=8; obase=10; $NUM" | bc)"
printf "Octal: %s\nDecimal: %s\n" "$NUM" "$OUTPUT"
```


