# Bash Parameter Expansion
Parameter expansion is a way to modify variables in Bash.  

Parameter expansions are used in braces (`${VAR...}`).  

## Table of Contents
* [Parameter Expansion (Slicing/Substitution)](#parameter-expansion-slicingsubstitution) 
    * [Slicing](#slicing) 
    * [Substitution](#substitution) 
    * [Substrings](#substrings) 
    * [Getting the Length of a String/Variable](#getting-the-length-of-a-stringvariable) 
* [Parameter Transformation](#parameter-transformation) 
    * [Parameter Transformation Operators](#parameter-transformation-operators) 
    * [Parameter Transformation on Arrays](#parameter-transformation-on-arrays) 
    * [Special Characters for Parameter Transformation](#special-characters-for-parameter-transformation) 
    * [Table of Examples using Special Characters](#table-of-examples-using-special-characters) 
* [Parameter Transformation Examples](#parameter-transformation-examples) 
* [POSIX-Compliant Parameter Expansions](#posix-compliant-parameter-expansions) 

## Parameter Expansion (Slicing/Substitution)  

Parameter expansion is a way to modify values in-place.  
Generally speaking, it uses the syntax:
```bash
${variable<operator><args>}
```

The operator sometimes requires arguments, sometimes it doesn't.  



Replace strings and variables in place with parameter expansion.  

### Slicing  


```bash  
name="John"  
echo "${name}"  
echo "${name/J/j}"    #=> "john" (substitution)  
echo "${name:0:2}"    #=> "Jo" (slicing)  
echo "${name::2}"     #=> "Jo" (slicing)  
echo "${name::-1}"    #=> "Joh" (slicing)  
echo "${name:(-1)}"   #=> "n" (slicing from right)  
echo "${name:(-2):1}" #=> "h" (slicing from right)  
echo "${food:-Cake}"  #=> $food or "Cake"  
length=2
echo "${name:0:length}"  #=> "Jo"  
# Cutting out the suffix  
str="/path/to/foo.cpp"  
echo "${str%.cpp}"    # /path/to/foo  
echo "${str%.cpp}.o"  # /path/to/foo.o  
echo "${str%/*}"      # /path/to  
# Cutting out the prefix  
echo "${str##*.}"     # cpp (extension)  
echo "${str##*/}"     # foo.cpp (basepath)  
# Cutting out the path, leaving the filename  
echo "${str#*/}"      # path/to/foo.cpp  
echo "${str##*/}"     # foo.cpp  

echo "${str/foo/bar}" # /path/to/bar.cpp  

str="Hello world"  
echo "${str:6:5}"   # "world"  
echo "${str: -5:5}"  # "world"  
```

### Substitution  
```bash  
${foo%suffix}       # Remove suffix  
${foo#prefix}       # Remove prefix  

${foo%%suffix}      # Remove long suffix  
${foo/%suffix}      # Remove long suffix  

${foo##prefix}      # Remove long prefix  
${foo/#prefix}      # Remove long prefix  

${foo/from/to}      # Replace first match  
${foo//from/to}     # Replace all  

${foo/%from/to}     # Replace suffix  
${foo/#from/to}     # Replace prefix  

src="/path/to/foo.cpp"  
base=${src##*/}   #=> "foo.cpp" (basepath)  
dir=${src%$base}  #=> "/path/to/" (dirpath)  
```

### Substrings  
```bash  
${foo:0:3}      # Substring (position, length)  
${foo:(-3):3}   # Substring from the right  
```

### Getting the Length of a String/Variable  
```bash  
${#foo}        # Length of $foo  
```

















## Parameter Transformation
`man://bash /^\s*Parameter\s*transformation`
Parameter transformation is a subset of parameter expansion.  
It's not generally compatible with POSIX shell.  
Parameter transformation is a way to perform a transformation on a value before it is used.  

Syntax:  
```bash  
${parameter@operator}
```
Each operator is a single letter.  

### Parameter Transformation Operators  
* `U`: Converts all lowercase letters in the value to uppercase.  
* `u`: Capitalizes only the first letter of the value.  
* `L`: Converts all uppercase letters in the value to lowercase.  
* `Q`: Quotes the value, making it safe to reuse as input.  
* `E`: Expands escape sequences in the value (like `$'...'` syntax).  
* `P`: Expands the value as a prompt string.  
* `A`: Generates an assignment statement to recreate the variable with its attributes.  
* `K`: Produces a quoted version of the value, displaying arrays as key-value pairs.  
* `a`: Returns the variable's attribute flags (like `readonly`, `exported`).  


### Parameter Transformation on Arrays

Just like using `$@` or `$*`, you can use parameter transformation on multiple 
positional parameters or arguments at once by using `${@}` or `${*}`.  

* `${@}` (like `$@`): Treats each positional parameter as a separate item and applies transformations to each individually.  
    * When you use `${@}`, Bash treats each positional parameter (e.g., command-line 
      arguments, `$1`, `$2`, etc) as separate arguments.
    * They're processed one by one and the transformation is applied to each.  
    * The output is a list with each item transformed according to the specified operator.  
* `${*}` (like `$*`): Treats all positional parameters as a single, combined string. 
    * Transformations apply to the entire combined string, not each parameter individually.  
    * With `${*}`, it combines all postitional arguments into a space-separated string and applies the transformation to the whole string.  
    * The output is a single string with the transformation applied to the entire string.  

Ex:  
```bash
all_args_lowercase_arr=("${@@L}") # This will be an array
all_args_lowercase_str="${*@L}"   # This will be a single string
```


If you use `${array[@]}` or `${array[*]}`, Bash applies the transformation to each
element of the array, one by one. The result is also a list with each array item
transformed individually.  

If enabled, the final transformed output might go through word splitting (separating by spaces) 
and pathname expansion (turning wildcard characters like `*` into matching filenames),
so the result could expand further into multiple words or paths.  


### Special Characters for Parameter Transformation
Bash supports the use of `^` and `,` for making values uppercase/lowercase.  

* `^`: Uppercase
* `,`: Lowercase
* `~`: Toggle
    - Lowercase becomes uppercase, and uppercase becomes lowercase.  
    - Like using `~` in vim.  

These are called "case modifications" in the Bash man page.  

```bash
${@^} # Capitalize the first character of each value in the array
${@,} # Lowercase the first character of each value in the array
${@^^} # Capitalize all characters of each value in the array
${@,,} # Lowercase all characters of each value in the array
${@~}  # Toggle the case of the first char of each value
${@~~} # Toggle the case of the all chars of each value

${*^} # Capitalize the first character of each value in the array
${*,} # Lowercase the first character of each value in the array
${*^^} # Capitalize all characters of each value in the array
${*,,} # Lowercase all characters of each value in the array
${*~}  # Toggle the case of the first char of each value in the array
${*~~} # Toggle the case of the all chars of each value in the array
```

When using `*`, the return value will be a single string, even though the
transformation is being applied to each element individually.  

If you want to save the output into an array, use `@` instead of `*`:
```bash
declare -a arr=('one' 'two' 'three')
all_upper=("${arr[@]^^}")
echo "${all_upper[@]@Q}"
# 'ONE' 'TWO' 'THREE'
```



### Table of Examples using Special Characters

| Syntax       | Description           | Example Output (for `"hello" "world" "bash"`)   |
|--------------|-------------------------------------------------|--------------------  
| `${@^}` | Capitalizes each parameter                            | `Hello World Bash`
| `${*^}` | Capitalizes each parameter                            | `Hello World Bash`
| `${@^^}`| Uppercases each parameter completely                  | `HELLO WORLD BASH`
| `${*^^}`| Uppercases each parameter completely                  | `HELLO WORLD BASH`
| `${@,}` | Lowercases the first character of each parameter      | `hello world bash`
| `${*,}` | Lowercases the first character of each parameter      | `hello world bash`
| `${@~}` | Toggle the first character of each parameter          | `Hello World Bash`
| `${@~~}` | Toggle/invert all characters of each parameter       | `HELLO WORLD BASH`
| `${*~}`  | Toggle/invert the first character of each parameter  | `Hello world bash`
| `${*~~}` | Toggle/invert all characters of each parameter       | `HELLO WORLD BASH`
| `${@@Q}` | Quotes each parameter individually                   | `'hello' 'world' 'bash'`
| `${*@Q}` | Quotes each parameter individually                   | `'hello' 'world' 'bash'`

* Typically, `*` will combine the parameters into one string, whereas `@` will split the parameters into an array.  
    - However, in the case of these parameter expansions, `*` and `@` behave the same way.  

* Both `${@^^}` and `${*^^}` make everything uppercase, applying the modification to
  each element of the array.  
* `${@^}` applies the uppercase transformation to each argument individually.  
* `${*^}` does the same thing as `${@^}`.  

## Parameter Transformation Examples  

Parameter transformation on variables, arrays, and associative arrays:  
```bash  
# Example variable for demonstration  
var="hello world"  
array_var=("one" "two" "three")  
declare -A assoc_array_var=([key1]="value1" [key2]="value2")  

# U: Convert all lowercase letters to uppercase  
echo "${var@U}"        # Output: HELLO WORLD  

# u: Capitalize only the first letter  
echo "${var@u}"        # Output: Hello world  

# L: Convert all uppercase letters to lowercase  
var="HELLO WORLD"  
echo "${var@L}"        # Output: hello world  

# Q: Quote the value, safe for reuse as input  
echo "${var@Q}"        # Output: 'HELLO WORLD' (or "HELLO WORLD" depending on context)  

# E: Expand escape sequences (e.g., newline, tab)  
esc_var=$'hello\nworld'  
echo "${esc_var@E}"    # Output: hello  
                       #         world  

# P: Expand as a prompt string (useful for prompt formatting)  
PS1="[\u@\h \W]\$ "    # Set the prompt  
echo "${PS1@P}"        # Output: [user@host directory]$  

# A: Generate an assignment statement that recreates the variable  
echo "${var@A}"        # Output: declare -- var="HELLO WORLD"  

# K: Quoted version of the value, with arrays as key-value pairs  
echo "${array_var@K}"          # Output: 'one' 'two' 'three'  
echo "${assoc_array_var@K}"    # Output: [key1]="value1" [key2]="value2"  

# a: Display attributes of the variable (flags)  
declare -r readonly_var="test"  
echo "${readonly_var@a}"       # Output: r (indicates readonly)  
```

Examples of using parameter transformation with positional parameters and arrays  
using the `^` and `@` operators:  
```bash  
# Positional parameters example  
set -- "hello" "world"  
echo "${@^}"   # Each positional parameter capitalized: "Hello World"  

# Array example  
array=("one" "two" "three")  
echo "${array[@]^}"   # Capitalize each array element: "One Two Three"  

# Word splitting and pathname expansion example  
files=("file1.txt" "*.sh")  
echo "${files[@]^}"   # Expands "*.sh" to match any shell scripts in the directory  

# Using ${@} with U  
echo "${@^}"       # Capitalizes each argument: "Hello World Bash"  

# Using ${*} with U  
echo "${*^}"       # Capitalizes each argument: "Hello World Bash"  

# Using ${@} with U for full uppercase  
echo "${@^^}"      # Outputs: "HELLO WORLD BASH"  

# Using ${*} with U for full uppercase  
echo "${*^^}"      # Outputs: "HELLO WORLD BASH"  

# Using ${@} with L  
echo "${@,}"       # Converts first character of each argument to lowercase  

# Using ${*} with L  
echo "${*,}"       # Converts first character of each argument to lowercase  

# Using ${@} with Q  
echo "${@@Q}"       # Quotes each argument individually, e.g., "'hello' 'world' 'bash'"  

# Using ${*} with Q  
echo "${*@Q}"       # Quotes each argument individually, e.g., "'hello' 'world' 'bash'"  
```

## Using Default Values

You can use default values for variables that are either null or unset.  

The operators used to do this:

- `:-` Only uses the default value for the current string.
- `:=` Uses the default value given for the current string *and* assigns the variable
  to that value.  


## POSIX-Compliant Parameter Expansions

POSIX shell does support some parameter expansions.  

- `${var:-Default Value}`
- `${var:=Default Value}`
- `${var:?Error message}`
- `${var:+Alternative value}`

The colons in these parameter expansions are saying "When this variable is either
unset or null." 

The colon (:) affects how the shell interprets the parameter's state:

* With `:` 
    - checks if variable is unset OR null (i.e., empty string)

* Without `:` 
    - checks if variable is unset only


The table shows what is used when the variable is set and not null, set and null, or unset.  

| Expression     | var is set & not null | var is set & null (`""`) | var is unset           
| - | - | - | -
| `${var:-word}` | value of `var`        | `word`                   | `word`                 
| `${var-word}`  | value of `var`        | ""                       | `word`                 
| `${var:=word}` | value of `var`        | sets var=`word`          | sets var=`word`        
| `${var=word}`  | value of `var`        | ""                       | sets var=`word`        
| `${var:?word}` | value of `var`        | prints `word` and exits  | prints `word` and exits
| `${var?word}`  | value of `var`        | `word`                   | prints `word` and exits
| `${var:+word}` | `word`                | ""                       | ""                     
| `${var+word}`  | `word`                | `word`                   | ""                     


## Resources

- <https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02>

